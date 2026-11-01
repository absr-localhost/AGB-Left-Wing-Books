import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data_buku.dart';
import 'sumber.dart';
import 'tema.dart';

/// Halaman Tentang: logo, versi, dan kredit sumber.
class LayarTentang extends StatelessWidget {
  const LayarTentang({super.key});

  @override
  Widget build(BuildContext context) {
    final bawah = MediaQuery.of(context).padding.bottom;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Warna.putih,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                24,
                MediaQuery.of(context).padding.top + 12,
                24,
                36,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Warna.biruTua, Warna.biru],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: Warna.putih),
                    tooltip: 'Kembali',
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  const SizedBox(height: 18),
                  Image.asset('assets/logo/logo_putih.png', width: 96),
                  const SizedBox(height: 18),
                  Text(
                    'AGB Left-Wing Books',
                    style: gayaJudul(24, warna: Warna.putih, tinggi: 1.2),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Versi $versiAplikasi',
                    style: gayaLabel(
                      13.5,
                      warna: const Color.fromRGBO(255, 255, 255, 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 28 + bawah),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tentang aplikasi', style: gayaJudul(17)),
                  const SizedBox(height: 8),
                  Text(
                    'Perpustakaan pemikiran kiri dalam satu rak: karya Marx, '
                    'Engels, Lenin, Tan Malaka, dan banyak tokoh lain, '
                    'lengkap dengan penanda halaman yang mengingat '
                    'bacaan terakhir Anda.',
                    style: gayaIsi(14.5, tinggi: 1.6),
                  ),
                  const SizedBox(height: 26),
                  Text('Kredit sumber', style: gayaJudul(17)),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Warna.biruMuda,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Isi buku dalam aplikasi ini bersumber dari '
                      '$sumberMarxists (terjemahan Indonesia oleh para '
                      'relawan penerjemahnya) dan $sumberGutenberg '
                      '(karya domain publik). Seluruh hak atas karya dan '
                      'terjemahan tetap pada penulis, penerjemah, dan '
                      'pengelola sumbernya masing-masing. Teks berbahasa '
                      'Inggris yang tampil dalam bahasa Indonesia adalah '
                      'terjemahan mesin otomatis, tanpa penyuntingan '
                      'manusia, sehingga dapat mengandung kekeliruan.',
                      style: gayaIsi(14, tinggi: 1.6),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      'AGB Left-Wing Books',
                      style: gayaLabel(12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
