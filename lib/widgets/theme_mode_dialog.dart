import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../state/app_settings_store.dart';

class ThemeModeDialog extends StatelessWidget {
  final AppThemeMode currentMode;

  const ThemeModeDialog({super.key, required this.currentMode});

  static Future<AppThemeMode?> show(
      BuildContext context, AppThemeMode current) {
    return showDialog<AppThemeMode>(
      context: context,
      builder: (_) => ThemeModeDialog(currentMode: current),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(t.settingsDisplayModeTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _themeOption(
            context,
            mode: AppThemeMode.system,
            icon: Icons.brightness_auto_outlined,
            title: t.settingsThemeAutoTitle,
            detail: t.settingsThemeAutoDetail,
          ),
          _themeOption(
            context,
            mode: AppThemeMode.light,
            icon: Icons.light_mode_outlined,
            title: t.settingsThemeLightTitle,
            detail: t.settingsThemeLightDetail,
          ),
          _themeOption(
            context,
            mode: AppThemeMode.dark,
            icon: Icons.dark_mode_outlined,
            title: t.settingsThemeDarkTitle,
            detail: t.settingsThemeDarkDetail,
          ),
        ],
      ),
    );
  }

  Widget _themeOption(
    BuildContext context, {
    required AppThemeMode mode,
    required IconData icon,
    required String title,
    required String detail,
  }) {
    return RadioListTile<AppThemeMode>(
      value: mode,
      groupValue: currentMode,
      secondary: Icon(icon),
      title: Text(title),
      subtitle: Text(detail),
      onChanged: (value) {
        if (value != null) {
          Navigator.pop(context, value);
        }
      },
    );
  }
}
