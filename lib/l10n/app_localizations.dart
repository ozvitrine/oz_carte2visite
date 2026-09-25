import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'oz_carte2visite'**
  String get appTitle;

  /// No description provided for @languageScreenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre langue'**
  String get languageScreenTitle;

  /// No description provided for @languageScreenSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vous pourrez changer ce réglage plus tard, depuis les préférences.'**
  String get languageScreenSubtitle;

  /// No description provided for @languageOptionFrench.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get languageOptionFrench;

  /// No description provided for @languageOptionEnglish.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get languageOptionEnglish;

  /// No description provided for @languageScreenContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get languageScreenContinue;

  /// No description provided for @actionCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get actionCancel;

  /// No description provided for @actionCreate.
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get actionCreate;

  /// No description provided for @actionRename.
  ///
  /// In fr, this message translates to:
  /// **'Renommer'**
  String get actionRename;

  /// No description provided for @actionDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get actionDelete;

  /// No description provided for @actionReset.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get actionReset;

  /// No description provided for @actionReplace.
  ///
  /// In fr, this message translates to:
  /// **'Remplacer'**
  String get actionReplace;

  /// No description provided for @actionMerge.
  ///
  /// In fr, this message translates to:
  /// **'Fusionner'**
  String get actionMerge;

  /// No description provided for @actionReplaceAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout remplacer'**
  String get actionReplaceAll;

  /// No description provided for @actionRestore.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer'**
  String get actionRestore;

  /// No description provided for @actionStayHere.
  ///
  /// In fr, this message translates to:
  /// **'Rester ici'**
  String get actionStayHere;

  /// No description provided for @actionOpenFolder.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir le classeur'**
  String get actionOpenFolder;

  /// No description provided for @actionImport.
  ///
  /// In fr, this message translates to:
  /// **'Importer'**
  String get actionImport;

  /// No description provided for @actionClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get actionClose;

  /// No description provided for @actionRemove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get actionRemove;

  /// No description provided for @fieldCompany.
  ///
  /// In fr, this message translates to:
  /// **'Entreprise'**
  String get fieldCompany;

  /// No description provided for @fieldName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get fieldName;

  /// No description provided for @fieldPhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get fieldPhone;

  /// No description provided for @fieldEmail.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get fieldEmail;

  /// No description provided for @fieldNotes.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get fieldNotes;

  /// No description provided for @fieldFolder.
  ///
  /// In fr, this message translates to:
  /// **'Classeur'**
  String get fieldFolder;

  /// No description provided for @onboardingTakePhoto.
  ///
  /// In fr, this message translates to:
  /// **'Prendre une photo'**
  String get onboardingTakePhoto;

  /// No description provided for @onboardingChooseImage.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une image'**
  String get onboardingChooseImage;

  /// No description provided for @onboardingImageError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de traiter cette image.'**
  String get onboardingImageError;

  /// No description provided for @onboardingOcrDetected.
  ///
  /// In fr, this message translates to:
  /// **'Texte détecté. Vérifiez les propositions avant validation.'**
  String get onboardingOcrDetected;

  /// No description provided for @onboardingOcrFailed.
  ///
  /// In fr, this message translates to:
  /// **'Le texte de cette image n’a pas pu être lu.'**
  String get onboardingOcrFailed;

  /// No description provided for @onboardingQrDetected.
  ///
  /// In fr, this message translates to:
  /// **'QR Code détecté : son contenu a été ajouté aux notes.'**
  String get onboardingQrDetected;

  /// No description provided for @onboardingMissingFrontPhoto.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez d’abord une photo recto de votre carte.'**
  String get onboardingMissingFrontPhoto;

  /// No description provided for @onboardingMissingNameOrCompany.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez ou renseignez au minimum le nom ou l’entreprise.'**
  String get onboardingMissingNameOrCompany;

  /// No description provided for @onboardingLegalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mentions légales'**
  String get onboardingLegalTitle;

  /// No description provided for @onboardingLegalBody.
  ///
  /// In fr, this message translates to:
  /// **'Vos cartes sont stockées sur votre appareil. Les photos, sauvegardes et partages sont déclenchés uniquement à votre demande.\n\nCopyright © 2025 oz_carte2visite.'**
  String get onboardingLegalBody;

  /// No description provided for @onboardingLegalAccept.
  ///
  /// In fr, this message translates to:
  /// **'J’accepte et je continue'**
  String get onboardingLegalAccept;

  /// No description provided for @onboardingPlanTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre formule'**
  String get onboardingPlanTitle;

  /// No description provided for @onboardingPlanSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vous pourrez passer à Premium après la mise en place de l’abonnement Google Play.'**
  String get onboardingPlanSubtitle;

  /// No description provided for @onboardingPlanFreeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sans publicité'**
  String get onboardingPlanFreeTitle;

  /// No description provided for @onboardingPlanFreeDetail.
  ///
  /// In fr, this message translates to:
  /// **'Une seule carte de visite. Paramètres verrouillés.'**
  String get onboardingPlanFreeDetail;

  /// No description provided for @onboardingPlanAdsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Avec publicité'**
  String get onboardingPlanAdsTitle;

  /// No description provided for @onboardingPlanAdsDetail.
  ///
  /// In fr, this message translates to:
  /// **'Cartes illimitées. Publicité après la première carte, puis au retour de l’application au premier plan. Paramètres et partage de cartes verrouillés.'**
  String get onboardingPlanAdsDetail;

  /// No description provided for @onboardingPremiumTitle.
  ///
  /// In fr, this message translates to:
  /// **'Premium — 10 € par an'**
  String get onboardingPremiumTitle;

  /// No description provided for @onboardingPremiumDetail.
  ///
  /// In fr, this message translates to:
  /// **'Cartes illimitées, sans publicité et accès aux paramètres. Disponible prochainement via Google Play.'**
  String get onboardingPremiumDetail;

  /// No description provided for @onboardingPlanValidate.
  ///
  /// In fr, this message translates to:
  /// **'Valider la formule'**
  String get onboardingPlanValidate;

  /// No description provided for @onboardingPhotoStepTitle.
  ///
  /// In fr, this message translates to:
  /// **'Photographiez votre première carte'**
  String get onboardingPhotoStepTitle;

  /// No description provided for @onboardingPhotoStepSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Les images sont optimisées pour rester lisibles tout en réduisant la taille des sauvegardes et partages.'**
  String get onboardingPhotoStepSubtitle;

  /// No description provided for @onboardingFrontPhotoLabel.
  ///
  /// In fr, this message translates to:
  /// **'Photo recto'**
  String get onboardingFrontPhotoLabel;

  /// No description provided for @onboardingBackPhotoLabel.
  ///
  /// In fr, this message translates to:
  /// **'Photo verso — facultative'**
  String get onboardingBackPhotoLabel;

  /// No description provided for @onboardingAnalyzing.
  ///
  /// In fr, this message translates to:
  /// **'Optimisation et analyse de l’image en cours…'**
  String get onboardingAnalyzing;

  /// No description provided for @onboardingDetectedInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations détectées — à corriger si nécessaire'**
  String get onboardingDetectedInfoTitle;

  /// No description provided for @onboardingValidateCard.
  ///
  /// In fr, this message translates to:
  /// **'Valider ma carte'**
  String get onboardingValidateCard;

  /// No description provided for @homeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes classeurs'**
  String get homeTitle;

  /// No description provided for @homeExportAllTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Exporter tous les classeurs en PDF'**
  String get homeExportAllTooltip;

  /// No description provided for @homeSettingsTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get homeSettingsTooltip;

  /// No description provided for @homeNewFolderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau classeur'**
  String get homeNewFolderTitle;

  /// No description provided for @homeFolderNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom du classeur'**
  String get homeFolderNameLabel;

  /// No description provided for @homeFolderNameTaken.
  ///
  /// In fr, this message translates to:
  /// **'Un classeur portant le nom « {name} » existe déjà.'**
  String homeFolderNameTaken(String name);

  /// No description provided for @homeFolderCreated.
  ///
  /// In fr, this message translates to:
  /// **'Classeur « {name} » créé.'**
  String homeFolderCreated(String name);

  /// No description provided for @homeRenameFolderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Renommer le classeur'**
  String get homeRenameFolderTitle;

  /// No description provided for @homeFolderRenamed.
  ///
  /// In fr, this message translates to:
  /// **'Classeur renommé en « {name} ».'**
  String homeFolderRenamed(String name);

  /// No description provided for @homeFolderColorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Couleur du classeur'**
  String get homeFolderColorTitle;

  /// No description provided for @homeFolderColorTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Couleur du classeur'**
  String get homeFolderColorTooltip;

  /// No description provided for @homeRenameFolderTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Renommer le classeur'**
  String get homeRenameFolderTooltip;

  /// No description provided for @homeAddCardBeforeExport.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez au moins une carte avant l’export PDF.'**
  String get homeAddCardBeforeExport;

  /// No description provided for @homeGlobalPdfReady.
  ///
  /// In fr, this message translates to:
  /// **'Le PDF global est prêt à être enregistré ou partagé.'**
  String get homeGlobalPdfReady;

  /// No description provided for @homeGlobalPdfError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de générer le PDF global.'**
  String get homeGlobalPdfError;

  /// No description provided for @homeCardCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 carte} =1{1 carte} other{{count} cartes}}'**
  String homeCardCount(int count);

  /// No description provided for @folderDeleteDefaultBlocked.
  ///
  /// In fr, this message translates to:
  /// **'Ce classeur par défaut ne peut pas être supprimé.'**
  String get folderDeleteDefaultBlocked;

  /// No description provided for @folderDeleteNotEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Ce classeur contient encore des cartes et ne peut pas être supprimé.'**
  String get folderDeleteNotEmpty;

  /// No description provided for @folderDeleteConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ce classeur ?'**
  String get folderDeleteConfirmTitle;

  /// No description provided for @folderDeleteConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'Le classeur « {name} » est vide. Voulez-vous vraiment le supprimer ?'**
  String folderDeleteConfirmBody(String name);

  /// No description provided for @folderDeleteFailed.
  ///
  /// In fr, this message translates to:
  /// **'Le classeur ne peut pas être supprimé.'**
  String get folderDeleteFailed;

  /// No description provided for @folderPdfReady.
  ///
  /// In fr, this message translates to:
  /// **'Le PDF est prêt à être enregistré ou partagé.'**
  String get folderPdfReady;

  /// No description provided for @folderPdfError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de générer le PDF.'**
  String get folderPdfError;

  /// No description provided for @folderDestinationNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Le classeur choisi est introuvable.'**
  String get folderDestinationNotFound;

  /// No description provided for @folderExportTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Exporter le classeur en PDF'**
  String get folderExportTooltip;

  /// No description provided for @folderDeleteTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le classeur'**
  String get folderDeleteTooltip;

  /// No description provided for @folderAllLetter.
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get folderAllLetter;

  /// No description provided for @folderAddCardLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une carte'**
  String get folderAddCardLabel;

  /// No description provided for @folderEmptyDefault.
  ///
  /// In fr, this message translates to:
  /// **'Le classeur « {name} » ne contient encore aucune carte.'**
  String folderEmptyDefault(String name);

  /// No description provided for @folderEmptyLetter.
  ///
  /// In fr, this message translates to:
  /// **'Aucune carte ne commence par la lettre {letter}.'**
  String folderEmptyLetter(String letter);

  /// No description provided for @cardDetailGone.
  ///
  /// In fr, this message translates to:
  /// **'Cette carte n’existe plus.'**
  String get cardDetailGone;

  /// No description provided for @cardLinkOpenError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’ouvrir ce lien.'**
  String get cardLinkOpenError;

  /// No description provided for @cardPhoneAppError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’ouvrir l’application téléphone.'**
  String get cardPhoneAppError;

  /// No description provided for @cardEmailSubject.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {name}'**
  String cardEmailSubject(String name);

  /// No description provided for @cardEmailAppError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’ouvrir votre application e-mail.'**
  String get cardEmailAppError;

  /// No description provided for @cardSmsAppError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’ouvrir votre application SMS.'**
  String get cardSmsAppError;

  /// No description provided for @cardShareOzcardReady.
  ///
  /// In fr, this message translates to:
  /// **'Carte .ozcard prête à être partagée.'**
  String get cardShareOzcardReady;

  /// No description provided for @cardShareOzcardError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de partager cette carte.'**
  String get cardShareOzcardError;

  /// No description provided for @cardContactSaved.
  ///
  /// In fr, this message translates to:
  /// **'Contact enregistré dans le répertoire Android.'**
  String get cardContactSaved;

  /// No description provided for @cardContactPermissionNeeded.
  ///
  /// In fr, this message translates to:
  /// **'L’autorisation Contacts est nécessaire pour enregistrer cette fiche.'**
  String get cardContactPermissionNeeded;

  /// No description provided for @cardContactSaveError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’enregistrer ce contact.'**
  String get cardContactSaveError;

  /// No description provided for @cardDeleteConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cette carte ?'**
  String get cardDeleteConfirmTitle;

  /// No description provided for @cardDeleteConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'La carte et ses informations seront retirées de l’application.'**
  String get cardDeleteConfirmBody;

  /// No description provided for @cardQrDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'QR Code de votre carte'**
  String get cardQrDialogTitle;

  /// No description provided for @cardQrScanHintNoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Scannable par n’importe quel appareil photo.'**
  String get cardQrScanHintNoTitle;

  /// No description provided for @cardQrScanHintWithTitle.
  ///
  /// In fr, this message translates to:
  /// **'{title} — scannable par n’importe quel appareil photo.'**
  String cardQrScanHintWithTitle(String title);

  /// No description provided for @cardDefaultTitle.
  ///
  /// In fr, this message translates to:
  /// **'Carte de visite'**
  String get cardDefaultTitle;

  /// No description provided for @cardEditTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la carte'**
  String get cardEditTooltip;

  /// No description provided for @cardDeleteTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la carte'**
  String get cardDeleteTooltip;

  /// No description provided for @cardFrontLabel.
  ///
  /// In fr, this message translates to:
  /// **'Carte recto'**
  String get cardFrontLabel;

  /// No description provided for @cardBackLabel.
  ///
  /// In fr, this message translates to:
  /// **'Carte verso'**
  String get cardBackLabel;

  /// No description provided for @cardDetailEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get cardDetailEmailLabel;

  /// No description provided for @sectionActions.
  ///
  /// In fr, this message translates to:
  /// **'Actions'**
  String get sectionActions;

  /// No description provided for @actionCall.
  ///
  /// In fr, this message translates to:
  /// **'Appeler'**
  String get actionCall;

  /// No description provided for @actionSmsContact.
  ///
  /// In fr, this message translates to:
  /// **'SMS contact'**
  String get actionSmsContact;

  /// No description provided for @actionSendCardSms.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer fiche SMS'**
  String get actionSendCardSms;

  /// No description provided for @actionShareOzcard.
  ///
  /// In fr, this message translates to:
  /// **'Partager .ozcard'**
  String get actionShareOzcard;

  /// No description provided for @actionAddToContacts.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux contacts'**
  String get actionAddToContacts;

  /// No description provided for @actionGenerateQr.
  ///
  /// In fr, this message translates to:
  /// **'Générer un QR Code'**
  String get actionGenerateQr;

  /// No description provided for @cardImageTapHint.
  ///
  /// In fr, this message translates to:
  /// **'{label} — toucher pour afficher en paysage'**
  String cardImageTapHint(String label);

  /// No description provided for @imageCloseTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Fermer l’image'**
  String get imageCloseTooltip;

  /// No description provided for @sectionNotes.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get sectionNotes;

  /// No description provided for @cardAsTextHeader.
  ///
  /// In fr, this message translates to:
  /// **'Carte de visite — oz_carte2visite'**
  String get cardAsTextHeader;

  /// No description provided for @cardAsTextCompany.
  ///
  /// In fr, this message translates to:
  /// **'Entreprise : {value}'**
  String cardAsTextCompany(String value);

  /// No description provided for @cardAsTextName.
  ///
  /// In fr, this message translates to:
  /// **'Nom : {value}'**
  String cardAsTextName(String value);

  /// No description provided for @cardAsTextPhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone : {value}'**
  String cardAsTextPhone(String value);

  /// No description provided for @cardAsTextEmail.
  ///
  /// In fr, this message translates to:
  /// **'E-mail : {value}'**
  String cardAsTextEmail(String value);

  /// No description provided for @cardAsTextNotes.
  ///
  /// In fr, this message translates to:
  /// **'Notes : {value}'**
  String cardAsTextNotes(String value);

  /// No description provided for @settingsFilePickError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’accéder au fichier sélectionné.'**
  String get settingsFilePickError;

  /// No description provided for @settingsCardFolderMissing.
  ///
  /// In fr, this message translates to:
  /// **'Cette carte existe déjà, mais son classeur est introuvable.'**
  String get settingsCardFolderMissing;

  /// No description provided for @settingsCardAlreadySaved.
  ///
  /// In fr, this message translates to:
  /// **'Cette carte est déjà enregistrée sur votre téléphone.'**
  String get settingsCardAlreadySaved;

  /// No description provided for @settingsImportError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’importer ce fichier. Vérifiez qu’il s’agit bien d’une carte .ozcard.'**
  String get settingsImportError;

  /// No description provided for @settingsAddCardBeforeBackup.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez au moins une carte avant de créer une sauvegarde.'**
  String get settingsAddCardBeforeBackup;

  /// No description provided for @settingsBackupReady.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde compressée prête à être partagée.'**
  String get settingsBackupReady;

  /// No description provided for @settingsBackupError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de créer la sauvegarde.'**
  String get settingsBackupError;

  /// No description provided for @settingsRestoreReplaced.
  ///
  /// In fr, this message translates to:
  /// **'Restauration terminée : toutes les données ont été remplacées par les {count} carte(s) de la sauvegarde.'**
  String settingsRestoreReplaced(int count);

  /// No description provided for @settingsRestoreMerged.
  ///
  /// In fr, this message translates to:
  /// **'Restauration terminée : {added} carte(s) ajoutée(s), {existing} déjà présente(s), {folders} classeur(s) ajouté(s).'**
  String settingsRestoreMerged(int added, int existing, int folders);

  /// No description provided for @settingsRestoreError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de restaurer cette sauvegarde. Vérifiez le fichier .ozbackup.'**
  String get settingsRestoreError;

  /// No description provided for @settingsChooseRestoreModeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer cette sauvegarde'**
  String get settingsChooseRestoreModeTitle;

  /// No description provided for @settingsChooseRestoreModeBody.
  ///
  /// In fr, this message translates to:
  /// **'La sauvegarde contient {cards} carte(s) et {folders} classeur(s).\n\nFusionner : ajoute ce qui manque, sans toucher à vos données actuelles.\n\nRemplacer : efface toutes vos cartes et classeurs actuels, puis les remplace par ceux de la sauvegarde.'**
  String settingsChooseRestoreModeBody(int cards, int folders);

  /// No description provided for @settingsConfirmReplaceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Remplacer toutes les données ?'**
  String get settingsConfirmReplaceTitle;

  /// No description provided for @settingsConfirmReplaceBody.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible. Toutes vos cartes et classeurs actuels seront définitivement effacés et remplacés par les {cards} carte(s) et {folders} classeur(s) de la sauvegarde.'**
  String settingsConfirmReplaceBody(int cards, int folders);

  /// No description provided for @settingsExternalBackupDisabled.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde externe automatique désactivée.'**
  String get settingsExternalBackupDisabled;

  /// No description provided for @settingsAddCardBeforeExternal.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez au moins une carte avant d’activer la sauvegarde externe.'**
  String get settingsAddCardBeforeExternal;

  /// No description provided for @settingsChooseFolderFirst.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez d’abord un dossier de sauvegarde externe.'**
  String get settingsChooseFolderFirst;

  /// No description provided for @settingsExternalBackupActivated.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde externe activée : la première copie a été créée.'**
  String get settingsExternalBackupActivated;

  /// No description provided for @settingsExternalBackupActivateError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’activer la sauvegarde externe. Vérifiez le dossier choisi.'**
  String get settingsExternalBackupActivateError;

  /// No description provided for @settingsFolderSelected.
  ///
  /// In fr, this message translates to:
  /// **'Dossier « {name} » sélectionné. Activez ensuite la sauvegarde externe.'**
  String settingsFolderSelected(String name);

  /// No description provided for @settingsFolderSelectError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de sélectionner ce dossier.'**
  String get settingsFolderSelectError;

  /// No description provided for @settingsNoExternalFolder.
  ///
  /// In fr, this message translates to:
  /// **'Aucun dossier externe accessible. Sélectionnez un dossier de sauvegarde.'**
  String get settingsNoExternalFolder;

  /// No description provided for @settingsBackupVerified.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde vérifiée : {fileName} ({sizeKb} Ko) est présent dans « {folderName} ».'**
  String settingsBackupVerified(String fileName, int sizeKb, String folderName);

  /// No description provided for @settingsSelectedFolderFallback.
  ///
  /// In fr, this message translates to:
  /// **'le dossier sélectionné'**
  String get settingsSelectedFolderFallback;

  /// No description provided for @settingsNoBackupThisWeek.
  ///
  /// In fr, this message translates to:
  /// **'Dossier externe accessible, mais aucune copie n’a encore été créée cette semaine.'**
  String get settingsNoBackupThisWeek;

  /// No description provided for @settingsCheckExternalError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de vérifier le dossier externe. Vérifiez son accès dans Android.'**
  String get settingsCheckExternalError;

  /// No description provided for @settingsDisplayModeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mode d’affichage'**
  String get settingsDisplayModeTitle;

  /// No description provided for @settingsThemeAutoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Automatique'**
  String get settingsThemeAutoTitle;

  /// No description provided for @settingsThemeAutoDetail.
  ///
  /// In fr, this message translates to:
  /// **'Utilise le réglage du téléphone.'**
  String get settingsThemeAutoDetail;

  /// No description provided for @settingsThemeLightTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mode clair'**
  String get settingsThemeLightTitle;

  /// No description provided for @settingsThemeLightDetail.
  ///
  /// In fr, this message translates to:
  /// **'Affichage lumineux.'**
  String get settingsThemeLightDetail;

  /// No description provided for @settingsThemeDarkTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mode sombre'**
  String get settingsThemeDarkTitle;

  /// No description provided for @settingsThemeDarkDetail.
  ///
  /// In fr, this message translates to:
  /// **'Affichage sombre.'**
  String get settingsThemeDarkDetail;

  /// No description provided for @settingsAppThemeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Thème de l’application'**
  String get settingsAppThemeTitle;

  /// No description provided for @settingsAutoCloseEnabled.
  ///
  /// In fr, this message translates to:
  /// **'Fermeture automatique activée après 3 minutes d’inactivité.'**
  String get settingsAutoCloseEnabled;

  /// No description provided for @settingsAutoCloseDisabled.
  ///
  /// In fr, this message translates to:
  /// **'Fermeture automatique désactivée.'**
  String get settingsAutoCloseDisabled;

  /// No description provided for @settingsNoticeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notice d’emploi'**
  String get settingsNoticeTitle;

  /// No description provided for @settingsNoticeBody.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans oz_carte2visite.\n\n1. CLASSEURS\nL’écran « Mes classeurs » affiche vos catégories de cartes. Ouvrez un classeur pour consulter les cartes qu’il contient. Vous pouvez créer un nouveau classeur. Un classeur ne peut être supprimé que lorsqu’il est vide. La couleur de chaque classeur se personnalise depuis Réglages → Couleurs des classeurs.\n\n2. AJOUTER UNE CARTE\nOuvrez un classeur puis touchez « Ajouter une carte ». Prenez une photo ou sélectionnez l’image recto de la carte. Vous pouvez aussi ajouter une image verso. Avec la formule Sans publicité, limitée à une carte, l’impossibilité d’en ajouter une deuxième est signalée dès ce bouton, avant même d’ouvrir l’écran de création.\n\n3. RECONNAISSANCE AUTOMATIQUE\nL’application optimise l’image, détecte le texte et recherche un QR Code, puis tente de remplir directement les champs entreprise, nom, téléphone, e-mail et notes. Le nom de l’entreprise est repéré au texte le plus grand et le plus souvent en majuscules sur la carte ; le nom du titulaire est recherché en le rapprochant de l’adresse e-mail détectée quand c’est possible. Si la photo et le QR Code donnent des valeurs différentes pour un même champ, les deux sont affichées à la suite, séparées par « / », pour que vous corrigiez vous-même. Vérifiez toujours les informations avant d’enregistrer.\n\n4. QR CODE\nUn QR Code au format vCard standard (celui que génère aussi cette application) remplit directement les champs de la carte. Pour un autre format, les mêmes règles que la reconnaissance de texte s’appliquent au contenu du QR Code ; si rien d’exploitable n’est trouvé, le texte brut est ajouté aux notes.\n\n5. CONSULTER UNE CARTE\nTouchez une carte pour ouvrir sa fiche. Touchez une image recto ou verso pour l’afficher en grand format paysage. Trois zones d’actions sont proposées : Prendre contact (appeler, SMS, e-mail, WhatsApp), Transférer (envoyer la fiche par SMS ou e-mail, la partager en .ozcard, générer un QR Code — réservé à la formule Premium), et Autres (ajouter la carte aux contacts Android).\n\n6. PARTAGER ET IMPORTER\nUtilisez « Partager .ozcard », réservé à la formule Premium, pour envoyer une carte avec ses images. Pour recevoir une carte, ouvrez Réglages puis « Importer une carte .ozcard » et choisissez son classeur — l’import reste disponible quelle que soit la formule.\n\n7. SAUVEGARDES ET TRANSMISSION\nLes données sont sauvegardées localement après chaque modification. Depuis les réglages, réservés à la formule Premium, vous pouvez exporter une sauvegarde complète .ozbackup, la partager, puis la restaurer sur un autre téléphone — la restauration ajoute les cartes et classeurs absents sans écraser ceux qui existent déjà. « Transmettre des classeurs » permet, elle, de choisir uniquement certains classeurs avant l’envoi, plutôt que la totalité de la base : le fichier produit se restaure exactement de la même façon, mais son nom et sa description précisent qu’il ne s’agit pas d’une sauvegarde complète.\n\n8. SAUVEGARDE EXTERNE\nSi votre formule le permet, choisissez un dossier local ou cloud dans les réglages. Une première copie est créée lors de l’activation, puis une seule copie externe figée est créée par semaine lors de la première modification. Les sept dernières copies externes sont conservées.\n\n9. FORMULES\nSans publicité : une carte maximum.\nAvec publicité : cartes illimitées, sans possibilité de transférer ou d’exporter une carte, avec annonces au démarrage et au retour au premier plan. Le passage de Sans publicité vers Avec publicité se fait depuis Réglages — ce changement est définitif, sans retour possible vers Sans publicité.\nPremium : cartes illimitées, sans publicité, avec accès aux réglages et au transfert de cartes. Premium s’obtient par abonnement annuel via Google Play, depuis Réglages → Abonnement Premium. En cas de réinstallation ou de changement de téléphone, le bouton « Restaurer mes achats » du même écran retrouve un abonnement déjà actif, sans nouveau paiement.\n\n10. FERMETURE AUTOMATIQUE\nL’application peut passer en arrière-plan après trois minutes sans activité. Ce mécanisme ne s’applique jamais pendant la création ou la modification d’une carte.'**
  String get settingsNoticeBody;

  /// No description provided for @settingsLegalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mentions légales et confidentialité'**
  String get settingsLegalTitle;

  /// No description provided for @settingsLegalBody.
  ///
  /// In fr, this message translates to:
  /// **'ÉDITEUR\nOz-WEB\nChristophe VIDAL — Micro-entrepreneur\nDéveloppeur Web & Webmaster\nE-mail : oz-vitrine@gmail.com\nSIRET : 528 401 391 00016\n\nCOPYRIGHT\nCopyright © 2025 Oz-WEB — Christophe VIDAL. Tous droits réservés.\n\nOBJET DE L’APPLICATION\noz_carte2visite permet de numériser, organiser, exporter, importer et sauvegarder des cartes de visite.\n\nDONNÉES TRAITÉES\nL’application peut traiter les informations présentes sur les cartes : nom, entreprise, téléphone, e-mail, notes, contenu de QR Code et photographies recto/verso.\n\nSTOCKAGE LOCAL\nPar défaut, les cartes, images et paramètres sont stockés localement sur votre appareil. Les images sont enregistrées dans le répertoire privé de l’application afin de limiter leur suppression accidentelle.\n\nPARTAGE ET SAUVEGARDE EXTERNE\nAucune donnée n’est envoyée vers un service externe sans action ou activation explicite de l’utilisateur. Lors d’un partage, export ou d’une sauvegarde externe, vous choisissez vous-même le destinataire ou le dossier. Vous êtes responsable de la sécurité des fichiers et services tiers choisis.\n\nAUTORISATIONS\nCaméra : photographier les cartes.\nPhotos et fichiers : sélectionner, importer et exporter des images ou sauvegardes.\nContacts : ajouter volontairement une fiche au répertoire Android.\nInternet : charger des annonces uniquement avec la formule Avec publicité.\n\nOCR ET QR CODES\nLa reconnaissance de texte et la lecture de QR Codes sont réalisées par les composants installés sur l’appareil. Vous devez vérifier les informations proposées avant de valider une carte.\n\nPUBLICITÉS\nLa formule Avec publicité peut afficher des annonces Google AdMob à l’ouverture ou au retour de l’application au premier plan. Google AdMob peut traiter des informations techniques selon sa propre politique de confidentialité. La formule Premium ne contient aucune publicité.\n\nABONNEMENT PREMIUM\nL’abonnement Premium annuel de 10 € sera géré par Google Play. Les données de paiement sont traitées par Google et ne sont pas collectées ni conservées par Oz-WEB.\n\nDURÉE DE CONSERVATION ET SUPPRESSION\nVos données restent sur votre appareil aussi longtemps que vous les conservez. Vous pouvez supprimer une carte ou un classeur depuis l’application. La désinstallation peut supprimer les données locales ; les sauvegardes externes restent sous votre contrôle.\n\nRESPONSABILITÉ\nVous devez disposer du droit de photographier, enregistrer et partager les données figurant sur les cartes de visite.\n\nVOS DROITS\nVous pouvez consulter, corriger, exporter ou supprimer vos données directement depuis l’application. Pour toute question sur la confidentialité : oz-vitrine@gmail.com.\n\nMISE À JOUR\nDernière mise à jour : 8 mars 2025.'**
  String get settingsLegalBody;

  /// No description provided for @settingsConfirmMergeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer cette sauvegarde ?'**
  String get settingsConfirmMergeTitle;

  /// No description provided for @settingsConfirmMergeBody.
  ///
  /// In fr, this message translates to:
  /// **'La sauvegarde contient {cards} carte(s) et {folders} classeur(s).\n\nLes cartes et classeurs déjà présents sur ce téléphone ne seront pas remplacés.'**
  String settingsConfirmMergeBody(int cards, int folders);

  /// No description provided for @settingsThisCardFallback.
  ///
  /// In fr, this message translates to:
  /// **'Cette carte'**
  String get settingsThisCardFallback;

  /// No description provided for @settingsCardAlreadySavedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Carte déjà enregistrée'**
  String get settingsCardAlreadySavedTitle;

  /// No description provided for @settingsCardAlreadySavedBody.
  ///
  /// In fr, this message translates to:
  /// **'« {name} » est déjà présente dans le classeur « {folder} ».\n\nAucun doublon ne sera créé. Souhaitez-vous ouvrir ce classeur ?'**
  String settingsCardAlreadySavedBody(String name, String folder);

  /// No description provided for @settingsChooseFolderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir le classeur'**
  String get settingsChooseFolderTitle;

  /// No description provided for @settingsChooseFolderBody.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez le classeur de destination de cette carte.'**
  String get settingsChooseFolderBody;

  /// No description provided for @settingsCreateNewFolder.
  ///
  /// In fr, this message translates to:
  /// **'Créer un nouveau classeur'**
  String get settingsCreateNewFolder;

  /// No description provided for @settingsFolderNameTaken.
  ///
  /// In fr, this message translates to:
  /// **'Un classeur portant ce nom existe déjà.'**
  String get settingsFolderNameTaken;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// No description provided for @settingsLockedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres verrouillés'**
  String get settingsLockedTitle;

  /// No description provided for @settingsLockedBody.
  ///
  /// In fr, this message translates to:
  /// **'Les réglages sont disponibles avec la licence Premium.'**
  String get settingsLockedBody;

  /// No description provided for @settingsSectionImport.
  ///
  /// In fr, this message translates to:
  /// **'Import et partage'**
  String get settingsSectionImport;

  /// No description provided for @settingsImportCardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Importer une carte .ozcard'**
  String get settingsImportCardTitle;

  /// No description provided for @settingsImportCardSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez une carte reçue puis choisissez son classeur.'**
  String get settingsImportCardSubtitle;

  /// No description provided for @settingsSectionDbBackup.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde de la base'**
  String get settingsSectionDbBackup;

  /// No description provided for @settingsExportBackupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Exporter la sauvegarde'**
  String get settingsExportBackupTitle;

  /// No description provided for @settingsExportBackupSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Archive .ozbackup compressée avec cartes, classeurs et images.'**
  String get settingsExportBackupSubtitle;

  /// No description provided for @settingsRestoreBackupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer une sauvegarde'**
  String get settingsRestoreBackupTitle;

  /// No description provided for @settingsRestoreBackupSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute uniquement les cartes et classeurs absents.'**
  String get settingsRestoreBackupSubtitle;

  /// No description provided for @settingsSectionExternalBackup.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde externe hebdomadaire'**
  String get settingsSectionExternalBackup;

  /// No description provided for @settingsExternalToggleTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde externe automatique'**
  String get settingsExternalToggleTitle;

  /// No description provided for @settingsExternalToggleOn.
  ///
  /// In fr, this message translates to:
  /// **'Active : une copie figée est créée au maximum une fois par semaine.'**
  String get settingsExternalToggleOn;

  /// No description provided for @settingsExternalToggleOff.
  ///
  /// In fr, this message translates to:
  /// **'Inactive. Son activation crée immédiatement la première copie.'**
  String get settingsExternalToggleOff;

  /// No description provided for @settingsChooseFolderMenuTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir le dossier de sauvegarde'**
  String get settingsChooseFolderMenuTitle;

  /// No description provided for @settingsNoFolderSelected.
  ///
  /// In fr, this message translates to:
  /// **'Aucun dossier sélectionné.'**
  String get settingsNoFolderSelected;

  /// No description provided for @settingsCurrentFolder.
  ///
  /// In fr, this message translates to:
  /// **'Dossier actuel : {name}'**
  String settingsCurrentFolder(String name);

  /// No description provided for @settingsCheckExternalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier la sauvegarde externe'**
  String get settingsCheckExternalTitle;

  /// No description provided for @settingsCheckExternalSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérifie l’accès au dossier sans créer de nouvelle copie.'**
  String get settingsCheckExternalSubtitle;

  /// No description provided for @settingsExternalFootnote.
  ///
  /// In fr, this message translates to:
  /// **'La sauvegarde locale est mise à jour après chaque modification. Après activation, une première copie externe est créée immédiatement. Ensuite, une seule copie externe figée est créée à la première modification de chaque nouvelle semaine. Les sept dernières copies externes sont conservées.'**
  String get settingsExternalFootnote;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsThemeMenuTitle.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get settingsThemeMenuTitle;

  /// No description provided for @settingsSectionBehavior.
  ///
  /// In fr, this message translates to:
  /// **'Fonctionnement'**
  String get settingsSectionBehavior;

  /// No description provided for @settingsAutoCloseTitle.
  ///
  /// In fr, this message translates to:
  /// **'Fermeture automatique'**
  String get settingsAutoCloseTitle;

  /// No description provided for @settingsAutoCloseSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ferme l’application après 3 minutes d’inactivité, sauf pendant la création ou la modification d’une fiche.'**
  String get settingsAutoCloseSubtitle;

  /// No description provided for @settingsSectionPrivacy.
  ///
  /// In fr, this message translates to:
  /// **'Confidentialité'**
  String get settingsSectionPrivacy;

  /// No description provided for @settingsPersonalizedAdsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Publicité personnalisée'**
  String get settingsPersonalizedAdsTitle;

  /// No description provided for @settingsPersonalizedAdsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifiez à tout moment votre choix concernant les publicités personnalisées.'**
  String get settingsPersonalizedAdsSubtitle;

  /// No description provided for @settingsSectionInfo.
  ///
  /// In fr, this message translates to:
  /// **'Informations'**
  String get settingsSectionInfo;

  /// No description provided for @settingsPersonalLicenseTitle.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement Premium'**
  String get settingsPersonalLicenseTitle;

  /// No description provided for @settingsPersonalLicenseSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'S’abonner ou restaurer un abonnement Google Play.'**
  String get settingsPersonalLicenseSubtitle;

  /// No description provided for @settingsLegalMenuTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mentions légales et licence'**
  String get settingsLegalMenuTitle;

  /// No description provided for @licenseTitle.
  ///
  /// In fr, this message translates to:
  /// **'Licence personnelle'**
  String get licenseTitle;

  /// No description provided for @licenseNoneActive.
  ///
  /// In fr, this message translates to:
  /// **'Aucun abonnement actif'**
  String get licenseNoneActive;

  /// No description provided for @licenseImportHint.
  ///
  /// In fr, this message translates to:
  /// **'Abonnez-vous pour débloquer les réglages et le transfert de cartes.'**
  String get licenseImportHint;

  /// No description provided for @editCardOcrDetected.
  ///
  /// In fr, this message translates to:
  /// **'Texte détecté. Vérifiez et corrigez les informations proposées.'**
  String get editCardOcrDetected;

  /// No description provided for @editCardQrDetected.
  ///
  /// In fr, this message translates to:
  /// **'Le contenu du QR Code a été ajouté aux notes.'**
  String get editCardQrDetected;

  /// No description provided for @editCardMissingImage.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez d’abord une image recto ou verso.'**
  String get editCardMissingImage;

  /// No description provided for @editCardMissingNameOrCompany.
  ///
  /// In fr, this message translates to:
  /// **'Renseignez au minimum une entreprise ou un nom.'**
  String get editCardMissingNameOrCompany;

  /// No description provided for @editCardPlanLimited.
  ///
  /// In fr, this message translates to:
  /// **'La formule Sans publicité est limitée à une seule carte. Choisissez la formule Avec publicité ou Premium pour ajouter d’autres cartes.'**
  String get editCardPlanLimited;

  /// No description provided for @editCardAddTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une carte'**
  String get editCardAddTitle;

  /// No description provided for @editCardEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la carte'**
  String get editCardEditTitle;

  /// No description provided for @editCardImagesSection.
  ///
  /// In fr, this message translates to:
  /// **'Images de la carte'**
  String get editCardImagesSection;

  /// No description provided for @editCardFront.
  ///
  /// In fr, this message translates to:
  /// **'Recto'**
  String get editCardFront;

  /// No description provided for @editCardBack.
  ///
  /// In fr, this message translates to:
  /// **'Verso'**
  String get editCardBack;

  /// No description provided for @editCardSearchQr.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un QR Code dans les images'**
  String get editCardSearchQr;

  /// No description provided for @editCardAnalyzing.
  ///
  /// In fr, this message translates to:
  /// **'Optimisation et analyse en cours…'**
  String get editCardAnalyzing;

  /// No description provided for @editCardInfoSection.
  ///
  /// In fr, this message translates to:
  /// **'Informations de la carte'**
  String get editCardInfoSection;

  /// No description provided for @editCardInvalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail invalide.'**
  String get editCardInvalidEmail;

  /// No description provided for @editCardSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer la carte'**
  String get editCardSave;

  /// No description provided for @editCardAddImage.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter l’image {label}'**
  String editCardAddImage(String label);

  /// No description provided for @settingsFolderColorsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Couleurs des classeurs'**
  String get settingsFolderColorsTitle;

  /// No description provided for @settingsFolderColorsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Personnaliser la couleur de chaque classeur'**
  String get settingsFolderColorsSubtitle;

  /// No description provided for @consentRequiredTitle.
  ///
  /// In fr, this message translates to:
  /// **'Publicité non autorisée'**
  String get consentRequiredTitle;

  /// No description provided for @consentRequiredBody.
  ///
  /// In fr, this message translates to:
  /// **'La formule Avec publicité nécessite votre consentement pour afficher des publicités. Sans ce consentement, cette formule ne peut pas fonctionner : revoyez votre consentement, ou passez à la formule Sans publicité.'**
  String get consentRequiredBody;

  /// No description provided for @premiumRequiredMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette fonctionnalité est réservée à la formule Premium.'**
  String get premiumRequiredMessage;

  /// No description provided for @actionReviewConsent.
  ///
  /// In fr, this message translates to:
  /// **'Revoir mon consentement'**
  String get actionReviewConsent;

  /// No description provided for @actionSwitchToFreePlan.
  ///
  /// In fr, this message translates to:
  /// **'Passer à Sans publicité (1 carte)'**
  String get actionSwitchToFreePlan;

  /// No description provided for @settingsCurrentPlanTitle.
  ///
  /// In fr, this message translates to:
  /// **'Formule actuelle'**
  String get settingsCurrentPlanTitle;

  /// No description provided for @settingsPlanFreeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Sans publicité — 1 carte'**
  String get settingsPlanFreeLabel;

  /// No description provided for @settingsPlanAdsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Avec publicité — illimité, sans partage'**
  String get settingsPlanAdsLabel;

  /// No description provided for @settingsPlanPremiumLabel.
  ///
  /// In fr, this message translates to:
  /// **'Premium — illimité sans publicité'**
  String get settingsPlanPremiumLabel;

  /// No description provided for @settingsSwitchToAdsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Passer à Avec publicité ?'**
  String get settingsSwitchToAdsTitle;

  /// No description provided for @settingsSwitchToAdsBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous pourrez créer un nombre illimité de cartes. Des publicités s’afficheront à l’ouverture et au retour de l’application. Ce changement n’est pas réversible : il ne sera plus possible de revenir à la formule Sans publicité.'**
  String get settingsSwitchToAdsBody;

  /// No description provided for @actionConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get actionConfirm;

  /// No description provided for @settingsPlanChanged.
  ///
  /// In fr, this message translates to:
  /// **'Formule mise à jour.'**
  String get settingsPlanChanged;

  /// No description provided for @settingsConsentNeededForAdsBody.
  ///
  /// In fr, this message translates to:
  /// **'La formule Avec publicité nécessite votre consentement. Revoyez votre consentement pour continuer.'**
  String get settingsConsentNeededForAdsBody;

  /// No description provided for @settingsConsentStillMissing.
  ///
  /// In fr, this message translates to:
  /// **'Le consentement n’a pas été accordé. La formule reste Sans publicité.'**
  String get settingsConsentStillMissing;

  /// No description provided for @cardSectionContact.
  ///
  /// In fr, this message translates to:
  /// **'Prendre contact'**
  String get cardSectionContact;

  /// No description provided for @cardSectionTransfer.
  ///
  /// In fr, this message translates to:
  /// **'Transférer'**
  String get cardSectionTransfer;

  /// No description provided for @cardSectionOther.
  ///
  /// In fr, this message translates to:
  /// **'Autres'**
  String get cardSectionOther;

  /// No description provided for @actionWhatsApp.
  ///
  /// In fr, this message translates to:
  /// **'WhatsApp'**
  String get actionWhatsApp;

  /// No description provided for @actionSendCardEmail.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer par e-mail'**
  String get actionSendCardEmail;

  /// No description provided for @cardWhatsAppError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’ouvrir WhatsApp.'**
  String get cardWhatsAppError;

  /// No description provided for @licensePlayBillingActive.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement Google Play actif'**
  String get licensePlayBillingActive;

  /// No description provided for @licensePlayBillingSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Géré depuis Google Play (Play Store → Abonnements).'**
  String get licensePlayBillingSubtitle;

  /// No description provided for @licenseSubscribeButton.
  ///
  /// In fr, this message translates to:
  /// **'S’abonner — {price} par an'**
  String licenseSubscribeButton(String price);

  /// No description provided for @licenseProductUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement indisponible pour le moment.'**
  String get licenseProductUnavailable;

  /// No description provided for @licenseRestoreButton.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer mes achats'**
  String get licenseRestoreButton;

  /// No description provided for @licenseRestoreDone.
  ///
  /// In fr, this message translates to:
  /// **'Vérification terminée.'**
  String get licenseRestoreDone;

  /// No description provided for @licensePurchaseError.
  ///
  /// In fr, this message translates to:
  /// **'Achat impossible pour le moment.'**
  String get licensePurchaseError;

  /// No description provided for @licenseOrDivider.
  ///
  /// In fr, this message translates to:
  /// **'ou'**
  String get licenseOrDivider;

  /// No description provided for @settingsTransmitFoldersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Transmettre des classeurs'**
  String get settingsTransmitFoldersTitle;

  /// No description provided for @settingsTransmitFoldersSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir les classeurs à inclure avant l’envoi.'**
  String get settingsTransmitFoldersSubtitle;

  /// No description provided for @settingsSelectFoldersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Classeurs à transmettre'**
  String get settingsSelectFoldersTitle;

  /// No description provided for @actionValidate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get actionValidate;

  /// No description provided for @settingsTransmitEmptyFolders.
  ///
  /// In fr, this message translates to:
  /// **'Les classeurs sélectionnés ne contiennent aucune carte.'**
  String get settingsTransmitEmptyFolders;

  /// No description provided for @settingsTransmitReady.
  ///
  /// In fr, this message translates to:
  /// **'Fichier prêt à être transmis.'**
  String get settingsTransmitReady;

  /// No description provided for @settingsTransmitError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de préparer cette transmission.'**
  String get settingsTransmitError;

  /// No description provided for @settingsTransmitShareSubject.
  ///
  /// In fr, this message translates to:
  /// **'Classeurs transmis depuis oz_carte2visite'**
  String get settingsTransmitShareSubject;

  /// No description provided for @settingsTransmitShareText.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Sélection de 1 classeur — ce n’est pas une sauvegarde complète.} other{Sélection de {count} classeurs — ce n’est pas une sauvegarde complète.}}'**
  String settingsTransmitShareText(int count);

  /// No description provided for @folderKindTitle.
  ///
  /// In fr, this message translates to:
  /// **'Type de classeur'**
  String get folderKindTitle;

  /// No description provided for @folderKindBusinessCard.
  ///
  /// In fr, this message translates to:
  /// **'Cartes de visite'**
  String get folderKindBusinessCard;

  /// No description provided for @folderKindBusinessCardDetail.
  ///
  /// In fr, this message translates to:
  /// **'Reconnaissance automatique, transfert et export possibles.'**
  String get folderKindBusinessCardDetail;

  /// No description provided for @folderKindSubscription.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement'**
  String get folderKindSubscription;

  /// No description provided for @folderKindSubscriptionDetail.
  ///
  /// In fr, this message translates to:
  /// **'Photo et code scanné. Non transférable, inclus dans les sauvegardes.'**
  String get folderKindSubscriptionDetail;

  /// No description provided for @folderKindDiscount.
  ///
  /// In fr, this message translates to:
  /// **'Cartes de fidélité'**
  String get folderKindDiscount;

  /// No description provided for @folderKindDiscountDetail.
  ///
  /// In fr, this message translates to:
  /// **'Photo et code scanné. Non transférable, inclus dans les sauvegardes.'**
  String get folderKindDiscountDetail;

  /// No description provided for @settingsSectionFolderKinds.
  ///
  /// In fr, this message translates to:
  /// **'Types de classeurs'**
  String get settingsSectionFolderKinds;

  /// No description provided for @settingsFolderKindToggleSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Proposer ce type lors de la création d’un classeur.'**
  String get settingsFolderKindToggleSubtitle;

  /// No description provided for @settingsFolderKindPremiumOnly.
  ///
  /// In fr, this message translates to:
  /// **'Réservé à Premium.'**
  String get settingsFolderKindPremiumOnly;

  /// No description provided for @cardTransferNotAllowed.
  ///
  /// In fr, this message translates to:
  /// **'Les cartes de ce classeur ne peuvent pas être transmises.'**
  String get cardTransferNotAllowed;

  /// No description provided for @fieldMerchant.
  ///
  /// In fr, this message translates to:
  /// **'Commerce'**
  String get fieldMerchant;

  /// No description provided for @fieldClub.
  ///
  /// In fr, this message translates to:
  /// **'Club'**
  String get fieldClub;

  /// No description provided for @settingsVersionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Version'**
  String get settingsVersionTitle;

  /// No description provided for @settingsVersionSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'{version} — mis à jour le {date}'**
  String settingsVersionSubtitle(String version, String date);

  /// No description provided for @commonLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement…'**
  String get commonLoading;

  /// No description provided for @settingsChangelogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveautés'**
  String get settingsChangelogTitle;

  /// No description provided for @settingsChangelogSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Historique des versions et des évolutions.'**
  String get settingsChangelogSubtitle;

  /// No description provided for @settingsChangelogError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’ouvrir cette page.'**
  String get settingsChangelogError;

  /// No description provided for @fieldExpirationDate.
  ///
  /// In fr, this message translates to:
  /// **'Date d’expiration'**
  String get fieldExpirationDate;

  /// No description provided for @fieldExpirationDateEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Non renseignée'**
  String get fieldExpirationDateEmpty;

  /// No description provided for @homeExpiringSubscriptionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Abonnements à renouveler'**
  String get homeExpiringSubscriptionsTitle;

  /// No description provided for @homeExpiringSubscriptionDate.
  ///
  /// In fr, this message translates to:
  /// **'Expire le {date}'**
  String homeExpiringSubscriptionDate(String date);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
