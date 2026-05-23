import 'package:flutter/material.dart';
import '../components/story/chapter_screen_template.dart';
import '../components/story/story_message_model.dart';

class Cap7Screen extends StatelessWidget {
  const Cap7Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      NarrativeMessage('cap7_narrative_1'),
      DialogueMessage('cap7_iker_1', 'assets/images/iker.jpeg', isLeft: true),
      DialogueMessage('cap7_molly_1', 'assets/images/perroblanco.png', isLeft: false),
      DialogueMessage('cap7_iker_2', 'assets/images/iker.jpeg', isLeft: true),
      NarrativeMessage('cap7_narrative_2'),
    ];

    return ChapterScreenTemplate(
      titleKey: 'chapter_7',
      messages: messages,
      onPlay: () {
        Navigator.pushReplacementNamed(
          context,
          '/game-screen',
          arguments: {'levelId': 7},
        );
      },
    );
  }
}
