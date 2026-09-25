// tools/generate_license.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart';

void main() {
  print('==================================================');
  print('     GESTIONNAIRE DE LICENCES OZ_CARTE2VISITE     ');
  print('==================================================');
  print('1 - Générer une paire de clés RSA (Privée / Publique)');
  print('2 - Générer un fichier .ozlicense / JSON signé');
  print('0 - Quitter');
  stdout.write('\nChoix : ');

  final choice = stdin.readLineSync()?.trim();

  switch (choice) {
    case '1':
      _generateRsaKeyPairMenu();
      break;
    case '2':
      _generateLicenseMenu();
      break;
    case '0':
      print('Au revoir !');
      exit(0);
    default:
      print('Choix invalide.');
  }
}

// ============================================================================
// 1. GENERATION DES CLES
// ============================================================================

void _generateRsaKeyPairMenu() {
  print('\n--- GENERATION DE CLÉS RSA (2048 bits) ---');

  stdout.write('Dossier d\'enregistrement (par défaut: ./keys) : ');
  String dirPath = stdin.readLineSync()?.trim() ?? '';
  if (dirPath.isEmpty) dirPath = './keys';

  stdout.write('Nom de la clé privée (par défaut: private_key.pem) : ');
  String privName = stdin.readLineSync()?.trim() ?? '';
  if (privName.isEmpty) privName = 'private_key.pem';

  stdout.write('Nom de la clé publique (par défaut: public_key.pem) : ');
  String pubName = stdin.readLineSync()?.trim() ?? '';
  if (pubName.isEmpty) pubName = 'public_key.pem';

  print('\nGénération en cours...');

  final keyPair = _generateRsaKeyPair();
  final privKey = keyPair.privateKey as RSAPrivateKey;
  final pubKey = keyPair.publicKey as RSAPublicKey;

  final dir = Directory(dirPath);
  if (!dir.existsSync()) dir.createSync(recursive: true);

  final privPem = _encodePrivateKeyToPem(privKey);
  final pubPem = _encodePublicKeyToPem(pubKey);

  File('${dir.path}/$privName').writeAsStringSync(privPem);
  File('${dir.path}/$pubName').writeAsStringSync(pubPem);

  print('\nClés générées avec succès dans ${dir.path} !');
}

AsymmetricKeyPair<PublicKey, PrivateKey> _generateRsaKeyPair() {
  final secureRandom = SecureRandom('Fortuna')
    ..seed(KeyParameter(Uint8List.fromList(List.generate(
        32,
        (i) =>
            Platform.operatingSystem.hashCode +
            DateTime.now().microsecondsSinceEpoch))));

  final keyGen = RSAKeyGenerator()
    ..init(ParametersWithRandom(
      RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
      secureRandom,
    ));

  return keyGen.generateKeyPair();
}

// ============================================================================
// 2. GENERATION DE LA LICENCE
// ============================================================================

