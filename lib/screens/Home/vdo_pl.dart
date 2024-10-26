import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YouTubeVideoPlayer extends StatefulWidget {
  final String videoUrl;

  YouTubeVideoPlayer({required this.videoUrl});

  @override
  _YouTubeVideoPlayerState createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<YouTubeVideoPlayer> {
  late final WebViewController controller;
  @override
  void initState() {
    controller = WebViewController()..loadRequest(Uri.parse(widget.videoUrl));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Extract the video ID from the YouTube URL
    final videoId = Uri.parse(widget.videoUrl).queryParameters['v'];

    if (videoId != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("YouTube Video"),
        ),
        body: WebViewWidget(
          controller: controller,
        ),
      );
    } else {
      // Show error message for invalid URL
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
        ),
        body: Center(
          child: Text("Invalid YouTube URL"),
        ),
      );
    }
  }
}
