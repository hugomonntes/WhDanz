import 'package:flutter/material.dart';
import 'package:whdanz/core/constants/app_constants.dart';

class CameraScreen extends StatelessWidget {
  final String poseId;

  const CameraScreen({super.key, required this.poseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cámara'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.videocam_off,
                size: 80,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: AppDimensions.lg),
              Text(
                'Cámara no disponible en web',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.md),
              Text(
                'La detección de poses requiere la app móvil o emulador',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.xl),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
