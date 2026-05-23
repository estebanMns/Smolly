import 'package:flutter/material.dart';
import '../components/story/chapter_screen_template.dart';
import '../components/story/story_message_model.dart';

class Cap1Screen extends StatelessWidget {
  const Cap1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      NarrativeMessage('cap1_narrative_1'),
      DialogueMessage('cap1_iker_1', 'assets/images/iker.jpeg', isLeft: true),
      DialogueMessage('cap1_molly_1', 'assets/images/perroblanco.png', isLeft: false),
      NarrativeMessage('cap1_narrative_2'),
      DialogueMessage('cap1_iker_2', 'assets/images/iker.jpeg', isLeft: true),
      DialogueMessage('cap1_molly_2', 'assets/images/perroblanco.png', isLeft: false),
      DialogueMessage('cap1_iker_3', 'assets/images/perroblanco.png', isLeft: false), // Corrigiendo al diseño, el perro blanco dice "Solo aceleré..."
      NarrativeMessage('cap1_narrative_3'),
      DialogueMessage('cap1_iker_4', 'assets/images/iker.jpeg', isLeft: true),
      DialogueMessage('cap1_molly_3', 'assets/images/perroblanco.png', isLeft: false),
      NarrativeMessage('cap1_narrative_4'),
      DialogueMessage('cap1_iker_5', 'assets/images/iker.jpeg', isLeft: true),
      DialogueMessage('cap1_molly_4', 'assets/images/perroblanco.png', isLeft: false),
      NarrativeMessage('cap1_narrative_5'),
    ];

    return ChapterScreenTemplate(
      titleKey: 'chapter_1',
      messages: messages,
      onPlay: () {
        Navigator.pushReplacementNamed(
          context,
          '/game-screen',
          arguments: {'levelId': 1},
        );
      },
    );
  }
}
