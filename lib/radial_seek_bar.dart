import 'package:flutter/material.dart';
import 'package:music_player/bottom_controls.dart';
import 'package:music_player/theme.dart' as theme;
import 'package:fluttery/gestures.dart'; // this is Fluttery developer package ^_^
import 'package:fluttery_audio/fluttery_audio.dart'; // this is Fluttery developer package ^_^
import 'dart:math';

class AudioRadialSeekBar extends StatefulWidget {
  final String albumArtUrl;

  AudioRadialSeekBar({this.albumArtUrl});

  @override
  _AudioRadialSeekBarState createState() => _AudioRadialSeekBarState();
}

class _AudioRadialSeekBarState extends State<AudioRadialSeekBar> {
  double _seekPercent;

  @override
  Widget build(BuildContext context) {
    return AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayhead,
        WatchableAudioProperties.audioSeeking,
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        double playbackProgress = 0.0;
        if (player.audioLength != null && player.position != null) {
          playbackProgress = player.position.inMilliseconds /
              player.audioLength.inMilliseconds;
        }

        _seekPercent = player.isSeeking ? _seekPercent : null;

        return RadialSeekBar(
          progress: playbackProgress,
          seekPercent: _seekPercent,
          onSeekRequested: (double seekPercent) {
            setState(() {
              _seekPercent = seekPercent;
            });
            final seekMillis =
                (player.audioLength.inMilliseconds * seekPercent).round();
            player.seek(Duration(microseconds: seekMillis));
          },
          child: Container(
            color: theme.accentColor,
            child: Image.asset(
              widget.albumArtUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class RadialSeekBar extends StatefulWidget {
  final double progress;
  final double seekPercent;
  final Function(double) onSeekRequested;
  final Widget child;

  RadialSeekBar(
      {this.seekPercent = 0.0,
      this.progress = 0.0,
      this.onSeekRequested,
      this.child});

  @override
  _RadialSeekBarState createState() => _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {
  double _progress = 0.0;
  PolarCoord _startDragCoord;
  double _startDragPercent;
  double _currentDragPercent;

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  @override
  void didUpdateWidget(RadialSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _progress = widget.progress;
  }

  void _onDragStart(PolarCoord coord) {
    _startDragCoord = coord;
    _currentDragPercent = _progress;
  }

  void _onDragUpdate(PolarCoord coord) {
    final dragAngle = coord.angle - _startDragCoord.angle;
    final dragPercent = dragAngle / (2 * pi);

    setState(() {
      _currentDragPercent = (_startDragPercent + dragPercent) % 1.0;
    });
  }

  void _onDragEnd() {
    if (widget.onSeekRequested != null) {
      widget.onSeekRequested(_currentDragPercent);
    }
    setState(() {
      _currentDragPercent = null;
      _startDragCoord = null;
      _startDragPercent = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double thumbPosition = _progress;
    if (_currentDragPercent != null) {
      thumbPosition = _currentDragPercent;
    } else if (widget.seekPercent != null) {
      thumbPosition = widget.seekPercent;
    }

    return RadialDragGestureDetector(
      // RadialDragGestureDetector made by Fluttery
      onRadialDragStart: _onDragStart,
      onRadialDragUpdate: _onDragUpdate,
      onRadialDragEnd: _onDragEnd,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 200.0,
            height: 200.0,
            // Just built this widget (new widget)
            child: RadialProgressBar(
              progressPercent: _progress,
              thumbPosition: thumbPosition,
              innerPadding: EdgeInsets.all(11.0),
              progressColor: theme.accentColor,
              thumbColor: theme.lightAccentColor,
              trackColor: Color(0xFFDDDDDD),
              child: ClipOval(
                clipper: CircleClipper(),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RadialProgressBar extends StatefulWidget {
  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double progressPercent;
  final double thumbSize;
  final Color thumbColor;
  final double thumbPosition;
  final EdgeInsets outerPadding;
  final EdgeInsets innerPadding;
  final Widget child;

  RadialProgressBar({
    this.trackWidth = 3.0,
    this.trackColor = Colors.grey,
    this.progressWidth = 5.0,
    this.progressColor = Colors.black,
    this.progressPercent = 0.0,
    this.thumbSize = 10.0,
    this.thumbColor = Colors.black,
    this.thumbPosition = 0.0,
    this.outerPadding = const EdgeInsets.all(0.0),
    this.innerPadding = const EdgeInsets.all(0.0),
    this.child,
  });

  @override
  _RadialProgressBarState createState() => _RadialProgressBarState();
}

class _RadialProgressBarState extends State<RadialProgressBar> {
  EdgeInsets _insetsForPainter() {
    /*
     Make room for the painted track, progress, and thumb. We divide by 2.0
     because we want to allow flush painting against the track, so we only
     need to account the thickness outside the track, not inside!!
    */
    final outerThickness =
        max(widget.trackWidth, max(widget.progressWidth, widget.thumbSize)) /
            2.0;
    return EdgeInsets.all(outerThickness);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.outerPadding,
      child: CustomPaint(
        foregroundPainter: RadialSeekBarPainter(
            trackWidth: widget.trackWidth,
            trackColor: widget.trackColor,
            progressWidth: widget.progressWidth,
            progressColor: widget.progressColor,
            progressPercent: widget.progressPercent,
            thumbSize: widget.thumbSize,
            thumbColor: widget.thumbColor,
            thumbPosition: widget.thumbPosition),
        child: Padding(
          padding: _insetsForPainter() + widget.innerPadding,
          child: widget.child,
        ),
      ),
    );
  }
}

class RadialSeekBarPainter extends CustomPainter {
  final double trackWidth;
  final Paint trackPaint;
  final double progressWidth;
  final Paint progressPaint;
  final double progressPercent;
  final double thumbSize;
  final Paint thumbPaint;
  final double thumbPosition;

  RadialSeekBarPainter({
    @required this.trackWidth,
    @required trackColor,
    @required this.progressWidth,
    @required progressColor,
    @required this.progressPercent,
    @required this.thumbSize,
    @required thumbColor,
    @required this.thumbPosition,
  })  : trackPaint = Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = trackWidth,
        progressPaint = Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = progressWidth
          ..strokeCap = StrokeCap.round,
        thumbPaint = Paint()
          ..color = thumbColor
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final outerThickness = max(trackWidth, max(progressWidth, thumbSize));
    Size constrainedSize =
        Size(size.width - outerThickness, size.height - outerThickness);

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(constrainedSize.width, constrainedSize.height) / 2;

    // Paint track
    canvas.drawCircle(center, radius, trackPaint);
    // Paint progress
    final progressAngle = 2 * pi * progressPercent;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        progressAngle, false, progressPaint);

    // Paint thumb
    final thumbAngle = 2 * pi * thumbPosition - (pi / 2);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = Offset(thumbX, thumbY) + center;
    final thumbRadius = thumbSize / 2.0;

    canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
