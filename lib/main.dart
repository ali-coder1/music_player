import 'package:music_player/bottom_controls.dart';
import 'package:flutter/material.dart';
import 'package:music_player/radial_seek_bar.dart';
import 'package:music_player/songs.dart';
import 'package:fluttery_audio/fluttery_audio.dart'; // this is Fluttery developer package ^_^

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Music Player",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return AudioPlaylist(
      // AudioPlaylist made by Fluttery
      playlist: demoPlayList.songs.map((DemoSong song) {
        return song.audioUrl;
      }).toList(growable: false),
      playbackState: PlaybackState.paused,
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Color(0xFFDDDDDD),
              onPressed: () {}),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.menu),
                color: Color(0xFFDDDDDD),
                onPressed: () {}),
          ],
        ),
        body: Column(
          children: <Widget>[
            // seek bar
            Expanded(
              child: AudioPlaylistComponent(
                // AudioPlaylistComponent made by Fluttery
                playlistBuilder:
                    (BuildContext context, Playlist playlist, Widget child) {
                  String albumArtUrl =
                      demoPlayList.songs[playlist.activeIndex].albumArtUrl;
                  // Just built this widget (AudioRadialSeekBar)
                  return AudioRadialSeekBar(
                    albumArtUrl: albumArtUrl,
                  );
                },
              ),
            ),
            // Container
            Container(
              width: double.infinity,
              height: 50.0,
            ),

            // Song title, artist name, controls
            new BottomControls(),
          ],
        ),
      ),
    );
  }
}
