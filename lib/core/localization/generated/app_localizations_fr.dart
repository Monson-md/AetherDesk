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
}
