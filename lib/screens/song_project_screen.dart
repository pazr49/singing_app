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

  @override
  void initState() {
    super.initState();
    _fetchSong();
    _fetchSongParts();
  }

  // function to fetch the song from the server
  void _fetchSong() async {
    Song fetchedSong = await fetchSong("123");
    setState(() {
      song = fetchedSong;
    });
  }

  // function to fetch the song parts from the server
  void _fetchSongParts() async {
    List<SongPart> fetchedSongParts = await fetchSongParts("123");
    setState(() {
      songParts = fetchedSongParts;
      songPartCards = _buildSongPartCards();
    });
  }

  // function to build the song part cards
  void setFilePath(String path, int fileNumber) {
    setState(() {
    filePaths[fileNumber -1] = path;
    });
  }

  // function to navigator push to the camera screen
  void _navigateToCameraScreen(int fileNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          CameraFromScratch(
            fileNumber: fileNumber,
            setFilePath: setFilePath,)),
    );
  }

  // check all elements in filePaths are not empty
  bool _checkFilePaths() {
    for (var path in filePaths) {
      if (path == '') {
        return false;
      }
    }
    return true;
  }

// function to upload files to the server
  Future<void> _uploadFiles() async {
    fileUploader.pingServer().then((value) {
      print(value);
    });
    fileUploader.uploadFiles(List<File>.from([File(""), File("")])).then((response) {
      print(response);
    });
  }

  // a function which will be used to create a list of SongPartCard widgets contaning the data in the songparts list
  List<Widget> _buildSongPartCards() {
    List<Widget> songPartCards = [];
    for (var i = 0; i < songParts.length; i++) {
      songPartCards.add(
          SongPartCard(
              fileNumber: songParts[i].part,
              title: songParts[i].id,
              filePath:'',
              navigateToCameraScreen: _navigateToCameraScreen,
          )
      );
      filePaths.add('');
    }
    return songPartCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song.name),
      ),
      body: Center(
        child: Column(
          // a list of SongPartCard widgets
          children: [
            ...songPartCards,
            ...filePaths.map((path) => Text(path)).toList(),
            ElevatedButton(
              onPressed: _checkFilePaths() ? _uploadFiles : null,
              child: Text('Upload Files'),
            ),
          ],
        ),
      ),
    );
  }
}
