import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Video Player Example'),
        ),
        body: const Center(
          child: VideoPlayerScreen(),
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late bool _isBuffering;

  @override
  void initState() {
    super.initState();
    _isBuffering = false;
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'));

    _controller.addListener(() {
      if (!_controller.value.isBuffering && _isBuffering) {
        setState(() {
          _isBuffering = false;
        });
      } else if (_controller.value.isBuffering && !_isBuffering) {
        setState(() {
          _isBuffering = true;
        });
      }
    });

    _controller.initialize().then((_) {
      setState(() {});
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getBufferedPercentage() {
    if (_controller.value.isInitialized) {
      double bufferedEnd = 0.0;
      if (_controller.value.buffered.isNotEmpty) {
        bufferedEnd =
            _controller.value.buffered.last.end.inMilliseconds.toDouble();
      }
      double duration = _controller.value.duration.inMilliseconds.toDouble();
      double bufferedPercentage = bufferedEnd / duration * 100;
      setState(() {});
      return '${bufferedPercentage.toStringAsFixed(2)}%';
    } else {
      setState(() {});
      return '0.00%';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          if (_isBuffering) const CircularProgressIndicator(),
          Positioned(
            bottom: 10,
            right: 10,
            child: Text(
              'Buffered: ${getBufferedPercentage()}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
