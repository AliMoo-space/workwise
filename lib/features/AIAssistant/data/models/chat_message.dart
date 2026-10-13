class ChatMessage {
  final String text;
  final bool isUser;
  final bool failed;

  const ChatMessage({
    required this.text,
    required this.isUser,
    this.failed = false,
  });

  Map<String, dynamic> toJson() {
    return {'text': text, 'isUser': isUser, 'failed': failed};
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      failed: json['failed'] as bool? ?? false,
    );
  }
}
