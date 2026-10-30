Here is a complete, upgraded main file featuring a dynamic voice assistant interface. It includes a chat history feed, animated voice wave visuals, interactive action buttons, and simulated AI responses to give your app a full "JARVIS" feel.
import 'package:flutter/material.dart';

void main() {
  runApp(const JarvisApp());
}

class JarvisApp extends StatelessWidget {
  const JarvisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JARVIS AI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF07111F),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          surface: Color(0xFF10243A),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  
  bool _isListening = false;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    // Animation controller for glowing voice wave ring
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Initial greeting message
    _messages.add(
      ChatMessage(
        text: "Online and operational, Boss. How can I assist you today?",
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? text]) {
    final queryText = text ?? _inputController.text.trim();
    if (queryText.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: queryText, isUser: true));
      _inputController.clear();
    });

    _scrollToBottom();

    // Simulate AI response delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            text: _generateJarvisReply(queryText),
            isUser: false,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  String _generateJarvisReply(String input) {
    final query = input.toLowerCase();
    if (query.contains('hello') || query.contains('hi')) {
      return "Greetings! Systems are operating at peak performance.";
    } else if (query.contains('status') || query.contains('system')) {
      return "All core modules are functional. Battery: 100%. Security grid: Active.";
    } else if (query.contains('who are you')) {
      return "I am JARVIS, your personal Artificial Intelligence Assistant.";
    }
    return "Processing request for: '$input'. Command executed successfully.";
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      // Simulate speech detection
      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted || !_isListening) return;
        setState(() {
          _isListening = false;
        });
        _sendMessage("Run full system diagnostics.");
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.memory, color: Colors.cyanAccent),
            SizedBox(width: 10),
            Text('JARVIS AI', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF10243A),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all, color: Colors.cyanAccent),
            onPressed: () => setState(() => _messages.clear()),
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Voice Visualizer Section
          _buildVoiceVisualizer(),

          // Chat Feed
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // Quick Action Chips
          _buildQuickActions(),

          // Text & Voice Input Bar
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildVoiceVisualizer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: const Color(0xFF0B192C),
      child: Center(
        child: GestureDetector(
          onTap: _toggleListening,
          child: AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              final scale = _isListening ? 1.0 + (_waveController.value * 0.25) : 1.0;
              final glowOpacity = _isListening ? 0.6 : 0.2;

              return Container(
                width: 90 * scale,
                height: 90 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF10243A),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(glowOpacity),
                      blurRadius: 25,
                      spreadRadius: 10,
                    ),
                  ],
                  border: Border.all(
                    color: _isListening ? Colors.cyanAccent : Colors.cyanAccent.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: Icon(
                  _isListening ? Icons.graphic_eq : Icons.mic,
                  color: Colors.cyanAccent,
                  size: 40,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF005670) : const Color(0xFF10243A),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
          border: Border.all(
            color: isUser ? Colors.cyanAccent.withOpacity(0.5) : Colors.cyanAccent.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          message.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.3,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final suggestions = ["System Status", "Run Diagnostics", "Who are you?"];
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ActionChip(
              backgroundColor: const Color(0xFF10243A),
              side: const BorderSide(color: Colors.cyanAccent, width: 0.8),
              label: Text(
                suggestions[index],
                style: const TextStyle(color: Colors.cyanAccent, fontSize: 12),
              ),
              onPressed: () => _sendMessage(suggestions[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFF10243A),
        border: Border(top: BorderSide(color: Color(0xFF1E3A5F), width: 1)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Ask JARVIS...",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF07111F),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (value) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.cyanAccent,
              child: IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF07111F)),
                onPressed: () => _sendMessage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Would you like to connect this UI to an actual AI backend (like the Gemini API) or integrate live speech recognition (speech_to_text) and text-to-speech (flutter_tts) packages?
