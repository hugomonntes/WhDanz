import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/core/theme/app_theme.dart';
import 'package:whdanz/core/widgets/modern_widgets.dart';
import 'package:whdanz/core/theme/app_theme.dart';

class PoseSelectionScreen extends StatefulWidget {
  const PoseSelectionScreen({super.key});

  @override
  State<PoseSelectionScreen> createState() => _PoseSelectionScreenState();
}

class _PoseSelectionScreenState extends State<PoseSelectionScreen> {
  String _selectedCategory = 'Todos';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _poses = [
    {'id': 'salsa_paso_basico', 'name': 'Salsa - Paso básico', 'difficulty': 'Principiante', 'category': 'Salsa', 'icon': Icons.music_note, 'color': AppColors.primary},
    {'id': 'bachata_basic', 'name': 'Bachata - Basic Step', 'difficulty': 'Principiante', 'category': 'Bachata', 'icon': Icons.music_note, 'color': AppColors.secondary},
    {'id': 'reggaeton_perreo', 'name': 'Reggaetón - Perreo', 'difficulty': 'Intermedio', 'category': 'Reggaeton', 'icon': Icons.music_note, 'color': AppColors.accent},
    {'id': 'kpop_basic', 'name': 'K-Pop - Coreografía', 'difficulty': 'Avanzado', 'category': 'K-Pop', 'icon': Icons.music_note, 'color': Colors.pink},
    {'id': 'hiphop_basic', 'name': 'Hip Hop - Basics', 'difficulty': 'Principiante', 'category': 'Hip Hop', 'icon': Icons.music_note, 'color': Colors.orange},
    {'id': 'salsa_turn', 'name': 'Salsa - Giro', 'difficulty': 'Intermedio', 'category': 'Salsa', 'icon': Icons.music_note, 'color': AppColors.primary},
    {'id': 'bachata_lado', 'name': 'Bachata - Lado a lado', 'difficulty': 'Principiante', 'category': 'Bachata', 'icon': Icons.music_note, 'color': AppColors.secondary},
    {'id': 'samba_basic', 'name': 'Samba - Basics', 'difficulty': 'Intermedio', 'category': 'Samba', 'icon': Icons.music_note, 'color': Colors.amber},
  ];

  List<String> get _categories => ['Todos', ..._poses.map((p) => p['category'] as String).toSet().toList()];

  List<Map<String, dynamic>> get _filteredPoses {
    return _poses.where((pose) {
      final matchesCategory = _selectedCategory == 'Todos' || pose['category'] == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty || (pose['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
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
              _buildSearchBar(),
              _buildCategoryChips(),
              Expanded(child: _buildPoseList()),
            ],
          ),
        ),
      ),
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
              'Practicar',
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
              icon: const Icon(Icons.history, size: 22),
              onPressed: () => context.go('/camera/history'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: AppColors.surfaceLight.withValues(alpha: 0.3),
          ),
        ),
        child: TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Buscar pose...',
            hintStyle: TextStyle(color: AppColors.textMuted),
            prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.md,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(AppDimensions.md),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.sm),
            child: ModernChip(
              label: category,
              icon: _getCategoryIcon(category),
              isSelected: isSelected,
              onTap: () => setState(() => _selectedCategory = category),
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Todos':
        return Icons.apps;
      case 'Salsa':
        return Icons.music_note;
      case 'Bachata':
        return Icons.music_note;
      case 'Reggaeton':
        return Icons.headphones;
      case 'K-Pop':
        return Icons.star;
      case 'Hip Hop':
        return Icons.sports_mma;
      case 'Samba':
        return Icons.sports;
      default:
        return Icons.place;
    }
  }

  Widget _buildPoseList() {
    if (_filteredPoses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: AppColors.textMuted),
            const SizedBox(height: AppDimensions.md),
            Text(
              'No se encontraron poses',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      itemCount: _filteredPoses.length,
      itemBuilder: (context, index) {
        final pose = _filteredPoses[index];
        return _PoseCard(
          pose: pose,
          onTap: () => context.go('/camera/practice/${pose['id']}'),
        );
      },
    );
  }
}

class _PoseCard extends StatelessWidget {
  final Map<String, dynamic> pose;
  final VoidCallback onTap;

  const _PoseCard({required this.pose, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = pose['color'] as Color;
    final difficulty = pose['difficulty'] as String;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.md),
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                pose['icon'] as IconData,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pose['name'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _DifficultyBadge(difficulty: difficulty),
                      const SizedBox(width: AppDimensions.sm),
                      Icon(
                        Icons.play_circle_outline,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Iniciar',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: color,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final icon = _getIcon();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            difficulty,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (difficulty) {
      case 'Principiante':
        return AppColors.success;
      case 'Intermedio':
        return AppColors.warning;
      case 'Avanzado':
        return AppColors.error;
      default:
        return AppColors.textMuted;
    }
  }

  IconData _getIcon() {
    switch (difficulty) {
      case 'Principiante':
        return Icons.star_outline;
      case 'Intermedio':
        return Icons.star_half;
      case 'Avanzado':
        return Icons.star;
      default:
        return Icons.help_outline;
    }
  }
}
