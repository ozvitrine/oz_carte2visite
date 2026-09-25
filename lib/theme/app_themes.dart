import 'package:flutter/material.dart';

/// Un thème nommé complet, généré à partir d'une seule couleur de départ
/// mais avec une variante « vibrant » du moteur Material 3 : contrairement
/// au schéma par défaut (assez pâle), cette variante produit des teintes
/// secondaires et tertiaires nettement plus saturées et contrastées, sans
/// avoir à choisir chaque couleur à la main.
class AppTheme {
  const AppTheme({
    required this.id,
    required this.label,
    required this.seedColor,
  });

  final String id;
  final String label;
  final Color seedColor;

  ColorScheme colorScheme(Brightness brightness) {
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    );
  }
}

const List<AppTheme> appThemes = [
  AppTheme(id: 'emerald', label: 'Émeraude', seedColor: Color(0xFF0F6E56)),
  AppTheme(id: 'ocean', label: 'Océan', seedColor: Color(0xFF1D63A8)),
  AppTheme(id: 'coral', label: 'Corail', seedColor: Color(0xFFD85A30)),
  AppTheme(id: 'amber', label: 'Ambre', seedColor: Color(0xFFB8860B)),
  AppTheme(id: 'violet', label: 'Violet', seedColor: Color(0xFF6A4C93)),
  AppTheme(id: 'raspberry', label: 'Framboise', seedColor: Color(0xFFB0335C)),
  AppTheme(id: 'slate', label: 'Ardoise', seedColor: Color(0xFF44546A)),
];

// Défini séparément plutôt que via appThemes[0] : l'opérateur [] n'est pas
// évaluable dans une expression const, même sur une liste const.
const AppTheme defaultAppTheme = AppTheme(
  id: 'emerald',
  label: 'Émeraude',
  seedColor: Color(0xFF0F6E56),
);

AppTheme appThemeById(String? id) {
  if (id == null) return defaultAppTheme;

  for (final theme in appThemes) {
    if (theme.id == id) return theme;
  }

  return defaultAppTheme;
}
