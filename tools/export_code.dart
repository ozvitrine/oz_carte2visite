import 'dart:io';

void main() {
  print('Exportation des fichiers du projet...');

  final List<File> filesToExport = [];

  // 1. Récupération des fichiers Dart dans lib/
  final libDir = Directory('lib');
  if (libDir.existsSync()) {
    filesToExport.addAll(
      libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart')),
    );
  }

  // 2. Récupération de pubspec.yaml
  final pubspec = File('pubspec.yaml');
  if (pubspec.existsSync()) {
    filesToExport.add(pubspec);
  }

  // 3. Configuration Android (hors build et .gradle)
  final androidDir = Directory('android');
  if (androidDir.existsSync()) {
    final allowedNames = {
      'AndroidManifest.xml',
      'build.gradle',
      'build.gradle.kts',
      'gradle.properties',
      'settings.gradle',
      'settings.gradle.kts',
      'MainActivity.kt',
    };

    final androidFiles =
        androidDir.listSync(recursive: true).whereType<File>().where((file) {
      final path = file.path;
      if (path.contains('.gradle') || path.contains('build')) return false;
      final fileName = path.split(Platform.pathSeparator).last;
      return allowedNames.contains(fileName);
    });

    filesToExport.addAll(androidFiles);
  }

  // 4. Écriture dans code_complet.txt
  final outputFile = File('code_complet.txt');
  final buffer = StringBuffer();

  for (final file in filesToExport) {
    buffer.writeln('==================================================');
    buffer.writeln('FILE: ${file.path}');
    buffer.writeln('==================================================');
    try {
      buffer.writeln(file.readAsStringSync());
    } catch (e) {
      buffer.writeln('// Erreur de lecture : $e');
    }
    buffer.writeln('\n\n');
  }

  outputFile.writeAsStringSync(buffer.toString());

  print(
      'Export terminé ! ${filesToExport.length} fichiers exportés dans code_complet.txt');
}
