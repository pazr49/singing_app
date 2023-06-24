import 'package:flutter/material.dart';
import 'package:my_app/screens/camera_from_scratch.dart';
import 'package:my_app/services/file_uploader.dart';
import 'package:my_app/services/song_service.dart';
import 'dart:io';
import '../models/song.dart';
import '../widgets/song_part_card.dart';

class SongProjectScreen extends StatefulWidget {
  final String songId;
  const SongProjectScreen({required this.songId, Key? key}) : super(key: key);

  @override
  _SongProjectScreenState createState() => _SongProjectScreenState();
}

class _SongProjectScreenState extends State<SongProjectScreen>{
 FileUploader fileUploader = FileUploader();
  List<Widget> songPartCards = [];
  List<String> recordedParts = [];
  List<String> filePaths = [];
  List<SongPart> songParts = [];

  bool initLoading = true;
  bool failedConnection = false;
  bool uploadingFiles = false;

  @override
  void initState() {
    super.initState();
    _fetchSongParts();
  }


  // function to fetch the song parts from the server
  void _fetchSongParts() async {
    try {
      List<SongPart> fetchedSongParts = await fetchSongParts(widget.songId);
      setState(() {
        songParts = fetchedSongParts;
        songPartCards = _buildSongPartCards();
        initLoading = false;
      });
    }
    catch (e) {
      setState(() {
        initLoading = false;
        failedConnection = true;
      });
       print("Error in _fetchSongParts(): $e");
   }

  }

  // function to build the song part cards
  void setFilePath(String partId, String filePath) {
    setState(() {
      recordedParts.add(partId);
      filePaths.add(filePath);
      songPartCards = _buildSongPartCards();
    });
  }

  // function to navigator push to the camera screen
  void _navigateToCameraScreen(String partId, String musicURL) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          CameraFromScratch(
            musicUrl: musicURL,
            partId: partId,
            setFilePath: setFilePath,
          )
      ),
    );
  }

// function to upload files to the server
  Future<void> _uploadFiles() async {
    setState(() {
      uploadingFiles = true;
    });
    fileUploader.uploadFiles(List<String>.from(filePaths)).then((response) {
      print(response);
      setState(() {
        uploadingFiles = false;
      });
    });
  }

  //function to check if the files in filepaths are null
  _checkFiles(index) {
    if (recordedParts.contains(songParts[index].id)){
      return false;
    }
    else {
      return true;
    }
  }

  // a function which will be used to create a list of SongPartCard widgets contaning the data in the songparts list
  List<Widget> _buildSongPartCards() {
    List<Widget> songPartCards = [];
    for (var i = 0; i < songParts.length; i++) {
      filePaths.add('');

      songPartCards.add(
          SongPartCard(
              partId: songParts[i].id,
              songId: songParts[i].songId,
              partNumber: songParts[i].part,
              name: songParts[i].name,
              musicUrl: songParts[i].musicURL,
              navigateToCameraScreen: _navigateToCameraScreen,
              isRecorded: _checkFiles(i)
          )
      );
    }
    return songPartCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Record your song"),
      ),
      body:
          // if the connection failed, display a message
      //if loadingSongParts is true, display a loading indicator
      initLoading ? const Center(
        child: CircularProgressIndicator(),
      ) :
          failedConnection ? const Center(
            child: Text('Failed to connect to server'),
          ) :
      Center(
        child: Column(
          // a list of SongPartCard widgets
          children: [
            ...songPartCards,
            uploadingFiles ? const Center(
              child: CircularProgressIndicator(),
            ) :
            ElevatedButton(
              // if filePaths is empty, disable the button
              onPressed:
                filePaths.length == songParts.length ? null : _uploadFiles,
              child: Text('Upload Files'),
            ),
          ],
        ),
      ),
    );
  }
}
