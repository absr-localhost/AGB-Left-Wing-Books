import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import 'data_buku.dart';
import 'paginasi.dart';
import 'simpanan.dart';
import 'sumber.dart';
import 'tema.dart';

/// Pembaca buku: halaman digeser ke samping, ada sampul, nomor halaman,
/// pemilihan teks (salin dan bagikan), serta tombol salin/bagikan halaman.
class LayarBaca extends StatefulWidget {
  final Buku buku;

  /// true = paksa tampilkan teks asli (bukan terjemahan).
  final bool asli;
  const LayarBaca({super.key, required this.buku, this.asli = false});

  @override
  State<LayarBaca> createState() => _LayarBacaState();
}

class _LayarBacaState extends State<LayarBaca> {
  final PageController _pc = PageController();

  String? _teks;
  String _sumber = '';
  String _bahasa = 'id';
  bool _mesin = false; // teks yang tampil adalah terjemahan mesin
  bool _adaTerjemahan = false; // berkas terjemahan tersedia
  String _progres = '';
  bool _gagalMuat = false;

  bool _sudahMulai = false;
  bool _batal = false;
  List<String> _halaman = [];
  bool _selesai = false;
  int _idx = 0;

  // Posisi terakhir dibaca (dipulihkan otomatis) dan status favorit.
  int _target = 0;
  bool _targetSiap = false;
  bool _sudahLompat = false;
  bool _favorit = false;

  late final TextStyle _gayaBaca = gayaIsi(16.5, tinggi: 1.6);

  @override
  void initState() {
    super.initState();
    _muat();
    _muatPosisi();
  }

  Future<void> _muatPosisi() async {
    final id = widget.buku.id;
    final hal = await Simpanan.ambilHalaman(id);
    final fav = (await Simpanan.favorit()).contains(id);
    if (!mounted) return;
    setState(() {
      _target = hal;
      _favorit = fav;
      _targetSiap = true;
    });
    _cobaLompat();
  }

