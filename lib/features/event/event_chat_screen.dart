import 'dart:io';
import 'package:ekklesia/features/event/text_msg_bubble.dart';
import 'package:ekklesia/features/event/voice_msg_bubble.dart';
import 'package:ekklesia/services/audio_player_service.dart';
import 'package:ekklesia/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:ekklesia/models/event.dart';
import 'package:ekklesia/models/message.dart';
import 'package:ekklesia/services/message_service.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class EventChatScreen extends StatefulWidget {
  final Event event;

  const EventChatScreen({super.key, required this.event});

  @override
  State<EventChatScreen> createState() => _EventChatScreenState();
}

class _EventChatScreenState extends State<EventChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final MessageService _messageService = MessageService();
  List<Message> messages = [];
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _recordedFilePath;
  bool _isLoading = true;
  late RealtimeChannel _realtimeChannel;
  late AudioPlayerService _audioPlayerService;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() async {
    _audioPlayerService = AudioPlayerService();

    await _checkPermission();
    await _loadCurrentUser();
    await _initializeRecorder();
    await _audioPlayerService.init(); // this now properly awaited

    _loadMessages();
    _messageSubscriber();
    MessageService().sendQueuedMessages();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    Supabase.instance.client.removeChannel(_realtimeChannel);
    _audioPlayerService.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    final uuid = await UserService().getUuid();
    setState(() {
      _currentUserId = uuid;
    });
  }

  // Check and request microphone permission
  Future<void> _checkPermission() async {
    // Request microphone permission
    PermissionStatus status = await Permission.microphone.request();

    if (status.isGranted) {
      print('Permission granted');
    } else {
      print('Permission denied');
    }
  }

  void _messageSubscriber() {
    _realtimeChannel =
        Supabase.instance.client
            .channel('public:messages')
            .onPostgresChanges(
              event: PostgresChangeEvent.insert,
              schema: 'public',
              table: 'messages',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'event_id',
                value: widget.event.id,
              ),
              callback: (payload) {
                final newMessage = Message.fromMap(payload.newRecord);
                if (newMessage.senderId != _currentUserId) {
                  setState(() {
                    messages.add(newMessage);
                  });
                }
              },
            )
            .subscribe();
  }

  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    final loadedMessages = await _messageService.fetchMessages(widget.event.id);
    setState(() {
      messages = loadedMessages;
      _isLoading = false;
    });
  }

  Future<void> _startRecording() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/${const Uuid().v4()}.aac';

      await _recorder.startRecorder(toFile: filePath, codec: Codec.aacADTS);

      setState(() {
        _isRecording = true;
        _recordedFilePath = filePath;
      });
    } catch (e) {
      print('Error starting recorder: $e');
    }
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    if (_recordedFilePath != null) {
      await _uploadVoiceMessage(File(_recordedFilePath!));
    }
  }

  Future<void> _uploadVoiceMessage(File file) async {
    final supabase = Supabase.instance.client;
    final fileName = 'messages/${const Uuid().v4()}.aac';

    try {
      await supabase.storage.from('chat-media').upload(fileName, file);

      final publicUrl = supabase.storage
          .from('chat-media')
          .getPublicUrl(fileName);

      final message = Message(
        mediaUrl: publicUrl,
        mediaType: 'audio',
        eventId: widget.event.id,
        createdAt: DateTime.now(),
        senderId: _currentUserId!,
      );

      await _messageService.sendMessage(message);
      setState(() {
        messages.add(message);
      });
    } catch (e) {
      print('Upload failed: $e');
    }
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
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[messages.length - 1 - index];
                        if (message.mediaType == 'audio') {
                          return VoiceMsgBubble(
                            audioUrl: message.mediaUrl!,
                            audioPlayerService: _audioPlayerService,
                          );
                        } else {
                          return TextMsgBubble(
                            messageText: message.messageText!,
                            isOwnMessage: message.senderId == _currentUserId!,
                          );
                        }
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
                    icon: Icon(_isRecording ? Icons.stop : Icons.mic_none),
                    color: Colors.grey.shade700,
                    onPressed: _isRecording ? _stopRecording : _startRecording,
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
                        if (text.isNotEmpty) {
                          final message = Message(
                            messageText: text,
                            eventId: widget.event.id,
                            createdAt: DateTime.now(),
                            senderId: _currentUserId!,
                          );

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
