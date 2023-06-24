//card widget to display the details of a song. including the song name and the number of parts


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/song_project_screen.dart';

class SelectSongCard extends StatefulWidget {
  final String title;
  final int numParts;
  final String songId;

  const SelectSongCard(
      {
        required this.title,
        required this.numParts,
        required this.songId,
        Key? key}) : super(key: key);


  @override
  _SelectSongCardState createState() => _SelectSongCardState();
}

class _SelectSongCardState extends State<SelectSongCard> {
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
              subtitle: Text(widget.numParts.toString() + " parts"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: Text("Select Song"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SongProjectScreen(songId: widget.songId)),
                    );
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