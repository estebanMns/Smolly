import 'package:flutter/material.dart';
import '../components/story/chapter_screen_template.dart';
import '../components/story/story_message_model.dart';
import '../config/app_routes.dart';

class Cap4Screen extends StatelessWidget {
  const Cap4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      NarrativeMessage('cap4_narrative_1'),
    ];

    return ChapterScreenTemplate(
      titleKey: 'chapter_4',
      messages: messages,
      onPlay: () {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.gameScreen,
          arguments: {'levelId': 12},
        );
      },
    );
  }
}
