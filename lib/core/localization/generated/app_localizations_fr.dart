// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'AetherDesk';

  @override
  String get navDashboard => 'Tableau de bord';

  @override
  String get navAiAssistant => 'Assistant IA';

  @override
  String get navCodeEditor => 'Éditeur de code';

  @override
  String get navProjectManagement => 'Gestion de projets';

  @override
  String get navSecureVault => 'Vault sécurisé';

  @override
  String get navCyberWorkspace => 'Cyber Workspace';

  @override
  String get navCreation2d => 'Création 2D';

  @override
  String get navCreation3d => 'Création 3D';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get navUserProfile => 'Profil';

  @override
  String get comingSoonTitle => 'Bientôt disponible';

  @override
  String get comingSoonMessage => 'Ce module est en cours de construction.';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonRename => 'Renommer';

  @override
  String get commonUnknownError => 'Erreur inconnue';

  @override
  String get errorGenericTitle => 'Une erreur est survenue';

  @override
  String get errorGenericMessage => 'Veuillez réessayer plus tard.';

  @override
  String get chatEmptyTitle => 'Comment puis-je vous aider ?';

  @override
  String get chatEmptyMessage =>
      'Posez une question ou choisissez une suggestion pour commencer.';

  @override
  String get chatErrorMessage =>
      'Impossible de contacter le modèle. Vérifiez l\'endpoint IA dans Réglages.';

  @override
  String get chatSuggestionGenerateCode => 'Générer du code';

  @override
  String get chatSuggestionDebug => 'Déboguer un programme';

  @override
  String get chatSuggestionExplain => 'Expliquer un concept';

  @override
  String get chatSuggestionPlan => 'Planifier un projet';

  @override
  String get chatInputHint => 'Écrivez un message…';

  @override
  String get chatSendTooltip => 'Envoyer';

  @override
  String get chatThinking => 'L\'IA réfléchit…';

  @override
  String get codeEditorNewFile => 'Nouveau fichier';

  @override
  String get codeEditorOpen => 'Ouvrir';

  @override
  String get codeEditorSave => 'Enregistrer';

  @override
  String get codeEditorCopy => 'Copier';

  @override
  String get codeEditorClear => 'Effacer';

  @override
  String get codeEditorEmptyHint => 'Commencez à écrire votre code ici…';

  @override
  String get codeEditorSearch => 'Rechercher';

  @override
  String get codeEditorSearchHint => 'Rechercher dans le code…';

  @override
  String get codeEditorSearchNoMatches => 'Aucune correspondance';

  @override
  String codeEditorFileOpenedMessage(String fileName) {
    return 'Fichier ouvert : $fileName';
  }

  @override
  String codeEditorFileSavedMessage(String fileName) {
    return 'Fichier enregistré : $fileName';
  }

  @override
  String get codeEditorCopiedMessage => 'Code copié dans le presse-papiers.';

  @override
  String codeEditorLinesCount(int count) {
    return '$count lignes';
  }

  @override
  String codeEditorCharsCount(int count) {
    return '$count caractères';
  }

  @override
  String codeEditorWordsCount(int count) {
    return '$count mots';
  }

  @override
  String get projectManagementEmptyTitle => 'Aucun projet';

  @override
  String get projectManagementEmptyMessage =>
      'Créez votre premier projet pour commencer.';

  @override
  String get projectManagementNoResultsTitle => 'Aucun résultat';

  @override
  String get projectManagementNoResultsMessage =>
      'Aucun projet ne correspond à ces filtres.';

  @override
  String get projectManagementNewProject => 'Nouveau projet';

  @override
  String get projectManagementSearchHint => 'Rechercher un projet…';

  @override
  String get projectManagementSortLabel => 'Trier par';

  @override
  String get projectManagementSortName => 'Nom';

  @override
  String get projectManagementSortDueDate => 'Échéance';

  @override
  String get projectManagementSortPriority => 'Priorité';

  @override
  String get projectManagementSortCreatedAt => 'Date de création';

  @override
  String get projectManagementFavoritesOnly => 'Favoris uniquement';

  @override
  String get projectManagementAllCategories => 'Toutes les catégories';

  @override
  String get projectManagementNoCategory => 'Sans catégorie';

  @override
  String get projectManagementNewCategory => 'Nouvelle catégorie';

  @override
  String get projectManagementCategoryNameHint => 'Nom de la catégorie';

  @override
  String get projectManagementCategoryLabel => 'Catégorie';

  @override
  String get projectManagementPriorityLabel => 'Priorité';

  @override
  String get projectManagementPriorityLow => 'Faible';

  @override
  String get projectManagementPriorityMedium => 'Moyenne';

  @override
  String get projectManagementPriorityHigh => 'Élevée';

  @override
  String get projectManagementPriorityUrgent => 'Urgente';

  @override
  String get projectManagementAllPriorities => 'Toutes les priorités';

  @override
  String get projectManagementNameLabel => 'Nom';

  @override
  String get projectManagementDescriptionLabel => 'Description';

  @override
  String get projectManagementDueDateLabel => 'Date d\'échéance';

  @override
  String get projectManagementNoDueDate => 'Aucune échéance';

  @override
  String get projectManagementPickDate => 'Choisir une date';

  @override
  String get projectManagementClearDate => 'Effacer la date';

  @override
  String get projectManagementCreateProjectTitle => 'Créer un projet';

  @override
  String get projectManagementEditProjectTitle => 'Modifier le projet';

  @override
  String get projectManagementDeleteProjectTitle => 'Supprimer le projet';

  @override
  String get projectManagementDeleteProjectMessage =>
      'Cette action supprimera définitivement le projet et toutes ses tâches.';

  @override
  String get projectManagementTasksTitle => 'Tâches';

  @override
  String get projectManagementNewTask => 'Nouvelle tâche';

  @override
  String get projectManagementEditTaskTitle => 'Modifier la tâche';

  @override
  String get projectManagementDeleteTaskTitle => 'Supprimer la tâche';

  @override
  String get projectManagementDeleteTaskMessage =>
      'Cette action supprimera définitivement cette tâche.';

  @override
  String get projectManagementTaskTitleLabel => 'Titre';

  @override
  String get projectManagementChecklistTitle => 'Checklist';

  @override
  String get projectManagementAddChecklistItemHint => 'Ajouter un élément…';

  @override
  String get projectManagementNoTasksYet => 'Aucune tâche pour ce projet.';

  @override
  String projectManagementTasksCompletedCount(int done, int total) {
    return '$done sur $total tâches terminées';
  }

  @override
  String get projectManagementDeleteCategoryTitle => 'Supprimer la catégorie';

  @override
  String get projectManagementDeleteCategoryMessage =>
      'Les projets de cette catégorie deviendront sans catégorie.';

  @override
  String get projectManagementFavoriteTooltip => 'Ajouter aux favoris';

  @override
  String get projectManagementUnfavoriteTooltip => 'Retirer des favoris';

  @override
  String projectManagementProjectsCount(int count) {
    return '$count projets';
  }

  @override
  String get projectManagementStatusTodo => 'À faire';

  @override
  String get projectManagementStatusInProgress => 'En cours';

  @override
  String get projectManagementStatusDone => 'Terminé';

  @override
  String get projectManagementTagsLabel => 'Tags';

  @override
  String get projectManagementTagsHint =>
      'Ajouter un tag et appuyer sur Entrée';

  @override
  String get projectManagementAllTags => 'Tous les tags';

  @override
  String get projectManagementFolderLabel => 'Dossier';

  @override
  String get projectManagementNoFolder => 'Aucun dossier';

  @override
  String get projectManagementFoldersTitle => 'Dossiers';

  @override
  String get projectManagementAllProjects => 'Tous les projets';

  @override
  String get projectManagementNewFolderTitle => 'Nouveau dossier';

  @override
  String get projectManagementRenameFolderTitle => 'Renommer le dossier';

  @override
  String get projectManagementFolderNameLabel => 'Nom du dossier';

  @override
  String get projectManagementNewSubfolder => 'Nouveau sous-dossier';

  @override
  String get projectManagementDeleteFolderTitle => 'Supprimer le dossier';

  @override
  String get projectManagementDeleteFolderMessage =>
      'Les sous-dossiers et projets qu\'il contient seront déplacés à la racine.';

  @override
  String get projectManagementViewList => 'Liste';

  @override
  String get projectManagementViewKanban => 'Kanban';

  @override
  String get projectManagementViewCalendar => 'Calendrier';

  @override
  String get projectManagementNoEventsOnDay => 'Aucun événement ce jour-là.';

  @override
  String get secureVaultEmptyTitle => 'Le coffre est vide';

  @override
  String get secureVaultEmptyMessage =>
      'Ajoutez votre premier élément pour commencer.';

  @override
  String get secureVaultNoResultsTitle => 'Aucun résultat';

  @override
  String get secureVaultNoResultsMessage =>
      'Aucun élément ne correspond à ces filtres.';

  @override
  String get secureVaultSearchHint => 'Rechercher dans le coffre…';

  @override
  String get secureVaultSortLabel => 'Trier par';

  @override
  String get secureVaultSortTitle => 'Titre';

  @override
  String get secureVaultSortCreatedAt => 'Date de création';

  @override
  String get secureVaultSortType => 'Type';

  @override
  String get secureVaultFavoritesOnly => 'Favoris uniquement';

  @override
  String get secureVaultAllFolders => 'Tous les dossiers';

  @override
  String get secureVaultNoFolder => 'Sans dossier';

  @override
  String get secureVaultNewFolder => 'Nouveau dossier';

  @override
  String get secureVaultFolderNameHint => 'Nom du dossier';

  @override
  String get secureVaultFolderLabel => 'Dossier';

  @override
  String get secureVaultAllTypes => 'Tous les types';

  @override
  String get secureVaultTypeSecureNote => 'Note sécurisée';

  @override
  String get secureVaultTypePassword => 'Mot de passe';

  @override
  String get secureVaultTypeApiKey => 'Clé API';

  @override
  String get secureVaultTypeCard => 'Carte';

  @override
  String get secureVaultTypeDocument => 'Document';

  @override
  String get secureVaultNewItem => 'Nouvel élément';

  @override
  String get secureVaultTitleLabel => 'Titre';

  @override
  String get secureVaultContentLabel => 'Contenu';

  @override
  String get secureVaultUsernameLabel => 'Identifiant';

  @override
  String get secureVaultPasswordLabel => 'Mot de passe';

  @override
  String get secureVaultUrlLabel => 'Site web';

  @override
  String get secureVaultServiceLabel => 'Service';

  @override
  String get secureVaultApiKeyLabel => 'Clé API';

  @override
  String get secureVaultCardholderLabel => 'Titulaire de la carte';

  @override
  String get secureVaultCardNumberLabel => 'Numéro de carte';

  @override
  String get secureVaultExpiryLabel => 'Expiration (MM/AA)';

  @override
  String get secureVaultCvvLabel => 'CVV';

  @override
  String get secureVaultFileNameLabel => 'Nom du fichier';

  @override
  String get secureVaultNotesLabel => 'Notes';

  @override
  String get secureVaultNewSecureNoteTitle => 'Nouvelle note sécurisée';

  @override
  String get secureVaultEditSecureNoteTitle => 'Modifier la note';

  @override
  String get secureVaultNewPasswordTitle => 'Nouveau mot de passe';

  @override
  String get secureVaultEditPasswordTitle => 'Modifier le mot de passe';

  @override
  String get secureVaultNewApiKeyTitle => 'Nouvelle clé API';

  @override
  String get secureVaultEditApiKeyTitle => 'Modifier la clé API';

  @override
  String get secureVaultNewCardTitle => 'Nouvelle carte';

  @override
  String get secureVaultEditCardTitle => 'Modifier la carte';

  @override
  String get secureVaultNewDocumentTitle => 'Nouveau document';

  @override
  String get secureVaultEditDocumentTitle => 'Modifier le document';

  @override
  String get secureVaultDeleteItemTitle => 'Supprimer l\'élément';

  @override
  String get secureVaultDeleteItemMessage =>
      'Cette action supprimera définitivement cet élément.';

  @override
  String get secureVaultDeleteFolderTitle => 'Supprimer le dossier';

  @override
  String get secureVaultDeleteFolderMessage =>
      'Les éléments de ce dossier deviendront sans dossier.';

  @override
  String get secureVaultFavoriteTooltip => 'Ajouter aux favoris';

  @override
  String get secureVaultUnfavoriteTooltip => 'Retirer des favoris';

  @override
  String get secureVaultRevealTooltip => 'Afficher';

  @override
  String get secureVaultHideTooltip => 'Masquer';

  @override
  String get secureVaultCopyTooltip => 'Copier';

  @override
  String get secureVaultCopiedMessage => 'Copié dans le presse-papiers.';

  @override
  String get secureVaultEncryptedAtRestTooltip => 'Chiffré au repos (AES-256)';

  @override
  String get secureVaultBiometricPromptReason =>
      'Authentifiez-vous pour ouvrir le coffre';

  @override
  String get secureVaultLockedTitle => 'Coffre verrouillé';

  @override
  String get secureVaultUnlockButton => 'Déverrouiller';

  @override
  String secureVaultItemsCount(int count) {
    return '$count éléments';
  }

  @override
  String get cyberWorkspaceToolIpAnalysis => 'Analyse d\'hôte';

  @override
  String get cyberWorkspaceToolUrlAnalysis => 'Analyse URL';

  @override
  String get cyberWorkspaceToolPortScan => 'Scanner de ports';

  @override
  String get cyberWorkspaceToolTerminal => 'Terminal';

  @override
  String get cyberWorkspaceIpAddressLabel => 'Hôte ou adresse IP';

  @override
  String get cyberWorkspaceAnalyzeAction => 'Analyser';

  @override
  String get cyberWorkspaceResolvedAddressesLabel => 'Adresses résolues';

  @override
  String get cyberWorkspaceNoAddressesResolved => 'Aucune adresse résolue';

  @override
  String get cyberWorkspaceReachableLabel => 'Joignable';

  @override
  String get cyberWorkspaceUnreachableLabel => 'Injoignable';

  @override
  String cyberWorkspaceResponseTimeLabel(int ms) {
    return '$ms ms';
  }

  @override
  String get cyberWorkspaceUrlLabel => 'URL';

  @override
  String get cyberWorkspaceUrlInvalidMessage => 'URL invalide';

  @override
  String get cyberWorkspaceSchemeLabel => 'Protocole';

  @override
  String get cyberWorkspaceHostLabel => 'Hôte';

  @override
  String get cyberWorkspaceScanAction => 'Scanner';

  @override
  String cyberWorkspacePortsOpenCount(int open, int total) {
    return '$open sur $total ports ouverts';
  }

  @override
  String get cyberWorkspaceTerminalHint =>
      'Tapez « help » pour voir les commandes disponibles.';

  @override
  String get cyberWorkspaceTerminalInputHint => 'Entrez une commande…';

  @override
  String get cyberWorkspaceFavoritesOnly => 'Favoris uniquement';

  @override
  String get cyberWorkspaceAllTools => 'Tous les outils';

  @override
  String get cyberWorkspaceTabDashboard => 'Tableau de bord';

  @override
  String get cyberWorkspaceTabTools => 'Outils réseau';

  @override
  String get cyberWorkspaceTabTerminal => 'Terminal';

  @override
  String get cyberWorkspaceTabHistory => 'Historique';

  @override
  String get cyberWorkspaceTabDevice => 'Appareil';

  @override
  String get cyberWorkspaceDashboardTitle => 'Aperçu';

  @override
  String get cyberWorkspaceStatTotalRuns => 'Analyses effectuées';

  @override
  String get cyberWorkspaceStatFavorites => 'Favoris';

  @override
  String get cyberWorkspaceQuickActionsTitle => 'Accès rapide';

  @override
  String get cyberWorkspaceClearHistory => 'Vider l\'historique';

  @override
  String get cyberWorkspaceEmptyHistoryTitle => 'Aucun historique';

  @override
  String get cyberWorkspaceEmptyHistoryMessage =>
      'Les analyses effectuées apparaîtront ici.';

  @override
  String get cyberWorkspaceSensorsTitle => 'Capteurs';

  @override
  String get cyberWorkspaceAccelerometerLabel => 'Accéléromètre';

  @override
  String get cyberWorkspaceGyroscopeLabel => 'Gyroscope';

  @override
  String get cyberWorkspaceMagnetometerLabel => 'Magnétomètre';

  @override
  String get cyberWorkspaceFlashlightTitle => 'Lampe torche';

  @override
  String get cyberWorkspaceFlashlightUnavailableMessage =>
      'Lampe torche indisponible sur cet appareil.';

  @override
  String get cyberWorkspaceFlashlightOnButton => 'Allumer';

  @override
  String get cyberWorkspaceFlashlightOffButton => 'Éteindre';

  @override
  String get cyberWorkspaceFlashlightStrobeButton => 'Stroboscope';

  @override
  String get cyberWorkspaceFlashlightStopStrobeButton =>
      'Arrêter le stroboscope';

  @override
  String get cyberWorkspaceQrToolTitle => 'Outil QR code';

  @override
  String get cyberWorkspaceQrScanLabel => 'Scanner un code';

  @override
  String get cyberWorkspaceQrStartScanButton => 'Démarrer le scan';

  @override
  String cyberWorkspaceQrScannedValueLabel(String value) {
    return 'Valeur scannée : $value';
  }

  @override
  String get cyberWorkspaceQrGenerateLabel => 'Générer un code';

  @override
  String get cyberWorkspaceQrTextToEncodeLabel => 'Texte à encoder';

  @override
  String get cyberWorkspaceBleScannerTitle => 'Scanner Bluetooth (BLE)';

  @override
  String get cyberWorkspaceBleUnsupportedMessage =>
      'Le Bluetooth Low Energy n\'est pas pris en charge sur cet appareil.';

  @override
  String get cyberWorkspaceBleStartScanButton => 'Démarrer le scan';

  @override
  String get cyberWorkspaceBleStopScanButton => 'Arrêter le scan';

  @override
  String get cyberWorkspaceBleNoDevicesMessage =>
      'Aucun appareil détecté pour le moment.';

  @override
  String get cyberWorkspaceBleUnknownDeviceLabel => 'Appareil inconnu';

  @override
  String get cyberWorkspaceGpsTitle => 'GPS';

  @override
  String get cyberWorkspaceGpsStartButton => 'Démarrer le suivi';

  @override
  String get cyberWorkspaceGpsStopButton => 'Arrêter le suivi';

  @override
  String get cyberWorkspaceGpsNoFixMessage => 'Aucune position pour le moment.';

  @override
  String get cyberWorkspaceGpsServiceDisabledMessage =>
      'Le service de localisation est désactivé sur cet appareil.';

  @override
  String get cyberWorkspaceGpsPermissionDeniedMessage =>
      'Permission de localisation refusée.';

  @override
  String get cyberWorkspaceGpsLatitudeLabel => 'Latitude';

  @override
  String get cyberWorkspaceGpsLongitudeLabel => 'Longitude';

  @override
  String get cyberWorkspaceGpsAccuracyLabel => 'Précision';

  @override
  String get cyberWorkspaceGpsAltitudeLabel => 'Altitude';

  @override
  String get cyberWorkspaceGpsSpeedLabel => 'Vitesse';

  @override
  String get cyberWorkspaceNfcTitle => 'Lecteur NFC / badge';

  @override
  String get cyberWorkspaceNfcSubtitle =>
      'Lecture seule : identifie l\'UID d\'un badge ou tag NFC, sans cloner ni contourner un contrôle d\'accès.';

  @override
  String get cyberWorkspaceNfcScanButton => 'Scanner un tag';

  @override
  String get cyberWorkspaceNfcStopButton => 'Arrêter';

  @override
  String get cyberWorkspaceNfcUnavailableMessage =>
      'NFC indisponible ou désactivé sur cet appareil.';

  @override
  String get cyberWorkspaceNfcNoTagMessage =>
      'Aucun tag scanné pour le moment.';

  @override
  String cyberWorkspaceNfcUidLabel(String uid) {
    return 'UID : $uid';
  }

  @override
  String cyberWorkspaceNfcTechListLabel(String techs) {
    return 'Technologies : $techs';
  }

  @override
  String get cyberWorkspaceSerialTitle => 'Console série USB';

  @override
  String get cyberWorkspaceSerialSubtitle =>
      'Connexion série réelle à un Arduino/ESP32 via câble USB-OTG : envoyez des commandes ou lisez les données d\'un capteur externe.';

  @override
  String get cyberWorkspaceSerialRefreshButton => 'Rechercher les appareils';

  @override
  String get cyberWorkspaceSerialNoDevicesMessage =>
      'Aucun appareil USB détecté. Branchez un câble USB-OTG.';

  @override
  String get cyberWorkspaceSerialConnectButton => 'Connecter';

  @override
  String get cyberWorkspaceSerialConnectFailedMessage =>
      'Échec de la connexion à l\'appareil.';

  @override
  String get cyberWorkspaceSerialConnectedMessage => 'Connecté (9600 bauds)';

  @override
  String get cyberWorkspaceSerialDisconnectButton => 'Déconnecter';

  @override
  String get cyberWorkspaceSerialCommandHint =>
      'Commande à envoyer (ex. LED_ON)';

  @override
  String get creation2dToolSelect => 'Sélection';

  @override
  String get creation2dToolBrush => 'Pinceau';

  @override
  String get creation2dToolEraser => 'Gomme';

  @override
  String get creation2dToolLine => 'Ligne';

  @override
  String get creation2dToolRectangle => 'Rectangle';

  @override
  String get creation2dToolEllipse => 'Ellipse';

  @override
  String get creation2dToolText => 'Texte';

  @override
  String get creation2dUndo => 'Annuler';

  @override
  String get creation2dClearLayer => 'Vider le calque';

  @override
  String get creation2dExport => 'Exporter';

  @override
  String creation2dExportedMessage(String fileName) {
    return 'Image exportée : $fileName';
  }

  @override
  String get creation2dLayersTitle => 'Calques';

  @override
  String get creation2dAddLayer => 'Ajouter un calque';

  @override
  String get creation2dDuplicateLayer => 'Dupliquer le calque';

  @override
  String get creation2dBlendModeNormal => 'Normal';

  @override
  String get creation2dBlendModeMultiply => 'Produit';

  @override
  String get creation2dBlendModeScreen => 'Écran';

  @override
  String get creation2dBlendModeOverlay => 'Incrustation';

  @override
  String get creation2dBlendModeDarken => 'Obscurcir';

  @override
  String get creation2dBlendModeLighten => 'Éclaircir';

  @override
  String get creation2dRenameLayerTitle => 'Renommer le calque';

  @override
  String get creation2dAddTextTitle => 'Ajouter du texte';

  @override
  String creation2dNewLayerName(int number) {
    return 'Calque $number';
  }

  @override
  String get creation3dTypeCube => 'Cube';

  @override
  String get creation3dTypeSphere => 'Sphère';

  @override
  String get creation3dTypeCylinder => 'Cylindre';

  @override
  String get creation3dTypeCone => 'Cône';

  @override
  String get creation3dTypePlane => 'Plan';

  @override
  String get creation3dTypeLight => 'Lumière';

  @override
  String get creation3dTypeCamera => 'Caméra';

  @override
  String get creation3dMaterialMatte => 'Mat';

  @override
  String get creation3dMaterialMetallic => 'Métallique';

  @override
  String get creation3dMaterialGlass => 'Verre';

  @override
  String get creation3dMaterialEmissive => 'Émissif';

  @override
  String get creation3dAssetsTitle => 'Objets disponibles';

  @override
  String get creation3dDuplicateObject => 'Dupliquer';

  @override
  String get creation3dObjectNameLabel => 'Nom';

  @override
  String get creation3dPositionLabel => 'Position';

  @override
  String get creation3dRotationLabel => 'Rotation';

  @override
  String get creation3dScaleLabel => 'Échelle';

  @override
  String get creation3dMaterialLabel => 'Matériau';

  @override
  String get creation3dLightIntensityLabel => 'Intensité de la lumière';

  @override
  String get creation3dCameraFovLabel => 'Champ de vision de la caméra';

  @override
  String get creation3dViewportHintLabel =>
      'Glisser : orbiter • Pincer : zoomer • Toucher : sélectionner';

  @override
  String get creation3dExportScene => 'Exporter la scène';

  @override
  String creation3dSceneExportedMessage(String fileName) {
    return 'Scène exportée : $fileName';
  }

  @override
  String get creation3dNoSelectionTitle => 'Aucun objet sélectionné';

  @override
  String get creation3dNoSelectionMessage =>
      'Sélectionnez un objet dans la scène pour modifier ses propriétés.';

  @override
  String get userProfileEditTooltip => 'Modifier le profil';

  @override
  String get userProfileEditTitle => 'Modifier le profil';

  @override
  String get userProfileAvatarLabel => 'Avatar';

  @override
  String get userProfileAvatarColorLabel => 'Couleur de l\'avatar';

  @override
  String get userProfileFirstNameLabel => 'Prénom';

  @override
  String get userProfileLastNameLabel => 'Nom';

  @override
  String get userProfileUsernameLabel => 'Pseudo';

  @override
  String get userProfileBioLabel => 'Bio';

  @override
  String get userProfileBioHint => 'Parlez un peu de vous…';

  @override
  String get userProfileNoBio => 'Aucune bio pour le moment.';

  @override
  String get userProfileNoName => 'Utilisateur';

  @override
  String get userProfileCountryLabel => 'Pays';

  @override
  String get userProfileCountryNone => 'Non renseigné';

  @override
  String get userProfileCountryFrance => 'France';

  @override
  String get userProfileCountryBelgium => 'Belgique';

  @override
  String get userProfileCountrySwitzerland => 'Suisse';

  @override
  String get userProfileCountryCanada => 'Canada';

  @override
  String get userProfileCountryUnitedStates => 'États-Unis';

  @override
  String get userProfileCountryUnitedKingdom => 'Royaume-Uni';

  @override
  String get userProfileCountryGermany => 'Allemagne';

  @override
  String get userProfileCountrySpain => 'Espagne';

  @override
  String get userProfileCountryItaly => 'Italie';

  @override
  String get userProfileCountryMorocco => 'Maroc';

  @override
  String get userProfileCountryAlgeria => 'Algérie';

  @override
  String get userProfileCountryTunisia => 'Tunisie';

  @override
  String get userProfileCountrySenegal => 'Sénégal';

  @override
  String get userProfileCountryIvoryCoast => 'Côte d\'Ivoire';

  @override
  String get userProfileCountryOther => 'Autre';

  @override
  String userProfileMemberSinceLabel(String date) {
    return 'Membre depuis $date';
  }

  @override
  String get userProfilePrivacyTitle => 'Confidentialité';

  @override
  String get userProfileLocalOnlyNote =>
      'Ce profil est local par défaut : aucune donnée n\'est envoyée à un serveur tant que vous ne connectez pas de compte cloud ci-dessous.';

  @override
  String get userProfileCloudTitle => 'Compte cloud';

  @override
  String get userProfileCloudDescription =>
      'Optionnel : connectez un compte pour sauvegarder et restaurer votre profil sur Firebase depuis n\'importe quel appareil.';

  @override
  String get userProfileCloudEmailLabel => 'Email';

  @override
  String get userProfileCloudPasswordLabel => 'Mot de passe';

  @override
  String get userProfileCloudSignInButton => 'Se connecter';

  @override
  String get userProfileCloudSignUpButton => 'Créer un compte';

  @override
  String get userProfileCloudForgotPasswordButton => 'Mot de passe oublié ?';

  @override
  String get userProfileCloudSignOutButton => 'Se déconnecter';

  @override
  String userProfileCloudSignedInAs(String email) {
    return 'Connecté en tant que $email';
  }

  @override
  String get userProfileCloudMissingFieldsMessage =>
      'Renseignez un email et un mot de passe.';

  @override
  String get userProfileCloudPasswordResetSentMessage =>
      'Email de réinitialisation envoyé.';

  @override
  String userProfileCloudErrorGeneric(String error) {
    return 'Une erreur est survenue : $error';
  }

  @override
  String get settingsProfileTitle => 'Profil';

  @override
  String get settingsLanguageTitle => 'Langue';

  @override
  String get settingsThemeTitle => 'Thème';

  @override
  String get settingsAppearanceTitle => 'Apparence';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsBackupTitle => 'Sauvegardes';

  @override
  String get settingsSecurityTitle => 'Sécurité';

  @override
  String get settingsPrivacyTitle => 'Confidentialité';

  @override
  String get settingsStorageTitle => 'Stockage';

  @override
  String get settingsAiTitle => 'IA';

  @override
  String get settingsAppInfoTitle => 'Informations sur l\'application';

  @override
  String get settingsDisplayNameLabel => 'Nom affiché';

  @override
  String get settingsDisplayNameHint => 'Votre nom';

  @override
  String get settingsEditDisplayNameTooltip => 'Modifier le nom';

  @override
  String get settingsNoDisplayName => 'Utilisateur';

  @override
  String get settingsLanguageSystem => 'Système';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsLanguageEnglish => 'Anglais';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsTextScaleSmall => 'Petit';

  @override
  String get settingsTextScaleMedium => 'Moyen';

  @override
  String get settingsTextScaleLarge => 'Grand';

  @override
  String get settingsNotificationsEnabledLabel => 'Activer les notifications';

  @override
  String get settingsNotificationsSoundLabel => 'Son des notifications';

  @override
  String get settingsNotificationsPermissionDeniedMessage =>
      'Autorisation de notifications refusée. Activez-la dans les paramètres du téléphone.';

  @override
  String get settingsNotificationsErrorMessage =>
      'Impossible de mettre à jour les notifications. Réessayez plus tard.';

  @override
  String get settingsBackupNeverLabel => 'Aucune sauvegarde effectuée';

  @override
  String settingsBackupLastLabel(String date) {
    return 'Dernière sauvegarde : $date';
  }

  @override
  String get settingsBackupButton => 'Sauvegarder maintenant';

  @override
  String get settingsRestoreButton => 'Restaurer';

  @override
  String get settingsBackupSuccessMessage => 'Profil sauvegardé sur le cloud.';

  @override
  String get settingsBackupSignInRequiredMessage =>
      'Connectez un compte cloud depuis Profil pour sauvegarder ou restaurer.';

  @override
  String get settingsBackupFailedMessage =>
      'L\'opération a échoué. Réessayez plus tard.';

  @override
  String get settingsRestoreSuccessMessage =>
      'Profil restauré depuis le cloud.';

  @override
  String get settingsRestoreNotFoundMessage =>
      'Aucune sauvegarde trouvée sur le cloud.';

  @override
  String get settingsBiometricLockLabel => 'Verrouillage biométrique';

  @override
  String get settingsBiometricUnavailableMessage =>
      'Non disponible sur cet appareil pour le moment.';

  @override
  String get settingsPinCodeLabel => 'Code PIN';

  @override
  String get settingsAnalyticsLabel => 'Partager les données d\'utilisation';

  @override
  String get settingsPrivacyNote =>
      'Aucune donnée ne quitte cet appareil : il n\'y a pas encore de serveur ni d\'analytique réelle.';

  @override
  String get settingsStorageUsageLabel => 'Utilisation simulée';

  @override
  String get settingsClearCacheButton => 'Vider le cache';

  @override
  String get settingsClearCacheConfirmTitle => 'Vider le cache';

  @override
  String get settingsClearCacheConfirmMessage =>
      'Cette action est simulée : aucune donnée réelle n\'est stockée sur le disque pour le moment.';

  @override
  String get settingsClearCacheDoneMessage => 'Cache vidé (simulé).';

  @override
  String get settingsAiProviderLabel => 'Fournisseur IA';

  @override
  String get settingsAiProviderSimulatedValue => 'Simulé (local)';

  @override
  String get settingsAiProviderCustomValue =>
      'Personnalisé (compatible OpenAI)';

  @override
  String get settingsAiEndpointLabel => 'URL du endpoint';

  @override
  String get settingsAiEndpointHint =>
      'ex. http://localhost:11434/v1 ou https://openrouter.ai/api/v1';

  @override
  String get settingsAiModelLabel => 'Modèle';

  @override
  String get settingsAiModelHint => 'ex. llama3, gpt-4o-mini';

  @override
  String get settingsAiApiKeyLabel => 'Clé API personnelle';

  @override
  String get settingsAiApiKeyHint =>
      'Coller votre clé API (optionnelle pour un serveur local)';

  @override
  String get settingsAiApiKeySavedMessage =>
      'Clé API enregistrée (en mémoire uniquement).';

  @override
  String get settingsAiApiKeyNote =>
      'Non stockée de façon sécurisée pour le moment — à venir avec le vrai stockage sécurisé.';

  @override
  String get settingsAppVersionLabel => 'Version';

  @override
  String get settingsAppBuildLabel => 'Build';

  @override
  String get settingsAppBuiltWith => 'Construit avec Flutter';

  @override
  String get settingsCheckForUpdateButton => 'Vérifier les mises à jour';

  @override
  String get settingsUpdateCheckFailedMessage =>
      'Impossible de vérifier pour le moment (pas de version publiée ou pas de réseau).';

  @override
  String get settingsUpToDateMessage => 'L\'application est à jour.';

  @override
  String settingsUpdateAvailableMessage(String version) {
    return 'Nouvelle version disponible : $version';
  }

  @override
  String get settingsOpenReleaseButton => 'Voir la version sur GitHub';
}
