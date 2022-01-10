import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItems extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;

  VideoItems({
    required this.videoPlayerController,
    required this.looping,
    required this.autoplay,
    Key? key,
  }) : super(key: key);

  @override
  _VideoItemsState createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
    _chewieController.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
