import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'story_message_model.dart';
import 'chat_bubble_widget.dart';

class ChapterScreenTemplate extends StatelessWidget {
  final String titleKey;
  final List<StoryMessage> messages;
  final VoidCallback onPlay;

  const ChapterScreenTemplate({
    super.key,
    required this.titleKey,
    required this.messages,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de fondoniveles
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondoniveles.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Magical Forest Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.deepPurple.withValues(alpha: 0.6),
                    Colors.blue.withValues(alpha: 0.4),
                    Colors.teal.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ),
          // Contenido principal
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.amber.withValues(alpha: 0.5),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withValues(alpha: 0.2),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.amber, size: 20),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          titleKey.tr.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.amber, 
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(color: Colors.orange, blurRadius: 10),
                              Shadow(color: Colors.yellow, blurRadius: 5),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 45), // Balance
                    ],
                  ),
                ),
                // Lista de mensajes
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ChatBubbleWidget(message: messages[index]);
                    },
                  ),
                ),
                // Botón JUGAR
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onPlay,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.yellow.withValues(alpha: 0.5), width: 2),
                        ),
                        elevation: 10,
                        shadowColor: Colors.amber.withValues(alpha: 0.6),
                      ),
                      child: Text(
                        'play'.tr.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
