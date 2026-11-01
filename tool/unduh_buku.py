#!/usr/bin/env python3
"""Mengunduh isi buku bebas hak cipta dari sumber publik ke assets/buku/.

Dijalankan oleh GitHub Actions sebelum APK dibangun. Jika satu buku gagal,
buku itu dilewati dan build tetap lanjut (aplikasi menampilkan pesan
"Isi buku belum tersedia" untuk buku tersebut).
"""
import json
import os
import re
import sys
import subprocess
import tempfile
import time
import urllib.parse
import urllib.request
from html.parser import HTMLParser

AKAR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TUJUAN = os.path.join(AKAR, 'assets', 'buku')
DAFTAR = os.path.join(AKAR, 'tool', 'sumber_buku.json')
UA = 'Mozilla/5.0 (AGB-Left-Wing-Books build script)'
MIN_HURUF = 2000


def ambil(url, coba=3):
    for i in range(coba):
        try:
            req = urllib.request.Request(url, headers={'User-Agent': UA})
            with urllib.request.urlopen(req, timeout=60) as r:
                data = r.read()
                charset = r.headers.get_content_charset()
            return data, charset
        except Exception as e:  # noqa: BLE001
            print(f'   gagal ({i + 1}/{coba}): {url} -> {e}')
            time.sleep(2 * (i + 1))
    return None, None


def dekode(data, charset):
    urutan = ([charset] if charset else []) + ['utf-8', 'cp1252']
    for enc in urutan:
        try:
            return data.decode(enc)
        except Exception:  # noqa: BLE001
            continue
    return data.decode('latin-1', errors='replace')


class Penyaring(HTMLParser):
    BLOK = {'p', 'div', 'br', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'li', 'tr',
            'td', 'th', 'blockquote', 'hr', 'table', 'pre', 'center', 'dd', 'dt'}
    ABAIKAN = {'script', 'style', 'head', 'title'}

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.paragraf = []
        self.saat_ini = []
        self.lewati = 0
        self.dalam_a = 0
        self.huruf_tautan = 0

    def tutup(self):
        teks = re.sub(r'\s+', ' ', ''.join(self.saat_ini)).strip()
        tautan = self.huruf_tautan
        self.saat_ini = []
        self.huruf_tautan = 0
        if not teks:
            return
        # Paragraf pendek yang hampir seluruhnya tautan = navigasi situs.
        if len(teks) < 200 and tautan >= 0.9 * len(teks):
            return
        if re.match(r'^(Perbaikan terakhir|Last updated|Kembali ke|Back to)\b', teks, re.I):
            return
        self.paragraf.append(teks)

    def handle_starttag(self, tag, attrs):
        if tag == 'a':
            self.dalam_a += 1
        if tag in self.ABAIKAN:
            self.lewati += 1
        elif tag == 'body':
            self.lewati = 0
        if tag in self.BLOK:
            self.tutup()

    def handle_endtag(self, tag):
        if tag == 'a':
            self.dalam_a = max(0, self.dalam_a - 1)
        if tag in self.ABAIKAN:
            self.lewati = max(0, self.lewati - 1)
        if tag in self.BLOK:
            self.tutup()

    def handle_data(self, data):
        if not self.lewati:
            self.saat_ini.append(data)
            if self.dalam_a:
                self.huruf_tautan += len(data.strip())


def html_ke_teks(html):
    p = Penyaring()
    p.feed(html)
    p.tutup()
    hasil = []
    for para in p.paragraf:
        if ' | ' in para and len(para) < 200:
            continue  # baris navigasi
        hasil.append(para)
    return '\n\n'.join(hasil)


class PengumpulTautan(HTMLParser):
    def __init__(self):
        super().__init__()
        self.tautan = []

    def handle_starttag(self, tag, attrs):
        if tag == 'a':
            for k, v in attrs:
                if k == 'href' and v:
                    self.tautan.append(v)


