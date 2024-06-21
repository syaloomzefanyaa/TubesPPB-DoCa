class HewanPeliharaan {
  final int id;
  final String kategori;
  final String ras;
  final String deskripsi;
  final String lingkunganHidup;
  final String caraMerawat;
  final List<String> imagePaths;

  HewanPeliharaan({
    required this.id,
    required this.kategori,
    required this.ras,
    required this.deskripsi,
    required this.lingkunganHidup,
    required this.caraMerawat,
    required this.imagePaths,
  });
}

final List<HewanPeliharaan> hewanPeliharaanList = [
  HewanPeliharaan(
    id: 5,
    kategori: 'Cat',
    ras: 'Persia',
    deskripsi: 'Cat berbulu panjang yang dikenal dengan wajah datar dan mata besar.',
    lingkunganHidup: 'Rumah dengan tempat tidur yang nyaman dan bersih.',
    caraMerawat: 'Menyikat bulu secara rutin, memberi makan makanan berkualitas tinggi, dan menjaga kebersihan mata.',
    imagePaths: [
      'assets/images/pet/cat.jpg',
      'assets/images/pet/cat.jpg',
    ],
  ),
  HewanPeliharaan(
    id: 6,
    kategori: 'Cat',
    ras: 'Maine Coon',
    deskripsi: 'Cat besar dengan bulu tebal yang dikenal ramah dan suka bermain.',
    lingkunganHidup: 'Rumah dengan banyak ruang untuk bergerak dan bermain.',
    caraMerawat: 'Menyikat bulu secara rutin, memberi makan makanan berkualitas tinggi, dan menyediakan mainan.',
    imagePaths: [
      'assets/images/pet/cat.jpg',
      'assets/images/pet/cat.jpg',
    ],
  ),
  HewanPeliharaan(
    id: 7,
    kategori: 'Cat',
    ras: 'Siamese',
    deskripsi: 'Cat ramping dengan bulu pendek yang dikenal sangat vokal dan sosial.',
    lingkunganHidup: 'Rumah dengan banyak interaksi manusia.',
    caraMerawat: 'Memberi makan makanan berkualitas tinggi, bermain secara rutin, dan menjaga kebersihan telinga.',
    imagePaths: [
      'assets/images/pet/cat.jpg',
      'assets/images/pet/cat.jpg',
    ],
  ),
  HewanPeliharaan(
    id: 8,
    kategori: 'Cat',
    ras: 'Bengal',
    deskripsi: 'Cat yang memiliki corak bulu seperti macan tutul dan sangat aktif.',
    lingkunganHidup: 'Rumah dengan banyak ruang untuk memanjat dan bermain.',
    caraMerawat: 'Memberi makan makanan berkualitas tinggi, menyediakan mainan, dan bermain secara aktif.',
    imagePaths: [
      'assets/images/pet/cat.jpg',
      'assets/images/pet/cat.jpg',
    ],
  ),
  HewanPeliharaan(
    id: 9,
    kategori: 'Dog',
    ras: 'Golden Retriever',
    deskripsi: 'Dog besar yang ramah dan sangat baik dengan anak-anak.',
    lingkunganHidup: 'Rumah dengan halaman luas untuk bermain.',
    caraMerawat: 'Memberi makan makanan berkualitas tinggi, olahraga rutin, dan menyikat bulu secara berkala.',
    imagePaths: [
      'assets/images/pet/dog.jpg',
      'assets/images/pet/dog.jpg',
    ],
  ),
  HewanPeliharaan(
    id: 10,
    kategori: 'Dog',
    ras: 'Bulldog',
    deskripsi: 'Dog dengan tubuh kekar dan wajah berkerut, dikenal tenang dan ramah.',
    lingkunganHidup: 'Rumah dengan tempat tidur yang nyaman dan sejuk.',
    caraMerawat: 'Memberi makan makanan berkualitas tinggi, menjaga kebersihan kulit, dan olahraga ringan.',
    imagePaths: [
      'assets/images/pet/dog.jpg',
      'assets/images/pet/dog.jpg',
    ],
  ),
  HewanPeliharaan(
    id: 11,
    kategori: 'Dog',
    ras: 'Beagle',
    deskripsi: 'Dog kecil yang dikenal cerdas dan memiliki naluri berburu yang kuat.',
    lingkunganHidup: 'Rumah dengan banyak aktivitas fisik dan mental.',
    caraMerawat: 'Memberi makan makanan berkualitas tinggi, olahraga rutin, dan melatih kepatuhan.',
    imagePaths: [
      'assets/images/pet/dog.jpg',
      'assets/images/pet/dog.jpg',
    ],
  ),
  HewanPeliharaan(
    id: 12,
    kategori: 'Dog',
    ras: 'Poodle',
    deskripsi: 'Dog yang sangat pintar dan memiliki berbagai ukuran dari kecil hingga besar.',
    lingkunganHidup: 'Rumah dengan banyak interaksi manusia dan ruang untuk bermain.',
    caraMerawat: 'Memberi makan makanan berkualitas tinggi, menyikat bulu secara rutin, dan melatih trik baru.',
    imagePaths: [
      'assets/images/pet/dog.jpg',
      'assets/images/pet/dog.jpg',
    ],
  ),
  HewanPeliharaan(
    id: 13,
    kategori: 'Dog',
    ras: 'Shih Tzu',
    deskripsi: 'Dog kecil dengan bulu panjang yang ramah dan suka berada di dalam rumah.',
    lingkunganHidup: 'Rumah dengan tempat tidur yang nyaman dan hangat.',
    caraMerawat: 'Menyikat bulu setiap hari, memberi makan makanan berkualitas tinggi, dan menjaga kebersihan mata dan telinga.',
    imagePaths: [
      'assets/images/pet/dog.jpg',
      'assets/images/pet/dog.jpg',
    ],
  ),
  HewanPeliharaan(
    id: 14,
    kategori: 'Dog',
    ras: 'Dalmatian',
    deskripsi: 'Dog besar yang dikenal dengan bintik hitam putihnya dan sangat energik.',
    lingkunganHidup: 'Rumah dengan banyak ruang untuk berlari dan bermain.',
    caraMerawat: 'Memberi makan makanan berkualitas tinggi, olahraga rutin, dan melatih kepatuhan.',
    imagePaths: [
      'assets/images/pet/dog.jpg',
      'assets/images/pet/dog.jpg',
    ],
  ),
];
