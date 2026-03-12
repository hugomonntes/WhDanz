import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whdanz/features/auth/domain/auth_notifier.dart';
import 'package:whdanz/core/constants/app_constants.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            'Cuenta',
            [
              _buildSettingsTile(
                context,
                Icons.person_outline,
                'Editar perfil',
                () {},
              ),
              _buildSettingsTile(
                context,
                Icons.lock_outline,
                'Privacidad',
                () {},
              ),
              _buildSettingsTile(
                context,
                Icons.security,
                'Seguridad',
                () {},
              ),
            ],
          ),
          _buildSection(
            context,
            'Aplicación',
            [
              _buildSettingsTile(
                context,
                Icons.notifications_outlined,
                'Notificaciones',
                () {},
              ),
              _buildSettingsTile(
                context,
                Icons.dark_mode_outlined,
                'Tema',
                () {},
              ),
              _buildSettingsTile(
                context,
                Icons.language,
                'Idioma',
                () {},
              ),
            ],
          ),
          _buildSection(
            context,
            'Ayuda',
            [
              _buildSettingsTile(
                context,
                Icons.help_outline,
                'Ayuda y soporte',
                () {},
              ),
              _buildSettingsTile(
                context,
                Icons.info_outline,
                'Acerca de',
                () {},
              ),
            ],
          ),
          _buildSection(
            context,
            '',
            [
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text('Cerrar sesión', style: TextStyle(color: AppColors.error)),
                onTap: () async {
                  await ref.read(authProvider.notifier).signOut();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.xl),
          Center(
            child: Text(
              'WhDanz v1.0.0',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.md,
              AppDimensions.lg,
              AppDimensions.md,
              AppDimensions.sm,
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ...children,
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
