abstract class StoryMessage {
  final String textKey;
  StoryMessage(this.textKey);
}

class NarrativeMessage extends StoryMessage {
  NarrativeMessage(super.textKey);
}

class DialogueMessage extends StoryMessage {
  final String avatarPath;
  final bool isLeft;

  DialogueMessage(super.textKey, this.avatarPath, {this.isLeft = true});
}
