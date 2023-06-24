// screen to display a list of song card widgets



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/song.dart';
import '../widgets/select_song_card.dart';
import '../services/song_service.dart';

class SelectSongScreen extends StatefulWidget {
  const SelectSongScreen({Key? key}) : super(key: key);

  @override
  _SelectSongScreenState createState() => _SelectSongScreenState();
}

class _SelectSongScreenState extends State<SelectSongScreen> {
  List<Widget> songCards = [];
  List<Song> songs = [];
  bool initLoading = true;
  bool failedConnection = false;

  @override
  void initState() {
    super.initState();
    _fetchSongs();
  }

  // function to fetch the songs from the server
  void _fetchSongs() async {
    List<Song> fetchedSongs = [];
    try {
      fetchedSongs = await fetchAllSongs();
    }
    catch (e) {
      setState(() {
        initLoading = false;
        failedConnection = true;
      });
      print("Error in _fetchSongs(): $e");
    }
    try {
      setState(() {
        songs = fetchedSongs;
        songCards = _buildSongCards();
        initLoading = false;
      });
    }
    catch (e) {
      print("Error in building Cards: $e");
    }
  }

  // function to build the song cards
  List<Widget> _buildSongCards() {
    List<Widget> songCards = [];
    for (Song song in songs) {
      songCards.add(
        SelectSongCard(
          title: song.name,
          numParts: song.numParts,
          songId: song.id,
        ),
      );
    }
    return songCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Song'),
      ),
      body: initLoading
          ? const Center(child: CircularProgressIndicator())
          : failedConnection
          ? const Center(child: Text("Failed to connect to server"))
          : ListView(
        padding: const EdgeInsets.all(8),
        children: songCards,
      ),
    );
  }
}