// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'oz_carte2visite';

  @override
  String get languageScreenTitle => 'Choisissez votre langue';

  @override
  String get languageScreenSubtitle =>
      'Vous pourrez changer ce réglage plus tard, depuis les préférences.';

  @override
  String get languageOptionFrench => 'Français';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String get languageScreenContinue => 'Continuer';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionCreate => 'Créer';

  @override
  String get actionRename => 'Renommer';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionReset => 'Réinitialiser';

  @override
  String get actionReplace => 'Remplacer';

  @override
  String get actionMerge => 'Fusionner';

  @override
  String get actionReplaceAll => 'Tout remplacer';

  @override
  String get actionRestore => 'Restaurer';

  @override
  String get actionStayHere => 'Rester ici';

  @override
  String get actionOpenFolder => 'Ouvrir le classeur';

  @override
  String get actionImport => 'Importer';

  @override
  String get actionClose => 'Fermer';

  @override
  String get actionRemove => 'Retirer';

  @override
  String get fieldCompany => 'Entreprise';

  @override
  String get fieldName => 'Nom';

  @override
  String get fieldPhone => 'Téléphone';

  @override
  String get fieldEmail => 'Adresse e-mail';

  @override
  String get fieldNotes => 'Notes';

  @override
  String get fieldFolder => 'Classeur';

  @override
  String get onboardingTakePhoto => 'Prendre une photo';

  @override
  String get onboardingChooseImage => 'Choisir une image';

  @override
  String get onboardingImageError => 'Impossible de traiter cette image.';

  @override
  String get onboardingOcrDetected =>
      'Texte détecté. Vérifiez les propositions avant validation.';

  @override
  String get onboardingOcrFailed =>
      'Le texte de cette image n’a pas pu être lu.';

  @override
  String get onboardingQrDetected =>
      'QR Code détecté : son contenu a été ajouté aux notes.';

  @override
  String get onboardingMissingFrontPhoto =>
      'Ajoutez d’abord une photo recto de votre carte.';

  @override
  String get onboardingMissingNameOrCompany =>
      'Vérifiez ou renseignez au minimum le nom ou l’entreprise.';

  @override
  String get onboardingLegalTitle => 'Mentions légales';

  @override
  String get onboardingLegalBody =>
      'Vos cartes sont stockées sur votre appareil. Les photos, sauvegardes et partages sont déclenchés uniquement à votre demande.\n\nCopyright © 2025 oz_carte2visite.';

  @override
  String get onboardingLegalAccept => 'J’accepte et je continue';

  @override
  String get onboardingPlanTitle => 'Choisissez votre formule';

  @override
  String get onboardingPlanSubtitle =>
      'Vous pourrez passer à Premium après la mise en place de l’abonnement Google Play.';

  @override
  String get onboardingPlanFreeTitle => 'Sans publicité';

  @override
  String get onboardingPlanFreeDetail =>
      'Une seule carte de visite. Paramètres verrouillés.';

  @override
  String get onboardingPlanAdsTitle => 'Avec publicité';

  @override
  String get onboardingPlanAdsDetail =>
      'Cartes illimitées. Publicité après la première carte, puis au retour de l’application au premier plan. Paramètres et partage de cartes verrouillés.';

  @override
  String get onboardingPremiumTitle => 'Premium — 10 € par an';

  @override
  String get onboardingPremiumDetail =>
      'Cartes illimitées, sans publicité et accès aux paramètres. Disponible prochainement via Google Play.';

  @override
  String get onboardingPlanValidate => 'Valider la formule';

  @override
  String get onboardingPhotoStepTitle => 'Photographiez votre première carte';

  @override
  String get onboardingPhotoStepSubtitle =>
      'Les images sont optimisées pour rester lisibles tout en réduisant la taille des sauvegardes et partages.';

  @override
  String get onboardingFrontPhotoLabel => 'Photo recto';

  @override
  String get onboardingBackPhotoLabel => 'Photo verso — facultative';

  @override
  String get onboardingAnalyzing =>
      'Optimisation et analyse de l’image en cours…';

  @override
  String get onboardingDetectedInfoTitle =>
      'Informations détectées — à corriger si nécessaire';

  @override
  String get onboardingValidateCard => 'Valider ma carte';

  @override
  String get homeTitle => 'Mes classeurs';

  @override
  String get homeExportAllTooltip => 'Exporter tous les classeurs en PDF';

  @override
  String get homeSettingsTooltip => 'Paramètres';

  @override
  String get homeNewFolderTitle => 'Nouveau classeur';

  @override
  String get homeFolderNameLabel => 'Nom du classeur';

  @override
  String homeFolderNameTaken(String name) {
    return 'Un classeur portant le nom « $name » existe déjà.';
  }

  @override
  String homeFolderCreated(String name) {
    return 'Classeur « $name » créé.';
  }

  @override
  String get homeRenameFolderTitle => 'Renommer le classeur';

  @override
  String homeFolderRenamed(String name) {
    return 'Classeur renommé en « $name ».';
  }

  @override
  String get homeFolderColorTitle => 'Couleur du classeur';

  @override
  String get homeFolderColorTooltip => 'Couleur du classeur';

  @override
  String get homeRenameFolderTooltip => 'Renommer le classeur';

  @override
  String get homeAddCardBeforeExport =>
      'Ajoutez au moins une carte avant l’export PDF.';

  @override
  String get homeGlobalPdfReady =>
      'Le PDF global est prêt à être enregistré ou partagé.';

  @override
  String get homeGlobalPdfError => 'Impossible de générer le PDF global.';

  @override
  String homeCardCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartes',
      one: '1 carte',
      zero: '0 carte',
    );
    return '$_temp0';
  }

  @override
  String get folderDeleteDefaultBlocked =>
      'Ce classeur par défaut ne peut pas être supprimé.';

  @override
  String get folderDeleteNotEmpty =>
      'Ce classeur contient encore des cartes et ne peut pas être supprimé.';

  @override
  String get folderDeleteConfirmTitle => 'Supprimer ce classeur ?';

  @override
  String folderDeleteConfirmBody(String name) {
    return 'Le classeur « $name » est vide. Voulez-vous vraiment le supprimer ?';
  }

  @override
  String get folderDeleteFailed => 'Le classeur ne peut pas être supprimé.';

  @override
  String get folderPdfReady => 'Le PDF est prêt à être enregistré ou partagé.';

  @override
  String get folderPdfError => 'Impossible de générer le PDF.';

  @override
  String get folderDestinationNotFound => 'Le classeur choisi est introuvable.';

  @override
  String get folderExportTooltip => 'Exporter le classeur en PDF';

  @override
  String get folderDeleteTooltip => 'Supprimer le classeur';

  @override
  String get folderAllLetter => 'Toutes';

  @override
  String get folderAddCardLabel => 'Ajouter une carte';

  @override
  String folderEmptyDefault(String name) {
    return 'Le classeur « $name » ne contient encore aucune carte.';
  }

  @override
  String folderEmptyLetter(String letter) {
    return 'Aucune carte ne commence par la lettre $letter.';
  }

  @override
  String get cardDetailGone => 'Cette carte n’existe plus.';

  @override
  String get cardLinkOpenError => 'Impossible d’ouvrir ce lien.';

  @override
  String get cardPhoneAppError =>
      'Impossible d’ouvrir l’application téléphone.';

  @override
  String cardEmailSubject(String name) {
    return 'Bonjour $name';
  }

  @override
  String get cardEmailAppError =>
      'Impossible d’ouvrir votre application e-mail.';

  @override
  String get cardSmsAppError => 'Impossible d’ouvrir votre application SMS.';

  @override
  String get cardShareOzcardReady => 'Carte .ozcard prête à être partagée.';

  @override
  String get cardShareOzcardError => 'Impossible de partager cette carte.';

  @override
  String get cardContactSaved =>
      'Contact enregistré dans le répertoire Android.';

  @override
  String get cardContactPermissionNeeded =>
      'L’autorisation Contacts est nécessaire pour enregistrer cette fiche.';

  @override
  String get cardContactSaveError => 'Impossible d’enregistrer ce contact.';

  @override
  String get cardDeleteConfirmTitle => 'Supprimer cette carte ?';

  @override
  String get cardDeleteConfirmBody =>
      'La carte et ses informations seront retirées de l’application.';

  @override
  String get cardQrDialogTitle => 'QR Code de votre carte';

  @override
  String get cardQrScanHintNoTitle =>
      'Scannable par n’importe quel appareil photo.';

  @override
  String cardQrScanHintWithTitle(String title) {
    return '$title — scannable par n’importe quel appareil photo.';
  }

  @override
  String get cardDefaultTitle => 'Carte de visite';

  @override
  String get cardEditTooltip => 'Modifier la carte';

  @override
  String get cardDeleteTooltip => 'Supprimer la carte';

  @override
  String get cardFrontLabel => 'Carte recto';

  @override
  String get cardBackLabel => 'Carte verso';

  @override
  String get cardDetailEmailLabel => 'E-mail';

  @override
  String get sectionActions => 'Actions';

  @override
  String get actionCall => 'Appeler';

  @override
  String get actionSmsContact => 'SMS contact';

  @override
  String get actionSendCardSms => 'Envoyer fiche SMS';

  @override
  String get actionShareOzcard => 'Partager .ozcard';

  @override
  String get actionAddToContacts => 'Ajouter aux contacts';

  @override
  String get actionGenerateQr => 'Générer un QR Code';

  @override
  String cardImageTapHint(String label) {
    return '$label — toucher pour afficher en paysage';
  }

  @override
  String get imageCloseTooltip => 'Fermer l’image';

  @override
  String get sectionNotes => 'Notes';

  @override
  String get cardAsTextHeader => 'Carte de visite — oz_carte2visite';

  @override
  String cardAsTextCompany(String value) {
    return 'Entreprise : $value';
  }

  @override
  String cardAsTextName(String value) {
    return 'Nom : $value';
  }

  @override
  String cardAsTextPhone(String value) {
    return 'Téléphone : $value';
  }

  @override
  String cardAsTextEmail(String value) {
    return 'E-mail : $value';
  }

  @override
  String cardAsTextNotes(String value) {
    return 'Notes : $value';
  }

  @override
  String get settingsFilePickError =>
      'Impossible d’accéder au fichier sélectionné.';

  @override
  String get settingsCardFolderMissing =>
      'Cette carte existe déjà, mais son classeur est introuvable.';

  @override
  String get settingsCardAlreadySaved =>
      'Cette carte est déjà enregistrée sur votre téléphone.';

  @override
  String get settingsImportError =>
      'Impossible d’importer ce fichier. Vérifiez qu’il s’agit bien d’une carte .ozcard.';

  @override
  String get settingsAddCardBeforeBackup =>
      'Ajoutez au moins une carte avant de créer une sauvegarde.';

  @override
  String get settingsBackupReady =>
      'Sauvegarde compressée prête à être partagée.';

  @override
  String get settingsBackupError => 'Impossible de créer la sauvegarde.';

  @override
  String settingsRestoreReplaced(int count) {
    return 'Restauration terminée : toutes les données ont été remplacées par les $count carte(s) de la sauvegarde.';
  }

  @override
  String settingsRestoreMerged(int added, int existing, int folders) {
    return 'Restauration terminée : $added carte(s) ajoutée(s), $existing déjà présente(s), $folders classeur(s) ajouté(s).';
  }

  @override
  String get settingsRestoreError =>
      'Impossible de restaurer cette sauvegarde. Vérifiez le fichier .ozbackup.';

  @override
  String get settingsChooseRestoreModeTitle => 'Restaurer cette sauvegarde';

  @override
  String settingsChooseRestoreModeBody(int cards, int folders) {
    return 'La sauvegarde contient $cards carte(s) et $folders classeur(s).\n\nFusionner : ajoute ce qui manque, sans toucher à vos données actuelles.\n\nRemplacer : efface toutes vos cartes et classeurs actuels, puis les remplace par ceux de la sauvegarde.';
  }

  @override
  String get settingsConfirmReplaceTitle => 'Remplacer toutes les données ?';

  @override
  String settingsConfirmReplaceBody(int cards, int folders) {
    return 'Cette action est irréversible. Toutes vos cartes et classeurs actuels seront définitivement effacés et remplacés par les $cards carte(s) et $folders classeur(s) de la sauvegarde.';
  }

  @override
  String get settingsExternalBackupDisabled =>
      'Sauvegarde externe automatique désactivée.';

  @override
  String get settingsAddCardBeforeExternal =>
      'Ajoutez au moins une carte avant d’activer la sauvegarde externe.';

  @override
  String get settingsChooseFolderFirst =>
      'Choisissez d’abord un dossier de sauvegarde externe.';

  @override
  String get settingsExternalBackupActivated =>
      'Sauvegarde externe activée : la première copie a été créée.';

  @override
  String get settingsExternalBackupActivateError =>
      'Impossible d’activer la sauvegarde externe. Vérifiez le dossier choisi.';

  @override
  String settingsFolderSelected(String name) {
    return 'Dossier « $name » sélectionné. Activez ensuite la sauvegarde externe.';
  }

  @override
  String get settingsFolderSelectError =>
      'Impossible de sélectionner ce dossier.';

  @override
  String get settingsNoExternalFolder =>
      'Aucun dossier externe accessible. Sélectionnez un dossier de sauvegarde.';

  @override
  String settingsBackupVerified(
      String fileName, int sizeKb, String folderName) {
    return 'Sauvegarde vérifiée : $fileName ($sizeKb Ko) est présent dans « $folderName ».';
  }

  @override
  String get settingsSelectedFolderFallback => 'le dossier sélectionné';

  @override
  String get settingsNoBackupThisWeek =>
      'Dossier externe accessible, mais aucune copie n’a encore été créée cette semaine.';

  @override
  String get settingsCheckExternalError =>
      'Impossible de vérifier le dossier externe. Vérifiez son accès dans Android.';

  @override
  String get settingsDisplayModeTitle => 'Mode d’affichage';

  @override
  String get settingsThemeAutoTitle => 'Automatique';

  @override
  String get settingsThemeAutoDetail => 'Utilise le réglage du téléphone.';

  @override
  String get settingsThemeLightTitle => 'Mode clair';

  @override
  String get settingsThemeLightDetail => 'Affichage lumineux.';

  @override
  String get settingsThemeDarkTitle => 'Mode sombre';

  @override
  String get settingsThemeDarkDetail => 'Affichage sombre.';

  @override
  String get settingsAppThemeTitle => 'Thème de l’application';

  @override
  String get settingsAutoCloseEnabled =>
      'Fermeture automatique activée après 3 minutes d’inactivité.';

  @override
  String get settingsAutoCloseDisabled => 'Fermeture automatique désactivée.';

  @override
  String get settingsNoticeTitle => 'Notice d’emploi';

  @override
  String get settingsNoticeBody =>
      'Bienvenue dans oz_carte2visite.\n\n1. CLASSEURS\nL’écran « Mes classeurs » affiche vos catégories de cartes. Ouvrez un classeur pour consulter les cartes qu’il contient. Vous pouvez créer un nouveau classeur. Un classeur ne peut être supprimé que lorsqu’il est vide. La couleur de chaque classeur se personnalise depuis Réglages → Couleurs des classeurs.\n\n2. AJOUTER UNE CARTE\nOuvrez un classeur puis touchez « Ajouter une carte ». Prenez une photo ou sélectionnez l’image recto de la carte. Vous pouvez aussi ajouter une image verso. Avec la formule Sans publicité, limitée à une carte, l’impossibilité d’en ajouter une deuxième est signalée dès ce bouton, avant même d’ouvrir l’écran de création.\n\n3. RECONNAISSANCE AUTOMATIQUE\nL’application optimise l’image, détecte le texte et recherche un QR Code, puis tente de remplir directement les champs entreprise, nom, téléphone, e-mail et notes. Le nom de l’entreprise est repéré au texte le plus grand et le plus souvent en majuscules sur la carte ; le nom du titulaire est recherché en le rapprochant de l’adresse e-mail détectée quand c’est possible. Si la photo et le QR Code donnent des valeurs différentes pour un même champ, les deux sont affichées à la suite, séparées par « / », pour que vous corrigiez vous-même. Vérifiez toujours les informations avant d’enregistrer.\n\n4. QR CODE\nUn QR Code au format vCard standard (celui que génère aussi cette application) remplit directement les champs de la carte. Pour un autre format, les mêmes règles que la reconnaissance de texte s’appliquent au contenu du QR Code ; si rien d’exploitable n’est trouvé, le texte brut est ajouté aux notes.\n\n5. CONSULTER UNE CARTE\nTouchez une carte pour ouvrir sa fiche. Touchez une image recto ou verso pour l’afficher en grand format paysage. Trois zones d’actions sont proposées : Prendre contact (appeler, SMS, e-mail, WhatsApp), Transférer (envoyer la fiche par SMS ou e-mail, la partager en .ozcard, générer un QR Code — réservé à la formule Premium), et Autres (ajouter la carte aux contacts Android).\n\n6. PARTAGER ET IMPORTER\nUtilisez « Partager .ozcard », réservé à la formule Premium, pour envoyer une carte avec ses images. Pour recevoir une carte, ouvrez Réglages puis « Importer une carte .ozcard » et choisissez son classeur — l’import reste disponible quelle que soit la formule.\n\n7. SAUVEGARDES ET TRANSMISSION\nLes données sont sauvegardées localement après chaque modification. Depuis les réglages, réservés à la formule Premium, vous pouvez exporter une sauvegarde complète .ozbackup, la partager, puis la restaurer sur un autre téléphone — la restauration ajoute les cartes et classeurs absents sans écraser ceux qui existent déjà. « Transmettre des classeurs » permet, elle, de choisir uniquement certains classeurs avant l’envoi, plutôt que la totalité de la base : le fichier produit se restaure exactement de la même façon, mais son nom et sa description précisent qu’il ne s’agit pas d’une sauvegarde complète.\n\n8. SAUVEGARDE EXTERNE\nSi votre formule le permet, choisissez un dossier local ou cloud dans les réglages. Une première copie est créée lors de l’activation, puis une seule copie externe figée est créée par semaine lors de la première modification. Les sept dernières copies externes sont conservées.\n\n9. FORMULES\nSans publicité : une carte maximum.\nAvec publicité : cartes illimitées, sans possibilité de transférer ou d’exporter une carte, avec annonces au démarrage et au retour au premier plan. Le passage de Sans publicité vers Avec publicité se fait depuis Réglages — ce changement est définitif, sans retour possible vers Sans publicité.\nPremium : cartes illimitées, sans publicité, avec accès aux réglages et au transfert de cartes. Premium s’obtient par abonnement annuel via Google Play, depuis Réglages → Abonnement Premium. En cas de réinstallation ou de changement de téléphone, le bouton « Restaurer mes achats » du même écran retrouve un abonnement déjà actif, sans nouveau paiement.\n\n10. FERMETURE AUTOMATIQUE\nL’application peut passer en arrière-plan après trois minutes sans activité. Ce mécanisme ne s’applique jamais pendant la création ou la modification d’une carte.';

  @override
  String get settingsLegalTitle => 'Mentions légales et confidentialité';

  @override
  String get settingsLegalBody =>
      'ÉDITEUR\nOz-WEB\nChristophe VIDAL — Micro-entrepreneur\nDéveloppeur Web & Webmaster\nE-mail : oz-vitrine@gmail.com\nSIRET : 528 401 391 00016\n\nCOPYRIGHT\nCopyright © 2025 Oz-WEB — Christophe VIDAL. Tous droits réservés.\n\nOBJET DE L’APPLICATION\noz_carte2visite permet de numériser, organiser, exporter, importer et sauvegarder des cartes de visite.\n\nDONNÉES TRAITÉES\nL’application peut traiter les informations présentes sur les cartes : nom, entreprise, téléphone, e-mail, notes, contenu de QR Code et photographies recto/verso.\n\nSTOCKAGE LOCAL\nPar défaut, les cartes, images et paramètres sont stockés localement sur votre appareil. Les images sont enregistrées dans le répertoire privé de l’application afin de limiter leur suppression accidentelle.\n\nPARTAGE ET SAUVEGARDE EXTERNE\nAucune donnée n’est envoyée vers un service externe sans action ou activation explicite de l’utilisateur. Lors d’un partage, export ou d’une sauvegarde externe, vous choisissez vous-même le destinataire ou le dossier. Vous êtes responsable de la sécurité des fichiers et services tiers choisis.\n\nAUTORISATIONS\nCaméra : photographier les cartes.\nPhotos et fichiers : sélectionner, importer et exporter des images ou sauvegardes.\nContacts : ajouter volontairement une fiche au répertoire Android.\nInternet : charger des annonces uniquement avec la formule Avec publicité.\n\nOCR ET QR CODES\nLa reconnaissance de texte et la lecture de QR Codes sont réalisées par les composants installés sur l’appareil. Vous devez vérifier les informations proposées avant de valider une carte.\n\nPUBLICITÉS\nLa formule Avec publicité peut afficher des annonces Google AdMob à l’ouverture ou au retour de l’application au premier plan. Google AdMob peut traiter des informations techniques selon sa propre politique de confidentialité. La formule Premium ne contient aucune publicité.\n\nABONNEMENT PREMIUM\nL’abonnement Premium annuel de 10 € sera géré par Google Play. Les données de paiement sont traitées par Google et ne sont pas collectées ni conservées par Oz-WEB.\n\nDURÉE DE CONSERVATION ET SUPPRESSION\nVos données restent sur votre appareil aussi longtemps que vous les conservez. Vous pouvez supprimer une carte ou un classeur depuis l’application. La désinstallation peut supprimer les données locales ; les sauvegardes externes restent sous votre contrôle.\n\nRESPONSABILITÉ\nVous devez disposer du droit de photographier, enregistrer et partager les données figurant sur les cartes de visite.\n\nVOS DROITS\nVous pouvez consulter, corriger, exporter ou supprimer vos données directement depuis l’application. Pour toute question sur la confidentialité : oz-vitrine@gmail.com.\n\nMISE À JOUR\nDernière mise à jour : 8 mars 2025.';

  @override
  String get settingsConfirmMergeTitle => 'Restaurer cette sauvegarde ?';

  @override
  String settingsConfirmMergeBody(int cards, int folders) {
    return 'La sauvegarde contient $cards carte(s) et $folders classeur(s).\n\nLes cartes et classeurs déjà présents sur ce téléphone ne seront pas remplacés.';
  }

  @override
  String get settingsThisCardFallback => 'Cette carte';

  @override
  String get settingsCardAlreadySavedTitle => 'Carte déjà enregistrée';

  @override
  String settingsCardAlreadySavedBody(String name, String folder) {
    return '« $name » est déjà présente dans le classeur « $folder ».\n\nAucun doublon ne sera créé. Souhaitez-vous ouvrir ce classeur ?';
  }

  @override
  String get settingsChooseFolderTitle => 'Choisir le classeur';

  @override
  String get settingsChooseFolderBody =>
      'Choisissez le classeur de destination de cette carte.';

  @override
  String get settingsCreateNewFolder => 'Créer un nouveau classeur';

  @override
  String get settingsFolderNameTaken =>
      'Un classeur portant ce nom existe déjà.';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsLockedTitle => 'Paramètres verrouillés';

  @override
  String get settingsLockedBody =>
      'Les réglages sont disponibles avec la licence Premium.';

  @override
  String get settingsSectionImport => 'Import et partage';

  @override
  String get settingsImportCardTitle => 'Importer une carte .ozcard';

  @override
  String get settingsImportCardSubtitle =>
      'Sélectionnez une carte reçue puis choisissez son classeur.';

  @override
  String get settingsSectionDbBackup => 'Sauvegarde de la base';

  @override
  String get settingsExportBackupTitle => 'Exporter la sauvegarde';

  @override
  String get settingsExportBackupSubtitle =>
      'Archive .ozbackup compressée avec cartes, classeurs et images.';

  @override
  String get settingsRestoreBackupTitle => 'Restaurer une sauvegarde';

  @override
  String get settingsRestoreBackupSubtitle =>
      'Ajoute uniquement les cartes et classeurs absents.';

  @override
  String get settingsSectionExternalBackup => 'Sauvegarde externe hebdomadaire';

  @override
  String get settingsExternalToggleTitle => 'Sauvegarde externe automatique';

  @override
  String get settingsExternalToggleOn =>
      'Active : une copie figée est créée au maximum une fois par semaine.';

  @override
  String get settingsExternalToggleOff =>
      'Inactive. Son activation crée immédiatement la première copie.';

  @override
  String get settingsChooseFolderMenuTitle =>
      'Choisir le dossier de sauvegarde';

  @override
  String get settingsNoFolderSelected => 'Aucun dossier sélectionné.';

  @override
  String settingsCurrentFolder(String name) {
    return 'Dossier actuel : $name';
  }

  @override
  String get settingsCheckExternalTitle => 'Vérifier la sauvegarde externe';

  @override
  String get settingsCheckExternalSubtitle =>
      'Vérifie l’accès au dossier sans créer de nouvelle copie.';

  @override
  String get settingsExternalFootnote =>
      'La sauvegarde locale est mise à jour après chaque modification. Après activation, une première copie externe est créée immédiatement. Ensuite, une seule copie externe figée est créée à la première modification de chaque nouvelle semaine. Les sept dernières copies externes sont conservées.';

  @override
  String get settingsSectionAppearance => 'Apparence';

  @override
  String get settingsThemeMenuTitle => 'Thème';

  @override
  String get settingsSectionBehavior => 'Fonctionnement';

  @override
  String get settingsAutoCloseTitle => 'Fermeture automatique';

  @override
  String get settingsAutoCloseSubtitle =>
      'Ferme l’application après 3 minutes d’inactivité, sauf pendant la création ou la modification d’une fiche.';

  @override
  String get settingsSectionPrivacy => 'Confidentialité';

  @override
  String get settingsPersonalizedAdsTitle => 'Publicité personnalisée';

  @override
  String get settingsPersonalizedAdsSubtitle =>
      'Modifiez à tout moment votre choix concernant les publicités personnalisées.';

  @override
  String get settingsSectionInfo => 'Informations';

  @override
  String get settingsPersonalLicenseTitle => 'Abonnement Premium';

  @override
  String get settingsPersonalLicenseSubtitle =>
      'S’abonner ou restaurer un abonnement Google Play.';

  @override
  String get settingsLegalMenuTitle => 'Mentions légales et licence';

  @override
  String get licenseTitle => 'Licence personnelle';

  @override
  String get licenseNoneActive => 'Aucun abonnement actif';

  @override
  String get licenseImportHint =>
      'Abonnez-vous pour débloquer les réglages et le transfert de cartes.';

  @override
  String get editCardOcrDetected =>
      'Texte détecté. Vérifiez et corrigez les informations proposées.';

  @override
  String get editCardQrDetected =>
      'Le contenu du QR Code a été ajouté aux notes.';

  @override
  String get editCardMissingImage =>
      'Ajoutez d’abord une image recto ou verso.';

  @override
  String get editCardMissingNameOrCompany =>
      'Renseignez au minimum une entreprise ou un nom.';

  @override
  String get editCardPlanLimited =>
      'La formule Sans publicité est limitée à une seule carte. Choisissez la formule Avec publicité ou Premium pour ajouter d’autres cartes.';

  @override
  String get editCardAddTitle => 'Ajouter une carte';

  @override
  String get editCardEditTitle => 'Modifier la carte';

  @override
  String get editCardImagesSection => 'Images de la carte';

  @override
  String get editCardFront => 'Recto';

  @override
  String get editCardBack => 'Verso';

  @override
  String get editCardSearchQr => 'Rechercher un QR Code dans les images';

  @override
  String get editCardAnalyzing => 'Optimisation et analyse en cours…';

  @override
  String get editCardInfoSection => 'Informations de la carte';

  @override
  String get editCardInvalidEmail => 'Adresse e-mail invalide.';

  @override
  String get editCardSave => 'Enregistrer la carte';

  @override
  String editCardAddImage(String label) {
    return 'Ajouter l’image $label';
  }

  @override
  String get settingsFolderColorsTitle => 'Couleurs des classeurs';

  @override
  String get settingsFolderColorsSubtitle =>
      'Personnaliser la couleur de chaque classeur';

  @override
  String get consentRequiredTitle => 'Publicité non autorisée';

  @override
  String get consentRequiredBody =>
      'La formule Avec publicité nécessite votre consentement pour afficher des publicités. Sans ce consentement, cette formule ne peut pas fonctionner : revoyez votre consentement, ou passez à la formule Sans publicité.';

  @override
  String get premiumRequiredMessage =>
      'Cette fonctionnalité est réservée à la formule Premium.';

  @override
  String get actionReviewConsent => 'Revoir mon consentement';

  @override
  String get actionSwitchToFreePlan => 'Passer à Sans publicité (1 carte)';

  @override
  String get settingsCurrentPlanTitle => 'Formule actuelle';

  @override
  String get settingsPlanFreeLabel => 'Sans publicité — 1 carte';

  @override
  String get settingsPlanAdsLabel => 'Avec publicité — illimité, sans partage';

  @override
  String get settingsPlanPremiumLabel => 'Premium — illimité sans publicité';

  @override
  String get settingsSwitchToAdsTitle => 'Passer à Avec publicité ?';

  @override
  String get settingsSwitchToAdsBody =>
      'Vous pourrez créer un nombre illimité de cartes. Des publicités s’afficheront à l’ouverture et au retour de l’application. Ce changement n’est pas réversible : il ne sera plus possible de revenir à la formule Sans publicité.';

  @override
  String get actionConfirm => 'Confirmer';

  @override
  String get settingsPlanChanged => 'Formule mise à jour.';

  @override
  String get settingsConsentNeededForAdsBody =>
      'La formule Avec publicité nécessite votre consentement. Revoyez votre consentement pour continuer.';

  @override
  String get settingsConsentStillMissing =>
      'Le consentement n’a pas été accordé. La formule reste Sans publicité.';

  @override
  String get cardSectionContact => 'Prendre contact';

  @override
  String get cardSectionTransfer => 'Transférer';

  @override
  String get cardSectionOther => 'Autres';

  @override
  String get actionWhatsApp => 'WhatsApp';

  @override
  String get actionSendCardEmail => 'Envoyer par e-mail';

  @override
  String get cardWhatsAppError => 'Impossible d’ouvrir WhatsApp.';

  @override
  String get licensePlayBillingActive => 'Abonnement Google Play actif';

  @override
  String get licensePlayBillingSubtitle =>
      'Géré depuis Google Play (Play Store → Abonnements).';

  @override
  String licenseSubscribeButton(String price) {
    return 'S’abonner — $price par an';
  }

  @override
  String get licenseProductUnavailable =>
      'Abonnement indisponible pour le moment.';

  @override
  String get licenseRestoreButton => 'Restaurer mes achats';

  @override
  String get licenseRestoreDone => 'Vérification terminée.';

  @override
  String get licensePurchaseError => 'Achat impossible pour le moment.';

  @override
  String get licenseOrDivider => 'ou';

  @override
  String get settingsTransmitFoldersTitle => 'Transmettre des classeurs';

  @override
  String get settingsTransmitFoldersSubtitle =>
      'Choisir les classeurs à inclure avant l’envoi.';

  @override
  String get settingsSelectFoldersTitle => 'Classeurs à transmettre';

  @override
  String get actionValidate => 'Valider';

  @override
  String get settingsTransmitEmptyFolders =>
      'Les classeurs sélectionnés ne contiennent aucune carte.';

  @override
  String get settingsTransmitReady => 'Fichier prêt à être transmis.';

  @override
  String get settingsTransmitError =>
      'Impossible de préparer cette transmission.';

  @override
  String get settingsTransmitShareSubject =>
      'Classeurs transmis depuis oz_carte2visite';

  @override
  String settingsTransmitShareText(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Sélection de $count classeurs — ce n’est pas une sauvegarde complète.',
      one: 'Sélection de 1 classeur — ce n’est pas une sauvegarde complète.',
    );
    return '$_temp0';
  }

  @override
  String get folderKindTitle => 'Type de classeur';

  @override
  String get folderKindBusinessCard => 'Cartes de visite';

  @override
  String get folderKindBusinessCardDetail =>
      'Reconnaissance automatique, transfert et export possibles.';

  @override
  String get folderKindSubscription => 'Abonnement';

  @override
  String get folderKindSubscriptionDetail =>
      'Photo et code scanné. Non transférable, inclus dans les sauvegardes.';

  @override
  String get folderKindDiscount => 'Cartes de fidélité';

  @override
  String get folderKindDiscountDetail =>
      'Photo et code scanné. Non transférable, inclus dans les sauvegardes.';

  @override
  String get settingsSectionFolderKinds => 'Types de classeurs';

  @override
  String get settingsFolderKindToggleSubtitle =>
      'Proposer ce type lors de la création d’un classeur.';

  @override
  String get settingsFolderKindPremiumOnly => 'Réservé à Premium.';

  @override
  String get cardTransferNotAllowed =>
      'Les cartes de ce classeur ne peuvent pas être transmises.';

  @override
  String get fieldMerchant => 'Commerce';

  @override
  String get fieldClub => 'Club';

  @override
  String get settingsVersionTitle => 'Version';

  @override
  String settingsVersionSubtitle(String version, String date) {
    return '$version — mis à jour le $date';
  }

  @override
  String get commonLoading => 'Chargement…';

  @override
  String get settingsChangelogTitle => 'Nouveautés';

  @override
  String get settingsChangelogSubtitle =>
      'Historique des versions et des évolutions.';

  @override
  String get settingsChangelogError => 'Impossible d’ouvrir cette page.';

  @override
  String get fieldExpirationDate => 'Date d’expiration';

  @override
  String get fieldExpirationDateEmpty => 'Non renseignée';

  @override
  String get homeExpiringSubscriptionsTitle => 'Abonnements à renouveler';

  @override
  String homeExpiringSubscriptionDate(String date) {
    return 'Expire le $date';
  }
}
