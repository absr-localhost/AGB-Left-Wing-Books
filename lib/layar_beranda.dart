import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data_buku.dart';
import 'layar_baca.dart';
import 'layar_tentang.dart';
import 'simpanan.dart';
import 'sumber.dart';
import 'tema.dart';

class LayarBeranda extends StatefulWidget {
  const LayarBeranda({super.key});

  @override
  State<LayarBeranda> createState() => _LayarBerandaState();
}

class _LayarBerandaState extends State<LayarBeranda> {
  String _kategori = 'Semua';
  String _kata = '';

  // Data pembaca: favorit, riwayat, dan posisi terakhir tiap buku.
  Set<String> _fav = <String>{};
  List<String> _riwayat = <String>[];
  final Map<String, int> _hal = <String, int>{};
  final Map<String, int> _tot = <String, int>{};

  @override
  void initState() {
    super.initState();
    _muatSimpanan();
  }

  Future<void> _muatSimpanan() async {
    final fav = await Simpanan.favorit();
    final riw = await Simpanan.riwayat();
    final hal = <String, int>{};
    final tot = <String, int>{};
    for (final id in riw) {
      hal[id] = await Simpanan.ambilHalaman(id);
      tot[id] = await Simpanan.ambilTotal(id);
    }
    if (!mounted) return;
    setState(() {
      _fav = fav;
      _riwayat = riw;
      _hal
        ..clear()
        ..addAll(hal);
      _tot
        ..clear()
        ..addAll(tot);
    });
  }

  Future<void> _ubahFavorit(Buku b) async {
    await Simpanan.ubahFavorit(b.id);
    await _muatSimpanan();
  }

  List<String> get _daftarChip => <String>[
        'Semua',
        'Favorit',
        ...daftarKategori.where((k) => k != 'Semua'),
      ];

