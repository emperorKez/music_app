import 'dart:math';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
        trackHeight: 4.0,
        thumbShape: SliderComponentShape.noThumb,
        trackShape: SliderCustomTrackShape());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            // activeTrackColor: Colors.blue.shade100,
            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.grey.shade300,
          ),
          child: ExcludeSemantics(
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            inactiveTrackColor: Colors.transparent,
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Positioned(
          left: 0.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("${widget.position}")
                      ?.group(1) ??
                  '${widget.position}',
              style: Theme.of(context).textTheme.bodySmall),
        ),
        Positioned(
          right: 0.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("$_remaining")
                      ?.group(1) ??
                  '$_remaining',
              style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

// void showSliderDialog({
//   required BuildContext context,
//   required String title,
//   required int divisions,
//   required double min,
//   required double max,
//   String valueSuffix = '',
//   // TODO: Replace these two by ValueStream.
//   required double value,
//   required Stream<double> stream,
//   required ValueChanged<double> onChanged,
// }) {
//   showDialog<void>(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text(title, textAlign: TextAlign.center),
//       content: StreamBuilder<double>(
//         stream: stream,
//         builder: (context, snapshot) => SizedBox(
//           height: 100.0,
//           child: Column(
//             children: [
//               Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
//                   style: const TextStyle(
//                       fontFamily: 'Fixed',
//                       fontWeight: FontWeight.bold,
//                       fontSize: 24.0)),
//               Slider(
//                 divisions: divisions,
//                 min: min,
//                 max: max,
//                 value: snapshot.data ?? value,
//                 onChanged: onChanged,
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

void showVerticalSliderDialog({
  required BuildContext context,
  // required String title,
  required Side side,
  int? divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  // TODO: Replace these two by ValueStream.
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  final deviceWidth = MediaQuery.of(context).size.width;
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      insetPadding: side == Side.left
          ? EdgeInsets.only(
              left: 30,
              right: deviceWidth - 40,
            )
          : EdgeInsets.only(left: deviceWidth - 40, right: 30),
      // title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 200.0,
          child: RotatedBox(
            quarterTurns: 3,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                // activeTrackColor: Colors.blue,
                // inactiveTrackColor: Colors.blue,
                // trackShape: RectangularSliderTrackShape(),
                trackHeight: 8.0,
                // thumbColor: Color.fromARGB(255, 204, 164, 35),
                // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                // overlayColor: Colors.red.withAlpha(32),
                // overlayShape: RoundSliderOverlayShape(overlayRadius: 25.0),
              ),
              child: Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ),
          ),
          //   ],
          // ),
        ),
      ),
    ),
  );
}

Widget artworkWidget({required int audioId, required ArtworkType artworkType}) {
  return QueryArtworkWidget(
    id: audioId,
    type: artworkType,
    artworkBorder: BorderRadius.circular(10),
    nullArtworkWidget: Image.asset(
      'assets/images/default_artwork.jpg',
      fit: BoxFit.fill,
    ),
  );
}

T? ambiguate<T>(T? value) => value;

class SliderCustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

enum Side { left, right }
