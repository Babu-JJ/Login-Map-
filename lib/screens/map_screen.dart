import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;
  GeoPoint? _currentLocation;
  GeoPoint? _destinationLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController(
      initPosition: GeoPoint(latitude: 0, longitude: 0),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _mapController.myLocation();
      setState(() {
        _currentLocation = position;
      });
      await _mapController.addMarker(
        position,
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 40,
          ),
        ),
      );
      await _mapController.moveTo(position);
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _addDestinationMarker(GeoPoint point) async {
    try {
      if (_destinationLocation != null) {
        await _mapController.removeMarker(_destinationLocation!);
      }
      setState(() {
        _destinationLocation = point;
      });
      await _mapController.addMarker(
        point,
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.place,
            color: Colors.blue,
            size: 40,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error adding marker: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: OSMFlutter(
        controller: _mapController,
        osmOption: OSMOption(
          userTrackingOption: UserTrackingOption(
            enableTracking: true,
            unFollowUser: false,
          ),
          zoomOption: ZoomOption(
            initZoom: 15,
            minZoomLevel: 8,
            maxZoomLevel: 18,
          ),
          isPicker: true,
        ),
        onMapIsReady: (ready) {
          if (ready) {
            _getCurrentLocation();
          }
        },
        onGeoPointClicked: (point) {
          _addDestinationMarker(point);
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              if (_currentLocation != null) {
                await _mapController.moveTo(_currentLocation!);
              }
            },
            heroTag: 'current_location',
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 16),
          if (_destinationLocation != null)
            FloatingActionButton(
              onPressed: () async {
                await _mapController.moveTo(_destinationLocation!);
              },
              heroTag: 'destination',
              child: const Icon(Icons.place),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