def daftar_bab(url_indeks, html):
    pk = PengumpulTautan()
    pk.feed(html)
    dasar = url_indeks.rsplit('/', 1)[0] + '/'
    hasil = []
    for t in pk.tautan:
        u = urllib.parse.urljoin(url_indeks, t).split('#')[0]
        if not u.startswith(dasar):
            continue
        if not re.search(r'\.html?$', u, re.I):
            continue
        if u == url_indeks or re.search(r'/index\.html?$', u, re.I):
            continue
        if u not in hasil:
            hasil.append(u)
    return hasil


def bersihkan_gutenberg(teks):
    teks = teks.replace('\r\n', '\n').replace('\r', '\n')
    m = re.search(r'\*\*\* ?START OF (THE|THIS) PROJECT GUTENBERG EBOOK.*?\*\*\*', teks, re.S | re.I)
    if m:
        teks = teks[m.end():]
    m = re.search(r'\*\*\* ?END OF (THE|THIS) PROJECT GUTENBERG EBOOK', teks, re.I)
    if m:
        teks = teks[:m.start()]
    hasil = []
    for para in re.split(r'\n\s*\n', teks):
        s = re.sub(r'\s+', ' ', para).strip()
        if s:
            hasil.append(s)
    return '\n\n'.join(hasil)


def cari_gutendex(s):
    q = urllib.parse.quote(s['kueri'])
    data, _ = ambil(f'https://gutendex.com/books/?search={q}&languages=en')
    if not data:
        return None
    try:
        j = json.loads(data.decode('utf-8'))
    except Exception:  # noqa: BLE001
        return None
    for b in j.get('results', []):
        judul = (b.get('title') or '').lower()
        penulis = ' '.join(a.get('name', '') for a in b.get('authors', [])).lower()
        if s.get('penulis', '').lower() not in penulis:
            continue
        if s.get('judul_berisi', '').lower() not in judul:
            continue
        if any(x in judul for x in s.get('hindari', [])):
            continue
        formats = b.get('formats', {})
        url = None
        for k, v in formats.items():
            if k.startswith('text/plain') and 'utf-8' in k:
                url = v
                break
        if not url:
            for k, v in formats.items():
                if k.startswith('text/plain'):
                    url = v
                    break
        if url:
            return b.get('title'), url
    return None


def pdf_ke_teks(data):
    """PDF -> teks lewat pdftotext. Paragraf dipisah baris kosong."""
    with tempfile.NamedTemporaryFile(suffix='.pdf', delete=False) as f:
        f.write(data)
        jalur = f.name
    try:
        hasil = subprocess.run(['pdftotext', '-enc', 'UTF-8', jalur, '-'],
                               capture_output=True, timeout=300)
        mentah = hasil.stdout.decode('utf-8', errors='replace')
    finally:
        os.unlink(jalur)
    mentah = mentah.replace('\f', '\n\n')
    para = []
    for blok in re.split(r'\n\s*\n', mentah):
        baris = [b.strip() for b in blok.split('\n') if b.strip()]
        if not baris:
            continue
        teks = ''
        for b in baris:
            if teks.endswith('-') and b[:1].islower():
                teks = teks[:-1] + b
            else:
                teks = (teks + ' ' + b).strip()
        if re.fullmatch(r'[\d\s.ivxlcIVXLC]+', teks) or len(teks) < 3:
            continue  # nomor halaman
        para.append(teks)
    return '\n\n'.join(para)


def tulis(id_buku, judul, sumber, bahasa, isi):
    os.makedirs(TUJUAN, exist_ok=True)
    jalur = os.path.join(TUJUAN, id_buku + '.txt')
    with open(jalur, 'w', encoding='utf-8') as f:
        f.write(f'#JUDUL: {judul}\n#SUMBER: {sumber}\n#BAHASA: {bahasa}\n\n{isi}\n')


