import 'package:flutter/material.dart';
import '../components/story/chapter_screen_template.dart';
import '../components/story/story_message_model.dart';

class Cap5Screen extends StatelessWidget {
  const Cap5Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      NarrativeMessage('cap5_narrative_1'),
      DialogueMessage('cap5_kovu_1', 'assets/images/kovu.jpeg', isLeft: false),
      DialogueMessage('cap5_iker_1', 'assets/images/iker.jpeg', isLeft: true),
      NarrativeMessage('cap5_narrative_2'),
      DialogueMessage('cap5_molly_1', 'assets/images/molly.jpeg', isLeft: false),
      DialogueMessage('cap5_iker_2', 'assets/images/iker.jpeg', isLeft: true),
      DialogueMessage('cap5_molly_2', 'assets/images/molly.jpeg', isLeft: false),
      DialogueMessage('cap5_horus_1', 'assets/images/horus.jpeg', isLeft: true),
      DialogueMessage('cap5_molly_3', 'assets/images/molly.jpeg', isLeft: false),
      DialogueMessage('cap5_perroblanco_1', 'assets/images/perroblanco.png', isLeft: true),
      NarrativeMessage('cap5_narrative_3'),
      DialogueMessage('cap5_molly_4', 'assets/images/molly.jpeg', isLeft: false),
      NarrativeMessage('cap5_narrative_4'),
    ];

    return ChapterScreenTemplate(
      titleKey: 'chapter_5',
      messages: messages,
      backgroundImage: 'assets/images/fondomolly.png',
      onPlay: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Level 5 no implementado aún')),
        );
      },
    );
  }
}
