import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/core/theme/app_theme.dart';
import 'package:whdanz/features/places/domain/place_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _selectedFilter = 'Todos';
  GoogleMapController? _mapController;
  
  static const LatLng _initialPosition = LatLng(40.4168, -3.7038);
  
  final List<PlaceModel> _places = [
    PlaceModel(
      id: '1',
      name: 'Salsa Club Latina',
      address: 'Calle Gran Vía 123, Madrid',
      type: 'discoteca',
      latitude: 40.4168,
      longitude: -3.7038,
      rating: 4.5,
      reviewsCount: 28,
      addedBy: 'user1',
      createdAt: DateTime.now(),
    ),
    PlaceModel(
      id: '2',
      name: 'Academia de Baile Madrid',
      address: 'Plaza Mayor 45, Madrid',
      type: 'academia',
      latitude: 40.4175,
      longitude: -3.7042,
      rating: 4.8,
      reviewsCount: 56,
      addedBy: 'user2',
      createdAt: DateTime.now(),
    ),
    PlaceModel(
      id: '3',
      name: 'Parque de la Danza',
      address: 'Retiro Park, Madrid',
      type: 'espacio_publico',
      latitude: 40.4185,
      longitude: -3.7020,
      rating: 4.2,
      reviewsCount: 15,
      addedBy: 'user3',
      createdAt: DateTime.now(),
    ),
    PlaceModel(
      id: '4',
      name: 'Estudio de K-Pop Madrid',
      address: 'Calle Fuencarral 78, Madrid',
      type: 'academia',
      latitude: 40.4155,
      longitude: -3.7060,
      rating: 4.9,
      reviewsCount: 42,
      addedBy: 'user4',
      createdAt: DateTime.now(),
    ),
  ];

  final List<String> _filters = ['Todos', 'Discotecas', 'Academias', 'Eventos', 'Espacios'];

  Set<Marker> _buildMarkers() {
    final filteredPlaces = _selectedFilter == 'Todos' 
        ? _places 
        : _places.where((p) => _getFilterType(p.type) == _selectedFilter).toList();
    
    return filteredPlaces.map((place) {
      return Marker(
        markerId: MarkerId(place.id),
        position: LatLng(place.latitude, place.longitude),
        infoWindow: InfoWindow(
          title: place.name,
          snippet: place.address,
          onTap: () => context.go('/map/place/${place.id}'),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerHue(place.type)),
      );
    }).toSet();
  }

  String _getFilterType(String type) {
    switch (type) {
      case 'discoteca':
        return 'Discotecas';
      case 'academia':
        return 'Academias';
      case 'evento':
        return 'Eventos';
      case 'espacio_publico':
        return 'Espacios';
      default:
        return 'Todos';
    }
  }

  double _getMarkerHue(String type) {
    switch (type) {
      case 'discoteca':
        return BitmapDescriptor.hueViolet;
      case 'academia':
        return BitmapDescriptor.hueAzure;
      case 'evento':
        return BitmapDescriptor.hueOrange;
      case 'espacio_publico':
        return BitmapDescriptor.hueGreen;
      default:
        return BitmapDescriptor.hueRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.backgroundSecondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildFilterChips(),
              Expanded(child: _buildMapSection()),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
            child: Text(
              'Lugares',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: IconButton(
              icon: const Icon(Icons.search, size: 22),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.sm),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedFilter = filter),
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary.withValues(alpha: 0.3),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : Colors.white70,
                fontSize: 13,
              ),
              checkmarkColor: AppColors.primary,
              side: BorderSide(
                color: isSelected ? AppColors.primary : Colors.white24,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapSection() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: AppColors.surfaceLight.withValues(alpha: 0.3),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _initialPosition,
              zoom: 14,
            ),
            markers: _buildMarkers(),
            onMapCreated: (controller) {
              _mapController = controller;
              _setMapStyle(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            padding: const EdgeInsets.only(bottom: 160),
          ),
        ),
        Positioned(
          right: AppDimensions.lg,
          bottom: 170,
          child: Column(
            children: [
              _buildMapButton(Icons.my_location, () {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLng(_initialPosition),
                );
              }),
              const SizedBox(height: AppDimensions.sm),
              _buildMapButton(Icons.layers, () {}),
            ],
          ),
        ),
        Positioned(
          bottom: AppDimensions.lg,
          left: 0,
          right: 0,
          child: _buildPlacesCarousel(),
        ),
      ],
    );
  }

  Widget _buildMapButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 22),
        onPressed: onTap,
        color: Colors.white,
      ),
    );
  }

  Future<void> _setMapStyle(GoogleMapController controller) async {
    const darkStyle = '''
    [
      {"elementType": "geometry", "stylers": [{"color": "#212121"}]},
      {"elementType": "labels.icon", "stylers": [{"visibility": "off"}]},
      {"elementType": "labels.text.fill", "stylers": [{"color": "#757575"}]},
      {"elementType": "labels.text.stroke", "stylers": [{"color": "#212121"}]},
      {"featureType": "administrative", "elementType": "geometry", "stylers": [{"color": "#757575"}]},
      {"featureType": "poi", "elementType": "labels.text.fill", "stylers": [{"color": "#757575"}]},
      {"featureType": "poi.park", "elementType": "geometry", "stylers": [{"color": "#181818"}]},
      {"featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [{"color": "#616161"}]},
      {"featureType": "road", "elementType": "geometry.fill", "stylers": [{"color": "#2c2c2c"}]},
      {"featureType": "road", "elementType": "labels.text.fill", "stylers": [{"color": "#8a8a8a"}]},
      {"featureType": "road.arterial", "elementType": "geometry", "stylers": [{"color": "#373737"}]},
      {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#3c3c3c"}]},
      {"featureType": "road.local", "elementType": "labels.text.fill", "stylers": [{"color": "#616161"}]},
      {"featureType": "transit", "elementType": "labels.text.fill", "stylers": [{"color": "#757575"}]},
      {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#000000"}]},
      {"featureType": "water", "elementType": "labels.text.fill", "stylers": [{"color": "#3d3d3d"}]}
    ]
    ''';
    await controller.setMapStyle(darkStyle);
  }

  Widget _buildPlacesCarousel() {
    final filteredPlaces = _selectedFilter == 'Todos' 
        ? _places 
        : _places.where((p) => _getFilterType(p.type) == _selectedFilter).toList();
    
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
        itemCount: filteredPlaces.length,
        itemBuilder: (context, index) {
          final place = filteredPlaces[index];
          return _PlaceCard(
            place: place,
            onTap: () {
              _mapController?.animateCamera(
                CameraUpdate.newLatLng(LatLng(place.latitude, place.longitude)),
              );
              context.go('/map/place/${place.id}');
            },
          );
        },
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.glow,
      ),
      child: FloatingActionButton(
        onPressed: () => context.go('/map/add'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add_location, color: Colors.white),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final VoidCallback onTap;

  const _PlaceCard({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: AppColors.surfaceLight.withValues(alpha: 0.3),
          ),
          boxShadow: AppShadows.medium,
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              decoration: BoxDecoration(
                gradient: _getGradient(place.type),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusLg),
                  bottomLeft: Radius.circular(AppDimensions.radiusLg),
                ),
              ),
              child: Icon(
                _getPlaceIcon(place.type),
                color: Colors.white,
                size: 32,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${place.rating}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' (${place.reviewsCount})',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      place.address,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getGradient(String type) {
    switch (type) {
      case 'discoteca':
        return AppColors.secondaryGradient;
      case 'academia':
        return AppColors.primaryGradient;
      case 'espacio_publico':
        return AppColors.accentGradient;
      default:
        return AppColors.primaryGradient;
    }
  }

  IconData _getPlaceIcon(String type) {
    switch (type) {
      case 'discoteca':
        return Icons.nightlife;
      case 'academia':
        return Icons.school;
      case 'evento':
        return Icons.event;
      case 'espacio_publico':
        return Icons.park;
      default:
        return Icons.place;
    }
  }
}
