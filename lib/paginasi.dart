import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Memotong teks panjang menjadi halaman-halaman seukuran layar.
/// Dikerjakan per jendela kecil supaya layar tidak macet, dan hasilnya
/// dilaporkan sedikit demi sedikit lewat [lapor].
Future<void> paginasiTeks({
  required String teks,
  required TextStyle gaya,
  required double lebar,
  required double tinggi,
  required void Function(List<String> halaman, bool selesai) lapor,
  required bool Function() dibatalkan,
}) async {
  final hasil = <String>[];
  var awal = 0;
  var jendela = 7000;

  while (awal < teks.length) {
    if (dibatalkan()) return;

    final akhir = math.min(awal + jendela, teks.length);
    final habis = akhir >= teks.length;
    final potong = teks.substring(awal, akhir);

    final tp = TextPainter(
      text: TextSpan(text: potong, style: gaya),
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: lebar);
    final metrik = tp.computeLineMetrics();

    // Catat posisi atas tiap halaman (dalam piksel).
    final batas = <double>[0];
    var y = 0.0;
    var awalHalaman = 0.0;
    for (final m in metrik) {
      if (y + m.height > awalHalaman + tinggi + 0.5) {
        awalHalaman = y;
        batas.add(y);
      }
      y += m.height;
    }

    if (!habis && batas.length < 2) {
      jendela *= 2;
      tp.dispose();
      continue;
    }

    // Ubah posisi piksel menjadi posisi huruf.
    final posisi = <int>[0];
    for (var i = 1; i < batas.length; i++) {
      posisi.add(tp.getPositionForOffset(Offset(1, batas[i] + 2)).offset);
    }

    if (!habis && posisi.last <= 0) {
      jendela *= 2;
      tp.dispose();
      continue;
    }

    // Halaman terakhir pada jendela belum tentu penuh, jadi disisakan
    // untuk jendela berikutnya (kecuali sudah akhir teks).
    final jumlah = habis ? batas.length : batas.length - 1;
    for (var i = 0; i < jumlah; i++) {
      final dari = posisi[i];
      final sampai = i + 1 < posisi.length ? posisi[i + 1] : potong.length;
      final halaman = potong.substring(dari, sampai).trim();
      if (halaman.isNotEmpty) hasil.add(halaman);
    }

    awal = habis ? teks.length : awal + posisi.last;
    tp.dispose();

    lapor(List<String>.of(hasil), habis);
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }

  lapor(List<String>.of(hasil), true);
}