def kerjakan(s):
    tipe = s['tipe']
    if tipe == 'halaman':
        data, cs = ambil(s['url'])
        if not data:
            return None
        return s['url'], html_ke_teks(dekode(data, cs))
    if tipe == 'indeks':
        data, cs = ambil(s['url'])
        if not data:
            return None
        html_indeks = dekode(data, cs)
        bab = daftar_bab(s['url'], html_indeks)
        print(f'   {len(bab)} halaman bab ditemukan')
        if not bab:
            # Tidak ada halaman bab: isi buku mungkin ada di halaman indeks itu sendiri.
            return s['url'], html_ke_teks(html_indeks)
        potongan = []
        for u in bab:
            time.sleep(0.6)
            d, c = ambil(u)
            if d:
                t = html_ke_teks(dekode(d, c))
                if t:
                    potongan.append(t)
        return s['url'], '\n\n'.join(potongan)
    if tipe == 'pdf':
        potongan = []
        for u in s['urls']:
            d, _ = ambil(u)
            if not d:
                return None
            potongan.append(pdf_ke_teks(d))
            time.sleep(0.6)
        return s['urls'][0], '\n\n'.join(potongan)
    if tipe == 'gutenberg':
        # Nomor Project Gutenberg tetap. Diperiksa: judul dan penulis harus
        # muncul di kepala berkas, kalau tidak buku dilewati (salah nomor).
        url = f"https://www.gutenberg.org/ebooks/{s['nomor']}.txt.utf-8"
        data, cs = ambil(url)
        if not data:
            return None
        mentah = dekode(data, cs)
        kepala = mentah[:4000].lower()
        if s['judul_berisi'].lower() not in kepala or s['penulis'].lower() not in kepala:
            print('   kepala berkas tidak cocok dengan judul/penulis, dilewati')
            return None
        return url, bersihkan_gutenberg(mentah)
    if tipe == 'gutendex':
        ketemu = cari_gutendex(s)
        if not ketemu:
            return None
        judul_asli, url = ketemu
        print(f'   cocok: {judul_asli}')
        data, cs = ambil(url)
        if not data:
            return None
        return url, bersihkan_gutenberg(dekode(data, cs))
    return None


def main():
    with open(DAFTAR, encoding='utf-8') as f:
        daftar = json.load(f)
    # Pemakaian: python3 tool/unduh_buku.py [id_buku ...]  (kosong = semua)
    pilihan = set(sys.argv[1:])
    if pilihan:
        daftar = [s for s in daftar if s['id'] in pilihan]
    os.makedirs(TUJUAN, exist_ok=True)
    berhasil, gagal = [], []
    for s in daftar:
        print(f"- {s['id']} ({s['tipe']})")
        pakai = s
        try:
            hasil = kerjakan(s)
        except Exception as e:  # noqa: BLE001
            print(f'   galat: {e}')
            hasil = None
        if (not hasil or len(hasil[1]) < MIN_HURUF) and s.get('cadangan'):
            print('   sumber utama gagal, coba sumber cadangan')
            pakai = dict(s, **s['cadangan'])
            try:
                hasil = kerjakan(pakai)
            except Exception as e:  # noqa: BLE001
                print(f'   galat cadangan: {e}')
                hasil = None
        if hasil and len(hasil[1]) >= MIN_HURUF:
            tulis(s['id'], s['judul'], hasil[0], pakai['bahasa'], hasil[1])
            berhasil.append(s['id'])
            print(f'   OK: {len(hasil[1])} huruf')
        else:
            gagal.append(s['id'])
            print('   DILEWATI (tidak berhasil / terlalu pendek)')
        time.sleep(0.6)
    print('\nBerhasil:', ', '.join(berhasil) or '-')
    print('Dilewati:', ', '.join(gagal) or '-')
    if not berhasil:
        print('PERINGATAN: tidak ada buku yang berhasil diunduh.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
