import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whdanz/features/auth/domain/auth_notifier.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/core/theme/app_theme.dart';
import 'package:whdanz/core/providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
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
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              title: const Text(
                'Ajustes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 20),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.md),
                child: Column(
                  children: [
                    _buildSection(
                      context,
                      'Cuenta',
                      [
                        _SettingsTile(
                          icon: Icons.person_outline,
                          iconColor: AppColors.primary,
                          title: 'Editar perfil',
                          subtitle: 'Cambia tu información personal',
                          onTap: () => context.push('/edit-profile'),
                        ),
                        _SettingsTile(
                          icon: Icons.lock_outline,
                          iconColor: AppColors.secondary,
                          title: 'Privacidad',
                          subtitle: 'Controla quién puede ver tu contenido',
                          onTap: () => _showComingSoonDialog(context),
                        ),
                        _SettingsTile(
                          icon: Icons.security,
                          iconColor: AppColors.accent,
                          title: 'Seguridad',
                          subtitle: 'Contraseña y autenticación',
                          onTap: () => _showComingSoonDialog(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),
                    _buildSection(
                      context,
                      'Aplicación',
                      [
                        _SettingsTile(
                          icon: Icons.notifications_outlined,
                          iconColor: AppColors.warning,
                          title: 'Notificaciones',
                          subtitle: 'Gestiona tus notificaciones',
                          trailing: Switch(
                            value: settings.notifications,
                            onChanged: (value) {
                              ref.read(settingsProvider.notifier).toggleNotifications();
                            },
                            activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                            thumbColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.primary;
                              }
                              return AppColors.textMuted;
                            }),
                          ),
                        ),
                        _SettingsTile(
                          icon: Icons.dark_mode_outlined,
                          iconColor: AppColors.info,
                          title: 'Tema oscuro',
                          subtitle: 'Activa el modo oscuro',
                          trailing: Switch(
                            value: settings.isDarkMode,
                            onChanged: (value) {
                              ref.read(settingsProvider.notifier).toggleDarkMode();
                            },
                            activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                            thumbColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.primary;
                              }
                              return AppColors.textMuted;
                            }),
                          ),
                        ),
                        _SettingsTile(
                          icon: Icons.language,
                          iconColor: AppColors.success,
                          title: 'Idioma',
                          subtitle: settings.language == 'es' ? 'Español' : 'English',
                          onTap: () => _showLanguageDialog(context, ref),
                        ),
                        _SettingsTile(
                          icon: Icons.volume_up,
                          iconColor: AppColors.primary,
                          title: 'Voz',
                          subtitle: 'Feedback por voz en prácticas',
                          trailing: Switch(
                            value: settings.voiceFeedback,
                            onChanged: (value) {
                              ref.read(settingsProvider.notifier).toggleVoiceFeedback();
                            },
                            activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                            thumbColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.primary;
                              }
                              return AppColors.textMuted;
                            }),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),
                    _buildSection(
                      context,
                      'Ayuda y soporte',
                      [
                        _SettingsTile(
                          icon: Icons.help_outline,
                          iconColor: AppColors.info,
                          title: 'Ayuda y soporte',
                          subtitle: 'Preguntas frecuentes y contacto',
                          onTap: () => _showComingSoonDialog(context),
                        ),
                        _SettingsTile(
                          icon: Icons.info_outline,
                          iconColor: AppColors.textMuted,
                          title: 'Acerca de',
                          subtitle: 'Versión 1.0.0',
                          onTap: () => _showAboutDialog(context),
                        ),
                        _SettingsTile(
                          icon: Icons.description_outlined,
                          iconColor: AppColors.textMuted,
                          title: 'Términos y condiciones',
                          subtitle: 'Lee nuestros términos',
                          onTap: () => _showComingSoonDialog(context),
                        ),
                        _SettingsTile(
                          icon: Icons.privacy_tip_outlined,
                          iconColor: AppColors.textMuted,
                          title: 'Política de privacidad',
                          subtitle: 'Cómo protegemos tus datos',
                          onTap: () => _showComingSoonDialog(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    _buildLogoutButton(context, ref),
                    const SizedBox(height: AppDimensions.xl),
                    Text(
                      'WhDanz v1.0.0',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppDimensions.xs,
            bottom: AppDimensions.sm,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: AppColors.surfaceLight.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return GradientButton(
      text: 'Cerrar sesión',
      icon: Icons.logout,
      gradient: const LinearGradient(
        colors: [AppColors.error, Color(0xFFF87171)],
      ),
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            title: const Text('¿Cerrar sesión?'),
            content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('Cerrar sesión'),
              ),
            ],
          ),
        );
        
        if (confirmed == true) {
          await ref.read(authProvider.notifier).signOut();
          if (context.mounted) {
            context.go('/login');
          }
        }
      },
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        title: const Text('Seleccionar idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Español'),
              leading: const Icon(Icons.language),
              onTap: () {
                ref.read(settingsProvider.notifier).setLanguage('es');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              leading: const Icon(Icons.language),
              onTap: () {
                ref.read(settingsProvider.notifier).setLanguage('en');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.music_note, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text('WhDanz'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Versión 1.0.0'),
            const SizedBox(height: 12),
            Text(
              'La app de corrección de baile con IA y funciones sociales.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        title: const Text('Próximamente'),
        content: const Text('Esta función estará disponible en una futura actualización.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textMuted,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
