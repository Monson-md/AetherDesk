/// Contract for sending a prompt to the assistant and receiving its reply
/// as a stream of text chunks — mirrors how a real streaming AI API
/// behaves, so the presentation layer never has to change when a real
/// provider replaces the simulated one.
abstract interface class AiAssistantRepository {
  Stream<String> sendMessage(String prompt);
}
