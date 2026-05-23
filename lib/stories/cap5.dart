import 'package:flutter/material.dart';
import '../components/story/chapter_screen_template.dart';
import '../components/story/story_message_model.dart';

class Cap5Screen extends StatelessWidget {
  const Cap5Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      NarrativeMessage('cap5_narrative_1'),
      DialogueMessage('cap5_iker_1', 'assets/images/iker.jpeg', isLeft: true),
      DialogueMessage('cap5_horus_1', 'assets/images/horus.jpeg', isLeft: false),
      NarrativeMessage('cap5_narrative_2'),
      DialogueMessage('cap5_horus_2', 'assets/images/horus.jpeg', isLeft: true),
      DialogueMessage('cap5_iker_2', 'assets/images/iker.jpeg', isLeft: false),
    ];

    return ChapterScreenTemplate(
      titleKey: 'chapter_5',
      messages: messages,
      onPlay: () {
        Navigator.pushReplacementNamed(
          context,
          '/game-screen',
          arguments: {'levelId': 5},
        );
      },
    );
  }
}
