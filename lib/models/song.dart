
class Song {
  final String id;
  final String name;
  final int numParts;

  Song({required this.id, required this.name, required this.numParts});
}

class SongPart {
  final String id;
  final int part;
  final String songId;
  final String musicURL;

  SongPart(
      {
        required this.id,
        required this.part,
        required this.songId,
        required this.musicURL,
      }
      );
}