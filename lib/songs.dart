import 'package:meta/meta.dart';

class DemoSong {
  final String audioUrl;
  final String albumArtUrl;
  final String songTitle;
  final String artist;

  DemoSong(
      {@required this.audioUrl,
      @required this.albumArtUrl,
      @required this.songTitle,
      @required this.artist});
}

class DemoPlayList {
  final List<DemoSong> songs;

  DemoPlayList({@required this.songs});
}

final demoPlayList = DemoPlayList(
  songs: [
    DemoSong(
      audioUrl: "https://a.top4top.net/m_1182hzirx1.mp3",
      albumArtUrl: "images/abdo1.png",
      songTitle: "تعجبيني",
      artist: "محمد عبده",
    ),
    DemoSong(
      audioUrl: "https://f.top4top.net/m_1182g1hzb1.mp3",
      albumArtUrl: "images/abdo2.png",
      songTitle: "مذهلة",
      artist: "محمد عبده",
    ),
    DemoSong(
      audioUrl: "https://c.top4top.net/m_11825bpp81.mp3",
      albumArtUrl: "images/abdo3.png",
      songTitle: "اعز انسان",
      artist: "محمد عبده",
    ),
    DemoSong(
      audioUrl: "https://f.top4top.net/m_1182zrzrr1.mp3",
      albumArtUrl: "images/abdo4.png",
      songTitle: "في سحابة",
      artist: "محمد عبده",
    ),
    DemoSong(
      audioUrl: "https://d.top4top.net/m_1182g3c731.mp3",
      albumArtUrl: "images/abdo5.png",
      songTitle: "جمرة غضى",
      artist: "محمد عبده",
    ),
  ],
);
