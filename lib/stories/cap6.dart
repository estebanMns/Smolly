import 'package:flutter/material.dart';
import '../components/story/chapter_screen_template.dart';
import '../components/story/story_message_model.dart';

class Cap6Screen extends StatelessWidget {
  const Cap6Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      NarrativeMessage('cap6_narrative_1'),
      DialogueMessage('cap6_iker_1', 'assets/images/iker.jpeg', isLeft: true),
      NarrativeMessage('cap6_narrative_2'),
      DialogueMessage('cap6_kovu_1', 'assets/images/kovu.jpeg', isLeft: false),
      DialogueMessage('cap6_molly_1', 'assets/images/molly.jpeg', isLeft: false),
      DialogueMessage('cap6_horus_1', 'assets/images/horus.jpeg', isLeft: true),
      DialogueMessage('cap6_perroblanco_1', 'assets/images/perroblanco.png', isLeft: true),
      DialogueMessage('cap6_iker_2', 'assets/images/iker.jpeg', isLeft: true),
      NarrativeMessage('cap6_narrative_3'),
      DialogueMessage('cap6_molly_2', 'assets/images/molly.jpeg', isLeft: false),
      NarrativeMessage('cap6_narrative_4'),
    ];

    return ChapterScreenTemplate(
      titleKey: 'chapter_6',
      messages: messages,
      onPlay: () {
        Navigator.pushReplacementNamed(
          context,
          '/game-screen',
          arguments: {'levelId': 20},
        );
      },
    );
  }
}
