import 'package:flutter/material.dart';
import '../components/story/chapter_screen_template.dart';
import '../components/story/story_message_model.dart';

class Cap7Screen extends StatelessWidget {
  const Cap7Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      NarrativeMessage('cap7_narrative_1'),
      DialogueMessage('cap7_molly_1', 'assets/images/molly.jpeg', isLeft: false),
      DialogueMessage('cap7_iker_1', 'assets/images/iker.jpeg', isLeft: true),
      NarrativeMessage('cap7_narrative_2'),
      DialogueMessage('cap7_horus_1', 'assets/images/horus.jpeg', isLeft: true),
      DialogueMessage('cap7_kovu_1', 'assets/images/kovu.jpeg', isLeft: false),
      NarrativeMessage('cap7_narrative_3'),
      DialogueMessage('cap7_molly_2', 'assets/images/molly.jpeg', isLeft: false),
      DialogueMessage('cap7_perroblanco_1', 'assets/images/perroblanco.png', isLeft: true),
      NarrativeMessage('cap7_narrative_4'),
      DialogueMessage('cap7_molly_3', 'assets/images/molly.jpeg', isLeft: false),
      DialogueMessage('cap7_iker_2', 'assets/images/iker.jpeg', isLeft: true),
      NarrativeMessage('cap7_narrative_5'),
      DialogueMessage('cap7_molly_4', 'assets/images/molly.jpeg', isLeft: false),
      NarrativeMessage('cap7_narrative_6'),
      NarrativeMessage('cap7_narrative_7'),
    ];

    return ChapterScreenTemplate(
      titleKey: 'chapter_7',
      messages: messages,
      onPlay: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Level 7 no implementado aún')),
        );
      },
    );
  }
}
