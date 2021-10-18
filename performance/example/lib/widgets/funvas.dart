import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:funvas/funvas.dart';

/// Funvas animation taken from https://github.com/creativecreatorormaybenot/funvas/blob/a0c9f22d9bf8a9013b5212d6fa6227cb38dee083/funvas_tweets/lib/src/32.dart#L7.
class ExampleFunvas extends Funvas {
  @override
  void u(double t) {
    const d = 750.0, h = d / 2;
    s2q(d);
    c.drawColor(const Color(0xff303030), BlendMode.srcOver);
    c.translate(h, h);
    int i, j, s;
    for (i = 9; i > 0; i--) {
      for (j = s = 3 << (i ~/ 3) + 1; j > 0; j--) {
        final af = s / (j + i / (1 + pow(4, 4 + i - t % 4.5 * 4)));
        final p = Offset.fromDirection(2 * pi / af - pi / 2, i * 37);
        final co = HSLColor.fromAHSL(1, (-360 / af - 42) % 360, 1, 3 / 4);
        c.drawCircle(p, 11 - i / 1.5, Paint()..color = co.toColor());
      }
    }
  }
}
