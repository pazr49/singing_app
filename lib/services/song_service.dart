import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/services/constants.dart';
import 'package:my_app/models/song.dart';

Future<Song> fetchSong(String songId) async {
  final response = await http.get(Uri.parse('$apiUrl/songs/$songId'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> songData = json.decode(response.body);
    return Song(
      id: songData['id'],
      name: songData['name'],
      numParts: songData['num_parts'],
    );
  } else {
    throw Exception('Failed to fetch song');
  }
}

// function to fetch the song parts from the server
Future<List<SongPart>> fetchSongParts(String songId) async {
  final response = await http.get(Uri.parse('$apiUrl/songs/$songId/song_parts'));
  print(response.body);
  if (response.statusCode == 200) {
    final List<dynamic> songPartsData = json.decode(response.body);
    List<SongPart> songParts = [];
    for (var songPartData in songPartsData) {
      songParts.add(SongPart(
        id: songPartData['id'],
        part: songPartData['part'],
        songId: songPartData['song_id'],
        musicURL: songPartData['music_url'],
      ));
    }
    return songParts;
  } else {
    throw Exception('Failed to fetch song parts');
  }
}