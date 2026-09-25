// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CardsTable extends Cards with TableInfo<$CardsTable, CardEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _companyMeta =
      const VerificationMeta('company');
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
      'company', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _folderIdMeta =
      const VerificationMeta('folderId');
  @override
  late final GeneratedColumn<String> folderId = GeneratedColumn<String>(
      'folder_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('personal'));
  static const VerificationMeta _frontImagePathMeta =
      const VerificationMeta('frontImagePath');
  @override
  late final GeneratedColumn<String> frontImagePath = GeneratedColumn<String>(
      'front_image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _backImagePathMeta =
      const VerificationMeta('backImagePath');
  @override
  late final GeneratedColumn<String> backImagePath = GeneratedColumn<String>(
      'back_image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expirationDateMeta =
      const VerificationMeta('expirationDate');
  @override
  late final GeneratedColumn<DateTime> expirationDate =
      GeneratedColumn<DateTime>('expiration_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _barcodeValueMeta =
      const VerificationMeta('barcodeValue');
  @override
  late final GeneratedColumn<String> barcodeValue = GeneratedColumn<String>(
      'barcode_value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _barcodeFormatMeta =
      const VerificationMeta('barcodeFormat');
  @override
  late final GeneratedColumn<String> barcodeFormat = GeneratedColumn<String>(
      'barcode_format', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _merchantPhoneMeta =
      const VerificationMeta('merchantPhone');
  @override
  late final GeneratedColumn<String> merchantPhone = GeneratedColumn<String>(
      'merchant_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _merchantEmailMeta =
      const VerificationMeta('merchantEmail');
  @override
  late final GeneratedColumn<String> merchantEmail = GeneratedColumn<String>(
      'merchant_email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        company,
        name,
        phone,
        email,
        notes,
        folderId,
        frontImagePath,
        backImagePath,
        createdAt,
        updatedAt,
        expirationDate,
        barcodeValue,
        barcodeFormat,
        merchantPhone,
        merchantEmail
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(Insertable<CardEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('company')) {
      context.handle(_companyMeta,
          company.isAcceptableOrUnknown(data['company']!, _companyMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('folder_id')) {
      context.handle(_folderIdMeta,
          folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta));
    }
    if (data.containsKey('front_image_path')) {
      context.handle(
          _frontImagePathMeta,
          frontImagePath.isAcceptableOrUnknown(
              data['front_image_path']!, _frontImagePathMeta));
    }
    if (data.containsKey('back_image_path')) {
      context.handle(
          _backImagePathMeta,
          backImagePath.isAcceptableOrUnknown(
              data['back_image_path']!, _backImagePathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('expiration_date')) {
      context.handle(
          _expirationDateMeta,
          expirationDate.isAcceptableOrUnknown(
              data['expiration_date']!, _expirationDateMeta));
    }
    if (data.containsKey('barcode_value')) {
      context.handle(
          _barcodeValueMeta,
          barcodeValue.isAcceptableOrUnknown(
              data['barcode_value']!, _barcodeValueMeta));
    }
    if (data.containsKey('barcode_format')) {
      context.handle(
          _barcodeFormatMeta,
          barcodeFormat.isAcceptableOrUnknown(
              data['barcode_format']!, _barcodeFormatMeta));
    }
    if (data.containsKey('merchant_phone')) {
      context.handle(
          _merchantPhoneMeta,
          merchantPhone.isAcceptableOrUnknown(
              data['merchant_phone']!, _merchantPhoneMeta));
    }
    if (data.containsKey('merchant_email')) {
      context.handle(
          _merchantEmailMeta,
          merchantEmail.isAcceptableOrUnknown(
              data['merchant_email']!, _merchantEmailMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      company: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}company'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      folderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}folder_id'])!,
      frontImagePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}front_image_path']),
      backImagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}back_image_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      expirationDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}expiration_date']),
      barcodeValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode_value']),
      barcodeFormat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode_format']),
      merchantPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}merchant_phone']),
      merchantEmail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}merchant_email']),
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class CardEntity extends DataClass implements Insertable<CardEntity> {
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

  /// Ajoutés en version 3 du schéma, pour les cartes de type abonnement ou
  /// remise/promo. Restent `null` pour toute carte de visite classique.
  final DateTime? expirationDate;
  final String? barcodeValue;
  final String? barcodeFormat;
  final String? merchantPhone;
  final String? merchantEmail;
  const CardEntity(
      {required this.id,
      required this.company,
      required this.name,
      required this.phone,
      required this.email,
      required this.notes,
      required this.folderId,
      this.frontImagePath,
      this.backImagePath,
      required this.createdAt,
      required this.updatedAt,
      this.expirationDate,
      this.barcodeValue,
      this.barcodeFormat,
      this.merchantPhone,
      this.merchantEmail});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['company'] = Variable<String>(company);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    map['notes'] = Variable<String>(notes);
    map['folder_id'] = Variable<String>(folderId);
    if (!nullToAbsent || frontImagePath != null) {
      map['front_image_path'] = Variable<String>(frontImagePath);
    }
    if (!nullToAbsent || backImagePath != null) {
      map['back_image_path'] = Variable<String>(backImagePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || expirationDate != null) {
      map['expiration_date'] = Variable<DateTime>(expirationDate);
    }
    if (!nullToAbsent || barcodeValue != null) {
      map['barcode_value'] = Variable<String>(barcodeValue);
    }
    if (!nullToAbsent || barcodeFormat != null) {
      map['barcode_format'] = Variable<String>(barcodeFormat);
    }
    if (!nullToAbsent || merchantPhone != null) {
      map['merchant_phone'] = Variable<String>(merchantPhone);
    }
    if (!nullToAbsent || merchantEmail != null) {
      map['merchant_email'] = Variable<String>(merchantEmail);
    }
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      company: Value(company),
      name: Value(name),
      phone: Value(phone),
      email: Value(email),
      notes: Value(notes),
      folderId: Value(folderId),
      frontImagePath: frontImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(frontImagePath),
      backImagePath: backImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(backImagePath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      expirationDate: expirationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expirationDate),
      barcodeValue: barcodeValue == null && nullToAbsent
          ? const Value.absent()
          : Value(barcodeValue),
      barcodeFormat: barcodeFormat == null && nullToAbsent
          ? const Value.absent()
          : Value(barcodeFormat),
      merchantPhone: merchantPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantPhone),
      merchantEmail: merchantEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantEmail),
    );
  }

  factory CardEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardEntity(
      id: serializer.fromJson<String>(json['id']),
      company: serializer.fromJson<String>(json['company']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      notes: serializer.fromJson<String>(json['notes']),
      folderId: serializer.fromJson<String>(json['folderId']),
      frontImagePath: serializer.fromJson<String?>(json['frontImagePath']),
      backImagePath: serializer.fromJson<String?>(json['backImagePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      expirationDate: serializer.fromJson<DateTime?>(json['expirationDate']),
      barcodeValue: serializer.fromJson<String?>(json['barcodeValue']),
      barcodeFormat: serializer.fromJson<String?>(json['barcodeFormat']),
      merchantPhone: serializer.fromJson<String?>(json['merchantPhone']),
      merchantEmail: serializer.fromJson<String?>(json['merchantEmail']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'company': serializer.toJson<String>(company),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'notes': serializer.toJson<String>(notes),
      'folderId': serializer.toJson<String>(folderId),
      'frontImagePath': serializer.toJson<String?>(frontImagePath),
      'backImagePath': serializer.toJson<String?>(backImagePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'expirationDate': serializer.toJson<DateTime?>(expirationDate),
      'barcodeValue': serializer.toJson<String?>(barcodeValue),
      'barcodeFormat': serializer.toJson<String?>(barcodeFormat),
      'merchantPhone': serializer.toJson<String?>(merchantPhone),
      'merchantEmail': serializer.toJson<String?>(merchantEmail),
    };
  }

  CardEntity copyWith(
          {String? id,
          String? company,
          String? name,
          String? phone,
          String? email,
          String? notes,
          String? folderId,
          Value<String?> frontImagePath = const Value.absent(),
          Value<String?> backImagePath = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> expirationDate = const Value.absent(),
          Value<String?> barcodeValue = const Value.absent(),
          Value<String?> barcodeFormat = const Value.absent(),
          Value<String?> merchantPhone = const Value.absent(),
          Value<String?> merchantEmail = const Value.absent()}) =>
      CardEntity(
        id: id ?? this.id,
        company: company ?? this.company,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        notes: notes ?? this.notes,
        folderId: folderId ?? this.folderId,
        frontImagePath:
            frontImagePath.present ? frontImagePath.value : this.frontImagePath,
        backImagePath:
            backImagePath.present ? backImagePath.value : this.backImagePath,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        expirationDate:
            expirationDate.present ? expirationDate.value : this.expirationDate,
        barcodeValue:
            barcodeValue.present ? barcodeValue.value : this.barcodeValue,
        barcodeFormat:
            barcodeFormat.present ? barcodeFormat.value : this.barcodeFormat,
        merchantPhone:
            merchantPhone.present ? merchantPhone.value : this.merchantPhone,
        merchantEmail:
            merchantEmail.present ? merchantEmail.value : this.merchantEmail,
      );
  CardEntity copyWithCompanion(CardsCompanion data) {
    return CardEntity(
      id: data.id.present ? data.id.value : this.id,
      company: data.company.present ? data.company.value : this.company,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      notes: data.notes.present ? data.notes.value : this.notes,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      frontImagePath: data.frontImagePath.present
          ? data.frontImagePath.value
          : this.frontImagePath,
      backImagePath: data.backImagePath.present
          ? data.backImagePath.value
          : this.backImagePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      expirationDate: data.expirationDate.present
          ? data.expirationDate.value
          : this.expirationDate,
      barcodeValue: data.barcodeValue.present
          ? data.barcodeValue.value
          : this.barcodeValue,
      barcodeFormat: data.barcodeFormat.present
          ? data.barcodeFormat.value
          : this.barcodeFormat,
      merchantPhone: data.merchantPhone.present
          ? data.merchantPhone.value
          : this.merchantPhone,
      merchantEmail: data.merchantEmail.present
          ? data.merchantEmail.value
          : this.merchantEmail,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardEntity(')
          ..write('id: $id, ')
          ..write('company: $company, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('notes: $notes, ')
          ..write('folderId: $folderId, ')
          ..write('frontImagePath: $frontImagePath, ')
          ..write('backImagePath: $backImagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('expirationDate: $expirationDate, ')
          ..write('barcodeValue: $barcodeValue, ')
          ..write('barcodeFormat: $barcodeFormat, ')
          ..write('merchantPhone: $merchantPhone, ')
          ..write('merchantEmail: $merchantEmail')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      company,
      name,
      phone,
      email,
      notes,
      folderId,
      frontImagePath,
      backImagePath,
      createdAt,
      updatedAt,
      expirationDate,
      barcodeValue,
      barcodeFormat,
      merchantPhone,
      merchantEmail);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardEntity &&
          other.id == this.id &&
          other.company == this.company &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.notes == this.notes &&
          other.folderId == this.folderId &&
          other.frontImagePath == this.frontImagePath &&
          other.backImagePath == this.backImagePath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.expirationDate == this.expirationDate &&
          other.barcodeValue == this.barcodeValue &&
          other.barcodeFormat == this.barcodeFormat &&
          other.merchantPhone == this.merchantPhone &&
          other.merchantEmail == this.merchantEmail);
}

class CardsCompanion extends UpdateCompanion<CardEntity> {
  final Value<String> id;
  final Value<String> company;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> email;
  final Value<String> notes;
  final Value<String> folderId;
  final Value<String?> frontImagePath;
  final Value<String?> backImagePath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> expirationDate;
  final Value<String?> barcodeValue;
  final Value<String?> barcodeFormat;
  final Value<String?> merchantPhone;
  final Value<String?> merchantEmail;
  final Value<int> rowid;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.company = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.folderId = const Value.absent(),
    this.frontImagePath = const Value.absent(),
    this.backImagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.expirationDate = const Value.absent(),
    this.barcodeValue = const Value.absent(),
    this.barcodeFormat = const Value.absent(),
    this.merchantPhone = const Value.absent(),
    this.merchantEmail = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardsCompanion.insert({
    required String id,
    this.company = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.folderId = const Value.absent(),
    this.frontImagePath = const Value.absent(),
    this.backImagePath = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.expirationDate = const Value.absent(),
    this.barcodeValue = const Value.absent(),
    this.barcodeFormat = const Value.absent(),
    this.merchantPhone = const Value.absent(),
    this.merchantEmail = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CardEntity> custom({
    Expression<String>? id,
    Expression<String>? company,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? notes,
    Expression<String>? folderId,
    Expression<String>? frontImagePath,
    Expression<String>? backImagePath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? expirationDate,
    Expression<String>? barcodeValue,
    Expression<String>? barcodeFormat,
    Expression<String>? merchantPhone,
    Expression<String>? merchantEmail,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (company != null) 'company': company,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (notes != null) 'notes': notes,
      if (folderId != null) 'folder_id': folderId,
      if (frontImagePath != null) 'front_image_path': frontImagePath,
      if (backImagePath != null) 'back_image_path': backImagePath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (expirationDate != null) 'expiration_date': expirationDate,
      if (barcodeValue != null) 'barcode_value': barcodeValue,
      if (barcodeFormat != null) 'barcode_format': barcodeFormat,
      if (merchantPhone != null) 'merchant_phone': merchantPhone,
      if (merchantEmail != null) 'merchant_email': merchantEmail,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardsCompanion copyWith(
      {Value<String>? id,
      Value<String>? company,
      Value<String>? name,
      Value<String>? phone,
      Value<String>? email,
      Value<String>? notes,
      Value<String>? folderId,
      Value<String?>? frontImagePath,
      Value<String?>? backImagePath,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? expirationDate,
      Value<String?>? barcodeValue,
      Value<String?>? barcodeFormat,
      Value<String?>? merchantPhone,
      Value<String?>? merchantEmail,
      Value<int>? rowid}) {
    return CardsCompanion(
      id: id ?? this.id,
      company: company ?? this.company,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      folderId: folderId ?? this.folderId,
      frontImagePath: frontImagePath ?? this.frontImagePath,
      backImagePath: backImagePath ?? this.backImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expirationDate: expirationDate ?? this.expirationDate,
      barcodeValue: barcodeValue ?? this.barcodeValue,
      barcodeFormat: barcodeFormat ?? this.barcodeFormat,
      merchantPhone: merchantPhone ?? this.merchantPhone,
      merchantEmail: merchantEmail ?? this.merchantEmail,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<String>(folderId.value);
    }
    if (frontImagePath.present) {
      map['front_image_path'] = Variable<String>(frontImagePath.value);
    }
    if (backImagePath.present) {
      map['back_image_path'] = Variable<String>(backImagePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (expirationDate.present) {
      map['expiration_date'] = Variable<DateTime>(expirationDate.value);
    }
    if (barcodeValue.present) {
      map['barcode_value'] = Variable<String>(barcodeValue.value);
    }
    if (barcodeFormat.present) {
      map['barcode_format'] = Variable<String>(barcodeFormat.value);
    }
    if (merchantPhone.present) {
      map['merchant_phone'] = Variable<String>(merchantPhone.value);
    }
    if (merchantEmail.present) {
      map['merchant_email'] = Variable<String>(merchantEmail.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('company: $company, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('notes: $notes, ')
          ..write('folderId: $folderId, ')
          ..write('frontImagePath: $frontImagePath, ')
          ..write('backImagePath: $backImagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('expirationDate: $expirationDate, ')
          ..write('barcodeValue: $barcodeValue, ')
          ..write('barcodeFormat: $barcodeFormat, ')
          ..write('merchantPhone: $merchantPhone, ')
          ..write('merchantEmail: $merchantEmail, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoldersTable extends Folders
    with TableInfo<$FoldersTable, FolderEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoldersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _kindValueMeta =
      const VerificationMeta('kindValue');
  @override
  late final GeneratedColumn<String> kindValue = GeneratedColumn<String>(
      'kind_value', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('businessCard'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, isDefault, colorValue, kindValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folders';
  @override
  VerificationContext validateIntegrity(Insertable<FolderEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    }
    if (data.containsKey('kind_value')) {
      context.handle(_kindValueMeta,
          kindValue.isAcceptableOrUnknown(data['kind_value']!, _kindValueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FolderEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FolderEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value']),
      kindValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind_value'])!,
    );
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(attachedDatabase, alias);
  }
}

class FolderEntity extends DataClass implements Insertable<FolderEntity> {
  final String id;
  final String name;
  final bool isDefault;

  /// Couleur choisie par l'utilisateur (ARGB), nullable : ajoutée en
  /// version 2 du schéma. `null` signifie qu'aucune couleur explicite n'a
  /// été choisie, l'interface en attribue une par défaut.
  final int? colorValue;

  /// Ajouté en version 3 du schéma : détermine si ce classeur contient des
  /// cartes de visite, des abonnements, ou des remises/promos — fixé à la
  /// création, jamais modifié ensuite. Les classeurs déjà en base avant
  /// cette version sont tous des classeurs de cartes de visite classiques.
  final String kindValue;
  const FolderEntity(
      {required this.id,
      required this.name,
      required this.isDefault,
      this.colorValue,
      required this.kindValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['is_default'] = Variable<bool>(isDefault);
    if (!nullToAbsent || colorValue != null) {
      map['color_value'] = Variable<int>(colorValue);
    }
    map['kind_value'] = Variable<String>(kindValue);
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: Value(id),
      name: Value(name),
      isDefault: Value(isDefault),
      colorValue: colorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(colorValue),
      kindValue: Value(kindValue),
    );
  }

  factory FolderEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FolderEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      colorValue: serializer.fromJson<int?>(json['colorValue']),
      kindValue: serializer.fromJson<String>(json['kindValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'isDefault': serializer.toJson<bool>(isDefault),
      'colorValue': serializer.toJson<int?>(colorValue),
      'kindValue': serializer.toJson<String>(kindValue),
    };
  }

  FolderEntity copyWith(
          {String? id,
          String? name,
          bool? isDefault,
          Value<int?> colorValue = const Value.absent(),
          String? kindValue}) =>
      FolderEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        isDefault: isDefault ?? this.isDefault,
        colorValue: colorValue.present ? colorValue.value : this.colorValue,
        kindValue: kindValue ?? this.kindValue,
      );
  FolderEntity copyWithCompanion(FoldersCompanion data) {
    return FolderEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      kindValue: data.kindValue.present ? data.kindValue.value : this.kindValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FolderEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDefault: $isDefault, ')
          ..write('colorValue: $colorValue, ')
          ..write('kindValue: $kindValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isDefault, colorValue, kindValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FolderEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.isDefault == this.isDefault &&
          other.colorValue == this.colorValue &&
          other.kindValue == this.kindValue);
}

class FoldersCompanion extends UpdateCompanion<FolderEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> isDefault;
  final Value<int?> colorValue;
  final Value<String> kindValue;
  final Value<int> rowid;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.kindValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoldersCompanion.insert({
    required String id,
    required String name,
    this.isDefault = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.kindValue = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<FolderEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? isDefault,
    Expression<int>? colorValue,
    Expression<String>? kindValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isDefault != null) 'is_default': isDefault,
      if (colorValue != null) 'color_value': colorValue,
      if (kindValue != null) 'kind_value': kindValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoldersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<bool>? isDefault,
      Value<int?>? colorValue,
      Value<String>? kindValue,
      Value<int>? rowid}) {
    return FoldersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
      colorValue: colorValue ?? this.colorValue,
      kindValue: kindValue ?? this.kindValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (kindValue.present) {
      map['kind_value'] = Variable<String>(kindValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDefault: $isDefault, ')
          ..write('colorValue: $colorValue, ')
          ..write('kindValue: $kindValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $FoldersTable folders = $FoldersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cards, folders];
}

typedef $$CardsTableCreateCompanionBuilder = CardsCompanion Function({
  required String id,
  Value<String> company,
  Value<String> name,
  Value<String> phone,
  Value<String> email,
  Value<String> notes,
  Value<String> folderId,
  Value<String?> frontImagePath,
  Value<String?> backImagePath,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> expirationDate,
  Value<String?> barcodeValue,
  Value<String?> barcodeFormat,
  Value<String?> merchantPhone,
  Value<String?> merchantEmail,
  Value<int> rowid,
});
typedef $$CardsTableUpdateCompanionBuilder = CardsCompanion Function({
  Value<String> id,
  Value<String> company,
  Value<String> name,
  Value<String> phone,
  Value<String> email,
  Value<String> notes,
  Value<String> folderId,
  Value<String?> frontImagePath,
  Value<String?> backImagePath,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> expirationDate,
  Value<String?> barcodeValue,
  Value<String?> barcodeFormat,
  Value<String?> merchantPhone,
  Value<String?> merchantEmail,
  Value<int> rowid,
});

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get company => $composableBuilder(
      column: $table.company, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get folderId => $composableBuilder(
      column: $table.folderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frontImagePath => $composableBuilder(
      column: $table.frontImagePath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get backImagePath => $composableBuilder(
      column: $table.backImagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expirationDate => $composableBuilder(
      column: $table.expirationDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcodeValue => $composableBuilder(
      column: $table.barcodeValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcodeFormat => $composableBuilder(
      column: $table.barcodeFormat, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get merchantPhone => $composableBuilder(
      column: $table.merchantPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get merchantEmail => $composableBuilder(
      column: $table.merchantEmail, builder: (column) => ColumnFilters(column));
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get company => $composableBuilder(
      column: $table.company, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get folderId => $composableBuilder(
      column: $table.folderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frontImagePath => $composableBuilder(
      column: $table.frontImagePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get backImagePath => $composableBuilder(
      column: $table.backImagePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expirationDate => $composableBuilder(
      column: $table.expirationDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcodeValue => $composableBuilder(
      column: $table.barcodeValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcodeFormat => $composableBuilder(
      column: $table.barcodeFormat,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get merchantPhone => $composableBuilder(
      column: $table.merchantPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get merchantEmail => $composableBuilder(
      column: $table.merchantEmail,
      builder: (column) => ColumnOrderings(column));
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get folderId =>
      $composableBuilder(column: $table.folderId, builder: (column) => column);

  GeneratedColumn<String> get frontImagePath => $composableBuilder(
      column: $table.frontImagePath, builder: (column) => column);

  GeneratedColumn<String> get backImagePath => $composableBuilder(
      column: $table.backImagePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expirationDate => $composableBuilder(
      column: $table.expirationDate, builder: (column) => column);

  GeneratedColumn<String> get barcodeValue => $composableBuilder(
      column: $table.barcodeValue, builder: (column) => column);

  GeneratedColumn<String> get barcodeFormat => $composableBuilder(
      column: $table.barcodeFormat, builder: (column) => column);

  GeneratedColumn<String> get merchantPhone => $composableBuilder(
      column: $table.merchantPhone, builder: (column) => column);

  GeneratedColumn<String> get merchantEmail => $composableBuilder(
      column: $table.merchantEmail, builder: (column) => column);
}

class $$CardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CardsTable,
    CardEntity,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (CardEntity, BaseReferences<_$AppDatabase, $CardsTable, CardEntity>),
    CardEntity,
    PrefetchHooks Function()> {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> company = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String> folderId = const Value.absent(),
            Value<String?> frontImagePath = const Value.absent(),
            Value<String?> backImagePath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> expirationDate = const Value.absent(),
            Value<String?> barcodeValue = const Value.absent(),
            Value<String?> barcodeFormat = const Value.absent(),
            Value<String?> merchantPhone = const Value.absent(),
            Value<String?> merchantEmail = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CardsCompanion(
            id: id,
            company: company,
            name: name,
            phone: phone,
            email: email,
            notes: notes,
            folderId: folderId,
            frontImagePath: frontImagePath,
            backImagePath: backImagePath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            expirationDate: expirationDate,
            barcodeValue: barcodeValue,
            barcodeFormat: barcodeFormat,
            merchantPhone: merchantPhone,
            merchantEmail: merchantEmail,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> company = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String> folderId = const Value.absent(),
            Value<String?> frontImagePath = const Value.absent(),
            Value<String?> backImagePath = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> expirationDate = const Value.absent(),
            Value<String?> barcodeValue = const Value.absent(),
            Value<String?> barcodeFormat = const Value.absent(),
            Value<String?> merchantPhone = const Value.absent(),
            Value<String?> merchantEmail = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CardsCompanion.insert(
            id: id,
            company: company,
            name: name,
            phone: phone,
            email: email,
            notes: notes,
            folderId: folderId,
            frontImagePath: frontImagePath,
            backImagePath: backImagePath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            expirationDate: expirationDate,
            barcodeValue: barcodeValue,
            barcodeFormat: barcodeFormat,
            merchantPhone: merchantPhone,
            merchantEmail: merchantEmail,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CardsTable,
    CardEntity,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (CardEntity, BaseReferences<_$AppDatabase, $CardsTable, CardEntity>),
    CardEntity,
    PrefetchHooks Function()>;
typedef $$FoldersTableCreateCompanionBuilder = FoldersCompanion Function({
  required String id,
  required String name,
  Value<bool> isDefault,
  Value<int?> colorValue,
  Value<String> kindValue,
  Value<int> rowid,
});
typedef $$FoldersTableUpdateCompanionBuilder = FoldersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<bool> isDefault,
  Value<int?> colorValue,
  Value<String> kindValue,
  Value<int> rowid,
});

class $$FoldersTableFilterComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kindValue => $composableBuilder(
      column: $table.kindValue, builder: (column) => ColumnFilters(column));
}

class $$FoldersTableOrderingComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kindValue => $composableBuilder(
      column: $table.kindValue, builder: (column) => ColumnOrderings(column));
}

class $$FoldersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  GeneratedColumn<String> get kindValue =>
      $composableBuilder(column: $table.kindValue, builder: (column) => column);
}

class $$FoldersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FoldersTable,
    FolderEntity,
    $$FoldersTableFilterComposer,
    $$FoldersTableOrderingComposer,
    $$FoldersTableAnnotationComposer,
    $$FoldersTableCreateCompanionBuilder,
    $$FoldersTableUpdateCompanionBuilder,
    (FolderEntity, BaseReferences<_$AppDatabase, $FoldersTable, FolderEntity>),
    FolderEntity,
    PrefetchHooks Function()> {
  $$FoldersTableTableManager(_$AppDatabase db, $FoldersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<int?> colorValue = const Value.absent(),
            Value<String> kindValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FoldersCompanion(
            id: id,
            name: name,
            isDefault: isDefault,
            colorValue: colorValue,
            kindValue: kindValue,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<bool> isDefault = const Value.absent(),
            Value<int?> colorValue = const Value.absent(),
            Value<String> kindValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FoldersCompanion.insert(
            id: id,
            name: name,
            isDefault: isDefault,
            colorValue: colorValue,
            kindValue: kindValue,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FoldersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FoldersTable,
    FolderEntity,
    $$FoldersTableFilterComposer,
    $$FoldersTableOrderingComposer,
    $$FoldersTableAnnotationComposer,
    $$FoldersTableCreateCompanionBuilder,
    $$FoldersTableUpdateCompanionBuilder,
    (FolderEntity, BaseReferences<_$AppDatabase, $FoldersTable, FolderEntity>),
    FolderEntity,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$FoldersTableTableManager get folders =>
      $$FoldersTableTableManager(_db, _db.folders);
}
