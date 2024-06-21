import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../dataset/data_dummy.dart';
import '../../MainPage/PetClinicFeature/DeskripsiLokasiPage.dart';
import '../../component/PartComponent/infoContent.dart';

class PetClinicPage extends StatefulWidget {
  const PetClinicPage({Key? key}) : super(key: key);

  @override
  State<PetClinicPage> createState() => _PetClinicPageState();
}

class _PetClinicPageState extends State<PetClinicPage> {
  final List<Marker> _markers = [];
  OverlayEntry? _overlayEntry;
  late LatLng _overlayPosition;
  late Lokasi _selectedLokasi;

  @override
  void initState() {
    super.initState();
    for (var lokasi in lokasiList) {
      _markers.add(
        Marker(
          point: LatLng(lokasi.latitude, lokasi.longitude),
          builder: (ctx) => IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.red,
            iconSize: 45.0,
            onPressed: () {
              _showOverlay(context, lokasi);
            },
          ),
        ),
      );
    }
  }

  void _showOverlay(BuildContext context, Lokasi lokasi) {
    _overlayPosition = LatLng(lokasi.latitude, lokasi.longitude);
    _selectedLokasi = lokasi;

    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    _overlayEntry = _createOverlayEntry(context, lokasi);
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry(BuildContext context, Lokasi lokasi) {
    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: 60.0 + 10.0, // 60.0 for Navbar height + 10.0 for margin
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: InfoContent(
          lokasi: lokasi,
          onDetailPressed: () {
            _removeOverlay();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeskripsiLokasiPage(
                  lokasi: lokasi,
                ),
              ),
            ).then((_) {
              // Pastikan overlay dihapus ketika kembali dari DeskripsiLokasiPage
              _removeOverlay();
            });
          },
        ),
      ),
    );
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PetClinic Location'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(-6.200000, 106.816666), // Pusat peta di Jakarta
              zoom: 10.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: _markers,
              ),
            ],
          ),
        ],
      ),
    );
  }
}