class Message {
  final int id;
  final String userMessage;
  final String popupMessage;
  final DateTime? updatedAt;
  final String? updatedBy;

  Message({
    required this.id,
    required this.userMessage,
    required this.popupMessage,
    this.updatedAt,
    this.updatedBy,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      userMessage: json['user_message'] ?? '',
      popupMessage: json['popup_message'] ?? '',
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
      updatedBy: json['updated_by'],
    );
  }

  factory Message.empty() {
    return Message(id: 0, userMessage: '', popupMessage: '');
  }

  bool get isEmpty => userMessage.isEmpty && popupMessage.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