  void _bukaBaca(Buku b) {
    Navigator.of(context)
        .push(
          PageRouteBuilder<void>(
            transitionDuration: const Duration(milliseconds: 450),
            pageBuilder: (c, a, s) => LayarBaca(buku: b),
            transitionsBuilder: (c, a, s, child) {
              return FadeTransition(
                opacity: a,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.04),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
                  child: child,
                ),
              );
            },
          ),
        )
        .then((_) => _muatSimpanan());
  }

  List<Buku> get _hasil {
    final k = _kata.trim().toLowerCase();
    return daftarBuku.where((b) {
      final cocokKategori = _kategori == 'Semua' ||
          (_kategori == 'Favorit'
              ? _fav.contains(b.id)
              : b.kategori == _kategori);
      final cocokKata = k.isEmpty ||
          b.judul.toLowerCase().contains(k) ||
          b.penulis.toLowerCase().contains(k);
      return cocokKategori && cocokKata;
    }).toList();
  }

  void _bukaDetail(Buku b) {
    final pesan = ScaffoldMessenger.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _LembarDetail(
          buku: b,
          lanjut: _hal[b.id] ?? 0,
          onBaca: () {
            Navigator.of(ctx).pop();
            _bukaBaca(b);
          },
          onSalin: () {
            Clipboard.setData(
              ClipboardData(text: '${b.judul} - ${b.penulis} (${b.tahun})'),
            );
            Navigator.of(ctx).pop();
            pesan.showSnackBar(
              const SnackBar(content: Text('Info buku tersalin.')),
            );
          },
        );
      },
    );
  }

  void _tentang() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const LayarTentang()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasil = _hasil;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Warna.putih,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _kepala()),
              SliverToBoxAdapter(child: _spanduk(daftarBuku.length)),
              SliverToBoxAdapter(child: _lanjutkan()),
              SliverToBoxAdapter(child: _kolomCari()),
              SliverToBoxAdapter(child: _deretanKategori()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
                  child: Row(
                    children: [
                      Text('Rak buku', style: gayaJudul(18)),
                      const Spacer(),
                      Text('${hasil.length} buku', style: gayaLabel(13)),
                    ],
                  ),
                ),
              ),
              if (hasil.isEmpty)
                SliverToBoxAdapter(child: _kosong())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 22,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.5,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _KartuBuku(
                        buku: hasil[i],
                        favorit: _fav.contains(hasil[i].id),
                        onFavorit: () => _ubahFavorit(hasil[i]),
                        indeks: i,
                        warnaIndeks: daftarBuku.indexOf(hasil[i]),
                        onTap: () => _bukaDetail(hasil[i]),
                      ),
                      childCount: hasil.length,
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  child: Text(
                    'AGB Left-Wing Books  \u2022  Versi $versiAplikasi',
                    textAlign: TextAlign.center,
                    style: gayaLabel(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kepala() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 12, 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset('assets/logo/ikon_512.png', width: 44, height: 44),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Perpustakaan', style: gayaIsi(12.5, warna: Warna.teksRedup)),
                Text('AGB Left-Wing Books', style: gayaJudul(18)),
              ],
            ),
          ),
          IconButton(
            onPressed: _tentang,
            icon: const Icon(Icons.info_outline_rounded, color: Warna.biru),
            tooltip: 'Tentang aplikasi',
          ),
        ],
      ),
    );
  }

  Widget _spanduk(int jumlah) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(22),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Warna.biruTua, Warna.biru],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 58, 112, 0.25),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            bottom: -18,
            child: Opacity(
              opacity: 0.14,
              child: Image.asset('assets/logo/logo_putih.png', width: 170),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pemikiran kiri,\ndalam satu rak.',
                style: gayaJudul(22, warna: Warna.putih, tinggi: 1.25),
              ),
              const SizedBox(height: 10),
              Text(
                'Dari Marx sampai Tan Malaka.',
                style: gayaIsi(
                  13.5,
                  warna: const Color.fromRGBO(255, 255, 255, 0.82),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _pil('$jumlah judul'),
                  const SizedBox(width: 8),
                  _pil('Gratis'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _lanjutkan() {
    final buku = <Buku>[];
    for (final id in _riwayat) {
      final i = daftarBuku.indexWhere((b) => b.id == id);
      if (i >= 0) buku.add(daftarBuku[i]);
      if (buku.length >= 6) break;
    }
    if (buku.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Lanjutkan membaca', style: gayaJudul(18)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 104,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: buku.length,
              separatorBuilder: (context, i) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final b = buku[i];
                final h = _hal[b.id] ?? 0;
                final t = _tot[b.id] ?? 0;
                final double? nilai =
                    t > 0 ? (h / t).clamp(0.0, 1.0).toDouble() : null;
                return GestureDetector(
                  onTap: () => _bukaBaca(b),
                  child: Container(
                    width: 250,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Warna.biruMuda,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            b.judul,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: gayaJudul(14, tinggi: 1.25),
                          ),
                        ),
                        if (nilai != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: nilai,
                              minHeight: 5,
                              color: Warna.biru,
                              backgroundColor: Warna.garis,
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                        Text(
                          t > 0
                              ? 'Halaman $h dari $t'
                              : (h > 0 ? 'Halaman $h' : 'Sampul'),
                          style: gayaLabel(12, warna: Warna.biru),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _pil(String teks) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(teks, style: gayaLabel(12, warna: Warna.putih)),
    );
  }

  Widget _kolomCari() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextField(
        onChanged: (v) => setState(() => _kata = v),
        style: gayaIsi(15),
        decoration: InputDecoration(
          hintText: 'Cari judul atau penulis',
          hintStyle: gayaIsi(15, warna: Warna.teksRedup),
          prefixIcon: const Icon(Icons.search_rounded, color: Warna.biru),
          filled: true,
          fillColor: Warna.biruMuda,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Warna.biru, width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _deretanKategori() {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _daftarChip.length,
          separatorBuilder: (context, i) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final k = _daftarChip[i];
            final aktif = k == _kategori;
            return GestureDetector(
              onTap: () => setState(() => _kategori = k),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: aktif ? Warna.biru : Warna.putih,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: aktif ? Warna.biru : Warna.garis),
                ),
                child: Text(
                  k,
                  style: gayaJudul(
                    13,
                    berat: FontWeight.w500,
                    warna: aktif ? Warna.putih : Warna.teks,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _kosong() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 44, color: Warna.biruCerah),
          const SizedBox(height: 12),
          Text(
            _kategori == 'Favorit'
                ? 'Belum ada buku favorit'
                : 'Tidak ada buku yang cocok',
            style: gayaJudul(15),
          ),
          const SizedBox(height: 6),
          Text(
            _kategori == 'Favorit'
                ? 'Tekan ikon penanda di sampul buku untuk menambahkannya.'
                : 'Coba kata kunci lain atau pilih kategori Semua.',
            textAlign: TextAlign.center,
            style: gayaIsi(13.5, warna: Warna.teksRedup),
          ),
        ],
      ),
    );
  }
}

const List<List<Color>> _warnaSampul = [
  [Color(0xFF00529C), Color(0xFF003A70)],
  [Color(0xFF1E6FC0), Color(0xFF00529C)],
  [Color(0xFF0A3D7A), Color(0xFF021E40)],
  [Color(0xFF2F80D6), Color(0xFF0B4E96)],
  [Color(0xFF1B4F8F), Color(0xFF0E2D5A)],
];

class _KartuBuku extends StatelessWidget {
  final Buku buku;
  final bool favorit;
  final VoidCallback onFavorit;
  final int indeks;
  final int warnaIndeks;
  final VoidCallback onTap;

  const _KartuBuku({
    required this.buku,
    required this.favorit,
    required this.onFavorit,
    required this.indeks,
    required this.warnaIndeks,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final warna = _warnaSampul[warnaIndeks % _warnaSampul.length];
    final tunda = (indeks > 7 ? 7 : indeks) * 70;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + tunda),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) {
        return Opacity(
          opacity: v,
          child: Transform.translate(offset: Offset(0, 18 * (1 - v)), child: child),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: warna,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                    topRight: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 58, 112, 0.28),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: 10,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(0, 0, 0, 0.28),
                              Color.fromRGBO(255, 255, 255, 0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 2,
                      top: 2,
                      child: GestureDetector(
                        onTap: onFavorit,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            favorit
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            size: 22,
                            color: Warna.putih,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 18, 34, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            buku.penulis,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: gayaLabel(
                              10.5,
                              warna: const Color.fromRGBO(255, 255, 255, 0.75),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            buku.judul,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: gayaJudul(
                              15,
                              warna: Warna.putih,
                              tinggi: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Image.asset('assets/logo/logo_putih.png', width: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              buku.judul,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: gayaJudul(13, tinggi: 1.25),
            ),
            const SizedBox(height: 3),
            Text(
              buku.penulis,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: gayaIsi(12, warna: Warna.teksRedup),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  buku.bebasHakCipta
                      ? Icons.menu_book_rounded
                      : Icons.info_outline_rounded,
                  size: 14,
                  color: buku.bebasHakCipta ? Warna.biru : Warna.teksRedup,
                ),
                const SizedBox(width: 5),
                Text(
                  buku.bebasHakCipta ? 'Isi penuh' : 'Info saja',
                  style: gayaLabel(
                    11.5,
                    warna: buku.bebasHakCipta ? Warna.biru : Warna.teksRedup,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LembarDetail extends StatelessWidget {
  final Buku buku;
  final int lanjut;
  final VoidCallback onBaca;
  final VoidCallback onSalin;

  const _LembarDetail({
    required this.buku,
    required this.lanjut,
    required this.onBaca,
    required this.onSalin,
  });

  @override
  Widget build(BuildContext context) {
    final bawah = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Warna.putih,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bawah),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Warna.garis,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              buku.kategori,
              style: gayaLabel(13, warna: Warna.biru, berat: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(buku.judul, style: gayaJudul(22, tinggi: 1.25)),
            const SizedBox(height: 6),
            Text(
              '${buku.penulis}, ${buku.tahun}',
              style: gayaIsi(14.5, warna: Warna.teksRedup),
            ),
            const SizedBox(height: 16),
            Text(buku.ringkasan, style: gayaIsi(15, tinggi: 1.55)),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Warna.biruMuda,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    buku.bebasHakCipta
                        ? Icons.check_circle_outline_rounded
                        : Icons.info_outline_rounded,
                    size: 20,
                    color: Warna.biru,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      buku.bebasHakCipta
                          ? (sumberBuku(buku).isEmpty
                              ? 'Isi lengkap tersedia di dalam aplikasi.'
                              : 'Sumber: ${sumberBuku(buku)}')
                          : 'Hanya info buku yang ditampilkan.',
                      style: gayaIsi(13.5, tinggi: 1.45),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: buku.bebasHakCipta ? onBaca : null,
              style: FilledButton.styleFrom(
                backgroundColor: Warna.biru,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                buku.bebasHakCipta
                    ? (lanjut > 0 ? 'Lanjutkan membaca' : 'Baca buku')
                    : 'Isi penuh tidak tersedia',
                style: gayaJudul(15, warna: Warna.putih, berat: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: onSalin,
              style: OutlinedButton.styleFrom(
                foregroundColor: Warna.biru,
                minimumSize: const Size.fromHeight(52),
                side: const BorderSide(color: Warna.garis),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Salin info buku',
                style: gayaJudul(15, warna: Warna.biru, berat: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
