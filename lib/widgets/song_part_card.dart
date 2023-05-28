// Purpose: Creates a card widget which will be used to record a song part

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/camera_from_scratch.dart';

// a stateful widget called SongPartCard which will be used to create a card widget
class SongPartCard extends StatefulWidget {
  final String title;
  final int fileNumber;
  final Function navigateToCameraScreen;
  final bool isRecorded;
  const SongPartCard(
      {
        required this.title,
        required this.fileNumber,
        required this.navigateToCameraScreen,
        required this.isRecorded,
        Key? key}) : super(key: key);

  @override
  _SongPartCardState createState() => _SongPartCardState();
}

// function to check if a file exists in a given path
  Future<bool> fileExists(String path) async {
    bool exists = await File(path).exists();
    return exists;
  }

//class called _SongPartCardState which will be used to create the state of the camera screen
class _SongPartCardState extends State<SongPartCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             ListTile(
              leading: Icon(Icons.album),
              title: Text(widget.title),
              subtitle: widget.isRecorded ? Text("Start your recording"): Text("Completed"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: widget.isRecorded ? Text("Record Video", style: TextStyle(color: Colors.red)) :
                    Text("Re-record Video"),
                  onPressed: () {
                    widget.navigateToCameraScreen(widget.fileNumber);
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}