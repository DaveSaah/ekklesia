import 'package:ekklesia/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:ekklesia/models/event.dart';
import 'package:ekklesia/models/message.dart';
import 'package:ekklesia/services/message_service.dart';

class EventChatScreen extends StatefulWidget {
  final Event event;

  const EventChatScreen({super.key, required this.event});

  @override
  State<EventChatScreen> createState() => _EventChatScreenState();
}

class _EventChatScreenState extends State<EventChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final MessageService _messageService = MessageService();
  List<Message> messages = []; // Store messages for the event

  @override
  void initState() {
    super.initState();
    // Fetch existing messages for the event when the screen is loaded
    _loadMessages();
  }

  // Load messages for the event
  Future<void> _loadMessages() async {
    final loadedMessages = await _messageService.fetchMessages(widget.event.id);
    setState(() {
      messages = loadedMessages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: Text(widget.event.title), elevation: 0),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent.shade100,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: const Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message.messageText!,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Bar
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  // Mic Button
                  IconButton(
                    icon: const Icon(Icons.mic_none),
                    color: Colors.grey.shade700,
                    onPressed: () {
                      print("Mic tapped");
                    },
                  ),

                  // Image/Camera Button
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    color: Colors.grey.shade700,
                    onPressed: () {
                      print("Camera tapped");
                    },
                  ),

                  // Text Input
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "Type message...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Send Button
                  CircleAvatar(
                    backgroundColor: Colors.deepOrange,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () async {
                        final text = _messageController.text.trim();
                        final senderId = await UserService().getUuid();
                        if (text.isNotEmpty) {
                          final message = Message(
                            messageText: text,
                            eventId: widget.event.id,
                            createdAt: DateTime.now(),
                            senderId: senderId!,
                          );

                          // Send message and update UI
                          await _messageService.sendMessage(message);
                          setState(() {
                            messages.add(message);
                            _messageController.clear();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