void _generateLicenseMenu() {
  print('\n--- GENERATION D\'UN FICHIER DE LICENCE SIGNÉ ---');

  stdout.write('Chemin de la clé privée PEM : ');
  final privKeyPath = stdin.readLineSync()?.trim() ?? '';
  final privFile = File(privKeyPath);

  if (!privFile.existsSync()) {
    print('Erreur : Clé privée introuvable.');
    return;
  }

  stdout
      .write('Installation ID / Appareil (ex: eEutfBDqgKEaQnNNViUxZL8-WVg) : ');
  final installationId = stdin.readLineSync()?.trim() ?? '';
  if (installationId.isEmpty) {
    print('Erreur : L\'Installation ID est obligatoire.');
    return;
  }

  stdout.write('Nom du titulaire (licensee) (ex: VIDAL Christophe) : ');
  final licensee = stdin.readLineSync()?.trim() ?? 'Titulaire';

  print('\nType de licence :');
  print('1 - Définitive (premium_lifetime)');
  print('2 - Annuelle (premium_annual)');
  stdout.write('Choix : ');
  final typeChoice = stdin.readLineSync()?.trim();

  String plan = 'premium_lifetime';
  String expiresAtText = '';

  if (typeChoice == '2') {
    plan = 'premium_annual';
    stdout.write('Durée en jours (ex: 365) : ');
    final days = int.tryParse(stdin.readLineSync()?.trim() ?? '365') ?? 365;
    final expiryDate = DateTime.now().add(Duration(days: days));
    expiresAtText =
        expiryDate.toIso8601String().split('.').first; // Format ISO sans ms
  }

  final issuedAtText = DateTime.now().toIso8601String().split('.').first;
  const product = 'oz_carte2visite';

  // 1. Chaîne canonique attendue par l'application pour la vérification signature
  final canonicalData = [
    product,
    licensee,
    plan,
    installationId,
    issuedAtText,
    expiresAtText,
  ].join('|');

  try {
    final privPem = privFile.readAsStringSync();
    final privKey = _parsePrivateKeyFromPem(privPem);

    // 2. Signature SHA-256 / RSA
    final signer = Signer('SHA-256/RSA')
      ..init(true, PrivateKeyParameter<RSAPrivateKey>(privKey));

    final RSASignature sig =
        signer.generateSignature(Uint8List.fromList(utf8.encode(canonicalData)))
            as RSASignature;

    final signatureText = base64Encode(sig.bytes);

    // 3. Objet JSON final
    final Map<String, dynamic> licenseJson = {
      'product': product,
      'licensee': licensee,
      'plan': plan,
      'installationId': installationId,
      'issuedAt': issuedAtText,
      'expiresAt': expiresAtText,
      'signature': signatureText,
    };

    final jsonFormatted =
        const JsonEncoder.withIndent('  ').convert(licenseJson);

    // 4. Export
    final cleanName = licensee.replaceAll(RegExp(r'[^\w\-]'), '_');
    final fileName = 'licence_${cleanName}.ozlicense';

    stdout.write('Dossier d\'export (par défaut: ./licences) : ');
    String outDir = stdin.readLineSync()?.trim() ?? '';
    if (outDir.isEmpty) outDir = './licences';

    final dir = Directory(outDir);
    if (!dir.existsSync()) dir.createSync(recursive: true);

    final outFile = File('${dir.path}/$fileName');
    outFile.writeAsStringSync(jsonFormatted);

    print('\n==================================================');
    print('LICENCE CRÉÉE AVEC SUCCÈS !');
    print('Fichier : ${outFile.path}');
    print('==================================================');
    print('\nCONTENU DU FICHIER À COPIER / COLLER DANS L\'APP :\n');
    print(jsonFormatted);
    print('\n==================================================\n');
  } catch (e) {
    print('Erreur lors de la génération : $e');
  }
}

// ============================================================================
// CRYPTO HELPERS
// ============================================================================

RSAPrivateKey _parsePrivateKeyFromPem(String pem) {
  final lines = pem
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty && !l.startsWith('-----'))
      .join('');

  final bytes = base64Decode(lines);
  final asn1Parser = ASN1Parser(bytes);
  var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

  if (topLevelSeq.elements!.length == 3 &&
      topLevelSeq.elements![2] is ASN1OctetString) {
    final octetString = topLevelSeq.elements![2] as ASN1OctetString;
    final innerParser = ASN1Parser(octetString.octets);
    topLevelSeq = innerParser.nextObject() as ASN1Sequence;
  }

  final modulus = (topLevelSeq.elements![1] as ASN1Integer).integer!;
  final privateExponent = (topLevelSeq.elements![3] as ASN1Integer).integer!;
  final p = (topLevelSeq.elements![4] as ASN1Integer).integer!;
  final q = (topLevelSeq.elements![5] as ASN1Integer).integer!;

  return RSAPrivateKey(modulus, privateExponent, p, q);
}

String _encodePrivateKeyToPem(RSAPrivateKey key) {
  final topSeq = ASN1Sequence();
  topSeq.add(ASN1Integer(BigInt.zero));
  topSeq.add(ASN1Integer(key.modulus));
  topSeq.add(ASN1Integer(key.publicExponent ?? BigInt.parse('65537')));
  topSeq.add(ASN1Integer(key.privateExponent));
  topSeq.add(ASN1Integer(key.p));
  topSeq.add(ASN1Integer(key.q));

  final exp1 = key.privateExponent! % (key.p! - BigInt.one);
  final exp2 = key.privateExponent! % (key.q! - BigInt.one);
  final coeff = key.q!.modInverse(key.p!);

  topSeq.add(ASN1Integer(exp1));
  topSeq.add(ASN1Integer(exp2));
  topSeq.add(ASN1Integer(coeff));

  return '-----BEGIN RSA PRIVATE KEY-----\n${base64Encode(topSeq.encode())}\n-----END RSA PRIVATE KEY-----\n';
}

String _encodePublicKeyToPem(RSAPublicKey key) {
  final topSeq = ASN1Sequence();
  topSeq.add(ASN1Integer(key.modulus));
  topSeq.add(ASN1Integer(key.publicExponent));

  return '-----BEGIN PUBLIC KEY-----\n${base64Encode(topSeq.encode())}\n-----END PUBLIC KEY-----\n';
}
