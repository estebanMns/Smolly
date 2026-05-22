import 'package:flutter/material.dart';
import '../components/story/chapter_screen_template.dart';
import '../components/story/story_message_model.dart';

class Cap3Screen extends StatelessWidget {
  const Cap3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      NarrativeMessage('cap3_narrative_1'),
      DialogueMessage('cap3_iker_1', 'assets/images/iker.jpeg', isLeft: true),
      DialogueMessage('cap3_kovu_1', 'assets/images/kovu.jpeg', isLeft: false),
      DialogueMessage('cap3_iker_2', 'assets/images/iker.jpeg', isLeft: true),
      NarrativeMessage('cap3_narrative_2'),
      DialogueMessage('cap3_molly_1', 'assets/images/molly.jpeg', isLeft: false),
      DialogueMessage('cap3_horus_1', 'assets/images/horus.jpeg', isLeft: true),
      DialogueMessage('cap3_molly_2', 'assets/images/molly.jpeg', isLeft: false),
      DialogueMessage('cap3_iker_3', 'assets/images/iker.jpeg', isLeft: true),
      DialogueMessage('cap3_molly_3', 'assets/images/molly.jpeg', isLeft: false),
      NarrativeMessage('cap3_narrative_3'),
    ];

    return ChapterScreenTemplate(
      titleKey: 'chapter_3',
      messages: messages,
      backgroundImage: 'assets/images/fondohorus.jpg',
      onPlay: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Level 3 no implementado aún')),
        );
      },
    );
  }
}
