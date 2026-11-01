import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Warna utama: putih dan biru (biru diambil dari logo, #00529C).
class Warna {
  static const Color biru = Color(0xFF00529C);
  static const Color biruTua = Color(0xFF003A70);
  static const Color biruCerah = Color(0xFF2F80D6);
  static const Color biruMuda = Color(0xFFEAF2FB);
  static const Color putih = Color(0xFFFFFFFF);
  static const Color teks = Color(0xFF0E2238);
  static const Color teksRedup = Color(0xFF5B6F86);
  static const Color garis = Color(0xFFD9E4F1);
}

/// Poppins untuk judul.
TextStyle gayaJudul(
  double ukuran, {
  FontWeight berat = FontWeight.w600,
  Color warna = Warna.teks,
  double? tinggi,
  double? jarak,
}) {
  return GoogleFonts.poppins(
    fontSize: ukuran,
    fontWeight: berat,
    color: warna,
    height: tinggi,
    letterSpacing: jarak,
  );
}

/// Inter untuk teks bacaan.
TextStyle gayaIsi(
  double ukuran, {
  FontWeight berat = FontWeight.w400,
  Color warna = Warna.teks,
  double? tinggi,
}) {
  return GoogleFonts.inter(
    fontSize: ukuran,
    fontWeight: berat,
    color: warna,
    height: tinggi,
  );
}

/// Roboto untuk label kecil dan angka.
TextStyle gayaLabel(
  double ukuran, {
  FontWeight berat = FontWeight.w500,
  Color warna = Warna.teksRedup,
}) {
  return GoogleFonts.roboto(
    fontSize: ukuran,
    fontWeight: berat,
    color: warna,
  );
}

ThemeData buatTema() {
  final dasar = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Warna.biru,
      brightness: Brightness.light,
    ).copyWith(primary: Warna.biru),
    scaffoldBackgroundColor: Warna.putih,
  );
  return dasar.copyWith(
    textTheme: GoogleFonts.interTextTheme(dasar.textTheme),
  );
}
