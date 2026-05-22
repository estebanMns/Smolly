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
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withValues(alpha: 0.75),
                Colors.deepPurple.withValues(alpha: 0.45),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.amber.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.15),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Text(
            message.textKey.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.amberAccent,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    } else if (message is DialogueMessage) {
      final diag = message as DialogueMessage;
      
      Widget avatar = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: diag.isLeft 
                ? Colors.cyan.withValues(alpha: 0.6) 
                : Colors.amber.withValues(alpha: 0.6),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: diag.isLeft 
                  ? Colors.cyan.withValues(alpha: 0.25) 
                  : Colors.amber.withValues(alpha: 0.25),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.black45,
          child: CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(diag.avatarPath),
          ),
        ),
      );

      Widget bubble = Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withValues(alpha: 0.8),
                Colors.deepPurple.withValues(alpha: 0.45),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(diag.isLeft ? 0 : 16),
              bottomRight: Radius.circular(diag.isLeft ? 16 : 0),
            ),
            border: Border.all(
              color: diag.isLeft 
                  ? Colors.cyan.withValues(alpha: 0.4) 
                  : Colors.amber.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: diag.isLeft 
                    ? Colors.cyan.withValues(alpha: 0.1) 
                    : Colors.amber.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Text(
            diag.textKey.tr,
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 13,
              height: 1.4,
            ),
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
