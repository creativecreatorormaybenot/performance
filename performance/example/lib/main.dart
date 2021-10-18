import 'package:flutter/cupertino.dart';
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

  var _funvasSize = 5 / 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Spacer(),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 3 / 4,
                    child: Slider(
                      min: 4 / 8,
                      max: 6 / 8,
                      value: _funvasSize,
                      onChanged: (value) {
                        setState(() {
                          _funvasSize = value;
                        });
                      },
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
