import 'package:dio/dio.dart';
import 'package:vocality_ai/models/voice_chat_models.dart';

class ApiServiceV2 {
  static const String baseUrl = 'http://10.10.7.24:8000';
  late Dio _dio;
  String? _token;

  ApiServiceV2() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options);
        },
        onError: (error, handler) {
          print('API Error: ${error.response?.statusCode} - ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  void setToken(String token) {
    _token = token;
  }

  // Personality APIs
  Future<List<Personality>> getPersonalities() async {
    try {
      final response = await _dio.get('/core/personalities/');
      final data = response.data as List;
      return data
          .map((p) => Personality.fromJson(p as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      print('Error fetching personalities: $e');
      rethrow;
    }
  }

  Future<Personality> getPersonality(int id) async {
    try {
      final response = await _dio.get('/core/personalities/$id/');
      return Personality.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      print('Error fetching personality: $e');
      rethrow;
    }
  }

  // Conversation APIs
  Future<List<Conversation>> getConversations() async {
    try {
      final response = await _dio.get('/core/conversations/');
      final data = response.data as List;
      return data
          .map((c) => Conversation.fromJson(c as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      print('Error fetching conversations: $e');
      rethrow;
    }
  }

  Future<Conversation> getConversation(int id) async {
    try {
      final response = await _dio.get('/core/conversations/$id/');
      return Conversation.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      print('Error fetching conversation: $e');
      rethrow;
    }
  }

  Future<Conversation> createConversation({
    required int personalityId,
    required String title,
  }) async {
    try {
      final response = await _dio.post(
        '/core/conversations/',
        data: {'personality_id': personalityId, 'title': title},
      );
      return Conversation.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      print('Error creating conversation: $e');
      rethrow;
    }
  }

  // Chat APIs
  Future<Map<String, dynamic>> sendMessage({
    required int personalityId,
    required String message,
  }) async {
    try {
      final response = await _dio.post(
        '/core/conversations/send_message/',
        data: {'personality_id': personalityId, 'message': message},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  // Subscription APIs
  Future<UserSubscription> getSubscription() async {
    try {
      final response = await _dio.get('/subscription/user-subscription/');
      return UserSubscription.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      print('Error fetching subscription: $e');
      rethrow;
    }
  }

  // Auth APIs
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/core/auth/login/',
        data: {'email': email, 'password': password},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print('Error logging in: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _dio.post(
        '/core/auth/register/',
        data: {'email': email, 'password': password, 'username': username},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print('Error registering: $e');
      rethrow;
    }
  }
}
