/// Contract that any future AI provider (Claude API, OpenAI, a local model,
/// etc.) must satisfy to power the "IA Assistant" module and any other
/// AI-driven feature.
///
/// Defining this now — with zero implementation — lets `features/ai_assistant`
/// be built against a stable abstraction. Swapping or adding providers later
/// only means writing a new `AiService` implementation and registering it in
/// a Riverpod provider; nothing in `domain/` or `presentation/` has to change.
abstract interface class AiService {
  /// Sends [prompt] and returns the full response once available.
  Future<String> generateText(String prompt);

  /// Sends [prompt] and streams the response incrementally (token/chunk by
  /// token/chunk), for providers and UIs that support it.
  Stream<String> streamResponse(String prompt);
}
