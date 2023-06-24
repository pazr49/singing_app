
class Song {
  final String id;
  final String name;
  final int numParts;
  final String backingTrackURL;

  Song({required this.id, required this.name, required this.numParts, required this.backingTrackURL});
}

class SongPart {
  final String id;
  final int part;
  final String songId;
  final String musicURL;
  final String name;

  SongPart(
      {
        required this.id,
        required this.part,
        required this.songId,
        required this.musicURL,
        required this.name
      }
      );
}