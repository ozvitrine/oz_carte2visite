enum FolderKind {
  businessCard,
  subscription,
  discount;

  static FolderKind fromValue(String? value) {
    return switch (value) {
      'subscription' => FolderKind.subscription,
      'discount' => FolderKind.discount,
      _ => FolderKind.businessCard,
    };
  }

  String get value {
    return switch (this) {
      FolderKind.businessCard => 'businessCard',
      FolderKind.subscription => 'subscription',
      FolderKind.discount => 'discount',
    };
  }
}

class CardFolder {
  const CardFolder({
    required this.id,
    required this.name,
    this.isDefault = false,
    this.colorValue,
    this.kind = FolderKind.businessCard,
  });

  final String id;
  final String name;
  final bool isDefault;

  /// Couleur choisie pour ce classeur (ARGB), ou `null` si l'utilisateur
  /// n'en a pas choisi une explicitement — dans ce cas l'interface attribue
  /// une couleur par défaut selon la position du classeur dans la liste.
  final int? colorValue;

  /// Fixé à la création du classeur, jamais modifiable ensuite — détermine
  /// quels champs sont proposés pour les cartes qu'il contient, et si le
  /// transfert (partage carte par carte, export PDF) est autorisé.
  final FolderKind kind;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isDefault': isDefault,
        'colorValue': colorValue,
        'kind': kind.value,
      };

  factory CardFolder.fromJson(Map<String, dynamic> json) {
    return CardFolder(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Sans nom',
      isDefault: json['isDefault'] == true,
      colorValue: json['colorValue'] is int ? json['colorValue'] as int : null,
      kind: FolderKind.fromValue(json['kind']?.toString()),
    );
  }
}
