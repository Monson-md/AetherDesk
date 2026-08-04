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
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('fr'),
  ];

  /// Nom affiché de l'application
  ///
  /// In fr, this message translates to:
  /// **'AetherDesk'**
  String get appTitle;

  /// No description provided for @navDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get navDashboard;

  /// No description provided for @navAiAssistant.
  ///
  /// In fr, this message translates to:
  /// **'Assistant IA'**
  String get navAiAssistant;

  /// No description provided for @navCodeEditor.
  ///
  /// In fr, this message translates to:
  /// **'Éditeur de code'**
  String get navCodeEditor;

  /// No description provided for @navProjectManagement.
  ///
  /// In fr, this message translates to:
  /// **'Gestion de projets'**
  String get navProjectManagement;

  /// No description provided for @navSecureVault.
  ///
  /// In fr, this message translates to:
  /// **'Vault sécurisé'**
  String get navSecureVault;

  /// No description provided for @navCyberWorkspace.
  ///
  /// In fr, this message translates to:
  /// **'Cyber Workspace'**
  String get navCyberWorkspace;

  /// No description provided for @navCreation2d.
  ///
  /// In fr, this message translates to:
  /// **'Création 2D'**
  String get navCreation2d;

  /// No description provided for @navCreation3d.
  ///
  /// In fr, this message translates to:
  /// **'Création 3D'**
  String get navCreation3d;

  /// No description provided for @navSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get navSettings;

  /// No description provided for @navUserProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navUserProfile;

  /// No description provided for @comingSoonTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt disponible'**
  String get comingSoonTitle;

  /// No description provided for @comingSoonMessage.
  ///
  /// In fr, this message translates to:
  /// **'Ce module est en cours de construction.'**
  String get comingSoonMessage;

  /// No description provided for @commonRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get commonConfirm;

  /// No description provided for @commonSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get commonSave;

  /// No description provided for @errorGenericTitle.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get errorGenericTitle;

  /// No description provided for @errorGenericMessage.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez réessayer plus tard.'**
  String get errorGenericMessage;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Comment puis-je vous aider ?'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Posez une question ou choisissez une suggestion pour commencer.'**
  String get chatEmptyMessage;

  /// No description provided for @chatSuggestionGenerateCode.
  ///
  /// In fr, this message translates to:
  /// **'Générer du code'**
  String get chatSuggestionGenerateCode;

  /// No description provided for @chatSuggestionDebug.
  ///
  /// In fr, this message translates to:
  /// **'Déboguer un programme'**
  String get chatSuggestionDebug;

  /// No description provided for @chatSuggestionExplain.
  ///
  /// In fr, this message translates to:
  /// **'Expliquer un concept'**
  String get chatSuggestionExplain;

  /// No description provided for @chatSuggestionPlan.
  ///
  /// In fr, this message translates to:
  /// **'Planifier un projet'**
  String get chatSuggestionPlan;

  /// No description provided for @chatInputHint.
  ///
  /// In fr, this message translates to:
  /// **'Écrivez un message…'**
  String get chatInputHint;

  /// No description provided for @chatSendTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get chatSendTooltip;

  /// No description provided for @chatThinking.
  ///
  /// In fr, this message translates to:
  /// **'L\'IA réfléchit…'**
  String get chatThinking;

  /// No description provided for @codeEditorNewFile.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau fichier'**
  String get codeEditorNewFile;

  /// No description provided for @codeEditorOpen.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir'**
  String get codeEditorOpen;

  /// No description provided for @codeEditorSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get codeEditorSave;

  /// No description provided for @codeEditorCopy.
  ///
  /// In fr, this message translates to:
  /// **'Copier'**
  String get codeEditorCopy;

  /// No description provided for @codeEditorClear.
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get codeEditorClear;

  /// No description provided for @codeEditorEmptyHint.
  ///
  /// In fr, this message translates to:
  /// **'Commencez à écrire votre code ici…'**
  String get codeEditorEmptyHint;

  /// No description provided for @codeEditorOpenPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Ouverture de fichiers disponible prochainement.'**
  String get codeEditorOpenPlaceholder;

  /// No description provided for @codeEditorSavePlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement disponible prochainement.'**
  String get codeEditorSavePlaceholder;

  /// No description provided for @codeEditorCopiedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Code copié dans le presse-papiers.'**
  String get codeEditorCopiedMessage;

  /// No description provided for @codeEditorLinesCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} lignes'**
  String codeEditorLinesCount(int count);

  /// No description provided for @codeEditorCharsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} caractères'**
  String codeEditorCharsCount(int count);

  /// No description provided for @codeEditorWordsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} mots'**
  String codeEditorWordsCount(int count);

  /// No description provided for @projectManagementEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun projet'**
  String get projectManagementEmptyTitle;

  /// No description provided for @projectManagementEmptyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Créez votre premier projet pour commencer.'**
  String get projectManagementEmptyMessage;

  /// No description provided for @projectManagementNoResultsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get projectManagementNoResultsTitle;

  /// No description provided for @projectManagementNoResultsMessage.
  ///
  /// In fr, this message translates to:
  /// **'Aucun projet ne correspond à ces filtres.'**
  String get projectManagementNoResultsMessage;

  /// No description provided for @projectManagementNewProject.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau projet'**
  String get projectManagementNewProject;

  /// No description provided for @projectManagementSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un projet…'**
  String get projectManagementSearchHint;

  /// No description provided for @projectManagementSortLabel.
  ///
  /// In fr, this message translates to:
  /// **'Trier par'**
  String get projectManagementSortLabel;

  /// No description provided for @projectManagementSortName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get projectManagementSortName;

  /// No description provided for @projectManagementSortDueDate.
  ///
  /// In fr, this message translates to:
  /// **'Échéance'**
  String get projectManagementSortDueDate;

  /// No description provided for @projectManagementSortPriority.
  ///
  /// In fr, this message translates to:
  /// **'Priorité'**
  String get projectManagementSortPriority;

  /// No description provided for @projectManagementSortCreatedAt.
  ///
  /// In fr, this message translates to:
  /// **'Date de création'**
  String get projectManagementSortCreatedAt;

  /// No description provided for @projectManagementFavoritesOnly.
  ///
  /// In fr, this message translates to:
  /// **'Favoris uniquement'**
  String get projectManagementFavoritesOnly;

  /// No description provided for @projectManagementAllCategories.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les catégories'**
  String get projectManagementAllCategories;

  /// No description provided for @projectManagementNoCategory.
  ///
  /// In fr, this message translates to:
  /// **'Sans catégorie'**
  String get projectManagementNoCategory;

  /// No description provided for @projectManagementNewCategory.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle catégorie'**
  String get projectManagementNewCategory;

  /// No description provided for @projectManagementCategoryNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la catégorie'**
  String get projectManagementCategoryNameHint;

  /// No description provided for @projectManagementCategoryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get projectManagementCategoryLabel;

  /// No description provided for @projectManagementPriorityLabel.
  ///
  /// In fr, this message translates to:
  /// **'Priorité'**
  String get projectManagementPriorityLabel;

  /// No description provided for @projectManagementPriorityLow.
  ///
  /// In fr, this message translates to:
  /// **'Faible'**
  String get projectManagementPriorityLow;

  /// No description provided for @projectManagementPriorityMedium.
  ///
  /// In fr, this message translates to:
  /// **'Moyenne'**
  String get projectManagementPriorityMedium;

  /// No description provided for @projectManagementPriorityHigh.
  ///
  /// In fr, this message translates to:
  /// **'Élevée'**
  String get projectManagementPriorityHigh;

  /// No description provided for @projectManagementPriorityUrgent.
  ///
  /// In fr, this message translates to:
  /// **'Urgente'**
  String get projectManagementPriorityUrgent;

  /// No description provided for @projectManagementAllPriorities.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les priorités'**
  String get projectManagementAllPriorities;

  /// No description provided for @projectManagementNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get projectManagementNameLabel;

  /// No description provided for @projectManagementDescriptionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get projectManagementDescriptionLabel;

  /// No description provided for @projectManagementDueDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'échéance'**
  String get projectManagementDueDateLabel;

  /// No description provided for @projectManagementNoDueDate.
  ///
  /// In fr, this message translates to:
  /// **'Aucune échéance'**
  String get projectManagementNoDueDate;

  /// No description provided for @projectManagementPickDate.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une date'**
  String get projectManagementPickDate;

  /// No description provided for @projectManagementClearDate.
  ///
  /// In fr, this message translates to:
  /// **'Effacer la date'**
  String get projectManagementClearDate;

  /// No description provided for @projectManagementCreateProjectTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un projet'**
  String get projectManagementCreateProjectTitle;

  /// No description provided for @projectManagementEditProjectTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le projet'**
  String get projectManagementEditProjectTitle;

  /// No description provided for @projectManagementDeleteProjectTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le projet'**
  String get projectManagementDeleteProjectTitle;

  /// No description provided for @projectManagementDeleteProjectMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette action supprimera définitivement le projet et toutes ses tâches.'**
  String get projectManagementDeleteProjectMessage;

  /// No description provided for @projectManagementTasksTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tâches'**
  String get projectManagementTasksTitle;

  /// No description provided for @projectManagementNewTask.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle tâche'**
  String get projectManagementNewTask;

  /// No description provided for @projectManagementEditTaskTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la tâche'**
  String get projectManagementEditTaskTitle;

  /// No description provided for @projectManagementDeleteTaskTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la tâche'**
  String get projectManagementDeleteTaskTitle;

  /// No description provided for @projectManagementDeleteTaskMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette action supprimera définitivement cette tâche.'**
  String get projectManagementDeleteTaskMessage;

  /// No description provided for @projectManagementTaskTitleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Titre'**
  String get projectManagementTaskTitleLabel;

  /// No description provided for @projectManagementChecklistTitle.
  ///
  /// In fr, this message translates to:
  /// **'Checklist'**
  String get projectManagementChecklistTitle;

  /// No description provided for @projectManagementAddChecklistItemHint.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un élément…'**
  String get projectManagementAddChecklistItemHint;

  /// No description provided for @projectManagementNoTasksYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucune tâche pour ce projet.'**
  String get projectManagementNoTasksYet;

  /// No description provided for @projectManagementTasksCompletedCount.
  ///
  /// In fr, this message translates to:
  /// **'{done} sur {total} tâches terminées'**
  String projectManagementTasksCompletedCount(int done, int total);

  /// No description provided for @projectManagementDeleteCategoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la catégorie'**
  String get projectManagementDeleteCategoryTitle;

  /// No description provided for @projectManagementDeleteCategoryMessage.
  ///
  /// In fr, this message translates to:
  /// **'Les projets de cette catégorie deviendront sans catégorie.'**
  String get projectManagementDeleteCategoryMessage;

  /// No description provided for @projectManagementFavoriteTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux favoris'**
  String get projectManagementFavoriteTooltip;

  /// No description provided for @projectManagementUnfavoriteTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Retirer des favoris'**
  String get projectManagementUnfavoriteTooltip;

  /// No description provided for @projectManagementProjectsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} projets'**
  String projectManagementProjectsCount(int count);

  /// No description provided for @secureVaultEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le coffre est vide'**
  String get secureVaultEmptyTitle;

  /// No description provided for @secureVaultEmptyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez votre premier élément pour commencer.'**
  String get secureVaultEmptyMessage;

  /// No description provided for @secureVaultNoResultsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get secureVaultNoResultsTitle;

  /// No description provided for @secureVaultNoResultsMessage.
  ///
  /// In fr, this message translates to:
  /// **'Aucun élément ne correspond à ces filtres.'**
  String get secureVaultNoResultsMessage;

  /// No description provided for @secureVaultSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher dans le coffre…'**
  String get secureVaultSearchHint;

  /// No description provided for @secureVaultSortLabel.
  ///
  /// In fr, this message translates to:
  /// **'Trier par'**
  String get secureVaultSortLabel;

  /// No description provided for @secureVaultSortTitle.
  ///
  /// In fr, this message translates to:
  /// **'Titre'**
  String get secureVaultSortTitle;

  /// No description provided for @secureVaultSortCreatedAt.
  ///
  /// In fr, this message translates to:
  /// **'Date de création'**
  String get secureVaultSortCreatedAt;

  /// No description provided for @secureVaultSortType.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get secureVaultSortType;

  /// No description provided for @secureVaultFavoritesOnly.
  ///
  /// In fr, this message translates to:
  /// **'Favoris uniquement'**
  String get secureVaultFavoritesOnly;

  /// No description provided for @secureVaultAllFolders.
  ///
  /// In fr, this message translates to:
  /// **'Tous les dossiers'**
  String get secureVaultAllFolders;

  /// No description provided for @secureVaultNoFolder.
  ///
  /// In fr, this message translates to:
  /// **'Sans dossier'**
  String get secureVaultNoFolder;

  /// No description provided for @secureVaultNewFolder.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau dossier'**
  String get secureVaultNewFolder;

  /// No description provided for @secureVaultFolderNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Nom du dossier'**
  String get secureVaultFolderNameHint;

  /// No description provided for @secureVaultFolderLabel.
  ///
  /// In fr, this message translates to:
  /// **'Dossier'**
  String get secureVaultFolderLabel;

  /// No description provided for @secureVaultAllTypes.
  ///
  /// In fr, this message translates to:
  /// **'Tous les types'**
  String get secureVaultAllTypes;

  /// No description provided for @secureVaultTypeSecureNote.
  ///
  /// In fr, this message translates to:
  /// **'Note sécurisée'**
  String get secureVaultTypeSecureNote;

  /// No description provided for @secureVaultTypePassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get secureVaultTypePassword;

  /// No description provided for @secureVaultTypeApiKey.
  ///
  /// In fr, this message translates to:
  /// **'Clé API'**
  String get secureVaultTypeApiKey;

  /// No description provided for @secureVaultTypeCard.
  ///
  /// In fr, this message translates to:
  /// **'Carte'**
  String get secureVaultTypeCard;

  /// No description provided for @secureVaultTypeDocument.
  ///
  /// In fr, this message translates to:
  /// **'Document'**
  String get secureVaultTypeDocument;

  /// No description provided for @secureVaultNewItem.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel élément'**
  String get secureVaultNewItem;

  /// No description provided for @secureVaultTitleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Titre'**
  String get secureVaultTitleLabel;

  /// No description provided for @secureVaultContentLabel.
  ///
  /// In fr, this message translates to:
  /// **'Contenu'**
  String get secureVaultContentLabel;

  /// No description provided for @secureVaultUsernameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant'**
  String get secureVaultUsernameLabel;

  /// No description provided for @secureVaultPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get secureVaultPasswordLabel;

  /// No description provided for @secureVaultUrlLabel.
  ///
  /// In fr, this message translates to:
  /// **'Site web'**
  String get secureVaultUrlLabel;

  /// No description provided for @secureVaultServiceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Service'**
  String get secureVaultServiceLabel;

  /// No description provided for @secureVaultApiKeyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Clé API'**
  String get secureVaultApiKeyLabel;

  /// No description provided for @secureVaultCardholderLabel.
  ///
  /// In fr, this message translates to:
  /// **'Titulaire de la carte'**
  String get secureVaultCardholderLabel;

  /// No description provided for @secureVaultCardNumberLabel.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de carte'**
  String get secureVaultCardNumberLabel;

  /// No description provided for @secureVaultExpiryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Expiration (MM/AA)'**
  String get secureVaultExpiryLabel;

  /// No description provided for @secureVaultCvvLabel.
  ///
  /// In fr, this message translates to:
  /// **'CVV'**
  String get secureVaultCvvLabel;

  /// No description provided for @secureVaultFileNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom du fichier'**
  String get secureVaultFileNameLabel;

  /// No description provided for @secureVaultNotesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get secureVaultNotesLabel;

  /// No description provided for @secureVaultNewSecureNoteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle note sécurisée'**
  String get secureVaultNewSecureNoteTitle;

  /// No description provided for @secureVaultEditSecureNoteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la note'**
  String get secureVaultEditSecureNoteTitle;

  /// No description provided for @secureVaultNewPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get secureVaultNewPasswordTitle;

  /// No description provided for @secureVaultEditPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le mot de passe'**
  String get secureVaultEditPasswordTitle;

  /// No description provided for @secureVaultNewApiKeyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle clé API'**
  String get secureVaultNewApiKeyTitle;

  /// No description provided for @secureVaultEditApiKeyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la clé API'**
  String get secureVaultEditApiKeyTitle;

  /// No description provided for @secureVaultNewCardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle carte'**
  String get secureVaultNewCardTitle;

  /// No description provided for @secureVaultEditCardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la carte'**
  String get secureVaultEditCardTitle;

  /// No description provided for @secureVaultNewDocumentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau document'**
  String get secureVaultNewDocumentTitle;

  /// No description provided for @secureVaultEditDocumentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le document'**
  String get secureVaultEditDocumentTitle;

  /// No description provided for @secureVaultDeleteItemTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'élément'**
  String get secureVaultDeleteItemTitle;

  /// No description provided for @secureVaultDeleteItemMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette action supprimera définitivement cet élément.'**
  String get secureVaultDeleteItemMessage;

  /// No description provided for @secureVaultDeleteFolderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le dossier'**
  String get secureVaultDeleteFolderTitle;

  /// No description provided for @secureVaultDeleteFolderMessage.
  ///
  /// In fr, this message translates to:
  /// **'Les éléments de ce dossier deviendront sans dossier.'**
  String get secureVaultDeleteFolderMessage;

  /// No description provided for @secureVaultFavoriteTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux favoris'**
  String get secureVaultFavoriteTooltip;

  /// No description provided for @secureVaultUnfavoriteTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Retirer des favoris'**
  String get secureVaultUnfavoriteTooltip;

  /// No description provided for @secureVaultRevealTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Afficher'**
  String get secureVaultRevealTooltip;

  /// No description provided for @secureVaultHideTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Masquer'**
  String get secureVaultHideTooltip;

  /// No description provided for @secureVaultCopyTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Copier'**
  String get secureVaultCopyTooltip;

  /// No description provided for @secureVaultCopiedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Copié dans le presse-papiers.'**
  String get secureVaultCopiedMessage;

  /// No description provided for @secureVaultItemsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} éléments'**
  String secureVaultItemsCount(int count);

  /// No description provided for @settingsProfileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get settingsProfileTitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get settingsThemeTitle;

  /// No description provided for @settingsAppearanceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get settingsAppearanceTitle;

  /// No description provided for @settingsNotificationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsTitle;

  /// No description provided for @settingsBackupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegardes'**
  String get settingsBackupTitle;

  /// No description provided for @settingsSecurityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité'**
  String get settingsSecurityTitle;

  /// No description provided for @settingsPrivacyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Confidentialité'**
  String get settingsPrivacyTitle;

  /// No description provided for @settingsStorageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Stockage'**
  String get settingsStorageTitle;

  /// No description provided for @settingsAiTitle.
  ///
  /// In fr, this message translates to:
  /// **'IA'**
  String get settingsAiTitle;

  /// No description provided for @settingsAppInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations sur l\'application'**
  String get settingsAppInfoTitle;

  /// No description provided for @settingsDisplayNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom affiché'**
  String get settingsDisplayNameLabel;

  /// No description provided for @settingsDisplayNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Votre nom'**
  String get settingsDisplayNameHint;

  /// No description provided for @settingsEditDisplayNameTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le nom'**
  String get settingsEditDisplayNameTooltip;

  /// No description provided for @settingsNoDisplayName.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get settingsNoDisplayName;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageFrench.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get settingsLanguageFrench;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In fr, this message translates to:
  /// **'Anglais'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get settingsThemeDark;

  /// No description provided for @settingsTextScaleSmall.
  ///
  /// In fr, this message translates to:
  /// **'Petit'**
  String get settingsTextScaleSmall;

  /// No description provided for @settingsTextScaleMedium.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get settingsTextScaleMedium;

  /// No description provided for @settingsTextScaleLarge.
  ///
  /// In fr, this message translates to:
  /// **'Grand'**
  String get settingsTextScaleLarge;

  /// No description provided for @settingsNotificationsEnabledLabel.
  ///
  /// In fr, this message translates to:
  /// **'Activer les notifications'**
  String get settingsNotificationsEnabledLabel;

  /// No description provided for @settingsNotificationsSoundLabel.
  ///
  /// In fr, this message translates to:
  /// **'Son des notifications'**
  String get settingsNotificationsSoundLabel;

  /// No description provided for @settingsBackupNeverLabel.
  ///
  /// In fr, this message translates to:
  /// **'Aucune sauvegarde effectuée'**
  String get settingsBackupNeverLabel;

  /// No description provided for @settingsBackupLastLabel.
  ///
  /// In fr, this message translates to:
  /// **'Dernière sauvegarde : {date}'**
  String settingsBackupLastLabel(String date);

  /// No description provided for @settingsBackupButton.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder maintenant'**
  String get settingsBackupButton;

  /// No description provided for @settingsBackupSimulatedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde simulée effectuée (aucun serveur réel).'**
  String get settingsBackupSimulatedMessage;

  /// No description provided for @settingsBiometricLockLabel.
  ///
  /// In fr, this message translates to:
  /// **'Verrouillage biométrique'**
  String get settingsBiometricLockLabel;

  /// No description provided for @settingsBiometricUnavailableMessage.
  ///
  /// In fr, this message translates to:
  /// **'Non disponible sur cet appareil pour le moment.'**
  String get settingsBiometricUnavailableMessage;

  /// No description provided for @settingsPinCodeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code PIN'**
  String get settingsPinCodeLabel;

  /// No description provided for @settingsAnalyticsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Partager les données d\'utilisation'**
  String get settingsAnalyticsLabel;

  /// No description provided for @settingsPrivacyNote.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée ne quitte cet appareil : il n\'y a pas encore de serveur ni d\'analytique réelle.'**
  String get settingsPrivacyNote;

  /// No description provided for @settingsStorageUsageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Utilisation simulée'**
  String get settingsStorageUsageLabel;

  /// No description provided for @settingsClearCacheButton.
  ///
  /// In fr, this message translates to:
  /// **'Vider le cache'**
  String get settingsClearCacheButton;

  /// No description provided for @settingsClearCacheConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vider le cache'**
  String get settingsClearCacheConfirmTitle;

  /// No description provided for @settingsClearCacheConfirmMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est simulée : aucune donnée réelle n\'est stockée sur le disque pour le moment.'**
  String get settingsClearCacheConfirmMessage;

  /// No description provided for @settingsClearCacheDoneMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cache vidé (simulé).'**
  String get settingsClearCacheDoneMessage;

  /// No description provided for @settingsAiProviderLabel.
  ///
  /// In fr, this message translates to:
  /// **'Fournisseur IA'**
  String get settingsAiProviderLabel;

  /// No description provided for @settingsAiProviderValue.
  ///
  /// In fr, this message translates to:
  /// **'Simulé (local)'**
  String get settingsAiProviderValue;

  /// No description provided for @settingsAiApiKeyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Clé API personnelle'**
  String get settingsAiApiKeyLabel;

  /// No description provided for @settingsAiApiKeyHint.
  ///
  /// In fr, this message translates to:
  /// **'Coller votre clé API'**
  String get settingsAiApiKeyHint;

  /// No description provided for @settingsAiApiKeySavedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Clé API enregistrée (en mémoire uniquement).'**
  String get settingsAiApiKeySavedMessage;

  /// No description provided for @settingsAiApiKeyNote.
  ///
  /// In fr, this message translates to:
  /// **'Non stockée de façon sécurisée pour le moment — à venir avec le vrai stockage sécurisé.'**
  String get settingsAiApiKeyNote;

  /// No description provided for @settingsAppVersionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Version'**
  String get settingsAppVersionLabel;

  /// No description provided for @settingsAppBuildLabel.
  ///
  /// In fr, this message translates to:
  /// **'Build'**
  String get settingsAppBuildLabel;

  /// No description provided for @settingsAppBuiltWith.
  ///
  /// In fr, this message translates to:
  /// **'Construit avec Flutter'**
  String get settingsAppBuiltWith;
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
    'that was used.',
  );
}
