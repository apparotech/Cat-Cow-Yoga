
class ScriptStep{
  final String text;
  final int startSec;
  final int endSec;
  final String imageRef;

  ScriptStep({
    required this.text,
    required this.startSec,
    required this.endSec,
    required this.imageRef,
  });


  factory ScriptStep.fromJson(Map<String, dynamic> json) {
    return ScriptStep(
      text: json['text'],
      startSec: json['startSec'],
      endSec: json['endSec'],
      imageRef: json['imageRef'],
    );
  }



}
class SequenceItem {

  final String type;
  final String name;
  final String audioRef;
  final int durationSec;

  final List<ScriptStep> script;


  SequenceItem({
    required this.type,
    required this.name,
    required this.audioRef,
    required this.durationSec,
    required this.script,
  });


  factory SequenceItem.fromJson(Map<String, dynamic> json) {
    var scriptList = (json['script'] as List)
        .map((s) => ScriptStep.fromJson(s))
        .toList();

    return SequenceItem(
      type: json['type'],
      name: json['name'],
      audioRef: json['audioRef'],
      durationSec: json['durationSec'],
      script: scriptList,
    );
  }



}

class YogaSession {
  final Map<String, String> images;
  final Map<String, String> audio;
  final List<SequenceItem> sequence;

  YogaSession({
    required this.images,
    required this.audio,
    required this.sequence,
  });

  factory YogaSession.fromJson(Map<String, dynamic> json) {
    var assets = json['assets'];
    var seq = (json['sequence'] as List)
        .map((s) => SequenceItem.fromJson(s))
        .toList();

    return YogaSession(
      images: Map<String, String>.from(assets['images']),
      audio: Map<String, String>.from(assets['audio']),
      sequence: seq,
    );
  }
}