import 'package:aetherdesk/core/services/ai/ai_service.dart';

/// Local, fully offline stand-in for [AiService].
///
/// Produces plausible canned replies with a simulated "thinking" delay
/// before the first chunk, then streams the reply piece by piece — the
/// same shape a real streaming AI API would have. Swapping this for a real
/// provider later means changing what `aiServiceProvider` resolves to;
/// nothing above [AiService] needs to change.
class SimulatedAiService implements AiService {
  const SimulatedAiService();

  static const _thinkingDelay = Duration(milliseconds: 700);
  static const _chunkDelay = Duration(milliseconds: 30);

  @override
  Future<String> generateText(String prompt) async {
    await Future<void>.delayed(_thinkingDelay);
    return _reply(prompt);
  }

  @override
  Stream<String> streamResponse(String prompt) async* {
    await Future<void>.delayed(_thinkingDelay);
    final words = _reply(prompt).split(' ');
    for (var i = 0; i < words.length; i++) {
      await Future<void>.delayed(_chunkDelay);
      yield i == 0 ? words[i] : ' ${words[i]}';
    }
  }

  String _reply(String prompt) {
    final p = prompt.toLowerCase();

    if (p.contains('code') || p.contains('générer') || p.contains('generate')) {
      return 'Voici un exemple simple :\n\n'
          '```dart\nint add(int a, int b) => a + b;\n```\n\n'
          'Ceci est une réponse simulée à des fins de démonstration de '
          "l'interface — aucune IA réelle n'est connectée pour le moment.";
    }
    if (p.contains('bug') ||
        p.contains('débog') ||
        p.contains('debug') ||
        p.contains('erreur') ||
        p.contains('error')) {
      return "Pour déboguer efficacement : reproduisez l'erreur de façon "
          'fiable, isolez la portion de code en cause, puis vérifiez les '
          "valeurs à chaque étape avec des points d'arrêt ou des logs. "
          '(Réponse simulée — aucune IA réelle connectée.)';
    }
    if (p.contains('expliqu') ||
        p.contains('explain') ||
        p.contains('concept')) {
      return 'Un concept se comprend mieux en le reliant à quelque chose de '
          'connu, puis en l\'illustrant avec un exemple concret. Dites-moi '
          'quel concept vous intéresse et je détaillerai. (Réponse simulée '
          '— aucune IA réelle connectée.)';
    }
    if (p.contains('projet') || p.contains('plan') || p.contains('project')) {
      return "Pour planifier un projet : définissez l'objectif, découpez-le "
          'en étapes courtes, priorisez, puis avancez itérativement. '
          '(Réponse simulée — aucune IA réelle connectée.)';
    }
    return "Je suis une réponse simulée : aucune IA n'est encore connectée. "
        'Cette interface est prête à recevoir un vrai modèle plus tard '
        "sans changement d'architecture.";
  }
}
