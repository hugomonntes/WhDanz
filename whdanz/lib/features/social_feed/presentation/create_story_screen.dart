import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/core/theme/app_theme.dart';

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final _picker = ImagePicker();
  XFile? _selectedMedia;
  String _selectedEffect = 'normal';
  final List<String> _effects = ['normal', 'heat', 'cold', 'bw', 'vintage'];
  bool _isPosting = false;

  Future<void> _pickMedia() async {
    final media = await _picker.pickImage(source: ImageSource.gallery);
    if (media != null) {
      setState(() => _selectedMedia = media);
    }
  }

  Future<void> _recordMedia() async {
    final media = await _picker.pickImage(source: ImageSource.camera);
    if (media != null) {
      setState(() => _selectedMedia = media);
    }
  }

  Future<void> _createStory() async {
    if (_selectedMedia == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Selecciona una imagen o video'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isPosting = true);
    
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _selectedMedia != null
                  ? _buildPreview()
                  : _buildMediaSelector(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.sm,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, size: 22, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          const Text(
            'Crear Historia',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          if (_selectedMedia != null)
            GestureDetector(
              onTap: _isPosting ? null : _createStory,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _isPosting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Compartir',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaSelector() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
          ),
          child: IconButton(
            icon: const Icon(Icons.add_a_photo, size: 50, color: Colors.white),
            onPressed: () => _showMediaOptions(),
          ),
        ),
        const SizedBox(height: AppDimensions.lg),
        const Text(
          'Toca para agregar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppDimensions.xxl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionButton(Icons.photo_library, 'Galería', _pickMedia),
            const SizedBox(width: AppDimensions.xl),
            _buildOptionButton(Icons.videocam, 'Cámara', _recordMedia),
          ],
        ),
      ],
    );
  }

  void _showMediaOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.photo_library, color: AppColors.primary),
              ),
              title: const Text('Elegir de Galería'),
              onTap: () {
                Navigator.pop(context);
                _pickMedia();
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.camera_alt, color: AppColors.secondary),
              ),
              title: const Text('Tomar Foto'),
              onTap: () {
                Navigator.pop(context);
                _recordMedia();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            image: DecorationImage(
              image: AssetImage(_selectedMedia!.path),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: AppDimensions.lg,
          right: AppDimensions.lg,
          child: GestureDetector(
            onTap: () => setState(() => _selectedMedia = null),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ),
        Positioned(
          bottom: AppDimensions.xxl,
          left: 0,
          right: 0,
          child: _buildEffectsSelector(),
        ),
      ],
    );
  }

  Widget _buildEffectsSelector() {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _effects.length,
        itemBuilder: (context, index) {
          final effect = _effects[index];
          final isSelected = _selectedEffect == effect;
          return GestureDetector(
            onTap: () => setState(() => _selectedEffect = effect),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getEffectColor(effect),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    effect,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getEffectColor(String effect) {
    switch (effect) {
      case 'heat':
        return Colors.orange;
      case 'cold':
        return Colors.blue;
      case 'bw':
        return Colors.grey;
      case 'vintage':
        return Colors.brown;
      default:
        return AppColors.primary;
    }
  }
}
