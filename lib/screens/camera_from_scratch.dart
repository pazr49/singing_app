import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class CameraFromScratch extends StatefulWidget {
  final void Function(String path, int fileNum) setFilePath;
  final int fileNumber;
  const CameraFromScratch({required this.setFilePath, required this.fileNumber, Key? key}) : super(key: key);

  @override
_CameraFromScratchState createState() => _CameraFromScratchState();}

//class called _CameraFromScratchState which will be used to create the state of the camera screen
class _CameraFromScratchState extends State<CameraFromScratch> {
  late CameraController _controller;
  late VideoPlayerController _videoController;
  Future<void>? _initializeControllerFuture;
  bool _isRecording = false;

  bool checkFileExists(String filePath) {
    final file = File(filePath);
    return file.existsSync();
  }

  //initializing the camera controller and the initialize controller future
  @override
  void initState() {
    const filePath = 'assets/test.mp4';
    final fileExists = checkFileExists(filePath);
    if (fileExists) {
      print('File exists at $filePath');
    } else {
      print('File does not exist at $filePath');
    }

    super.initState();
    _videoController = VideoPlayerController.asset(filePath)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
        });
      });
    // Obtain a list of available cameras

    availableCameras().then((cameras) {
      if (cameras.isNotEmpty) {
        // Select the first available camera
        final frontCamera = cameras.firstWhere(
                (camera) => camera.lensDirection == CameraLensDirection.front,
            orElse: () => cameras.first);
        _controller = CameraController(frontCamera, ResolutionPreset.high);
        _initializeControllerFuture = _controller.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
      }
    });
  }

  //disposing the camera controller
  @override
  void dispose() {
    _controller?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  //function to get the path of the video file
  Future<String> _getVideoFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/recorded_video_${widget.fileNumber}.mp4';
    return filePath;
  }

  //function to start the video recording
  Future<void> _startVideoRecording() async {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      print('Error: select a camera first.');
      return;
    }
    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }
    try {
      await cameraController.startVideoRecording();
      _videoController.play();
      setState(() {
        _isRecording = true;
      });
    } on CameraException catch (e) {
      print(e);
      return;
    }
  }

  //function to stop the video recording
  Future<void> _stopVideoRecording() async {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      final XFile videoFile = await cameraController.stopVideoRecording();
      if (videoFile != null) {
        final String documentsPath = (await getApplicationDocumentsDirectory()).path;
        final String videoPath = '$documentsPath/videonumber_${widget.fileNumber}.mp4';
        await videoFile.saveTo(videoPath);
        widget.setFilePath(videoPath, widget.fileNumber);
        print('Video saved to: $videoPath');
        Navigator.pop(context);
      }
      setState(() {
        _isRecording = false;
      });
    } on CameraException catch (e) {
      print(e);
      return;
    }
  }



  //function to build the camera screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera From Scratch'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return
              Column(
              children: [
                !_videoController.value.isInitialized ? CircularProgressIndicator() :
                Center(
                  child: AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: Center(
                        child: _videoController.value.isInitialized
                            ? AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        ) : Container(),
                      )
                  ),
                ),
                Expanded(
                    child: Container(
                     color: Colors.black,
                     child: CameraPreview(_controller)
                    )
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_isRecording) {
            await _stopVideoRecording();
          } else {
            await _startVideoRecording();
          }
        },
        child: Icon(_isRecording ? Icons.stop : Icons.play_arrow),
      ),
    );
  }
}