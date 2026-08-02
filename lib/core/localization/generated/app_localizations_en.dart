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
  String get loginHeadline => 'Connect your GitHub account';

  @override
  String get loginDescription =>
      'AetherDesk needs access to your GitHub account to read and modify your repositories.';

  @override
  String get loginButton => 'Sign in with GitHub';

  @override
  String get loginPendingTitle => 'Enter this code on GitHub';

  @override
  String get loginPendingDescription =>
      'Open the GitHub verification page and enter the code below.';

  @override
  String get loginCopyCodeTooltip => 'Copy code';

  @override
  String get loginCodeCopiedMessage => 'Code copied to clipboard.';

  @override
  String get loginOpenGithubButton => 'Open GitHub';

  @override
  String get loginWaitingMessage => 'Waiting for your authorization…';

  @override
  String get loginOpenUrlError => 'Couldn\'t open the browser.';

  @override
  String get profileLogoutButton => 'Sign out';

  @override
  String profilePublicReposCount(int count) {
    return '$count public repos';
  }
}
