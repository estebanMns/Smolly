import 'package:flutter/material.dart';
import '../components/story/chapter_screen_template.dart';
import '../components/story/story_message_model.dart';

class Cap2Screen extends StatelessWidget {
  const Cap2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      NarrativeMessage('cap2_narrative_1'),
      DialogueMessage('cap2_horus_1', 'assets/images/horus.jpeg', isLeft: true),
      DialogueMessage('cap2_iker_1', 'assets/images/iker.jpeg', isLeft: false),
      NarrativeMessage('cap2_narrative_2'),
      DialogueMessage('cap2_horus_2', 'assets/images/horus.jpeg', isLeft: true),
      NarrativeMessage('cap2_narrative_3'),
      DialogueMessage('cap2_molly_1', 'assets/images/molly.jpeg', isLeft: false),
      DialogueMessage('cap2_iker_2', 'assets/images/iker.jpeg', isLeft: true),
      DialogueMessage('cap2_molly_2', 'assets/images/molly.jpeg', isLeft: false),
      DialogueMessage('cap2_horus_3', 'assets/images/horus.jpeg', isLeft: true),
      NarrativeMessage('cap2_narrative_4'),
      NarrativeMessage('cap2_narrative_5'),
    ];

    return ChapterScreenTemplate(
      titleKey: 'chapter_2',
      messages: messages,
      backgroundImage: 'assets/images/horus.jpeg',
      onPlay: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Level 2 no implementado aún')),
        );
      },
    );
  }
}
