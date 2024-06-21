import 'package:flutter/material.dart';
import '../../dataset/data_dummy.dart';
import 'package:doca_project/component/PartComponent/navbar.dart';
import 'package:doca_project/component/PartComponent/header.dart';

class DeskripsiLokasiPage extends StatelessWidget {
  final Lokasi lokasi;

  const DeskripsiLokasiPage({
    Key? key,
    required this.lokasi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Info Petshop'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              lokasi.namaKlinik,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: lokasi.imagePaths.length,
                itemBuilder: (context, index) {
                  return Image.asset(lokasi.imagePaths[index]);
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Alamat:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              lokasi.alamat,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Deskripsi Klinik:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              lokasi.deskripsi,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Buka-Tutup:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              lokasi.bukaTutup,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Dokter Hewan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              lokasi.dokterHewan,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(),
    );
  }
}
