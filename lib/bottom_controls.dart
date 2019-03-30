import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music_player/songs.dart';
import 'package:music_player/theme.dart' as theme;
import 'dart:math';

class BottomControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Material(
        color: theme.accentColor,
        shadowColor: Color(0x44000000),
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
          child: Column(
            children: <Widget>[
              AudioPlaylistComponent(
                playlistBuilder:
                    (BuildContext context, Playlist playlist, Widget child) {
                  final songTitle =
                      demoPlayList.songs[playlist.activeIndex].songTitle;
                  final artistName =
                      demoPlayList.songs[playlist.activeIndex].artist;
                  return RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "${songTitle.toUpperCase()}\n",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4.0,
                            height: 1.5),
                      ),
                      TextSpan(
                          text: "${artistName.toUpperCase()}",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 15.0,
                              letterSpacing: 3.0,
                              height: 1.5)),
                    ]),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SkipPreviousBtn(),
                    PlayArrowBtn(),
                    SkipNextBtn(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkipNextBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return IconButton(
          splashColor: theme.lightAccentColor,
          highlightColor: Colors.transparent,
          icon: Icon(
            Icons.skip_next,
            color: Colors.white,
            size: 40.0,
          ),
          onPressed: playlist.next, // TODO
        );
      },
    );
  }
}

class PlayArrowBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AudioComponent(
      // AudioComponent made by Fluttery
      updateMe: [
        // to able to switch between ▶ and ||
        WatchableAudioProperties.audioPlayerState,
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        IconData _icon = Icons.music_note;
        Color _buttonColor = theme.lightAccentColor;
        Function _onPressed;

        if (player.state == AudioPlayerState.playing) {
          _icon = Icons.pause;
          _onPressed = player.pause;
          _buttonColor = Colors.white;
        } else if (player.state == AudioPlayerState.paused ||
            player.state == AudioPlayerState.completed) {
          _icon = Icons.play_arrow;
          _onPressed = player.play;
          _buttonColor = Colors.white;
        }
        return RawMaterialButton(
          shape: CircleBorder(),
          fillColor: _buttonColor,
          // decided from if statement
          splashColor: theme.lightAccentColor,
          highlightColor: theme.lightAccentColor.withOpacity(0.5),
          elevation: 10.0,
          highlightElevation: 5.0,
          onPressed: _onPressed,
          // decided from if statement
          // TODO
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              _icon, // decided from if statement
              color: theme.darkAccentColor,
              size: 35.0,
            ),
          ),
        );
      },
    );
  }
}

class SkipPreviousBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return IconButton(
          splashColor: theme.lightAccentColor,
          highlightColor: Colors.transparent,
          icon: Icon(
            Icons.skip_previous,
            color: Colors.white,
            size: 40.0,
          ),
          onPressed: playlist.previous, // TODO
        );
      },
    );
  }
}

class CircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    // TODO: implement getClip
    return Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: min(size.width, size.height) / 2);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
