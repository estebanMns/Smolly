import 'package:flutter/material.dart';
import '../components/story/chapter_screen_template.dart';
import '../components/story/story_message_model.dart';
import '../config/app_routes.dart';

class Cap5Screen extends StatelessWidget {
  const Cap5Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      NarrativeMessage('cap5_narrative_1'),
    ];

    return ChapterScreenTemplate(
      titleKey: 'chapter_5',
      messages: messages,
      onPlay: () {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.gameScreen,
          arguments: {'levelId': 17},
        );
      },
    );
  }
}
