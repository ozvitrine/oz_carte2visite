import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_themes.dart';

class ThemeSelectionDialog extends StatelessWidget {
  final AppTheme selectedTheme;

  const ThemeSelectionDialog({super.key, required this.selectedTheme});

  static Future<AppTheme?> show(BuildContext context, AppTheme currentTheme) {
    return showDialog<AppTheme>(
      context: context,
      builder: (_) => ThemeSelectionDialog(selectedTheme: currentTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.settingsAppThemeTitle),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: appThemes.map((theme) {
            final scheme = theme.colorScheme(Theme.of(context).brightness);
            final isSelected = theme.id == selectedTheme.id;

            return ListTile(
              onTap: () => Navigator.pop(context, theme),
              leading: SizedBox(
                width: 56,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: scheme.primary,
                      ),
                    ),
                    Positioned(
                      left: 16,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: scheme.secondary,
                      ),
                    ),
                    Positioned(
                      left: 32,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: scheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(theme.label),
              trailing: isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: scheme.primary,
                    )
                  : null,
            );
          }).toList(),
        ),
      ),
    );
  }
}
