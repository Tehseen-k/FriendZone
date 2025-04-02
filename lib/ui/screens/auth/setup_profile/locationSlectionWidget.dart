import 'package:code_structure/core/constants/auth_text_feild.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class LocationSelectionWidget extends StatefulWidget {
  final Function(double lat, double lon, String address) onLocationSelected;
  final String? initialLocation;

  const LocationSelectionWidget({
    Key? key, 
    required this.onLocationSelected,
    this.initialLocation,
  }) : super(key: key);

  @override
  _LocationSelectionWidgetState createState() => _LocationSelectionWidgetState();
}

class _LocationSelectionWidgetState extends State<LocationSelectionWidget> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String _locationText = '';
  bool _isLoadingLocation = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _locationText = widget.initialLocation!;
    }
  }

Future<void> _getCurrentLocation() async {
  setState(() => _isLoadingLocation = true);
  
  try {
    // 1. Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled. Please enable them.')),
      );
      return;
    }

    // 2. Check location permission status
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied. Enable them in app settings.')),
      );
      return;
    }

    // 3. Request permission if denied
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && 
          permission != LocationPermission.always) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are required.')),
        );
        return;
      }
    }

    // 4. Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    // 5. Get placemark details
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      setState(() {
        _locationText = '${place.locality ?? ''}, ${place.country ?? ''}'.trim();
        _selectedLocation = LatLng(position.latitude, position.longitude);
        
        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(_selectedLocation!),
          );
        }
      });

      widget.onLocationSelected(
        position.latitude, 
        position.longitude, 
        _locationText
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error getting location: ${e.toString()}')),
    );
  } finally {
    setState(() => _isLoadingLocation = false);
  }
}
  void _showLocationSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            // Location Search Input
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: _searchController,
                googleAPIKey: "YOUR_GOOGLE_MAPS_API_KEY", // Replace with your API key
                inputDecoration: InputDecoration(
                  hintText: "Search for a location",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                debounceTime: 400,
                countries: ["us", "ca", "gb"], // Optional: limit to specific countries
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  // Update selected location when a place is selected
                  setState(() {
                    _locationText = prediction.description ?? '';
                    _selectedLocation = LatLng(
                      double.parse(prediction.lat ?? '0'), 
                      double.parse(prediction.lng ?? '0')
                    );
                    _searchController.text = _locationText;
                  });

                  // Move map camera
                  if (_mapController != null && _selectedLocation != null) {
                    _mapController!.animateCamera(
                      CameraUpdate.newLatLng(_selectedLocation!),
                    );
                  }

                  // Call location selection callback
                  widget.onLocationSelected(
                    _selectedLocation!.latitude, 
                    _selectedLocation!.longitude, 
                    _locationText
                  );

                  Navigator.pop(context);
                },
              ),
            ),
            
            // Google Map
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _selectedLocation ?? LatLng(0, 0),
                  zoom: 15,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                markers: _selectedLocation != null 
                  ? {
                      Marker(
                        markerId: MarkerId('selected_location'),
                        position: _selectedLocation!,
                        infoWindow: InfoWindow(title: _locationText),
                      )
                    }
                  : {},
                onTap: (LatLng location) async {
                  // Reverse geocode the tapped location
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                    location.latitude, 
                    location.longitude
                  );

                  if (placemarks.isNotEmpty) {
                    Placemark place = placemarks[0];
                    setState(() {
                      _selectedLocation = location;
                      _locationText = '${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}'.trim();
                      _searchController.text = _locationText;
                    });

                    // Move camera
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLng(location),
                    );

                    // Call location selection callback
                    widget.onLocationSelected(
                      location.latitude, 
                      location.longitude, 
                      _locationText
                    );
                  }
                },
              ),
            ),
            
            // Confirm Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _selectedLocation != null 
                  ? () => Navigator.pop(context) 
                  : null,
                child: Text('Confirm Location'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Location", style: style16B.copyWith(color: blackColor)),
        SizedBox(height: 10),
        TextFormField(
          readOnly: true,
          controller: TextEditingController(text: _locationText),
          decoration: authFieldDecoration.copyWith(
            prefixIcon: Icon(Icons.location_on, color: greyColor),
            hintText: "Select Your Location",
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Current Location Button
                if (_isLoadingLocation)
                  Container(
                    margin: EdgeInsets.all(12),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  )
                else
                  IconButton(
                    icon: Icon(Icons.my_location),
                    onPressed: _getCurrentLocation,
                  ),
                
                // Location Search and Select Button
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _showLocationSelectionBottomSheet,
                ),
              ],
            ),
          ),
          onTap: _showLocationSelectionBottomSheet,
        ),
      ],
    );
  }
}