import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/core/theme/app_theme.dart';
import 'package:whdanz/features/places/domain/place_model.dart';
import 'package:whdanz/core/widgets/modern_widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _selectedFilter = 'Todos';
  
  final List<PlaceModel> _places = [
    PlaceModel(
      id: '1',
      name: 'Salsa Club Latina',
      address: 'Calle Main 123',
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
      address: 'Plaza Centro 45',
      type: 'academia',
      latitude: 40.4170,
      longitude: -3.7040,
      rating: 4.8,
      reviewsCount: 56,
      addedBy: 'user2',
      createdAt: DateTime.now(),
    ),
    PlaceModel(
      id: '3',
      name: 'Parque de la Danza',
      address: 'Avenida Parque s/n',
      type: 'espacio_publico',
      latitude: 40.4180,
      longitude: -3.7020,
      rating: 4.2,
      reviewsCount: 15,
      addedBy: 'user3',
      createdAt: DateTime.now(),
    ),
  ];

  final List<String> _filters = ['Todos', 'Discotecas', 'Academias', 'Eventos', 'Espacios'];

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
            child: ModernChip(
              label: filter,
              icon: _getFilterIcon(filter),
              isSelected: isSelected,
              onTap: () => setState(() => _selectedFilter = filter),
            ),
          );
        },
      ),
    );
  }

  IconData _getFilterIcon(String filter) {
    switch (filter) {
      case 'Todos':
        return Icons.apps;
      case 'Discotecas':
        return Icons.nightlife;
      case 'Academias':
        return Icons.school;
      case 'Eventos':
        return Icons.event;
      case 'Espacios':
        return Icons.park;
      default:
        return Icons.place;
    }
  }

  Widget _buildMapSection() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.surfaceLight,
                AppColors.surface,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: AppColors.surfaceLight.withValues(alpha: 0.3),
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.glow,
                      ),
                      child: const Icon(
                        Icons.map,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Text(
                      'Mapa Interactivo',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xl),
                      child: Text(
                        'Configura Google Maps API para ver el mapa en vivo',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMapFeature(Icons.location_on, '3 Lugares'),
                        const SizedBox(width: AppDimensions.lg),
                        _buildMapFeature(Icons.people, '12 Bailarines'),
                      ],
                    ),
                  ],
                ),
              ),
              ..._buildMapMarkers(),
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

  List<Widget> _buildMapMarkers() {
    return [
      Positioned(
        top: 80,
        left: 60,
        child: _buildMapMarker(AppColors.primary, '1'),
      ),
      Positioned(
        top: 120,
        right: 80,
        child: _buildMapMarker(AppColors.secondary, '2'),
      ),
      Positioned(
        bottom: 180,
        left: 100,
        child: _buildMapMarker(AppColors.accent, '3'),
      ),
    ];
  }

  Widget _buildMapMarker(Color color, String label) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMapFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildPlacesCarousel() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
        itemCount: _places.length,
        itemBuilder: (context, index) {
          final place = _places[index];
          return _PlaceCard(
            place: place,
            onTap: () => context.go('/map/place/${place.id}'),
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
