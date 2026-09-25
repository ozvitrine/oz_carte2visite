// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'oz_carte2visite';

  @override
  String get languageScreenTitle => 'Choose your language';

  @override
  String get languageScreenSubtitle =>
      'You can change this setting later, from the app preferences.';

  @override
  String get languageOptionFrench => 'Français';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String get languageScreenContinue => 'Continue';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionCreate => 'Create';

  @override
  String get actionRename => 'Rename';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionReset => 'Reset';

  @override
  String get actionReplace => 'Replace';

  @override
  String get actionMerge => 'Merge';

  @override
  String get actionReplaceAll => 'Replace everything';

  @override
  String get actionRestore => 'Restore';

  @override
  String get actionStayHere => 'Stay here';

  @override
  String get actionOpenFolder => 'Open folder';

  @override
  String get actionImport => 'Import';

  @override
  String get actionClose => 'Close';

  @override
  String get actionRemove => 'Remove';

  @override
  String get fieldCompany => 'Company';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldPhone => 'Phone';

  @override
  String get fieldEmail => 'Email address';

  @override
  String get fieldNotes => 'Notes';

  @override
  String get fieldFolder => 'Folder';

  @override
  String get onboardingTakePhoto => 'Take a photo';

  @override
  String get onboardingChooseImage => 'Choose an image';

  @override
  String get onboardingImageError => 'Unable to process this image.';

  @override
  String get onboardingOcrDetected =>
      'Text detected. Check the suggestions before confirming.';

  @override
  String get onboardingOcrFailed => 'The text in this image could not be read.';

  @override
  String get onboardingQrDetected =>
      'QR code detected: its content was added to the notes.';

  @override
  String get onboardingMissingFrontPhoto =>
      'First add a front photo of your card.';

  @override
  String get onboardingMissingNameOrCompany =>
      'Check or fill in at least the name or the company.';

  @override
  String get onboardingLegalTitle => 'Legal notice';

  @override
  String get onboardingLegalBody =>
      'Your cards are stored on your device. Photos, backups and shares are only triggered at your request.\n\nCopyright © 2025 oz_carte2visite.';

  @override
  String get onboardingLegalAccept => 'I accept and continue';

  @override
  String get onboardingPlanTitle => 'Choose your plan';

  @override
  String get onboardingPlanSubtitle =>
      'You can switch to Premium once Google Play subscriptions are set up.';

  @override
  String get onboardingPlanFreeTitle => 'No ads';

  @override
  String get onboardingPlanFreeDetail =>
      'One business card only. Settings locked.';

  @override
  String get onboardingPlanAdsTitle => 'With ads';

  @override
  String get onboardingPlanAdsDetail =>
      'Unlimited cards. Ads appear after the first card, then when the app returns to the foreground. Settings and card sharing are locked.';

  @override
  String get onboardingPremiumTitle => 'Premium — €10 per year';

  @override
  String get onboardingPremiumDetail =>
      'Unlimited cards, no ads, and access to settings. Coming soon via Google Play.';

  @override
  String get onboardingPlanValidate => 'Confirm plan';

  @override
  String get onboardingPhotoStepTitle => 'Photograph your first card';

  @override
  String get onboardingPhotoStepSubtitle =>
      'Images are optimized to stay legible while keeping backups and shares small.';

  @override
  String get onboardingFrontPhotoLabel => 'Front photo';

  @override
  String get onboardingBackPhotoLabel => 'Back photo — optional';

  @override
  String get onboardingAnalyzing => 'Optimizing and analyzing the image…';

  @override
  String get onboardingDetectedInfoTitle =>
      'Detected information — edit if needed';

  @override
  String get onboardingValidateCard => 'Save my card';

  @override
  String get homeTitle => 'My folders';

  @override
  String get homeExportAllTooltip => 'Export all folders as PDF';

  @override
  String get homeSettingsTooltip => 'Settings';

  @override
  String get homeNewFolderTitle => 'New folder';

  @override
  String get homeFolderNameLabel => 'Folder name';

  @override
  String homeFolderNameTaken(String name) {
    return 'A folder named “$name” already exists.';
  }

  @override
  String homeFolderCreated(String name) {
    return 'Folder “$name” created.';
  }

  @override
  String get homeRenameFolderTitle => 'Rename folder';

  @override
  String homeFolderRenamed(String name) {
    return 'Folder renamed to “$name”.';
  }

  @override
  String get homeFolderColorTitle => 'Folder color';

  @override
  String get homeFolderColorTooltip => 'Folder color';

  @override
  String get homeRenameFolderTooltip => 'Rename folder';

  @override
  String get homeAddCardBeforeExport =>
      'Add at least one card before exporting to PDF.';

  @override
  String get homeGlobalPdfReady =>
      'The combined PDF is ready to save or share.';

  @override
  String get homeGlobalPdfError => 'Unable to generate the combined PDF.';

  @override
  String homeCardCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards',
      one: '1 card',
    );
    return '$_temp0';
  }

  @override
  String get folderDeleteDefaultBlocked =>
      'This default folder cannot be deleted.';

  @override
  String get folderDeleteNotEmpty =>
      'This folder still contains cards and cannot be deleted.';

  @override
  String get folderDeleteConfirmTitle => 'Delete this folder?';

  @override
  String folderDeleteConfirmBody(String name) {
    return 'The “$name” folder is empty. Do you really want to delete it?';
  }

  @override
  String get folderDeleteFailed => 'This folder cannot be deleted.';

  @override
  String get folderPdfReady => 'The PDF is ready to save or share.';

  @override
  String get folderPdfError => 'Unable to generate the PDF.';

  @override
  String get folderDestinationNotFound =>
      'The chosen folder could not be found.';

  @override
  String get folderExportTooltip => 'Export folder as PDF';

  @override
  String get folderDeleteTooltip => 'Delete folder';

  @override
  String get folderAllLetter => 'All';

  @override
  String get folderAddCardLabel => 'Add a card';

  @override
  String folderEmptyDefault(String name) {
    return 'The “$name” folder does not contain any cards yet.';
  }

  @override
  String folderEmptyLetter(String letter) {
    return 'No card starts with the letter $letter.';
  }

  @override
  String get cardDetailGone => 'This card no longer exists.';

  @override
  String get cardLinkOpenError => 'Unable to open this link.';

  @override
  String get cardPhoneAppError => 'Unable to open the phone app.';

  @override
  String cardEmailSubject(String name) {
    return 'Hello $name';
  }

  @override
  String get cardEmailAppError => 'Unable to open your email app.';

  @override
  String get cardSmsAppError => 'Unable to open your SMS app.';

  @override
  String get cardShareOzcardReady => 'The .ozcard file is ready to share.';

  @override
  String get cardShareOzcardError => 'Unable to share this card.';

  @override
  String get cardContactSaved => 'Contact saved to the Android address book.';

  @override
  String get cardContactPermissionNeeded =>
      'Contacts permission is required to save this card.';

  @override
  String get cardContactSaveError => 'Unable to save this contact.';

  @override
  String get cardDeleteConfirmTitle => 'Delete this card?';

  @override
  String get cardDeleteConfirmBody =>
      'The card and its information will be removed from the app.';

  @override
  String get cardQrDialogTitle => 'QR code for your card';

  @override
  String get cardQrScanHintNoTitle => 'Scannable with any camera app.';

  @override
  String cardQrScanHintWithTitle(String title) {
    return '$title — scannable with any camera app.';
  }

  @override
  String get cardDefaultTitle => 'Business card';

  @override
  String get cardEditTooltip => 'Edit card';

  @override
  String get cardDeleteTooltip => 'Delete card';

  @override
  String get cardFrontLabel => 'Card front';

  @override
  String get cardBackLabel => 'Card back';

  @override
  String get cardDetailEmailLabel => 'Email';

  @override
  String get sectionActions => 'Actions';

  @override
  String get actionCall => 'Call';

  @override
  String get actionSmsContact => 'Text contact';

  @override
  String get actionSendCardSms => 'Send card by SMS';

  @override
  String get actionShareOzcard => 'Share .ozcard';

  @override
  String get actionAddToContacts => 'Add to contacts';

  @override
  String get actionGenerateQr => 'Generate QR code';

  @override
  String cardImageTapHint(String label) {
    return '$label — tap to view in landscape';
  }

  @override
  String get imageCloseTooltip => 'Close image';

  @override
  String get sectionNotes => 'Notes';

  @override
  String get cardAsTextHeader => 'Business card — oz_carte2visite';

  @override
  String cardAsTextCompany(String value) {
    return 'Company: $value';
  }

  @override
  String cardAsTextName(String value) {
    return 'Name: $value';
  }

  @override
  String cardAsTextPhone(String value) {
    return 'Phone: $value';
  }

  @override
  String cardAsTextEmail(String value) {
    return 'Email: $value';
  }

  @override
  String cardAsTextNotes(String value) {
    return 'Notes: $value';
  }

  @override
  String get settingsFilePickError => 'Unable to access the selected file.';

  @override
  String get settingsCardFolderMissing =>
      'This card already exists, but its folder could not be found.';

  @override
  String get settingsCardAlreadySaved =>
      'This card is already saved on your phone.';

  @override
  String get settingsImportError =>
      'Unable to import this file. Check that it is really an .ozcard file.';

  @override
  String get settingsAddCardBeforeBackup =>
      'Add at least one card before creating a backup.';

  @override
  String get settingsBackupReady => 'The compressed backup is ready to share.';

  @override
  String get settingsBackupError => 'Unable to create the backup.';

  @override
  String settingsRestoreReplaced(int count) {
    return 'Restore complete: all data was replaced with the $count card(s) from the backup.';
  }

  @override
  String settingsRestoreMerged(int added, int existing, int folders) {
    return 'Restore complete: $added card(s) added, $existing already present, $folders folder(s) added.';
  }

  @override
  String get settingsRestoreError =>
      'Unable to restore this backup. Check the .ozbackup file.';

  @override
  String get settingsChooseRestoreModeTitle => 'Restore this backup';

  @override
  String settingsChooseRestoreModeBody(int cards, int folders) {
    return 'The backup contains $cards card(s) and $folders folder(s).\n\nMerge: adds what is missing, without touching your current data.\n\nReplace: erases all your current cards and folders, then replaces them with those from the backup.';
  }

  @override
  String get settingsConfirmReplaceTitle => 'Replace all data?';

  @override
  String settingsConfirmReplaceBody(int cards, int folders) {
    return 'This action is irreversible. All your current cards and folders will be permanently erased and replaced with the $cards card(s) and $folders folder(s) from the backup.';
  }

  @override
  String get settingsExternalBackupDisabled =>
      'Automatic external backup disabled.';

  @override
  String get settingsAddCardBeforeExternal =>
      'Add at least one card before enabling external backup.';

  @override
  String get settingsChooseFolderFirst =>
      'First choose an external backup folder.';

  @override
  String get settingsExternalBackupActivated =>
      'External backup enabled: the first copy has been created.';

  @override
  String get settingsExternalBackupActivateError =>
      'Unable to enable external backup. Check the chosen folder.';

  @override
  String settingsFolderSelected(String name) {
    return '“$name” folder selected. Now enable external backup.';
  }

  @override
  String get settingsFolderSelectError => 'Unable to select this folder.';

  @override
  String get settingsNoExternalFolder =>
      'No external folder is accessible. Select a backup folder.';

  @override
  String settingsBackupVerified(
      String fileName, int sizeKb, String folderName) {
    return 'Backup verified: $fileName ($sizeKb KB) is present in “$folderName”.';
  }

  @override
  String get settingsSelectedFolderFallback => 'the selected folder';

  @override
  String get settingsNoBackupThisWeek =>
      'External folder accessible, but no copy has been created this week yet.';

  @override
  String get settingsCheckExternalError =>
      'Unable to check the external folder. Check its access in Android.';

  @override
  String get settingsDisplayModeTitle => 'Display mode';

  @override
  String get settingsThemeAutoTitle => 'Automatic';

  @override
  String get settingsThemeAutoDetail => 'Uses the phone’s setting.';

  @override
  String get settingsThemeLightTitle => 'Light mode';

  @override
  String get settingsThemeLightDetail => 'Bright display.';

  @override
  String get settingsThemeDarkTitle => 'Dark mode';

  @override
  String get settingsThemeDarkDetail => 'Dark display.';

  @override
  String get settingsAppThemeTitle => 'App theme';

  @override
  String get settingsAutoCloseEnabled =>
      'Automatic closing enabled after 3 minutes of inactivity.';

  @override
  String get settingsAutoCloseDisabled => 'Automatic closing disabled.';

  @override
  String get settingsNoticeTitle => 'User guide';

  @override
  String get settingsNoticeBody =>
      'Welcome to oz_carte2visite.\n\n1. FOLDERS\nThe “My folders” screen shows your card categories. Open a folder to see the cards it contains. You can create a new folder. A folder can only be deleted once it is empty. Each folder’s color can be customized from Settings → Folder colors.\n\n2. ADDING A CARD\nOpen a folder, then tap “Add a card”. Take a photo or select the front image of the card. You can also add a back image. With the No Ads plan, limited to one card, being unable to add a second one is shown right on this button, before even opening the creation screen.\n\n3. AUTOMATIC RECOGNITION\nThe app optimizes the image, detects text and looks for a QR code, then tries to fill the company, name, phone, email and notes fields directly. The company name is identified as the largest, most often all-caps text on the card; the holder’s name is matched against the detected email address when possible. If the photo and the QR code give different values for the same field, both are shown together, separated by “/”, for you to correct. Always check the information before saving.\n\n4. QR CODE\nA QR code in standard vCard format (the one this app also generates) fills the card’s fields directly. For any other format, the same rules as text recognition apply to the QR code’s content; if nothing usable is found, the raw text is added to the notes.\n\n5. VIEWING A CARD\nTap a card to open its details. Tap a front or back image to view it full-screen in landscape. Three action areas are offered: Get in touch (call, SMS, email, WhatsApp), Transfer (send the card by SMS or email, share it as .ozcard, generate a QR code — Premium plan only), and Other (add the card to Android contacts).\n\n6. SHARING AND IMPORTING\nUse “Share .ozcard”, reserved for the Premium plan, to send a card with its images. To receive a card, open Settings, then “Import an .ozcard card” and choose its folder — importing stays available on every plan.\n\n7. BACKUPS AND TRANSMISSION\nData is backed up locally after every change. From settings, reserved for the Premium plan, you can export a complete .ozbackup backup, share it, then restore it on another phone — restoring adds missing cards and folders without overwriting existing ones. “Transmit folders” instead lets you choose only certain folders before sending, rather than the entire database: the resulting file restores exactly the same way, but its name and description make clear it is not a complete backup.\n\n8. EXTERNAL BACKUP\nIf your plan allows it, choose a local or cloud folder in settings. A first copy is created upon activation, then a single fixed external copy is created weekly on the first change. The last seven external copies are kept.\n\n9. PLANS\nNo ads: one card maximum.\nWith ads: unlimited cards, with no way to transfer or export a card, and ads at startup and when returning to the foreground. Switching from No Ads to With Ads is done from Settings — this change is final, with no way back to No Ads.\nPremium: unlimited cards, no ads, with access to settings and card transfer. Premium is obtained through an annual Google Play subscription, from Settings → Premium subscription. If you reinstall the app or change phones, the “Restore purchases” button on that same screen recovers an already-active subscription, with no new payment.\n\n10. AUTOMATIC CLOSING\nThe app may go to the background after three minutes of inactivity. This never applies while creating or editing a card.';

  @override
  String get settingsLegalTitle => 'Legal notice and privacy';

  @override
  String get settingsLegalBody =>
      'PUBLISHER\nOz-WEB\nChristophe VIDAL — Sole trader\nWeb Developer & Webmaster\nEmail: oz-vitrine@gmail.com\nSIRET: 528 401 391 00016\n\nCOPYRIGHT\nCopyright © 2025 Oz-WEB — Christophe VIDAL. All rights reserved.\n\nPURPOSE OF THE APP\noz_carte2visite lets you scan, organize, export, import and back up business cards.\n\nDATA PROCESSED\nThe app may process information found on cards: name, company, phone, email, notes, QR code content and front/back photographs.\n\nLOCAL STORAGE\nBy default, cards, images and settings are stored locally on your device. Images are saved in the app’s private directory to limit accidental deletion.\n\nSHARING AND EXTERNAL BACKUP\nNo data is sent to an external service without an explicit action or activation by the user. When sharing, exporting or using external backup, you choose the recipient or folder yourself. You are responsible for the security of any third-party files and services you choose.\n\nPERMISSIONS\nCamera: photographing cards.\nPhotos and files: selecting, importing and exporting images or backups.\nContacts: voluntarily adding a card to the Android address book.\nInternet: loading ads only with the With Ads plan.\n\nOCR AND QR CODES\nText recognition and QR code reading are performed by components installed on the device. You must check the suggested information before confirming a card.\n\nADS\nThe With Ads plan may show Google AdMob ads when opening the app or returning to the foreground. Google AdMob may process technical information according to its own privacy policy. The Premium plan contains no ads.\n\nPREMIUM SUBSCRIPTION\nThe annual €10 Premium subscription will be managed by Google Play. Payment data is processed by Google and is not collected or retained by Oz-WEB.\n\nRETENTION AND DELETION\nYour data stays on your device for as long as you keep it. You can delete a card or a folder from the app. Uninstalling may delete local data; external backups remain under your control.\n\nRESPONSIBILITY\nYou must have the right to photograph, save and share the data shown on business cards.\n\nYOUR RIGHTS\nYou can view, correct, export or delete your data directly from the app. For any privacy question: oz-vitrine@gmail.com.\n\nLAST UPDATED\nLast updated: March 8, 2025.';

  @override
  String get settingsConfirmMergeTitle => 'Restore this backup?';

  @override
  String settingsConfirmMergeBody(int cards, int folders) {
    return 'The backup contains $cards card(s) and $folders folder(s).\n\nCards and folders already on this phone will not be replaced.';
  }

  @override
  String get settingsThisCardFallback => 'This card';

  @override
  String get settingsCardAlreadySavedTitle => 'Card already saved';

  @override
  String settingsCardAlreadySavedBody(String name, String folder) {
    return '“$name” is already present in the “$folder” folder.\n\nNo duplicate will be created. Do you want to open this folder?';
  }

  @override
  String get settingsChooseFolderTitle => 'Choose the folder';

  @override
  String get settingsChooseFolderBody =>
      'Choose the destination folder for this card.';

  @override
  String get settingsCreateNewFolder => 'Create a new folder';

  @override
  String get settingsFolderNameTaken =>
      'A folder with this name already exists.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLockedTitle => 'Settings locked';

  @override
  String get settingsLockedBody =>
      'Settings are available with the Premium license.';

  @override
  String get settingsSectionImport => 'Import and sharing';

  @override
  String get settingsImportCardTitle => 'Import an .ozcard card';

  @override
  String get settingsImportCardSubtitle =>
      'Select a received card, then choose its folder.';

  @override
  String get settingsSectionDbBackup => 'Database backup';

  @override
  String get settingsExportBackupTitle => 'Export backup';

  @override
  String get settingsExportBackupSubtitle =>
      'Compressed .ozbackup archive with cards, folders and images.';

  @override
  String get settingsRestoreBackupTitle => 'Restore a backup';

  @override
  String get settingsRestoreBackupSubtitle =>
      'Only adds missing cards and folders.';

  @override
  String get settingsSectionExternalBackup => 'Weekly external backup';

  @override
  String get settingsExternalToggleTitle => 'Automatic external backup';

  @override
  String get settingsExternalToggleOn =>
      'On: a fixed copy is created at most once a week.';

  @override
  String get settingsExternalToggleOff =>
      'Off. Turning it on creates the first copy immediately.';

  @override
  String get settingsChooseFolderMenuTitle => 'Choose the backup folder';

  @override
  String get settingsNoFolderSelected => 'No folder selected.';

  @override
  String settingsCurrentFolder(String name) {
    return 'Current folder: $name';
  }

  @override
  String get settingsCheckExternalTitle => 'Check external backup';

  @override
  String get settingsCheckExternalSubtitle =>
      'Checks access to the folder without creating a new copy.';

  @override
  String get settingsExternalFootnote =>
      'The local backup is updated after every change. Once enabled, a first external copy is created immediately. After that, a single fixed external copy is created on the first change of each new week. The last seven external copies are kept.';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsThemeMenuTitle => 'Theme';

  @override
  String get settingsSectionBehavior => 'Behavior';

  @override
  String get settingsAutoCloseTitle => 'Automatic closing';

  @override
  String get settingsAutoCloseSubtitle =>
      'Closes the app after 3 minutes of inactivity, except while creating or editing a card.';

  @override
  String get settingsSectionPrivacy => 'Privacy';

  @override
  String get settingsPersonalizedAdsTitle => 'Personalized ads';

  @override
  String get settingsPersonalizedAdsSubtitle =>
      'Change your choice about personalized ads at any time.';

  @override
  String get settingsSectionInfo => 'Information';

  @override
  String get settingsPersonalLicenseTitle => 'Premium subscription';

  @override
  String get settingsPersonalLicenseSubtitle =>
      'Subscribe or restore a Google Play subscription.';

  @override
  String get settingsLegalMenuTitle => 'Legal notice and license';

  @override
  String get licenseTitle => 'Personal license';

  @override
  String get licenseNoneActive => 'No active subscription';

  @override
  String get licenseImportHint =>
      'Subscribe to unlock settings and card transfer.';

  @override
  String get editCardOcrDetected =>
      'Text detected. Check and correct the suggested information.';

  @override
  String get editCardQrDetected =>
      'The QR code content was added to the notes.';

  @override
  String get editCardMissingImage => 'First add a front or back image.';

  @override
  String get editCardMissingNameOrCompany =>
      'Fill in at least a company or a name.';

  @override
  String get editCardPlanLimited =>
      'The No Ads plan is limited to a single card. Choose the With Ads or Premium plan to add more cards.';

  @override
  String get editCardAddTitle => 'Add a card';

  @override
  String get editCardEditTitle => 'Edit card';

  @override
  String get editCardImagesSection => 'Card images';

  @override
  String get editCardFront => 'Front';

  @override
  String get editCardBack => 'Back';

  @override
  String get editCardSearchQr => 'Search for a QR code in the images';

  @override
  String get editCardAnalyzing => 'Optimizing and analyzing…';

  @override
  String get editCardInfoSection => 'Card information';

  @override
  String get editCardInvalidEmail => 'Invalid email address.';

  @override
  String get editCardSave => 'Save card';

  @override
  String editCardAddImage(String label) {
    return 'Add $label image';
  }

  @override
  String get settingsFolderColorsTitle => 'Folder colors';

  @override
  String get settingsFolderColorsSubtitle => 'Customize each folder\'s color';

  @override
  String get consentRequiredTitle => 'Ads not authorized';

  @override
  String get consentRequiredBody =>
      'The With Ads plan requires your consent to show ads. Without this consent, this plan cannot work: review your consent, or switch to the No Ads plan.';

  @override
  String get premiumRequiredMessage =>
      'This feature is reserved for the Premium plan.';

  @override
  String get actionReviewConsent => 'Review my consent';

  @override
  String get actionSwitchToFreePlan => 'Switch to No Ads (1 card)';

  @override
  String get settingsCurrentPlanTitle => 'Current plan';

  @override
  String get settingsPlanFreeLabel => 'No ads — 1 card';

  @override
  String get settingsPlanAdsLabel => 'With ads — unlimited, no sharing';

  @override
  String get settingsPlanPremiumLabel => 'Premium — unlimited, no ads';

  @override
  String get settingsSwitchToAdsTitle => 'Switch to With Ads?';

  @override
  String get settingsSwitchToAdsBody =>
      'You’ll be able to create unlimited cards. Ads will appear when opening the app or returning to it. This change cannot be undone: you won’t be able to go back to the No Ads plan afterward.';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get settingsPlanChanged => 'Plan updated.';

  @override
  String get settingsConsentNeededForAdsBody =>
      'The With Ads plan requires your consent. Review your consent to continue.';

  @override
  String get settingsConsentStillMissing =>
      'Consent was not granted. Your plan remains No Ads.';

  @override
  String get cardSectionContact => 'Get in touch';

  @override
  String get cardSectionTransfer => 'Transfer';

  @override
  String get cardSectionOther => 'Other';

  @override
  String get actionWhatsApp => 'WhatsApp';

  @override
  String get actionSendCardEmail => 'Send by email';

  @override
  String get cardWhatsAppError => 'Unable to open WhatsApp.';

  @override
  String get licensePlayBillingActive => 'Google Play subscription active';

  @override
  String get licensePlayBillingSubtitle =>
      'Managed from Google Play (Play Store → Subscriptions).';

  @override
  String licenseSubscribeButton(String price) {
    return 'Subscribe — $price per year';
  }

  @override
  String get licenseProductUnavailable => 'Subscription currently unavailable.';

  @override
  String get licenseRestoreButton => 'Restore purchases';

  @override
  String get licenseRestoreDone => 'Check complete.';

  @override
  String get licensePurchaseError => 'Purchase currently unavailable.';

  @override
  String get licenseOrDivider => 'or';

  @override
  String get settingsTransmitFoldersTitle => 'Transmit folders';

  @override
  String get settingsTransmitFoldersSubtitle =>
      'Choose which folders to include before sending.';

  @override
  String get settingsSelectFoldersTitle => 'Folders to transmit';

  @override
  String get actionValidate => 'Confirm';

  @override
  String get settingsTransmitEmptyFolders =>
      'The selected folders contain no cards.';

  @override
  String get settingsTransmitReady => 'File ready to send.';

  @override
  String get settingsTransmitError => 'Unable to prepare this transmission.';

  @override
  String get settingsTransmitShareSubject =>
      'Folders sent from oz_carte2visite';

  @override
  String settingsTransmitShareText(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Selection of $count folders — this is not a complete backup.',
      one: 'Selection of 1 folder — this is not a complete backup.',
    );
    return '$_temp0';
  }

  @override
  String get folderKindTitle => 'Folder type';

  @override
  String get folderKindBusinessCard => 'Business cards';

  @override
  String get folderKindBusinessCardDetail =>
      'Automatic recognition, transfer and export available.';

  @override
  String get folderKindSubscription => 'Subscription';

  @override
  String get folderKindSubscriptionDetail =>
      'Photo and scanned code. Not transferable, included in backups.';

  @override
  String get folderKindDiscount => 'Loyalty cards';

  @override
  String get folderKindDiscountDetail =>
      'Photo and scanned code. Not transferable, included in backups.';

  @override
  String get settingsSectionFolderKinds => 'Folder types';

  @override
  String get settingsFolderKindToggleSubtitle =>
      'Offer this type when creating a folder.';

  @override
  String get settingsFolderKindPremiumOnly => 'Premium only.';

  @override
  String get cardTransferNotAllowed =>
      'Cards in this folder cannot be transferred.';

  @override
  String get fieldMerchant => 'Merchant';

  @override
  String get fieldClub => 'Club';

  @override
  String get settingsVersionTitle => 'Version';

  @override
  String settingsVersionSubtitle(String version, String date) {
    return '$version — updated on $date';
  }

  @override
  String get commonLoading => 'Loading…';

  @override
  String get settingsChangelogTitle => 'What\'s new';

  @override
  String get settingsChangelogSubtitle => 'Version history and changes.';

  @override
  String get settingsChangelogError => 'Unable to open this page.';

  @override
  String get fieldExpirationDate => 'Expiration date';

  @override
  String get fieldExpirationDateEmpty => 'Not set';

  @override
  String get homeExpiringSubscriptionsTitle => 'Subscriptions to renew';

  @override
  String homeExpiringSubscriptionDate(String date) {
    return 'Expires on $date';
  }
}
