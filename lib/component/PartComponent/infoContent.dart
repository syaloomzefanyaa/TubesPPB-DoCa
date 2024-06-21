// InfoContent.dart

import 'package:doca_project/component/ColorGlobal.dart';
import 'package:flutter/material.dart';
import '../../dataset/data_dummy.dart';

class InfoContent extends StatelessWidget {
  final Lokasi lokasi;
  final VoidCallback onDetailPressed;

  InfoContent({required this.lokasi, required this.onDetailPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3, // Adjust the flex value to 3 for a width of 30.0
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lokasi.namaKlinik,
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    lokasi.alamat,
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.0),
            ElevatedButton(
              onPressed: onDetailPressed,
              child: Text('Details'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
