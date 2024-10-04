import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class MyVlcPlayer extends StatefulWidget {
  final String link;
  final bool iswake;

  const MyVlcPlayer({super.key, required this.link, required this.iswake});

  @override
  _MyVlcPlayerState createState() => _MyVlcPlayerState();
}

class _MyVlcPlayerState extends State<MyVlcPlayer> {
  static const _networkCachingMs = 2000;
  static const double _seekButtonIconSize = 48;
  double sliderValue = 0.0;
  bool validPosition = false;
  double volumeValue = 50;
  static const _overlayWidth = 100.0;

  static const Duration _seekStepForward = Duration(seconds: 10);
  static const Duration _seekStepBackward = Duration(seconds: -10);
  List<double> playbackSpeeds = [0.5, 1.0, 2.0];
  int playbackSpeedIndex = 1;
  static const Color _textColorWhite = Colors.red;

  bool isPlaying = true;
  String duration = '';
  double opacity = 0.0;
  bool isFullScreen = false;
  String position = '';

  late VlcPlayerController _videoPlayerController;

  void listener() {
    if (!mounted) return;
    //
    if (_videoPlayerController.value.isEnded) {
      _videoPlayerController.stop();
      _videoPlayerController.play();
    }
    if (_videoPlayerController.value.isInitialized) {
      final oPosition = _videoPlayerController.value.position;
      final oDuration = _videoPlayerController.value.duration;
      if (oDuration.inHours == 0) {
        final strPosition = oPosition.toString().split('.').first;
        final strDuration = oDuration.toString().split('.').first;
        setState(() {
          position =
              "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
          duration =
              "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
        });
      } else {
        setState(() {
          position = oPosition.toString().split('.').first;
          duration = oDuration.toString().split('.').first;
        });
      }
      setState(() {
        validPosition = oDuration.compareTo(oPosition) >= 0;
        sliderValue = validPosition ? oPosition.inSeconds.toDouble() : 0;
      });

      // update recording blink widget
    }
  }

  @override
  void initState() {
    _videoPlayerController = VlcPlayerController.network(
      widget.link,
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(_networkCachingMs),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );

    _videoPlayerController.addOnInitListener(() async {
      await _videoPlayerController.startRendererScanning();
      listener();
    });
    _videoPlayerController.addListener(listener);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    super.initState();
  }

  void updateResolutionNormal() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void updateResolutionLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    super.dispose();

    _videoPlayerController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
//   Wakelock.disable();
  }

  @override
  Widget build(BuildContext context) {
    //  Wakelock.toggle(enable: widget.iswake);
    final screenSize = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    final vlcPlayer = VlcPlayer(
        controller: _videoPlayerController,
        aspectRatio: screenSize.width / screenSize.height,
        placeholder: const Center(child: CircularProgressIndicator()));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            GestureDetector(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                      height: orientation == Orientation.portrait
                          ? 270
                          : screenSize.height,
                      width: screenSize.width,
                      color: const Color.fromARGB(255, 59, 58, 58),
                      child: _videoPlayerController.value.hasError
                          ? Center(
                              child: TextButton(
                                  onPressed: () {
                                    _replay();
                                  },
                                  child: const Text("Replay")))
                          : vlcPlayer),
                  Opacity(
                    opacity: opacity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () => _seekRelative(_seekStepBackward),
                          color: _textColorWhite,
                          iconSize: _seekButtonIconSize,
                          icon: const Icon(Icons.replay_10),
                        ),
                        IconButton(
                          color: _textColorWhite,
                          icon: _videoPlayerController.value.isPlaying
                              ? const Icon(
                                  Icons.pause_circle_outline,
                                  size: 45,
                                )
                              : const Icon(
                                  Icons.play_circle_outline,
                                  size: 45,
                                ),
                          onPressed: _togglePlaying,
                        ),
                        IconButton(
                          onPressed: () => _seekRelative(_seekStepForward),
                          color: _textColorWhite,
                          iconSize: _seekButtonIconSize,
                          icon: const Icon(Icons.forward_10),
                        ),
                      ],
                    ),
                  ),
                  opacityWidget(orientation),
                  volumeLine(orientation)
                ],
              ),
              onTap: () {
                setState(() {
                  opacity = opacity == 0.0 ? 1.0 : 0.0;
                });
              },
            ),
            orientation == Orientation.portrait
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 3,
                      ),
                      Container(
                          child: _videoPlayerController.value.playingState
                                          .toString()
                                          .split('.')[1] ==
                                      "buffering" ||
                                  _videoPlayerController.value.playingState
                                          .toString()
                                          .split('.')[1] ==
                                      "inilized"
                              ? const LinearProgressIndicator()
                              : Text(
                                  _videoPlayerController.value.playingState
                                      .toString()
                                      .split('.')[1],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : const SizedBox(),
          ]),
        ),
      ),
    );
  }

  Widget volumeLine(Orientation orientation) {
    return Positioned(
      right: 4,
      top: orientation == Orientation.portrait ? 29 : 80,
      child: Opacity(
        opacity: opacity,
        child: RotatedBox(
          quarterTurns: -1,
          child: Slider(
            activeColor: Colors.red,
            max: _overlayWidth,
            value: volumeValue,
            onChanged: _setSoundVolume,
          ),
        ),
      ),
    );
  }

  Widget opacityWidget(Orientation orientation) {
    return Positioned(
      bottom: orientation == Orientation.portrait ? 5 : 25,
      child: Opacity(
        opacity: opacity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              position,
              style: const TextStyle(color: _textColorWhite),
            ),
            Slider(
              activeColor: Colors.redAccent,
              inactiveColor: const Color.fromARGB(179, 34, 31, 31),
              value: sliderValue,
              max: !validPosition
                  ? 1.0
                  : _videoPlayerController.value.duration.inSeconds.toDouble(),
              onChanged: validPosition ? _onSliderPositionChanged : null,
            ),
            Text(
              duration,
              style: const TextStyle(color: _textColorWhite),
            ),
            IconButton(
              icon: const Icon(
                Icons.fullscreen,
                color: Colors.red,
                size: 28,
              ),
              onPressed: () {
                setState(() {
                  isFullScreen = !isFullScreen;
                  if (isFullScreen) {
                    updateResolutionLandscape();
                  } else {
                    updateResolutionNormal();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _setSoundVolume(double value) {
    setState(() {
      volumeValue = value;
    });
    _videoPlayerController.setVolume(volumeValue.toInt());
  }

  void _onSliderPositionChanged(double progress) {
    setState(() {
      sliderValue = progress.floor().toDouble();
    });
    //convert to Milliseconds since VLC requires MS to set time
    _videoPlayerController
        .setTime(sliderValue.toInt() * Duration.millisecondsPerSecond);
  }

  Future<void> _togglePlaying() async {
    _videoPlayerController.value.isPlaying
        ? await _videoPlayerController.pause()
        : await _videoPlayerController.play();
  }

  Future<void> _replay() async {
    await _videoPlayerController.stop();
    await _videoPlayerController.play();
  }

  Future<void> _seekRelative(Duration seekStep) {
    return _videoPlayerController
        .seekTo(_videoPlayerController.value.position + seekStep);
  }
}
