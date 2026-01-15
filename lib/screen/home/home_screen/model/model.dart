// AI Response Model
class AIResponse {
  final String type;
  final Map<String, dynamic> data;
  final String? message;
  final String? error;

  AIResponse({
    required this.type,
    this.data = const {},
    this.message,
    this.error,
  });

  factory AIResponse.fromJson(Map<String, dynamic> json) {
    return AIResponse(
      type: json['type'] ?? '',
      data: json['data'] ?? {},
      message: json['message'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'data': data,
    'message': message,
    'error': error,
  };
}

// Session Model
class VoiceSession {
  final String sessionId;
  final int personalityId;
  final String personalityName;
  final DateTime createdAt;
  final bool isActive;

  VoiceSession({
    required this.sessionId,
    required this.personalityId,
    required this.personalityName,
    required this.createdAt,
    this.isActive = true,
  });

  factory VoiceSession.fromJson(Map<String, dynamic> json) {
    return VoiceSession(
      sessionId: json['session_id'] ?? '',
      personalityId: json['personality_id'] ?? 0,
      personalityName: json['personality_name'] ?? '',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toString(),
      ),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'session_id': sessionId,
    'personality_id': personalityId,
    'personality_name': personalityName,
    'created_at': createdAt.toIso8601String(),
    'is_active': isActive,
  };
}

// Chat Message Model
class ChatMessage {
  final String id;
  final String role; // 'user' or 'ai'
  final String messageText;
  final String? voiceFileUrl;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.role,
    required this.messageText,
    this.voiceFileUrl,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      role: json['role'] ?? 'user',
      messageText: json['message_text'] ?? '',
      voiceFileUrl: json['voice_file_url'],
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role,
    'message_text': messageText,
    'voice_file_url': voiceFileUrl,
    'timestamp': timestamp.toIso8601String(),
  };
}

// Conversation Model
class Conversation {
  final int id;
  final int userId;
  final int personalityId;
  final String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Conversation({
    required this.id,
    required this.userId,
    required this.personalityId,
    required this.title,
    this.messages = const [],
    required this.createdAt,
    this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    var messagesJson = json['messages'] as List? ?? [];
    return Conversation(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      personalityId: json['personality_id'] ?? 0,
      title: json['title'] ?? '',
      messages: messagesJson
          .map((msg) => ChatMessage.fromJson(msg as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toString(),
      ),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'personality_id': personalityId,
    'title': title,
    'messages': messages.map((m) => m.toJson()).toList(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

// Subscription Model
class UserSubscription {
  final int id;
  final String plan;
  final double remainingMinutes;
  final double dailyMinutesUsed;
  final DateTime createdAt;
  final DateTime? expiresAt;

  UserSubscription({
    required this.id,
    required this.plan,
    required this.remainingMinutes,
    required this.dailyMinutesUsed,
    required this.createdAt,
    this.expiresAt,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'] ?? 0,
      plan: json['plan'] ?? 'free',
      remainingMinutes: (json['remaining_minutes'] ?? 0).toDouble(),
      dailyMinutesUsed: (json['daily_minutes_used'] ?? 0).toDouble(),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toString(),
      ),
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'plan': plan,
    'remaining_minutes': remainingMinutes,
    'daily_minutes_used': dailyMinutesUsed,
    'created_at': createdAt.toIso8601String(),
    'expires_at': expiresAt?.toIso8601String(),
  };
}

// Personality Model
class Personality {
  final int id;
  final String personalityName;
  final String description;
  final String personalityPrompt;
  final bool isPremium;
  final String? imageUrl;

  Personality({
    required this.id,
    required this.personalityName,
    required this.description,
    required this.personalityPrompt,
    this.isPremium = false,
    this.imageUrl,
  });

  factory Personality.fromJson(Map<String, dynamic> json) {
    return Personality(
      id: json['id'] ?? 0,
      personalityName: json['personality_name'] ?? '',
      description: json['description'] ?? '',
      personalityPrompt: json['personality_promt'] ?? '',
      isPremium: json['is_premium'] ?? false,
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'personality_name': personalityName,
    'description': description,
    'personality_promt': personalityPrompt,
    'is_premium': isPremium,
    'image_url': imageUrl,
  };
}
