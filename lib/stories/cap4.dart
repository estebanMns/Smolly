import 'package:flutter/material.dart';
import '../components/story/chapter_screen_template.dart';
import '../components/story/story_message_model.dart';

class Cap4Screen extends StatelessWidget {
  const Cap4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      NarrativeMessage('cap4_narrative_1'),
      DialogueMessage('cap4_perroblanco_1', 'assets/images/perroblanco.png', isLeft: true),
      DialogueMessage('cap4_kovu_1', 'assets/images/kovu.jpeg', isLeft: false),
      DialogueMessage('cap4_iker_1', 'assets/images/iker.jpeg', isLeft: true),
      NarrativeMessage('cap4_narrative_2'),
      DialogueMessage('cap4_horus_1', 'assets/images/horus.jpeg', isLeft: true),
      NarrativeMessage('cap4_narrative_3'),
      DialogueMessage('cap4_molly_1', 'assets/images/molly.jpeg', isLeft: false),
      DialogueMessage('cap4_iker_2', 'assets/images/iker.jpeg', isLeft: true),
      DialogueMessage('cap4_molly_2', 'assets/images/molly.jpeg', isLeft: false),
      DialogueMessage('cap4_perroblanco_2', 'assets/images/perroblanco.png', isLeft: true),
      DialogueMessage('cap4_molly_3', 'assets/images/molly.jpeg', isLeft: false),
      NarrativeMessage('cap4_narrative_4'),
    ];

    return ChapterScreenTemplate(
      titleKey: 'chapter_4',
      messages: messages,
      onPlay: () {
        Navigator.pushReplacementNamed(
          context,
          '/game-screen',
          arguments: {'levelId': 12},
        );
      },
    );
  }
}
