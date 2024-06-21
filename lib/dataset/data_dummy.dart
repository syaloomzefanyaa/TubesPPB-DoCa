class Lokasi {
  final int id;
  final String namaKlinik;
  final String alamat;
  final String bukaTutup;
  final String deskripsi;
  final String dokterHewan;
  final List<String> imagePaths;
  final double latitude;
  final double longitude;

  Lokasi({
    required this.id,
    required this.namaKlinik,
    required this.alamat,
    required this.bukaTutup,
    required this.deskripsi,
    required this.dokterHewan,
    required this.imagePaths,
    required this.latitude,
    required this.longitude,
  });
}

final List<Lokasi> lokasiList = [
  Lokasi(
    id: 1,
    namaKlinik: 'Klinik Hewan Sehat',
    alamat: 'Jl. Cemara No. 12, Kelapa Gading, Jakarta Utara',
    bukaTutup: 'Senin - Jumat: 08.00 - 20.00, Sabtu: 08.00 - 17.00',
    deskripsi:
    'Klinik Hewan Sehat merupakan tempat perawatan hewan yang dilengkapi dengan fasilitas modern dan dokter-dokter hewan berpengalaman.',
    dokterHewan: 'Dr. Andi Wijaya, drh.',
    imagePaths: [
      'assets/images/PetShop/DogBed.jpg',
      'assets/images/PetClinic/petClinic1.jpg',
      'assets/images/PetClinic/petClinic1.jpg'
    ],
    latitude: -6.167282,
    longitude: 106.908979,
  ),
  Lokasi(
    id: 2,
    namaKlinik: 'Pet Shop Happy Pets',
    alamat: 'Jl. Darmo Baru No. 32, Surabaya',
    bukaTutup: 'Senin - Minggu: 09.00 - 22.00',
    deskripsi:
    'Pet Shop Happy Pets adalah tempat yang cocok untuk memenuhi kebutuhan hewan peliharaan Anda dengan beragam produk dan layanan yang disediakan.',
    dokterHewan: 'Dr. Ika Putri, drh.',
    imagePaths: [
      'assets/images/PetClinic/petClinic1.jpg',
      'assets/images/PetClinic/petClinic3.jpg',
      'assets/images/PetClinic/petClinic2.jpg',
    ],
    latitude: -7.269800,
    longitude: 112.734192,
  ),
  Lokasi(
    id: 3,
    namaKlinik: 'Klinik Hewan Bandung Sejahtera',
    alamat: 'Jl. Ir. H. Juanda No. 54, Bandung',
    bukaTutup: 'Senin - Sabtu: 08.00 - 18.00',
    deskripsi:
    'Klinik Hewan Bandung Sejahtera menyediakan layanan kesehatan hewan yang profesional dan terpercaya dengan tenaga medis yang handal.',
    dokterHewan: 'Dr. Budi Santoso, drh.',
    imagePaths: [
      'assets/images/PetClinic/petClinic6.jpg',
      'assets/images/PetClinic/petClinic3.jpg',
      'assets/images/PetClinic/petClinic1.jpg',
    ],
    latitude: -6.903273,
    longitude: 107.618847,
  ),
  Lokasi(
    id: 4,
    namaKlinik: 'Clinic Pet Care Semarang',
    alamat: 'Jl. Pahlawan No. 78, Semarang',
    bukaTutup: 'Senin - Jumat: 07.00 - 19.00, Sabtu: 07.00 - 15.00',
    deskripsi:
    'Clinic Pet Care Semarang adalah tempat yang ramah hewan dengan dokter-dokter hewan yang berdedikasi untuk memberikan perawatan terbaik bagi hewan peliharaan Anda.',
    dokterHewan: 'Dr. Susi Lestari, drh.',
    imagePaths: [
      'assets/images/PetClinic/petClinic4.jpg',
      'assets/images/PetClinic/petClinic5.jpg',
      'assets/images/PetClinic/petClinic6.jpg',
    ],
    latitude: -7.005145,
    longitude: 110.438125,
  ),
  Lokasi(
    id: 5,
    namaKlinik: 'Pet Wonderland Makassar',
    alamat: 'Jl. Sultan Alauddin No. 24, Makassar',
    bukaTutup: 'Senin - Minggu: 10.00 - 21.00',
    deskripsi:
    'Pet Wonderland Makassar adalah tempat yang menyenangkan bagi hewan peliharaan dan pemiliknya dengan berbagai fasilitas dan kegiatan yang tersedia.',
    dokterHewan: 'Dr. Rudi Cahyono, drh.',
    imagePaths: [
      'assets/images/PetClinic/petClinic1.jpg',
      'assets/images/PetClinic/petClinic2.jpg',
      'assets/images/PetClinic/petClinic3.jpg',
    ],
    latitude: -5.147665,
    longitude: 119.427679,
  ),
];
