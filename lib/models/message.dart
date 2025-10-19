class Message {
  final String text;
  final bool isUser;
  bool isPinned;

  Message({required this.text, required this.isUser, this.isPinned = false});
}