  /// Setelah halaman cukup tersusun, loncat ke halaman terakhir dibaca.
  void _cobaLompat() {
    if (_sudahLompat || !_targetSiap) return;
    if (_target <= 0) {
      _sudahLompat = true;
      return;
    }
    if (_halaman.length >= _target || _selesai) {
      _sudahLompat = true;
      final tujuan = _target > _halaman.length ? _halaman.length : _target;
      if (tujuan <= 0) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_pc.hasClients) return;
        _pc.jumpToPage(tujuan);
      });
    }
  }

  Future<void> _ubahFavorit() async {
    final baru = await Simpanan.ubahFavorit(widget.buku.id);
    if (!mounted) return;
    setState(() => _favorit = baru);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(baru ? 'Ditambahkan ke favorit.' : 'Dihapus dari favorit.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _batal = true;
    _pc.dispose();
    super.dispose();
  }

  Future<String?> _bacaBerkas(String nama) async {
    try {
      return await rootBundle.loadString('assets/buku/$nama');
    } catch (_) {
      return null;
    }
  }

  Future<void> _muat() async {
    try {
      final id = widget.buku.id;
      final terjemahan = await _bacaBerkas('$id.id.txt');
      final asliTeks = await _bacaBerkas('$id.txt');
      final pakaiTerjemahan = terjemahan != null && !widget.asli;
      final mentah = pakaiTerjemahan ? terjemahan : (asliTeks ?? terjemahan);
      if (mentah == null) {
        if (mounted) setState(() => _gagalMuat = true);
        return;
      }
      final baris = mentah.split('\n');
      var i = 0;
      var sumber = '';
      var bahasa = 'id';
      var mesin = false;
      var progres = '';
      while (i < baris.length && baris[i].startsWith('#')) {
        final b = baris[i];
        if (b.startsWith('#SUMBER:')) sumber = b.substring(8).trim();
        if (b.startsWith('#BAHASA:')) bahasa = b.substring(8).trim();
        if (b.startsWith('#TERJEMAHAN:')) {
          mesin = b.substring(12).trim() == 'mesin';
        }
        if (b.startsWith('#PROGRES:')) progres = b.substring(9).trim();
        i++;
      }
      final isi = baris.sublist(i).join('\n').trim();
      if (!mounted) return;
      if (isi.isEmpty) {
        setState(() => _gagalMuat = true);
        return;
      }
      setState(() {
        _teks = isi;
        _sumber = sumber;
        _bahasa = bahasa;
        _mesin = pakaiTerjemahan && mesin;
        _progres = progres;
        _adaTerjemahan = terjemahan != null;
      });
    } catch (_) {
      if (mounted) setState(() => _gagalMuat = true);
    }
  }

  /// Persen terjemahan, dari "n/total". Kosong bila tidak ada.
  String get _persen {
    final m = RegExp(r'^(\d+)\s*/\s*(\d+)$').firstMatch(_progres);
    if (m == null) return '';
    final n = int.parse(m.group(1)!);
    final t = int.parse(m.group(2)!);
    if (t <= 0) return '';
    return '${(n * 100 / t).floor()}%';
  }

  void _gantiTampilan() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => LayarBaca(buku: widget.buku, asli: !widget.asli),
      ),
    );
  }

  Future<void> _paginasi(double lebar, double tinggi) async {
    final teks = _teks;
    if (teks == null) return;
    try {
      await GoogleFonts.pendingFonts([_gayaBaca]);
    } catch (_) {}
    if (!mounted) return;
    await paginasiTeks(
      teks: teks,
      gaya: _gayaBaca,
      lebar: lebar,
      tinggi: tinggi,
      dibatalkan: () => _batal,
      lapor: (halaman, selesai) {
        if (!mounted) return;
        setState(() {
          _halaman = halaman;
          _selesai = selesai;
        });
        _cobaLompat();
        if (selesai) Simpanan.simpanTotal(widget.buku.id, halaman.length);
      },
    );
  }

  String get _teksHalamanIni {
    if (_idx <= 0 || _idx > _halaman.length) return '';
    return _halaman[_idx - 1];
  }

  String _tambahSumber(String isi) {
    final b = widget.buku;
    return '$isi\n\n- ${b.judul}, ${b.penulis} (${b.tahun})\nAGB Left-Wing Books';
  }

  void _bagikan() {
    final t = _teksHalamanIni;
    final b = widget.buku;
    Share.share(
      t.isEmpty ? '${b.judul} - ${b.penulis} (${b.tahun})' : _tambahSumber(t),
    );
  }

  void _salin() {
    final t = _teksHalamanIni;
    if (t.isEmpty) return;
    Clipboard.setData(ClipboardData(text: t));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Halaman tersalin.')),
    );
  }

  void _infoBuku() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Warna.putih,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            24 + MediaQuery.of(ctx).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.buku.judul, style: gayaJudul(19, tinggi: 1.25)),
              const SizedBox(height: 4),
              Text(
                '${widget.buku.penulis}, ${widget.buku.tahun}',
                style: gayaIsi(14, warna: Warna.teksRedup),
              ),
              const SizedBox(height: 16),
              if (labelSumber(_sumber).isNotEmpty) ...[
                Text(
                  'Sumber',
                  style: gayaLabel(12.5, berat: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  labelSumber(_sumber),
                  style: gayaIsi(14, tinggi: 1.45),
                ),
              ],
              if (_mesin) ...[
                const SizedBox(height: 12),
                Text(
                  'Penerjemah',
                  style: gayaLabel(12.5, berat: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Terjemahan mesin otomatis, tanpa penyuntingan manusia'
                  '${_persen.isEmpty ? '' : ', sudah $_persen diterjemahkan'}.',
                  style: gayaIsi(13.5, tinggi: 1.45),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Warna.biruMuda,
        body: SafeArea(
          child: Column(
            children: [
              _bilahAtas(),
              if (_teks != null && (_bahasa == 'en' || _mesin)) _catatanBahasa(),
              Expanded(child: _isi()),
              _bilahBawah(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bilahAtas() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded, color: Warna.biru),
            tooltip: 'Kembali',
          ),
          Expanded(
            child: Text(
              widget.buku.judul,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: gayaJudul(15),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: _ubahFavorit,
            icon: Icon(
              _favorit ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: Warna.biru,
            ),
            tooltip: _favorit ? 'Hapus dari favorit' : 'Tambah ke favorit',
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: _teks == null ? null : _salin,
            icon: const Icon(Icons.copy_rounded, color: Warna.biru),
            tooltip: 'Salin halaman',
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: _teks == null ? null : _bagikan,
            icon: const Icon(Icons.ios_share_rounded, color: Warna.biru),
            tooltip: 'Bagikan halaman',
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: _infoBuku,
            icon: const Icon(Icons.info_outline_rounded, color: Warna.biru),
            tooltip: 'Info buku',
          ),
        ],
      ),
    );
  }

  Widget _catatanBahasa() {
    String teks;
    String? tombol;
    if (_mesin) {
      teks = 'Terjemahan mesin otomatis, tanpa penyuntingan manusia. '
          'Bisa ada kekeliruan.'
          '${_persen.isEmpty ? '' : ' Baru $_persen diterjemahkan, sisanya masih berbahasa Inggris.'}';
      tombol = 'Lihat teks asli';
    } else if (_adaTerjemahan) {
      teks = 'Anda sedang membaca teks asli berbahasa Inggris.';
      tombol = 'Lihat terjemahan';
    } else {
      teks = 'Teks asli berbahasa Inggris. Terjemahan Indonesia belum tersedia.';
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Warna.putih,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Warna.garis),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              teks,
              style: gayaIsi(12.5, warna: Warna.teksRedup, tinggi: 1.4),
            ),
          ),
          if (tombol != null)
            TextButton(
              onPressed: _gantiTampilan,
              child: Text(tombol),
            ),
        ],
      ),
    );
  }

  Widget _isi() {
    if (_gagalMuat) return _pesanTengah(
      Icons.cloud_off_rounded,
      'Isi buku belum tersedia',
      'Isi buku ini belum ada di dalam aplikasi. '
          'Coba pasang versi aplikasi yang lebih baru.',
    );
    if (_teks == null) {
      return const Center(child: CircularProgressIndicator(color: Warna.biru));
    }

    return LayoutBuilder(
      builder: (context, box) {
        const margin = 16.0;
        const geserAtas = 22.0;
        const kakiHalaman = 40.0;
        const geserSamping = 22.0;

        final lebarTeks = box.maxWidth - margin * 2 - geserSamping * 2;
        final tinggiTeks =
            box.maxHeight - 16 - geserAtas - kakiHalaman - 4;

        if (!_sudahMulai && lebarTeks > 50 && tinggiTeks > 50) {
          _sudahMulai = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _paginasi(lebarTeks, tinggiTeks);
          });
        }

        final total = 1 + _halaman.length + (_selesai ? 0 : 1);

        return PageView.builder(
          controller: _pc,
          itemCount: total,
          onPageChanged: (i) {
            setState(() => _idx = i);
            Simpanan.simpanPosisi(
              widget.buku.id,
              i,
              _selesai ? _halaman.length : 0,
            );
          },
          itemBuilder: (context, i) {
            return AnimatedBuilder(
              animation: _pc,
              builder: (context, _) {
                var posisi = _idx.toDouble();
                if (_pc.hasClients && _pc.position.haveDimensions) {
                  posisi = _pc.page ?? posisi;
                }
                final d = (i - posisi).clamp(-1.0, 1.0);
                return Transform(
                  alignment:
                      d < 0 ? Alignment.centerRight : Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0009)
                    ..rotateY(d * 0.55),
                  child: _satuHalaman(i),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _satuHalaman(int i) {
    if (i == 0) return _sampul();
    if (i > _halaman.length) return _kertasMemuat();
    return _kertas(i, _halaman[i - 1]);
  }

  Widget _sampul() {
    final b = widget.buku;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Warna.biru, Warna.biruTua],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          bottomLeft: Radius.circular(6),
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 58, 112, 0.3),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 16,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.3),
                    Color.fromRGBO(255, 255, 255, 0.06),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(36, 40, 28, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b.penulis,
                  style: gayaLabel(
                    14,
                    warna: const Color.fromRGBO(255, 255, 255, 0.8),
                  ),
                ),
                const Spacer(),
                Text(
                  b.judul,
                  style: gayaJudul(30, warna: Warna.putih, tinggi: 1.2),
                ),
                const SizedBox(height: 14),
                Text(
                  b.tahun,
                  style: gayaLabel(
                    14,
                    warna: const Color.fromRGBO(255, 255, 255, 0.8),
                  ),
                ),
                const SizedBox(height: 40),
                Image.asset('assets/logo/logo_putih.png', width: 64),
                const SizedBox(height: 12),
                Text(
                  'Geser ke kiri untuk mulai membaca',
                  style: gayaIsi(
                    12.5,
                    warna: const Color.fromRGBO(255, 255, 255, 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _hiasanKertas() {
    return BoxDecoration(
      color: Warna.putih,
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 58, 112, 0.14),
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ],
    );
  }

  Widget _kertasMemuat() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: _hiasanKertas(),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Warna.biru),
            const SizedBox(height: 16),
            Text('Menyusun halaman...', style: gayaIsi(14, warna: Warna.teksRedup)),
          ],
        ),
      ),
    );
  }

  Widget _kertas(int nomor, String isi) {
    final b = widget.buku;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: _hiasanKertas(),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 14,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 58, 112, 0.10),
                    Color.fromRGBO(0, 58, 112, 0.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
            child: Column(
              children: [
                Expanded(
                  child: ClipRect(
                    child: SelectableText(
                      isi,
                      style: _gayaBaca,
                      textAlign: TextAlign.justify,
                      textScaler: TextScaler.noScaling,
                      contextMenuBuilder: (ctx, state) {
                        final item = <ContextMenuButtonItem>[
                          ...state.contextMenuButtonItems,
                          ContextMenuButtonItem(
                            label: 'Bagikan',
                            onPressed: () {
                              final v = state.textEditingValue;
                              final pilih = v.selection.textInside(v.text);
                              state.hideToolbar();
                              if (pilih.trim().isNotEmpty) {
                                Share.share(
                                  _tambahSumber('\u201C${pilih.trim()}\u201D'),
                                );
                              }
                            },
                          ),
                        ];
                        return AdaptiveTextSelectionToolbar.buttonItems(
                          anchors: state.contextMenuAnchors,
                          buttonItems: item,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      '$nomor',
                      style: gayaLabel(12.5, warna: Warna.teksRedup),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 14,
            top: 6,
            child: Text(
              b.judul,
              style: gayaLabel(10, warna: const Color(0xFF9DB1C7)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bilahBawah() {
    final total = 1 + _halaman.length + (_selesai ? 0 : 1);
    final maks = (total - 1).toDouble();
    final nilai = _idx.toDouble().clamp(0.0, maks < 1 ? 1.0 : maks);
    final label = _idx == 0
        ? 'Sampul'
        : _selesai
            ? 'Halaman $_idx dari ${_halaman.length}'
            : 'Halaman $_idx (menyusun...)';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Column(
        children: [
          Slider(
            value: nilai,
            min: 0,
            max: maks < 1 ? 1.0 : maks,
            activeColor: Warna.biru,
            inactiveColor: Warna.garis,
            onChanged: _teks == null || total < 2
                ? null
                : (v) => _pc.jumpToPage(v.round()),
          ),
          Text(label, style: gayaLabel(12.5)),
        ],
      ),
    );
  }

  Widget _pesanTengah(IconData ikon, String judul, String isi) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ikon, size: 48, color: Warna.biruCerah),
            const SizedBox(height: 14),
            Text(judul, style: gayaJudul(17)),
            const SizedBox(height: 8),
            Text(
              isi,
              textAlign: TextAlign.center,
              style: gayaIsi(14, warna: Warna.teksRedup, tinggi: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
