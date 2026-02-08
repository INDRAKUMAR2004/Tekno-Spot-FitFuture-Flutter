import 'dart:convert';
import 'package:fitfuture/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String id;
  final String text;
  final String sender; // "user" or "ai"
  final String time;

  ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.time,
  });
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> messages = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    // Initial welcome message
    messages.add(ChatMessage(
      id: "welcome",
      text: "Hi 👋 I’m your AI assistant FitBot",
      sender: "ai",
      time: _formattedTime(),
    ));
  }

  String _formattedTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  Future<void> sendMessage() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: input,
      sender: "user",
      time: _formattedTime(),
    );

    setState(() {
      messages.add(userMsg);
      _controller.clear();
      loading = true;
    });

    _scrollToBottom();

    try {
      final apiMessages = messages
          .map((m) => {
                "role": m.sender == "user" ? "user" : "assistant",
                "content": m.text,
              })
          .toList();

      apiMessages.add({"role": "user", "content": userMsg.text});

      final response = await http.post(
        Uri.parse(AppConstants.groqUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${AppConstants.groqApiKey}",
        },
        body: jsonEncode({
          "model": AppConstants.groqModel,
          "messages": apiMessages,
          "max_tokens": 800,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final assistantText = data["choices"]?[0]?["message"]?["content"] ??
            "Sorry, I couldn't generate a response right now.";

        final aiMsg = ChatMessage(
          id: "${DateTime.now().millisecondsSinceEpoch}_ai",
          text: assistantText.trim(),
          sender: "ai",
          time: _formattedTime(),
        );

        setState(() {
          messages.add(aiMsg);
        });
        _scrollToBottom();
      } else {
        _addErrorMsg("⚠️ API error: ${response.statusCode}");
      }
    } catch (e) {
      _addErrorMsg("⚠️ Something went wrong. Try again later.");
    } finally {
      setState(() => loading = false);
    }
  }

  void _addErrorMsg(String msg) {
    final errMsg = ChatMessage(
      id: "${DateTime.now().millisecondsSinceEpoch}_err",
      text: msg,
      sender: "ai",
      time: _formattedTime(),
    );
    setState(() {
      messages.add(errMsg);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessage(ChatMessage msg) {
    final isUser = msg.sender == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? AppConstants.neonGreen : AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? const Radius.circular(0) : null,
            bottomLeft: !isUser ? const Radius.circular(0) : null,
          ),
          boxShadow: [
            BoxShadow(
              color: isUser
                  ? AppConstants.neonGreen.withOpacity(0.2)
                  : Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: isUser
              ? null
              : Border.all(
                  color: AppConstants.neonGreen.withOpacity(0.5), width: 1),
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                fontSize: 15,
                color: isUser ? Colors.black : Colors.white,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              msg.time,
              style: TextStyle(
                fontSize: 10,
                color: isUser ? Colors.black54 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          children: [
            Icon(Icons.chat_bubble, color: Color(0xFF39FF14)),
            SizedBox(width: 8),
            Text(
              "FitBot",
              style: TextStyle(
                color: Color(0xFF39FF14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) => _buildMessage(messages[index]),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF111111))),
                color: Colors.black,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Color(0xFF39FF14)),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: const TextStyle(color: Color(0xFF777777)),
                        filled: true,
                        fillColor: const Color(0xFF111111),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: loading ? null : sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF39FF14),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: loading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send,
                              size: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
