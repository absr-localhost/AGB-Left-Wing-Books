#!/usr/bin/env python3
"""Menerjemahkan satu buku berbahasa Inggris ke Indonesia (terjemahan mesin).

Pemakaian: python3 tool/terjemah.py <id_buku> [--batas-menit 330]

Masukan : assets/buku/<id>.txt      (hasil tool/unduh_buku.py, #BAHASA: en)
Keluaran: assets/buku/<id>.id.txt   (#TERJEMAHAN: mesin, #PROGRES: n/total)

Bisa dilanjutkan: kalau waktu habis, hasil sebagian disimpan dan sisa paragraf
tetap berbahasa Inggris. Jalankan lagi, pekerjaan lanjut dari paragraf terakhir.
Berhenti sendiri sebelum batas waktu supaya hasil sempat disimpan.
"""
import os
import re
import sys
import time

AKAR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FOLDER = os.path.join(AKAR, 'assets', 'buku')
MAKS_POTONG = 900  # huruf per potongan yang dikirim ke mesin


def baca(jalur):
    with open(jalur, encoding='utf-8') as f:
        mentah = f.read()
    kepala, baris = {}, mentah.split('\n')
    i = 0
    while i < len(baris) and baris[i].startswith('#'):
        k, _, v = baris[i][1:].partition(':')
        kepala[k.strip()] = v.strip()
        i += 1
    isi = '\n'.join(baris[i:]).strip()
    return kepala, [p for p in re.split(r'\n\s*\n', isi) if p.strip()]


def tulis(jalur, judul, sumber, hasil, total):
    with open(jalur, 'w', encoding='utf-8') as f:
        f.write(f'#JUDUL: {judul}\n')
        f.write(f'#SUMBER: {sumber}\n')
        f.write('#BAHASA: id\n#TERJEMAHAN: mesin\n')
        f.write(f'#PROGRES: {len(hasil[0])}/{total}\n\n')
        f.write('\n\n'.join(hasil[0] + hasil[1]) + '\n')


def potong(teks):
    """Bagi paragraf panjang di batas kalimat."""
    if len(teks) <= MAKS_POTONG:
        return [teks]
    kalimat = re.split(r'(?<=[.!?;:])\s+', teks)
    hasil, now = [], ''
    for k in kalimat:
        if now and len(now) + len(k) + 1 > MAKS_POTONG:
            hasil.append(now)
            now = k
        else:
            now = (now + ' ' + k).strip()
    if now:
        hasil.append(now)
    return hasil


def siapkan_mesin():
    import argostranslate.package as paket
    import argostranslate.translate as tr
    paket.update_package_index()
    ada = paket.get_available_packages()
    cocok = [p for p in ada if p.from_code == 'en' and p.to_code == 'id']
    if not cocok:
        raise RuntimeError('Paket en->id tidak ditemukan di indeks Argos.')
    paket.install_from_path(cocok[0].download())
    bahasa = tr.get_installed_languages()
    en = next(b for b in bahasa if b.code == 'en')
    idn = next(b for b in bahasa if b.code == 'id')
    return en.get_translation(idn)


def main():
    if len(sys.argv) < 2:
        print('Pemakaian: terjemah.py <id_buku> [--batas-menit N]')
        return 2
    id_buku = sys.argv[1]
    batas = 330
    if '--batas-menit' in sys.argv:
        batas = int(sys.argv[sys.argv.index('--batas-menit') + 1])
    mulai = time.time()

    asal = os.path.join(FOLDER, id_buku + '.txt')
    if not os.path.exists(asal):
        print(f'Teks asli {id_buku} tidak ada (unduhan gagal). Dilewati.')
        return 0
    kepala, paragraf = baca(asal)
    if kepala.get('BAHASA') != 'en':
        print('Bukan teks Inggris, tidak perlu diterjemahkan.')
        return 0
    judul = kepala.get('JUDUL', id_buku)
    sumber = kepala.get('SUMBER', '')
    total = len(paragraf)

    keluar = os.path.join(FOLDER, id_buku + '.id.txt')
    sudah = []
    if os.path.exists(keluar):
        k2, p2 = baca(keluar)
        m = re.match(r'^(\d+)/(\d+)$', k2.get('PROGRES', ''))
        if m and int(m.group(2)) == total:
            n = int(m.group(1))
            sudah = p2[:n]
            print(f'Lanjut dari paragraf {n}/{total}')
        else:
            print('Berkas lama tidak cocok, mulai dari awal.')
    if len(sudah) >= total:
        print('Sudah selesai diterjemahkan.')
        return 0

    mesin = siapkan_mesin()
    print(f'Siap. {total - len(sudah)} paragraf akan diterjemahkan.')
    hasil = [list(sudah), []]
    terakhir_simpan = time.time()
    for i in range(len(sudah), total):
        p = paragraf[i]
        if len(re.findall(r'[A-Za-z]', p)) < 4:
            t = p  # nomor, garis, judul sangat pendek: biarkan
        else:
            try:
                t = ' '.join(mesin.translate(x) for x in potong(p))
            except Exception as e:  # noqa: BLE001
                print(f'   paragraf {i} gagal ({e}), dibiarkan Inggris')
                t = p
        hasil[0].append(t)
        menit = (time.time() - mulai) / 60
        if menit >= batas:
            print(f'Batas waktu {batas} menit tercapai di paragraf {i + 1}.')
            break
        if time.time() - terakhir_simpan > 300 or (i + 1) % 200 == 0:
            hasil[1] = paragraf[len(hasil[0]):]
            tulis(keluar, judul, sumber, hasil, total)
            terakhir_simpan = time.time()
            print(f'   {len(hasil[0])}/{total} ({menit:.0f} menit)')
    hasil[1] = paragraf[len(hasil[0]):]
    tulis(keluar, judul, sumber, hasil, total)
    print(f'Selesai simpan: {len(hasil[0])}/{total} paragraf.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
