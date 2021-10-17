import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import 'package:performance_example/widgets/funvas.dart';
import 'package:performance_example/widgets/link.dart';
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

class _HomePage extends StatefulWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  late final _funvas = ExampleFunvas();

  var _funvasSize = 3 / 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FractionallySizedBox(
                  widthFactor: _funvasSize,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: FunvasContainer(
                      funvas: _funvas,
                    ),
                  ),
                ),
                const Link(
                  url: 'https://funvas.creativemaybeno.dev/#/32',
                  body: Text('funvas animation'),
                ),
                Slider(
                  min: 1 / 2,
                  max: 1,
                  value: _funvasSize,
                  onChanged: (value) {
                    setState(() {
                      _funvasSize = value;
                    });
                  },
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
