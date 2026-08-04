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
