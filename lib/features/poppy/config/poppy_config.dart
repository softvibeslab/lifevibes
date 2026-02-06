/// Configuration for PoppyAI service
class PoppyConfig {
  static const String baseUrl = 'https://api.openai.com/v1';
  static const String apiKey = 'YOUR_API_KEY';
  static const String modelId = 'gpt-4';
  static const int maxTokens = 2000;
  static const double temperature = 0.7;
  static const int timeoutSeconds = 30;
}
