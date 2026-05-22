import 'package:flutter/material.dart';
import '../../components/story/chapter_screen_template.dart';
import '../../components/story/story_message_model.dart';
import '../../auth/service/supabase_service.dart';

class DynamicChapterScreen extends StatefulWidget {
  final int chapterId;
  const DynamicChapterScreen({super.key, required this.chapterId});

  @override
  State<DynamicChapterScreen> createState() => _DynamicChapterScreenState();
}

class _DynamicChapterScreenState extends State<DynamicChapterScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  bool _isLoading = true;
  String _titleKey = '';
  String _backgroundImage = '';
  int _levelId = 1;
  List<StoryMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadChapterData();
  }

  Future<void> _loadChapterData() async {
    try {
      final data = await _supabaseService.fetchChapter(widget.chapterId);
      if (data != null && mounted) {
        final List<dynamic> rawMessages = data['messages'] ?? [];
        final List<StoryMessage> parsedMessages = rawMessages.map((m) {
          final String type = m['type'] ?? 'narrative';
          final String textKey = m['text_key'] ?? '';
          if (type == 'dialogue') {
            final String avatarPath = m['avatar_path'] ?? 'assets/images/kovu.jpeg';
            final bool isLeft = m['is_left'] ?? true;
            return DialogueMessage(textKey, avatarPath, isLeft: isLeft);
          } else {
            return NarrativeMessage(textKey);
          }
        }).toList();

        setState(() {
          _titleKey = data['title_key'] ?? 'chapter_${widget.chapterId}';
          _backgroundImage = data['background_image'] ?? 'assets/images/fondomolly.png';
          _levelId = data['level_id'] ?? widget.chapterId;
          _messages = parsedMessages;
          _isLoading = false;
        });
      } else {
        // Fallback en caso de que sea null
        _useFallbackData();
      }
    } catch (e) {
      print('Error loading dynamic chapter: $e');
      _useFallbackData();
    }
  }

  void _useFallbackData() {
    if (mounted) {
      setState(() {
        _titleKey = 'chapter_${widget.chapterId}';
        _backgroundImage = 'assets/images/fondomolly.png';
        _levelId = widget.chapterId;
        _messages = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.purpleAccent),
        ),
      );
    }

    return ChapterScreenTemplate(
      titleKey: _titleKey,
      messages: _messages,
      backgroundImage: _backgroundImage,
      onPlay: () {
        Navigator.pushReplacementNamed(
          context,
          '/game-screen',
          arguments: {'levelId': _levelId},
        );
      },
    );
  }
}
