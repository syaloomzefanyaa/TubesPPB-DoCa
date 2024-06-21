import 'package:flutter/material.dart';
import 'package:doca_project/dataset/datapet.dart';

class DetailPet extends StatelessWidget {
  final int id;

  DetailPet({required this.id});

  @override
  Widget build(BuildContext context) {
    // Cari data hewan peliharaan berdasarkan ID
    final hewan = hewanPeliharaanList.firstWhere((hewan) => hewan.id == id);

    if (hewan == null) {
      // Tampilkan pesan jika data tidak ditemukan
      return Scaffold(
        appBar: AppBar(
          title: Text('Detail Pet'),
        ),
        body: Center(
          child: Text('Pet with ID $id not found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pet'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hewan.ras,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Kategori: ${hewan.kategori}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Deskripsi: ${hewan.deskripsi}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Lingkungan Hidup: ${hewan.lingkunganHidup}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Cara Merawat: ${hewan.caraMerawat}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Gambar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hewan.imagePaths.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(
                      hewan.imagePaths[index],
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
