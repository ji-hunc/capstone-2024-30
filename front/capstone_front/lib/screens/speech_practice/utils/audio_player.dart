import 'dart:async';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:audioplayers/audioplayers.dart';
import 'package:capstone_front/models/speech_model.dart';
import 'package:capstone_front/screens/speech_practice/speech_practice_screen.dart';
import 'package:capstone_front/services/speech_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AudioPlayer extends StatefulWidget {
  /// Path from where to play recorded audio
  final String source;

  /// Callback when audio file should be removed
  /// Setting this to null hides the delete button
  final VoidCallback onDelete;
  final String path;
  final String sentence;
  final VoidCallback onBtnPressed;

  const AudioPlayer({
    super.key,
    required this.source,
    required this.onDelete,
    required this.path,
    required this.sentence,
    required this.onBtnPressed,
  });

  @override
  AudioPlayerState createState() => AudioPlayerState();
}

class AudioPlayerState extends State<AudioPlayer> {
  static const double _controlSize = 56;
  static const double _deleteBtnSize = 30;

  final _audioPlayer = ap.AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  late StreamSubscription<void> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;
  Duration? _position;
  Duration? _duration;

  @override
  void initState() {
    _playerStateChangedSubscription =
        _audioPlayer.onPlayerComplete.listen((state) async {
      await stop();
    });
    _positionChangedSubscription = _audioPlayer.onPositionChanged.listen(
      (position) => setState(() {
        _position = position;
      }),
    );
    _durationChangedSubscription = _audioPlayer.onDurationChanged.listen(
      (duration) => setState(() {
        _duration = duration;
      }),
    );

    _audioPlayer.setSource(_source);

    super.initState();
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildControl(),
            // _buildSlider(constraints.maxWidth),
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.replay_outlined,
                    size: _deleteBtnSize,
                  ),
                  onPressed: () {
                    if (_audioPlayer.state == ap.PlayerState.playing) {
                      stop().then((value) => widget.onDelete());
                    } else {
                      widget.onDelete();
                    }
                  },
                ),
                Text(tr('speech.re_record')),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.check,
                    size: _deleteBtnSize,
                  ),
                  onPressed: () {
                    // print(widget.path);
                    // speechModel =
                    //     await getSpeechResult(widget.path, widget.sentence);
                    print("123123123132231123123123123132132");
                    widget.onBtnPressed();
                    print("!@#@#!@#!@#!@#!@#!#@!#@!@#!@#!#@");
                  },
                ),
                Text(tr('speech.get_result')),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _buildControl() {
    Icon icon;
    Color color;

    if (_audioPlayer.state == ap.PlayerState.playing) {
      icon = const Icon(Icons.pause, size: 30);
    } else {
      final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow, size: 30);
    }

    return Column(
      children: [
        IconButton(
            onPressed: () {
              if (_audioPlayer.state == ap.PlayerState.playing) {
                pause();
              } else {
                play();
              }
            },
            icon: icon),
        // InkWell(
        //   child:
        //       SizedBox(width: _controlSize, height: _controlSize, child: icon),
        //   onTap: () {
        //     if (_audioPlayer.state == ap.PlayerState.playing) {
        //       pause();
        //     } else {
        //       play();
        //     }
        //   },
        // ),
        Text(tr('speech.my_speech')),
      ],
    );
  }

  Widget _buildSlider(double widgetWidth) {
    bool canSetValue = false;
    final duration = _duration;
    final position = _position;

    if (duration != null && position != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    double width = widgetWidth - _controlSize - _deleteBtnSize - _deleteBtnSize;
    width -= _deleteBtnSize + _deleteBtnSize;

    return SizedBox(
      width: width,
      child: Slider(
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).colorScheme.secondary,
        onChanged: (v) {
          if (duration != null) {
            final position = v * duration.inMilliseconds;
            _audioPlayer.seek(Duration(milliseconds: position.round()));
          }
        },
        value: canSetValue && duration != null && position != null
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0,
      ),
    );
  }

  Future<void> play() => _audioPlayer.play(_source);

  Future<void> pause() async {
    await _audioPlayer.pause();
    setState(() {});
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    setState(() {});
  }

  Source get _source =>
      kIsWeb ? ap.UrlSource(widget.source) : ap.DeviceFileSource(widget.source);
}
