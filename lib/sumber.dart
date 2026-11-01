import 'data_buku.dart';

/// Nama sumber yang ditampilkan di aplikasi.
const String sumberMarxists = 'BUKU Marxists.org';
const String sumberGutenberg = 'BUKU Project Gutenberg';

/// Mengubah keterangan sumber mentah menjadi nama sumber yang rapi.
/// Kosong bila tidak dikenali.
String labelSumber(String mentah) {
  final s = mentah.toLowerCase();
  if (s.contains('marxists')) return sumberMarxists;
  if (s.contains('gutenberg')) return sumberGutenberg;
  return '';
}

/// Sumber utama tiap buku (dipakai di lembar detail sebelum buku dibuka).
const Map<String, String> _sumberAwal = {
  'manifesto': 'marxists',
  'madilog': 'marxists',
  'menuju_republik': 'marxists',
  'kapital1': 'gutenberg',
  'upah_harga_laba': 'marxists',
  'sosialisme_utopis': 'marxists',
  'asal_usul_keluarga': 'gutenberg',
  'negara_revolusi': 'marxists',
  'imperialisme': 'gutenberg',
  'reformasi_revolusi': 'gutenberg',
  'penaklukan_roti': 'gutenberg',
  'saling_bantu': 'gutenberg',
  'apakah_milik': 'gutenberg',
  'tuhan_negara': 'gutenberg',
  'parlemen_soviet': 'marxists',
  'si_semarang': 'marxists',
  'komunisme_panislamisme': 'marxists',
  'semangat_muda': 'marxists',
  'aksi_massa': 'marxists',
  'politik_1945': 'marxists',
  'rencana_ekonomi': 'marxists',
  'muslihat': 'marxists',
  'manifesto_jakarta': 'marxists',
  'situasi_politik': 'marxists',
  'thesis': 'marxists',
  'kuhandel_kaliurang': 'marxists',
  'berpisah_berjuang': 'marxists',
  'gerpolek': 'marxists',
  'pandangan_partai_rakyat': 'marxists',
  'uraian_mendadak': 'marxists',
  'proklamasi_1945': 'marxists',
  'pandangan_hidup': 'marxists',
  'islam_madilog': 'marxists',
  'nasrani_madilog': 'marxists',
  'sambutan_murba': 'marxists',
  'hukum_revolusi': 'marxists',
  'dari_irsoekarno': 'marxists',
  'program_maksimum': 'marxists',
  'brumaire': 'marxists',
  'anarkisme_goldman': 'gutenberg',
  'news_nowhere': 'gutenberg',
  'looking_backward': 'gutenberg',
  'iron_heel': 'gutenberg',
  'kondisi_pekerja': 'gutenberg',
  'memoar_kropotkin': 'gutenberg',
  'utopia_more': 'gutenberg',
  'kerja_upahan': 'marxists',
  'kemiskinan_filsafat': 'marxists',
  'prinsip_komunisme': 'marxists',
  'perang_tani': 'marxists',
  'keluarga_suci': 'marxists',
  'tesis_feuerbach': 'marxists',
  'feuerbach_klasik': 'marxists',
  'kera_manusia': 'marxists',
  'pengantar_kritik': 'marxists',
  'kapital1_bag1': 'marxists',
  'anti_duhring': 'marxists',
  'kapital2': 'marxists',
  'kapital3': 'marxists',
  'masalah_perumahan': 'marxists',
  'apa_dikerjakan': 'marxists',
  'revolusi_permanen': 'marxists',
  'civil_war_france': 'gutenberg',
  'kautsky_class': 'gutenberg',
  'plekhanov_anarkisme': 'gutenberg',
  'malatesta_anarki': 'gutenberg',
  'owen_pandangan_baru': 'gutenberg',
  'komunisme_sayap_kiri': 'gutenberg',
  'sepuluh_hari': 'gutenberg',
  'seruan_kaum_muda': 'gutenberg',
  'ladang_pabrik': 'gutenberg',
  'junius': 'gutenberg',
};

String sumberBuku(Buku b) {
  final v = _sumberAwal[b.id];
  if (v == 'gutenberg') return sumberGutenberg;
  if (v == 'marxists') return sumberMarxists;
  return '';
}
