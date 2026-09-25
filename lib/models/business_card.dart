class BusinessCard {
  const BusinessCard({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.company = '',
    this.name = '',
    this.phone = '',
    this.email = '',
    this.notes = '',
    this.folderId = 'personal',
    this.frontImagePath,
    this.backImagePath,
    this.expirationDate,
    this.barcodeValue,
    this.barcodeFormat,
    this.merchantPhone,
    this.merchantEmail,
  });

  final String id;
  final String company;
  final String name;
  final String phone;
  final String email;
  final String notes;
  final String folderId;
  final String? frontImagePath;
  final String? backImagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Utilisé par les cartes de type abonnement ou remise/promo uniquement.
  final DateTime? expirationDate;

  /// Valeur brute du code scanné (QR ou code-barres), pour un abonnement ou
  /// une remise/promo — permet de le réafficher sans repasser par l'appareil
  /// photo.
  final String? barcodeValue;

  /// Nom du format détecté par le scanner (ex. 'qrCode', 'code128',
  /// 'ean13'), nécessaire pour redessiner le bon type de code à l'écran.
  final String? barcodeFormat;

  /// Coordonnées du commerce ou de l'enseigne émettrice — distinctes du
  /// titulaire de la carte — pour un abonnement ou une remise/promo.
  final String? merchantPhone;
  final String? merchantEmail;

  String get title => company.isNotEmpty ? company : name;

  BusinessCard copyWith({
    String? company,
    String? name,
    String? phone,
    String? email,
    String? notes,
    String? folderId,
    String? frontImagePath,
    String? backImagePath,
    DateTime? updatedAt,
    DateTime? expirationDate,
    String? barcodeValue,
    String? barcodeFormat,
    String? merchantPhone,
    String? merchantEmail,
  }) {
    return BusinessCard(
      id: id,
      company: company ?? this.company,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      folderId: folderId ?? this.folderId,
      frontImagePath: frontImagePath ?? this.frontImagePath,
      backImagePath: backImagePath ?? this.backImagePath,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expirationDate: expirationDate ?? this.expirationDate,
      barcodeValue: barcodeValue ?? this.barcodeValue,
      barcodeFormat: barcodeFormat ?? this.barcodeFormat,
      merchantPhone: merchantPhone ?? this.merchantPhone,
      merchantEmail: merchantEmail ?? this.merchantEmail,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'company': company,
        'name': name,
        'phone': phone,
        'email': email,
        'notes': notes,
        'folderId': folderId,
        'frontImagePath': frontImagePath,
        'backImagePath': backImagePath,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'expirationDate': expirationDate?.toIso8601String(),
        'barcodeValue': barcodeValue,
        'barcodeFormat': barcodeFormat,
        'merchantPhone': merchantPhone,
        'merchantEmail': merchantEmail,
      };

  factory BusinessCard.fromJson(Map<String, dynamic> json) {
    DateTime readDate(String key) {
      return DateTime.tryParse(json[key]?.toString() ?? '') ?? DateTime.now();
    }

    DateTime? readOptionalDate(String key) {
      final raw = json[key]?.toString();
      if (raw == null || raw.isEmpty) return null;
      return DateTime.tryParse(raw);
    }

    return BusinessCard(
      id: json['id']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      folderId: json['folderId']?.toString() ?? 'personal',
      frontImagePath: json['frontImagePath']?.toString(),
      backImagePath: json['backImagePath']?.toString(),
      createdAt: readDate('createdAt'),
      updatedAt: readDate('updatedAt'),
      expirationDate: readOptionalDate('expirationDate'),
      barcodeValue: json['barcodeValue']?.toString(),
      barcodeFormat: json['barcodeFormat']?.toString(),
      merchantPhone: json['merchantPhone']?.toString(),
      merchantEmail: json['merchantEmail']?.toString(),
    );
  }
}
