import 'package:flutter/material.dart';
import '../components/story/chapter_screen_template.dart';
import '../components/story/story_message_model.dart';
import '../config/app_routes.dart';

class Cap3Screen extends StatelessWidget {
  const Cap3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      NarrativeMessage('cap3_narrative_1'),
    ];

    return ChapterScreenTemplate(
      titleKey: 'chapter_3',
      messages: messages,
      onPlay: () {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.gameScreen,
          arguments: {'levelId': 8},
        );
      },
    );
  }
}
