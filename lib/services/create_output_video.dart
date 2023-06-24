

// a function to create the output video by calling the backend and passing the songId,
// the list of partIds
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

Future<String> createOutputVideo(String songId, List<String> partIds) async {
  final response = await http.post(
    Uri.parse('$apiUrl/create_output_video'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: {
      'song_id': songId,
      'part_ids': partIds.join(','),
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    final Map<String, dynamic> outputVideoData = json.decode(response.body);
    return outputVideoData['output_video_url'];
  } else {
    throw Exception('Failed to create output video');
  }
}