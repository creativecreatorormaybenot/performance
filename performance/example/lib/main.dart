import 'dart:math';

import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'performance overlay demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
      ),
      home: const _HomePage(),
    );
  }
}

// https://funvas.creativemaybeno.dev/#/32

class _HomePage extends StatefulWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  late final _funvas = _Funvas();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                FractionallySizedBox(
                  widthFactor: 1 / 2,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: FunvasContainer(
                      funvas: _funvas,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

/// Funvas animation taken from https://github.com/creativecreatorormaybenot/funvas/blob/a0c9f22d9bf8a9013b5212d6fa6227cb38dee083/funvas_tweets/lib/src/32.dart#L7.
class _Funvas extends Funvas {
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
