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
  String get errorGenericTitle => 'Une erreur est survenue';

  @override
  String get errorGenericMessage => 'Veuillez réessayer plus tard.';

  @override
  String get chatEmptyTitle => 'Comment puis-je vous aider ?';

  @override
  String get chatEmptyMessage =>
      'Posez une question ou choisissez une suggestion pour commencer.';

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
  String get codeEditorOpenPlaceholder =>
      'Ouverture de fichiers disponible prochainement.';

  @override
  String get codeEditorSavePlaceholder =>
      'Enregistrement disponible prochainement.';

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
  String get secureVaultEncryptedAtRestTooltip =>
      'Chiffré au repos (simulation)';

  @override
  String secureVaultItemsCount(int count) {
    return '$count éléments';
  }

  @override
  String get cyberWorkspaceToolIpAnalysis => 'Analyse IP';

  @override
  String get cyberWorkspaceToolUrlAnalysis => 'Analyse URL';

  @override
  String get cyberWorkspaceToolPortScan => 'Scanner de ports';

  @override
  String get cyberWorkspaceToolTerminal => 'Terminal';

  @override
  String cyberWorkspaceRiskScore(int score) {
    return 'Score de risque : $score/100';
  }

  @override
  String get cyberWorkspaceIpAddressLabel => 'Adresse IP';

  @override
  String get cyberWorkspaceAnalyzeAction => 'Analyser';

  @override
  String get cyberWorkspaceCountryLabel => 'Pays';

  @override
  String get cyberWorkspaceIspLabel => 'Fournisseur';

  @override
  String get cyberWorkspaceSuspiciousLabel => 'Suspecte';

  @override
  String get cyberWorkspaceUrlLabel => 'URL';

  @override
  String get cyberWorkspaceCategoryLabel => 'Catégorie';

  @override
  String get cyberWorkspaceSafeLabel => 'Sûre';

  @override
  String get cyberWorkspaceUnsafeLabel => 'Non sûre';

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
  String get creation2dLayersTitle => 'Calques';

  @override
  String get creation2dAddLayer => 'Ajouter un calque';

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
  String get creation3dMaterialLabel => 'Matériau (simulé)';

  @override
  String get creation3dLightIntensityLabel => 'Intensité de la lumière';

  @override
  String get creation3dCameraFovLabel => 'Champ de vision de la caméra';

  @override
  String get creation3dSimulatedPreviewLabel =>
      'Aperçu simulé — aucun moteur 3D réel';

  @override
  String get creation3dRenderPreview => 'Générer l\'aperçu';

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
      'Ce profil est entièrement local : aucune donnée n\'est envoyée à un serveur. L\'architecture est prête à se connecter à Firebase plus tard sans changer cet écran.';

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
  String get settingsBackupNeverLabel => 'Aucune sauvegarde effectuée';

  @override
  String settingsBackupLastLabel(String date) {
    return 'Dernière sauvegarde : $date';
  }

  @override
  String get settingsBackupButton => 'Sauvegarder maintenant';

  @override
  String get settingsBackupSimulatedMessage =>
      'Sauvegarde simulée effectuée (aucun serveur réel).';

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
  String get settingsAiProviderValue => 'Simulé (local)';

  @override
  String get settingsAiApiKeyLabel => 'Clé API personnelle';

  @override
  String get settingsAiApiKeyHint => 'Coller votre clé API';

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
}
