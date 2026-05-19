import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'story_message_model.dart';

class ChatBubbleWidget extends StatelessWidget {
  final StoryMessage message;

  const ChatBubbleWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message is NarrativeMessage) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF6A4C93).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: Text(
            message.textKey.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else if (message is DialogueMessage) {
      final diag = message as DialogueMessage;
      
      Widget avatar = CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage(diag.avatarPath),
        ),
      );

      Widget bubble = Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF4A3470).withValues(alpha: 0.9),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(diag.isLeft ? 0 : 16),
              bottomRight: Radius.circular(diag.isLeft ? 16 : 0),
            ),
            border: Border.all(color: Colors.white24),
          ),
          child: Text(
            diag.textKey.tr,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      );

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: diag.isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: diag.isLeft 
              ? [avatar, const SizedBox(width: 8), bubble]
              : [bubble, const SizedBox(width: 8), avatar],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
