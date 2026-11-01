import 'package:shared_preferences/shared_preferences.dart';

/// Penyimpanan kecil di perangkat: posisi terakhir dibaca, riwayat, favorit.
/// Semua pemanggilan aman: bila penyimpanan gagal, aplikasi tetap jalan.
class Simpanan {
  static const String _kRiwayat = 'riwayat';
  static const String _kFavorit = 'favorit';

  static String _kHal(String id) => 'hal_$id';
  static String _kTot(String id) => 'tot_$id';

  static Future<SharedPreferences?> _p() async {
    try {
      return await SharedPreferences.getInstance();
    } catch (_) {
      return null;
    }
  }

  /// Simpan halaman terakhir. [total] 0 = jumlah halaman belum diketahui.
  static Future<void> simpanPosisi(String id, int halaman, int total) async {
    final p = await _p();
    if (p == null) return;
    try {
      await p.setInt(_kHal(id), halaman);
      if (total > 0) await p.setInt(_kTot(id), total);
      if (halaman > 0) {
        final r = List<String>.from(p.getStringList(_kRiwayat) ?? <String>[]);
        r.remove(id);
        r.insert(0, id);
        await p.setStringList(_kRiwayat, r.take(20).toList());
      }
    } catch (_) {}
  }

  static Future<void> simpanTotal(String id, int total) async {
    final p = await _p();
    if (p == null || total <= 0) return;
    try {
      await p.setInt(_kTot(id), total);
    } catch (_) {}
  }

  static Future<int> ambilHalaman(String id) async {
    final p = await _p();
    return p?.getInt(_kHal(id)) ?? 0;
  }

  static Future<int> ambilTotal(String id) async {
    final p = await _p();
    return p?.getInt(_kTot(id)) ?? 0;
  }

  /// Daftar id buku yang pernah dibaca, yang terbaru di depan.
  static Future<List<String>> riwayat() async {
    final p = await _p();
    return List<String>.from(p?.getStringList(_kRiwayat) ?? <String>[]);
  }

  static Future<Set<String>> favorit() async {
    final p = await _p();
    return Set<String>.from(p?.getStringList(_kFavorit) ?? <String>[]);
  }

  /// Membalik status favorit. Mengembalikan status baru.
  static Future<bool> ubahFavorit(String id) async {
    final p = await _p();
    if (p == null) return false;
    try {
      final f = Set<String>.from(p.getStringList(_kFavorit) ?? <String>[]);
      final baru = !f.contains(id);
      if (baru) {
        f.add(id);
      } else {
        f.remove(id);
      }
      await p.setStringList(_kFavorit, f.toList());
      return baru;
    } catch (_) {
      return false;
    }
  }
}
