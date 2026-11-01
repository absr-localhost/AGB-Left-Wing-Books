const String versiAplikasi = '0.3.5';

class Buku {
  final String id;
  final String judul;
  final String penulis;
  final String tahun;
  final String kategori;
  final String ringkasan;

  /// true = karya sudah bebas hak cipta, isi penuh boleh dimasukkan.
  /// false = masih berhak cipta, hanya info buku yang ditampilkan.
  final bool bebasHakCipta;

  const Buku({
    required this.id,
    required this.judul,
    required this.penulis,
    required this.tahun,
    required this.kategori,
    required this.ringkasan,
    required this.bebasHakCipta,
  });
}

const List<String> daftarKategori = [
  'Semua',
  'Marxisme',
  'Sosialisme',
  'Anarkisme',
  'Pemikiran Indonesia',
];

// Katalog buku.
const List<Buku> daftarBuku = [
  Buku(
    id: 'manifesto',
    judul: 'Manifesto Partai Komunis',
    penulis: 'Karl Marx & Friedrich Engels',
    tahun: '1848',
    kategori: 'Marxisme',
    ringkasan:
        'Seruan ringkas yang memaparkan sejarah sebagai sejarah perjuangan kelas dan tujuan gerakan komunis.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'kapital1',
    judul: 'Kapital, Jilid I',
    penulis: 'Karl Marx',
    tahun: '1867',
    kategori: 'Marxisme',
    ringkasan:
        'Kritik terhadap ekonomi politik kapitalisme: komoditas, nilai lebih, dan penumpukan modal.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'upah_harga_laba',
    judul: 'Upah, Harga, dan Laba',
    penulis: 'Karl Marx',
    tahun: '1865',
    kategori: 'Marxisme',
    ringkasan:
        'Ceramah Marx yang menjelaskan hubungan upah, harga, dan laba bagi kaum pekerja.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'sosialisme_utopis',
    judul: 'Sosialisme: Utopis dan Ilmiah',
    penulis: 'Friedrich Engels',
    tahun: '1880',
    kategori: 'Sosialisme',
    ringkasan:
        'Uraian tentang perkembangan sosialisme dari gagasan para pemimpi menuju analisis sejarah dan ekonomi.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'asal_usul_keluarga',
    judul: 'Asal-usul Keluarga, Milik Pribadi, dan Negara',
    penulis: 'Friedrich Engels',
    tahun: '1884',
    kategori: 'Marxisme',
    ringkasan:
        'Penelusuran asal mula keluarga, kepemilikan pribadi, dan negara dalam sejarah masyarakat.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'negara_revolusi',
    judul: 'Negara dan Revolusi',
    penulis: 'V. I. Lenin',
    tahun: '1917',
    kategori: 'Marxisme',
    ringkasan:
        'Pembahasan ajaran Marxisme tentang negara dan tugas proletariat dalam revolusi.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'imperialisme',
    judul: 'Imperialisme, Tahap Tertinggi Kapitalisme',
    penulis: 'V. I. Lenin',
    tahun: '1917',
    kategori: 'Marxisme',
    ringkasan:
        'Analisis tentang monopoli, modal keuangan, dan perebutan wilayah oleh negara-negara besar.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'reformasi_revolusi',
    judul: 'Reformasi atau Revolusi?',
    penulis: 'Rosa Luxemburg',
    tahun: '1899',
    kategori: 'Sosialisme',
    ringkasan:
        'Bantahan terhadap gagasan bahwa sosialisme cukup dicapai lewat perbaikan bertahap.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'penaklukan_roti',
    judul: 'Penaklukan Roti',
    penulis: 'Pyotr Kropotkin',
    tahun: '1892',
    kategori: 'Anarkisme',
    ringkasan:
        'Gambaran masyarakat tanpa negara yang menjamin kebutuhan pangan dan papan bagi semua orang.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'saling_bantu',
    judul: 'Saling Bantu: Faktor dalam Evolusi',
    penulis: 'Pyotr Kropotkin',
    tahun: '1902',
    kategori: 'Anarkisme',
    ringkasan:
        'Argumen bahwa kerja sama sama pentingnya dengan persaingan dalam perkembangan makhluk hidup dan masyarakat.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'apakah_milik',
    judul: 'Apakah Milik Itu?',
    penulis: 'Pierre-Joseph Proudhon',
    tahun: '1840',
    kategori: 'Anarkisme',
    ringkasan:
        'Kajian tentang kepemilikan dan keadilan yang memuat pernyataan terkenal tentang milik sebagai pencurian.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'tuhan_negara',
    judul: 'Tuhan dan Negara',
    penulis: 'Mikhail Bakunin',
    tahun: '1882',
    kategori: 'Anarkisme',
    ringkasan:
        'Tulisan Bakunin tentang kebebasan, ilmu pengetahuan, dan kritiknya terhadap agama dan kekuasaan negara.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'madilog',
    judul: 'Madilog',
    penulis: 'Tan Malaka',
    tahun: '1943',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Materialisme, Dialektika, dan Logika: cara berpikir yang ditawarkan Tan Malaka bagi bangsa Indonesia.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'menuju_republik',
    judul: 'Menuju Republik Indonesia',
    penulis: 'Tan Malaka',
    tahun: '1925',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Rancangan awal tentang bentuk negara dan jalan perjuangan menuju Republik Indonesia.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'parlemen_soviet',
    judul: 'Parlemen atau Soviet?',
    penulis: 'Tan Malaka',
    tahun: '1921',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Membandingkan parlemen dan soviet sebagai bentuk kekuasaan, dengan tinjauan sejarah badan legislatif dan penerapannya bagi Indonesia.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'si_semarang',
    judul: 'SI Semarang dan Onderwijs',
    penulis: 'Tan Malaka',
    tahun: '1921',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Tulisan Tan Malaka tentang pendidikan rakyat di lingkungan Sarekat Islam Semarang.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'komunisme_panislamisme',
    judul: 'Komunisme dan Pan-Islamisme',
    penulis: 'Tan Malaka',
    tahun: '1922',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Pidato Tan Malaka di Kongres Komunis Internasional ke-4 tentang sikap terhadap Pan-Islamisme dan perjuangan pembebasan kaum Muslim terjajah.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'semangat_muda',
    judul: 'Semangat Muda',
    penulis: 'Tan Malaka',
    tahun: '1926',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Brosur Tan Malaka tahun 1926 yang ditujukan kepada kaum muda pergerakan.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'aksi_massa',
    judul: 'Massa Aksi',
    penulis: 'Tan Malaka',
    tahun: '1926',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Gagasan Tan Malaka tentang perjuangan rakyat banyak (massa aksi) sebagai jalan menuju kemerdekaan. Di arsip bertajuk Aksi Massa.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'politik_1945',
    judul: 'Politik',
    penulis: 'Tan Malaka',
    tahun: '1945',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Tulisan Tan Malaka, 24 November 1945, tentang politik perjuangan awal kemerdekaan.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'rencana_ekonomi',
    judul: 'Rencana Ekonomi Berjuang',
    penulis: 'Tan Malaka',
    tahun: '1945',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Tulisan Tan Malaka, 28 November 1945, tentang rencana ekonomi masa perjuangan.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'muslihat',
    judul: 'Muslihat',
    penulis: 'Tan Malaka',
    tahun: '1945',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Tulisan Tan Malaka, 2 Desember 1945, tentang muslihat perjuangan.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'manifesto_jakarta',
    judul: 'Manifesto Jakarta',
    penulis: 'Tan Malaka',
    tahun: '1945',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Manifesto kedua PARI (Partai Republik Indonesia), disebarkan ke seluruh Indonesia setelah Manifesto Bangkok 1927.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'situasi_politik',
    judul: 'Situasi Politik Luar dan Dalam Negeri',
    penulis: 'Tan Malaka',
    tahun: '1946',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Tulisan Tan Malaka, Januari 1946, tentang keadaan politik di dalam dan luar negeri.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'thesis',
    judul: 'Thesis',
    penulis: 'Tan Malaka',
    tahun: '1946',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Karya Tan Malaka (Juni 1946) yang oleh penerbit disebut menunjukkan jalan sosialisme sebagai pokok pemecahan masalah Indonesia.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'kuhandel_kaliurang',
    judul: 'Kuhandel di Kaliurang',
    penulis: 'Tan Malaka',
    tahun: '1948',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Tulisan Tan Malaka, 16 April 1948.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'berpisah_berjuang',
    judul: 'Berpisah Kita Berjuang, Bersama Kita Memukul',
    penulis: 'Tan Malaka',
    tahun: '1948',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Tulisan Tan Malaka, 6 Mei 1948 (Getrennt Marschieren, Vereint Schlagen).',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'gerpolek',
    judul: 'Gerpolek: Gerilya, Politik, Ekonomi',
    penulis: 'Tan Malaka',
    tahun: '1948',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Siasat perang gerilya yang dipadukan dengan politik dan ekonomi, ditulis Tan Malaka pada Mei 1948.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'pandangan_partai_rakyat',
    judul: 'Pandangan dan Langkah Partai Rakyat',
    penulis: 'Tan Malaka',
    tahun: '1948',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Tulisan Tan Malaka, 31 Juli 1948, tentang pandangan dan langkah Partai Rakyat.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'uraian_mendadak',
    judul: 'Uraian Mendadak',
    penulis: 'Tan Malaka',
    tahun: '1948',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Tulisan Tan Malaka, 7 November 1948, bertepatan dengan berdirinya Partai Murba.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'proklamasi_1945',
    judul: 'Proklamasi 17-8-1945: Isi dan Pelaksanaannya',
    penulis: 'Tan Malaka',
    tahun: '1948',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Tulisan Tan Malaka, 16 Desember 1948, tentang isi dan pelaksanaan Proklamasi.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'pandangan_hidup',
    judul: 'Pandangan Hidup',
    penulis: 'Tan Malaka',
    tahun: '1948',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Tulisan Tan Malaka tentang pandangan hidup.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'islam_madilog',
    judul: 'Islam dalam Tinjauan Madilog',
    penulis: 'Tan Malaka',
    tahun: '1948',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Tinjauan Tan Malaka terhadap Islam dengan cara berpikir Madilog.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'nasrani_madilog',
    judul: 'Nasrani-Yahudi dalam Tinjauan Madilog',
    penulis: 'Tan Malaka',
    tahun: '1948',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Tinjauan Tan Malaka terhadap agama Nasrani dan Yahudi dengan cara berpikir Madilog.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'sambutan_murba',
    judul: 'Sambutan Murba',
    penulis: 'Tan Malaka',
    tahun: '1948',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Sambutan Tan Malaka kepada kaum murba.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'hukum_revolusi',
    judul: 'Hukum Revolusi',
    penulis: 'Tan Malaka',
    tahun: '1948',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Tulisan Tan Malaka tentang hukum revolusi.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'dari_irsoekarno',
    judul: 'Dari Ir. Soekarno sampai ke Presiden Soekarno',
    penulis: 'Tan Malaka',
    tahun: '1948',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Tulisan Tan Malaka tentang Sukarno.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'program_maksimum',
    judul: 'Keterangan Ringkas tentang Program Maksimum',
    penulis: 'Tan Malaka',
    tahun: '1948',
    kategori: 'Pemikiran Indonesia',
    ringkasan:
        'Keterangan ringkas Tan Malaka tentang program maksimum.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'brumaire',
    judul: 'Brumaire Kedelapan Belas Louis Bonaparte',
    penulis: 'Karl Marx',
    tahun: '1852',
    kategori: 'Marxisme',
    ringkasan:
        'Analisis Marx atas kudeta Louis Bonaparte di Prancis tahun 1851 dan hubungan kelas di baliknya.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'anarkisme_goldman',
    judul: 'Anarkisme dan Esai Lain',
    penulis: 'Emma Goldman',
    tahun: '1910',
    kategori: 'Anarkisme',
    ringkasan:
        'Kumpulan esai Emma Goldman tentang anarkisme, kebebasan, dan kritik terhadap negara dan lembaga sosial.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'news_nowhere',
    judul: 'News from Nowhere (Kabar dari Negeri Entah)',
    penulis: 'William Morris',
    tahun: '1890',
    kategori: 'Sosialisme',
    ringkasan:
        'Novel utopia sosialis tentang masyarakat Inggris masa depan tanpa kapitalisme.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'looking_backward',
    judul: 'Looking Backward (Menengok ke Belakang)',
    penulis: 'Edward Bellamy',
    tahun: '1888',
    kategori: 'Sosialisme',
    ringkasan:
        'Novel utopia tentang seseorang yang terbangun di tahun 2000 dan mendapati masyarakat yang ditata secara sosialis.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'iron_heel',
    judul: 'The Iron Heel (Tumit Besi)',
    penulis: 'Jack London',
    tahun: '1908',
    kategori: 'Sosialisme',
    ringkasan:
        'Novel distopia tentang kekuasaan oligarki dan perlawanan kaum sosialis.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'kondisi_pekerja',
    judul: 'Kondisi Kelas Pekerja di Inggris',
    penulis: 'Friedrich Engels',
    tahun: '1845',
    kategori: 'Marxisme',
    ringkasan:
        'Laporan Engels tentang kehidupan buruh industri di Inggris pada awal Revolusi Industri.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'memoar_kropotkin',
    judul: 'Memoar Seorang Revolusioner',
    penulis: 'Pyotr Kropotkin',
    tahun: '1899',
    kategori: 'Anarkisme',
    ringkasan:
        'Memoar Kropotkin tentang masa mudanya, penjara, dan jalan hidupnya menjadi anarkis.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'utopia_more',
    judul: 'Utopia',
    penulis: 'Thomas More',
    tahun: '1516',
    kategori: 'Sosialisme',
    ringkasan:
        'Gambaran pulau Utopia dengan masyarakat tanpa milik pribadi, klasik awal gagasan masyarakat ideal.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'kerja_upahan',
    judul: 'Kerja-Upahan dan Kapital',
    penulis: 'Karl Marx',
    tahun: '1847',
    kategori: 'Marxisme',
    ringkasan:
        'Ceramah Marx tentang bagaimana upah ditentukan dan hubungan antara buruh dan modal.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'kemiskinan_filsafat',
    judul: 'Kemiskinan Filsafat',
    penulis: 'Karl Marx',
    tahun: '1847',
    kategori: 'Marxisme',
    ringkasan:
        'Jawaban Marx atas Filsafat Kemiskinan karya Proudhon dan kritiknya terhadap ekonomi politik borjuis.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'prinsip_komunisme',
    judul: 'Prinsip-Prinsip Komunisme',
    penulis: 'Friedrich Engels',
    tahun: '1847',
    kategori: 'Marxisme',
    ringkasan:
        'Rumusan tanya-jawab Engels tentang prinsip dasar komunisme, bahan awal bagi Manifesto.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'perang_tani',
    judul: 'Perang Tani di Jerman',
    penulis: 'Friedrich Engels',
    tahun: '1850',
    kategori: 'Marxisme',
    ringkasan:
        'Analisis Engels atas Perang Tani Jerman abad ke-16 dan pertentangan kelas di dalamnya.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'keluarga_suci',
    judul: 'Keluarga Suci',
    penulis: 'Karl Marx & Friedrich Engels',
    tahun: '1845',
    kategori: 'Marxisme',
    ringkasan:
        'Kritik Marx dan Engels terhadap idealisme kaum Hegelian Muda.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'tesis_feuerbach',
    judul: 'Tesis tentang Feuerbach',
    penulis: 'Karl Marx',
    tahun: '1845',
    kategori: 'Marxisme',
    ringkasan:
        'Sebelas catatan ringkas Marx tentang materialisme dan praktik, versi asli.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'feuerbach_klasik',
    judul: 'Feuerbach dan Akhir Filsafat Klasik Jerman',
    penulis: 'Friedrich Engels',
    tahun: '1886',
    kategori: 'Marxisme',
    ringkasan:
        'Engels meninjau hubungan Hegel dan Feuerbach dengan lahirnya materialisme dialektis.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'kera_manusia',
    judul: 'Peranan Kerja dalam Peralihan dari Kera ke Manusia',
    penulis: 'Friedrich Engels',
    tahun: '1876',
    kategori: 'Marxisme',
    ringkasan:
        'Esai Engels tentang peran kerja dalam evolusi manusia dari kera.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'pengantar_kritik',
    judul: 'Kata Pengantar: Sumbangan untuk Kritik Ekonomi Politik',
    penulis: 'Karl Marx',
    tahun: '1859',
    kategori: 'Marxisme',
    ringkasan:
        'Pengantar 1859 yang merumuskan pandangan Marx tentang dasar ekonomi dan perkembangan masyarakat.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'kapital1_bag1',
    judul: 'Kapital I, Bagian 1 (belum lengkap)',
    penulis: 'Karl Marx',
    tahun: '1867',
    kategori: 'Marxisme',
    ringkasan:
        'Bagian awal Kapital Jilid I dalam terjemahan Indonesia dari Marxists.org. Versi penuh Inggris ada di Kapital, Jilid I.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'anti_duhring',
    judul: 'Anti-Dühring',
    penulis: 'Friedrich Engels',
    tahun: '1877',
    kategori: 'Marxisme',
    ringkasan:
        'Pembelaan sistematis Engels atas pandangan Marxis tentang filsafat, ekonomi politik, dan sosialisme terhadap Eugen Dühring.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'kapital2',
    judul: 'Kapital, Jilid II',
    penulis: 'Karl Marx',
    tahun: '1885',
    kategori: 'Marxisme',
    ringkasan:
        'Jilid II Kapital: proses sirkulasi modal.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'kapital3',
    judul: 'Kapital, Jilid III',
    penulis: 'Karl Marx',
    tahun: '1894',
    kategori: 'Marxisme',
    ringkasan:
        'Jilid III Kapital: proses keseluruhan produksi kapitalis.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'masalah_perumahan',
    judul: 'Masalah Perumahan',
    penulis: 'Friedrich Engels',
    tahun: '1872',
    kategori: 'Marxisme',
    ringkasan:
        'Engels tentang krisis perumahan buruh dan kritiknya terhadap solusi reformis.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'apa_dikerjakan',
    judul: 'Apa yang Harus Dikerjakan? (belum lengkap)',
    penulis: 'V.I. Lenin',
    tahun: '1902',
    kategori: 'Marxisme',
    ringkasan:
        'Gagasan Lenin tentang organisasi partai revolusioner dan koran politik se-Rusia.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'revolusi_permanen',
    judul: 'Revolusi Permanen (termasuk Hasil dan Prospek)',
    penulis: 'Leon Trotsky',
    tahun: '1906',
    kategori: 'Marxisme',
    ringkasan:
        'Teori Revolusi Permanen Trotsky tentang jalannya revolusi di negara yang terbelakang.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'civil_war_france',
    judul: 'Perang Saudara di Prancis',
    penulis: 'Karl Marx',
    tahun: '1871',
    kategori: 'Marxisme',
    ringkasan:
        'Analisis Marx atas Komune Paris 1871.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'kautsky_class',
    judul: 'Perjuangan Kelas',
    penulis: 'Karl Kautsky',
    tahun: '1892',
    kategori: 'Marxisme',
    ringkasan:
        'Uraian Kautsky tentang Program Erfurt dan perjuangan kelas.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'plekhanov_anarkisme',
    judul: 'Anarkisme dan Sosialisme',
    penulis: 'Georgi Plekhanov',
    tahun: '1895',
    kategori: 'Marxisme',
    ringkasan:
        'Kritik Plekhanov terhadap anarkisme dari sudut pandang Marxis.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'malatesta_anarki',
    judul: 'Anarki',
    penulis: 'Errico Malatesta',
    tahun: '1891',
    kategori: 'Anarkisme',
    ringkasan:
        'Uraian Malatesta tentang gagasan anarkisme.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'owen_pandangan_baru',
    judul: 'Pandangan Baru tentang Masyarakat',
    penulis: 'Robert Owen',
    tahun: '1813',
    kategori: 'Sosialisme',
    ringkasan:
        'Esai Robert Owen tentang pembentukan watak oleh lingkungan dan reformasi sosial.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'komunisme_sayap_kiri',
    judul: 'Komunisme Sayap Kiri: Penyakit Kekanak-kanakan',
    penulis: 'V.I. Lenin',
    tahun: '1920',
    kategori: 'Marxisme',
    ringkasan:
        'Lenin tentang taktik gerakan komunis dan kritik terhadap kekirian yang kaku.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'sepuluh_hari',
    judul: 'Sepuluh Hari yang Mengguncang Dunia',
    penulis: 'John Reed',
    tahun: '1919',
    kategori: 'Sosialisme',
    ringkasan:
        'Laporan saksi mata John Reed tentang Revolusi Oktober 1917.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'seruan_kaum_muda',
    judul: 'Seruan kepada Kaum Muda',
    penulis: 'Pyotr Kropotkin',
    tahun: '1880',
    kategori: 'Anarkisme',
    ringkasan:
        'Seruan Kropotkin kepada kaum muda terdidik agar berpihak pada rakyat pekerja.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'ladang_pabrik',
    judul: 'Ladang, Pabrik, dan Bengkel',
    penulis: 'Pyotr Kropotkin',
    tahun: '1898',
    kategori: 'Anarkisme',
    ringkasan:
        'Gagasan Kropotkin tentang memadukan pertanian, industri, serta kerja otak dan tangan.',
    bebasHakCipta: true,
  ),
  Buku(
    id: 'junius',
    judul: 'Pamflet Junius',
    penulis: 'Rosa Luxemburg',
    tahun: '1916',
    kategori: 'Marxisme',
    ringkasan:
        'Kritik Luxemburg terhadap perang dunia dan sikap Sosial Demokrasi Jerman.',
    bebasHakCipta: true,
  ),
];
