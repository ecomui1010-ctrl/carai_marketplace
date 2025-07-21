import 'package:dio/dio.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  late final Dio _dio;
  static const String apiKey = String.fromEnvironment('GEMINI_API_KEY');

  factory GeminiService() {
    return _instance;
  }

  GeminiService._internal() {
    _initializeService();
  }

  void _initializeService() {
    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY must be provided via --dart-define');
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://generativelanguage.googleapis.com/v1',
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Dio get dio => _dio;
  String get authApiKey => apiKey;
}

class GeminiClient {
  final Dio dio;
  final String apiKey;

  GeminiClient(this.dio, this.apiKey);

  Future<Completion> createChat({
    required List<Message> messages,
    String model = 'gemini-1.5-flash-002',
    int maxTokens = 1024,
    double temperature = 1.0,
  }) async {
    try {
      final contents = messages
          .map((m) => {
                'role': m.role,
                'parts': m.content is String
                    ? [
                        {'text': m.content}
                      ]
                    : m.content,
              })
          .toList();

      final response = await dio.post(
        '/models/$model:generateContent',
        queryParameters: {
          'key': apiKey,
        },
        data: {
          'contents': contents,
          'generationConfig': {
            'maxOutputTokens': maxTokens,
            'temperature': temperature,
          },
        },
      );

      if (response.data['candidates'] != null &&
          response.data['candidates'].isNotEmpty &&
          response.data['candidates'][0]['content'] != null) {
        final parts = response.data['candidates'][0]['content']['parts'];
        final text = parts.isNotEmpty ? parts[0]['text'] : '';
        return Completion(text: text);
      } else {
        throw GeminiException(
          statusCode: response.statusCode ?? 500,
          message: 'Failed to parse response or empty response',
        );
      }
    } on DioException catch (e) {
      throw GeminiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data?['error']?['message'] ?? e.message,
      );
    }
  }

  Future<List<String>> listModels() async {
    try {
      final response = await dio.get(
        '/models',
        queryParameters: {
          'key': apiKey,
        },
      );

      final modelList = (response.data['models'] as List)
          .map((model) => model['name'] as String)
          .toList();
      return modelList;
    } on DioException catch (e) {
      throw GeminiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data?['error']?['message'] ??
            e.message ??
            'Failed to fetch models',
      );
    } catch (e) {
      throw GeminiException(
        statusCode: 500,
        message: 'Unexpected error fetching models: ${e.toString()}',
      );
    }
  }
}

class Message {
  final String role;
  final dynamic content;

  Message({required this.role, required this.content});
}

class Completion {
  final String text;

  Completion({required this.text});
}

class GeminiException implements Exception {
  final int statusCode;
  final String message;

  GeminiException({required this.statusCode, required this.message});

  @override
  String toString() => 'GeminiException: $statusCode - $message';
}
