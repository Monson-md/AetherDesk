// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AetherDesk';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navAiAssistant => 'AI Assistant';

  @override
  String get navCodeEditor => 'Code Editor';

  @override
  String get navProjectManagement => 'Project Management';

  @override
  String get navSecureVault => 'Secure Vault';

  @override
  String get navCyberWorkspace => 'Cyber Workspace';

  @override
  String get navCreation2d => '2D Creation';

  @override
  String get navCreation3d => '3D Creation';

  @override
  String get navSettings => 'Settings';

  @override
  String get navUserProfile => 'Profile';

  @override
  String get comingSoonTitle => 'Coming soon';

  @override
  String get comingSoonMessage => 'This module is under construction.';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errorGenericMessage => 'Please try again later.';

  @override
  String get chatEmptyTitle => 'How can I help you?';

  @override
  String get chatEmptyMessage =>
      'Ask a question or pick a suggestion to get started.';

  @override
  String get chatSuggestionGenerateCode => 'Generate code';

  @override
  String get chatSuggestionDebug => 'Debug a program';

  @override
  String get chatSuggestionExplain => 'Explain a concept';

  @override
  String get chatSuggestionPlan => 'Plan a project';

  @override
  String get chatInputHint => 'Write a message…';

  @override
  String get chatSendTooltip => 'Send';

  @override
  String get chatThinking => 'The AI is thinking…';

  @override
  String get codeEditorNewFile => 'New file';

  @override
  String get codeEditorOpen => 'Open';

  @override
  String get codeEditorSave => 'Save';

  @override
  String get codeEditorCopy => 'Copy';

  @override
  String get codeEditorClear => 'Clear';

  @override
  String get codeEditorEmptyHint => 'Start writing your code here…';

  @override
  String get codeEditorOpenPlaceholder => 'File opening coming soon.';

  @override
  String get codeEditorSavePlaceholder => 'Saving coming soon.';

  @override
  String get codeEditorCopiedMessage => 'Code copied to clipboard.';

  @override
  String codeEditorLinesCount(int count) {
    return '$count lines';
  }

  @override
  String codeEditorCharsCount(int count) {
    return '$count characters';
  }

  @override
  String codeEditorWordsCount(int count) {
    return '$count words';
  }

  @override
  String get projectManagementEmptyTitle => 'No projects yet';

  @override
  String get projectManagementEmptyMessage =>
      'Create your first project to get started.';

  @override
  String get projectManagementNoResultsTitle => 'No results';

  @override
  String get projectManagementNoResultsMessage =>
      'No projects match these filters.';

  @override
  String get projectManagementNewProject => 'New project';

  @override
  String get projectManagementSearchHint => 'Search projects…';

  @override
  String get projectManagementSortLabel => 'Sort by';

  @override
  String get projectManagementSortName => 'Name';

  @override
  String get projectManagementSortDueDate => 'Due date';

  @override
  String get projectManagementSortPriority => 'Priority';

  @override
  String get projectManagementSortCreatedAt => 'Date created';

  @override
  String get projectManagementFavoritesOnly => 'Favorites only';

  @override
  String get projectManagementAllCategories => 'All categories';

  @override
  String get projectManagementNoCategory => 'No category';

  @override
  String get projectManagementNewCategory => 'New category';

  @override
  String get projectManagementCategoryNameHint => 'Category name';

  @override
  String get projectManagementCategoryLabel => 'Category';

  @override
  String get projectManagementPriorityLabel => 'Priority';

  @override
  String get projectManagementPriorityLow => 'Low';

  @override
  String get projectManagementPriorityMedium => 'Medium';

  @override
  String get projectManagementPriorityHigh => 'High';

  @override
  String get projectManagementPriorityUrgent => 'Urgent';

  @override
  String get projectManagementAllPriorities => 'All priorities';

  @override
  String get projectManagementNameLabel => 'Name';

  @override
  String get projectManagementDescriptionLabel => 'Description';

  @override
  String get projectManagementDueDateLabel => 'Due date';

  @override
  String get projectManagementNoDueDate => 'No due date';

  @override
  String get projectManagementPickDate => 'Pick a date';

  @override
  String get projectManagementClearDate => 'Clear date';

  @override
  String get projectManagementCreateProjectTitle => 'Create project';

  @override
  String get projectManagementEditProjectTitle => 'Edit project';

  @override
  String get projectManagementDeleteProjectTitle => 'Delete project';

  @override
  String get projectManagementDeleteProjectMessage =>
      'This will permanently delete the project and all of its tasks.';

  @override
  String get projectManagementTasksTitle => 'Tasks';

  @override
  String get projectManagementNewTask => 'New task';

  @override
  String get projectManagementEditTaskTitle => 'Edit task';

  @override
  String get projectManagementDeleteTaskTitle => 'Delete task';

  @override
  String get projectManagementDeleteTaskMessage =>
      'This will permanently delete this task.';

  @override
  String get projectManagementTaskTitleLabel => 'Title';

  @override
  String get projectManagementChecklistTitle => 'Checklist';

  @override
  String get projectManagementAddChecklistItemHint => 'Add an item…';

  @override
  String get projectManagementNoTasksYet => 'No tasks in this project yet.';

  @override
  String projectManagementTasksCompletedCount(int done, int total) {
    return '$done of $total tasks completed';
  }

  @override
  String get projectManagementDeleteCategoryTitle => 'Delete category';

  @override
  String get projectManagementDeleteCategoryMessage =>
      'Projects in this category will become uncategorized.';

  @override
  String get projectManagementFavoriteTooltip => 'Add to favorites';

  @override
  String get projectManagementUnfavoriteTooltip => 'Remove from favorites';

  @override
  String projectManagementProjectsCount(int count) {
    return '$count projects';
  }
}
