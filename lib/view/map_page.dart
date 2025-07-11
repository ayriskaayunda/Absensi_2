import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BelajarMaps extends StatefulWidget {
  const BelajarMaps({super.key});
  static const String id = "/map_page";

  @override
  State<BelajarMaps> createState() => _BelajarMapsState();
}

class _BelajarMapsState extends State<BelajarMaps> {
  GoogleMapController? mapController;
  LatLng _currentPosition = const LatLng(
    -6.200000,
    106.816666,
  ); // Default: Jakarta
  String _currentAddress = 'Alamat tidak ditemukan';
  Marker? _marker;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviseEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviseEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _currentPosition = LatLng(position.latitude, position.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentPosition.latitude,
      _currentPosition.longitude,
    );
    Placemark place = placemarks[0];

    setState(() {
      _marker = Marker(
        markerId: MarkerId("lokasi_saya"),
        position: _currentPosition,
        infoWindow: InfoWindow(
          title: 'Lokasi Anda',
          snippet: "${place.street}, ${place.locality}",
        ),
      );

      _currentAddress =
          "${place.name}, ${place.street}, ${place.locality}, ${place.country}";

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 16),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Map + Geolocator')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              mapController = controller;
            },
            markers: _marker != null ? {_marker!} : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              color: Colors.white,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  _currentAddress,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip: 'Refresh Lokasi',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
