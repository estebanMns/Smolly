import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'story_message_model.dart';
import 'chat_bubble_widget.dart';

class ChapterScreenTemplate extends StatelessWidget {
  final String titleKey;
  final List<StoryMessage> messages;
  final String backgroundImage;
  final VoidCallback onPlay;

  const ChapterScreenTemplate({
    super.key,
    required this.titleKey,
    required this.messages,
    required this.backgroundImage,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo oscuro estrellado
          Positioned.fill(
            child: Image.asset(
              'assets/images/FondoLobby.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
          // Imagen de fondo grande
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                backgroundImage,
                fit: BoxFit.contain,
                height: 400,
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
                            color: Colors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          titleKey.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 28, 
                            fontWeight: FontWeight.bold,
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
                        backgroundColor: const Color(0xFF9C27B0).withValues(alpha: 0.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.white54, width: 2),
                        ),
                        elevation: 8,
                        shadowColor: Colors.purpleAccent,
                      ),
                      child: Text(
                        'play'.tr.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
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
