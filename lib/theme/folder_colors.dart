import 'package:flutter/material.dart';

/// Palette de couleurs proposées pour un classeur. Volontairement
/// indépendante du thème choisi dans les réglages : la couleur d'un
/// classeur doit rester reconnaissable même si l'utilisateur change de
/// thème ensuite.
const List<Color> folderColorPalette = [
  Color(0xFFE24B4A), // rouge
  Color(0xFFD85A30), // corail
  Color(0xFFE0A23C), // ambre
  Color(0xFF639922), // vert
  Color(0xFF1D9E75), // émeraude
  Color(0xFF1D63A8), // bleu
  Color(0xFF6A4C93), // violet
  Color(0xFFB0335C), // framboise
  Color(0xFF5F5E5A), // ardoise (neutre)
];

/// Couleur attribuée à un classeur par défaut, avant tout choix explicite
/// de l'utilisateur : cycle dans la palette selon un index stable (par
/// exemple la position du classeur dans la liste), pour que chaque
/// classeur ait une couleur différente sans configuration.
Color defaultFolderColor(int index) {
  return folderColorPalette[index % folderColorPalette.length];
}

Color resolveFolderColor(int? storedValue, int fallbackIndex) {
  if (storedValue == null) return defaultFolderColor(fallbackIndex);

  return Color(storedValue);
}
