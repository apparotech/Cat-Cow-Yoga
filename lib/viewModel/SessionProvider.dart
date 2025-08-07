
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cat_cow_yoga/Model/yoga_sequence.dart';
import 'package:flutter/material.dart';



class SessionProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _bgMusicPlayer = AudioPlayer(); // optional background music

  YogaSession? _session;
  int _currentSequenceIndex = 0;
  int _currentScriptIndex = 0;
  bool _isPlaying = false;

  Timer? _stepTimer;
  int _stepElapsed = 0;
  bool _isBgMusicPlaying = true;


  bool get   isBgMusicPlaying => _isBgMusicPlaying;
  YogaSession? get session => _session;
  int get currentSequenceIndex => _currentSequenceIndex;
  int get currentScriptIndex => _currentScriptIndex;
  bool get isPlaying => _isPlaying;
  int get stepElapsed => _stepElapsed;

  void setSession(YogaSession session) {
    _session = session;
    _currentSequenceIndex = 0;
    _currentScriptIndex = 0;
    _isPlaying = false;
    _stepElapsed = 0;
    _stepTimer?.cancel();
    notifyListeners();
  }

  Future<void> playSession() async {
    if (_session == null) return;

    _isPlaying = true;
    notifyListeners();

    await _startBackgroundMusic();
    _playAudioForCurrentSequence();

    _startStepTimer(); // start visual + timing loop
  }

  void _startStepTimer() {
    _stepTimer?.cancel();

    _stepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPlaying || _session == null) return;

      final currentSeq = _session!.sequence[_currentSequenceIndex];
      final script = currentSeq.script;

      _stepElapsed++;

      final currentStep = script[_currentScriptIndex];
      final currentStepDuration = currentStep.endSec - currentStep.startSec;

      if (_stepElapsed >= currentStepDuration) {
        _stepElapsed = 0;
        if (_currentScriptIndex < script.length - 1) {
          _currentScriptIndex++;
        } else {
          // move to next sequence
          if (_currentSequenceIndex < _session!.sequence.length - 1) {
            _currentSequenceIndex++;
            _currentScriptIndex = 0;
            _playAudioForCurrentSequence();
          } else {
            // session done
            _isPlaying = false;
            _stepTimer?.cancel();
            _bgMusicPlayer.stop();
          }
        }
      }

      notifyListeners();
    });
  }

  void _playAudioForCurrentSequence() async {
    if (_session == null) return;
    final currentSeq = _session!.sequence[_currentSequenceIndex];
    final audioPath = "audio/${_session!.audio[currentSeq.audioRef]}";
    await _audioPlayer.play(AssetSource(audioPath));
  }

  void pause() async {
    await _audioPlayer.pause();
    //wait _bgMusicPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await _audioPlayer.resume();
   // await _bgMusicPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void toggleBackgroundMusic() async {
    if(_isBgMusicPlaying) {
      await _bgMusicPlayer.pause();
    } else {
      await _bgMusicPlayer.resume();
    }
    _isBgMusicPlaying = !_isBgMusicPlaying;
    notifyListeners();
  }

  Future<void> _startBackgroundMusic() async {
    try {
      debugPrint("Starting background music...");
      await _bgMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgMusicPlayer.setVolume(0.5);
      await _bgMusicPlayer.play(AssetSource('audio/yoga_music.mp3'));
      debugPrint(" BG music started.");
    } catch (e) {
      debugPrint(" Background music error: $e");
    }
  }

  void restartSession() async {
    _currentSequenceIndex = 0;
    _currentScriptIndex = 0;
    _stepElapsed = 0;

    _isPlaying = true;

    await _audioPlayer.stop();
    await _bgMusicPlayer.stop();

    await _startBackgroundMusic();
    _playAudioForCurrentSequence();
    _startStepTimer();

    notifyListeners();
  }





  void disposeSession() {
    _stepTimer?.cancel();
    _audioPlayer.dispose();
   // _bgMusicPlayer.dispose();
  }
}