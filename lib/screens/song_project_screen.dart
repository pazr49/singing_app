import 'package:flutter/material.dart';
import 'package:my_app/screens/camera_from_scratch.dart';
import 'package:my_app/services/file_uploader.dart';
import 'package:my_app/services/song_service.dart';
import 'dart:io';
import '../models/song.dart';
import '../widgets/song_part_card.dart';

class SongProjectScreen extends StatefulWidget {
  const SongProjectScreen({Key? key}) : super(key: key);

  @override
  _SongProjectScreenState createState() => _SongProjectScreenState();
}

class _SongProjectScreenState extends State<SongProjectScreen>{
 FileUploader fileUploader = FileUploader();
  List<Widget> songPartCards = [];
  List<String> filePaths = [];
  List<SongPart> songParts = [];
  Song song = Song(id: '', name: '', numParts: 0);
  bool initLoading = true;
  bool failedConnection = false;
  bool uploadingFiles = false;

  @override
  void initState() {
    super.initState();
    _fetchSong();
    _fetchSongParts();
  }

  // function to fetch the song from the server
  void _fetchSong() async {
    try {
      Song fetchedSong = await fetchSong("123");
      setState(() {
        song = fetchedSong;
      });
    }
    catch (e) {
      setState(() {
        initLoading = false;
        failedConnection = true;
      });
      print(e);
    }
  }

  // function to fetch the song parts from the server
  void _fetchSongParts() async {
    try {
      List<SongPart> fetchedSongParts = await fetchSongParts("123");
      setState(() {
        songParts = fetchedSongParts;
        songPartCards = _buildSongPartCards();
        initLoading = false;
      });
    }
    catch (e) {
      print("oeirgoeirjgo");
      setState(() {
        initLoading = false;
        failedConnection = true;
      });
       print(e);
   }
  }

  // function to build the song part cards
  void setFilePath(String path, int fileNumber) {
    setState(() {
      filePaths[fileNumber -1] = path;
      songPartCards = _buildSongPartCards();
    });
  }

  // function to navigator push to the camera screen
  void _navigateToCameraScreen(int fileNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          CameraFromScratch(
            fileURL: songParts[fileNumber - 1].musicURL,
            fileNumber: fileNumber,
            setFilePath: setFilePath,)),
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
    if (filePaths[index] != '') {
      return false;
    }
    return true;
  }

  // a function which will be used to create a list of SongPartCard widgets contaning the data in the songparts list
  List<Widget> _buildSongPartCards() {
    List<Widget> songPartCards = [];
    for (var i = 0; i < songParts.length; i++) {
      filePaths.add('');
      songPartCards.add(
          SongPartCard(
              fileNumber: songParts[i].part,
              title: songParts[i].id,
              navigateToCameraScreen: _navigateToCameraScreen,
              isRecorded: _checkFiles(i),
          )
      );
    }
    return songPartCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song.name),
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
