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
}
