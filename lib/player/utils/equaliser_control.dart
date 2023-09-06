import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class EqualizerControls extends StatelessWidget {
  final AndroidEqualizer equalizer;

  const EqualizerControls({
    Key? key,
    required this.equalizer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AndroidEqualizerParameters>(
      future: equalizer.parameters,
      builder: (context, snapshot) {
        final parameters = snapshot.data;
        if (parameters == null) return const SizedBox();
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            for (var band in parameters.bands)
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<double>(
                        stream: band.gainStream,
                        builder: (context, snapshot) {
                          return verticalSlider(
                            context: context,
                            min: parameters.minDecibels,
                            max: parameters.maxDecibels,
                            value: band.gain,
                            onChanged: band.setGain,
                          );
                        },
                      ),
                    ),
                    Text('${band.centerFrequency.round()} Hz'),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }



  Widget verticalSlider({required BuildContext context, required double value, double min = 0.0, double max = 1.0, ValueChanged<double>? onChanged}) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      alignment: Alignment.bottomCenter,
      child: Transform.rotate(
        angle: -pi / 2,
        child: Container(
          width: 400.0,
          height: 400.0,
          alignment: Alignment.center,
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

}