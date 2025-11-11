import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../providers/profile_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Configuración',
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // General Section
              _buildSectionHeader('General'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.palette),
                      title: const Text('Tema'),
                      subtitle: Text(_getThemeLabel(profileProvider.themeMode)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showThemeDialog(context, profileProvider);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.attach_money),
                      title: const Text('Moneda'),
                      subtitle: Text(profileProvider.currency),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showCurrencyDialog(context, profileProvider);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: const Text('Idioma'),
                      subtitle: Text(_getLanguageLabel(profileProvider.language)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showLanguageDialog(context, profileProvider);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Formato de Fecha'),
                      subtitle: const Text('DD/MM/YYYY'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Date format settings
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Notifications Section
              _buildSectionHeader('Notificaciones'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications),
                      title: const Text('Alertas de Presupuesto'),
                      subtitle: const Text('Notificar cuando te acerques al límite'),
                      value: true,
                      onChanged: (value) {
                        // TODO: Toggle budget alerts
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.calendar_today),
                      title: const Text('Recordatorios'),
                      subtitle: const Text('Recordar pagos próximos'),
                      value: true,
                      onChanged: (value) {
                        // TODO: Toggle reminders
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.email),
                      title: const Text('Resumen Semanal'),
                      subtitle: const Text('Recibir resumen por correo'),
                      value: false,
                      onChanged: (value) {
                        // TODO: Toggle weekly summary
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Security Section
              _buildSectionHeader('Seguridad'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Cambiar Contraseña'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Change password
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.fingerprint),
                      title: const Text('Autenticación Biométrica'),
                      subtitle: const Text('Usa huella o Face ID'),
                      value: false,
                      onChanged: (value) {
                        // TODO: Toggle biometric
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.timer),
                      title: const Text('Auto-cierre de Sesión'),
                      subtitle: const Text('Después de 15 minutos'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Auto lock settings
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Data Section
              _buildSectionHeader('Datos'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.cloud_upload),
                      title: const Text('Backup Automático'),
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {
                          // TODO: Toggle auto backup
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.download),
                      title: const Text('Exportar Datos'),
                      subtitle: const Text('Descargar en formato CSV'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Export data
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.sync),
                      title: const Text('Sincronización'),
                      subtitle: const Text('Última sincronización: Hoy'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Sync settings
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // About Section
              _buildSectionHeader('Acerca de'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('Versión de la App'),
                      subtitle: const Text('1.0.0'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Version info
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text('Términos de Servicio'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Show terms
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip),
                      title: const Text('Política de Privacidad'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Show privacy policy
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  String _getThemeLabel(String themeMode) {
    switch (themeMode) {
      case 'light':
        return 'Claro';
      case 'dark':
        return 'Oscuro';
      case 'system':
      default:
        return 'Sistema';
    }
  }

  String _getLanguageLabel(String language) {
    switch (language) {
      case 'es':
        return 'Español';
      case 'en':
        return 'English';
      default:
        return 'Español';
    }
  }

  void _showThemeDialog(BuildContext context, ProfileProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Claro'),
              value: 'light',
              groupValue: provider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  provider.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Oscuro'),
              value: 'dark',
              groupValue: provider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  provider.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Sistema'),
              value: 'system',
              groupValue: provider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  provider.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, ProfileProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Moneda'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Sol Peruano (PEN)'),
              value: 'PEN',
              groupValue: provider.currency,
              onChanged: (value) {
                if (value != null) {
                  provider.setCurrency(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Dólar (USD)'),
              value: 'USD',
              groupValue: provider.currency,
              onChanged: (value) {
                if (value != null) {
                  provider.setCurrency(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Euro (EUR)'),
              value: 'EUR',
              groupValue: provider.currency,
              onChanged: (value) {
                if (value != null) {
                  provider.setCurrency(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, ProfileProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Español'),
              value: 'es',
              groupValue: provider.language,
              onChanged: (value) {
                if (value != null) {
                  provider.setLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: provider.language,
              onChanged: (value) {
                if (value != null) {
                  provider.setLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}