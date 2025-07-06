import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:funvas/funvas.dart';
import 'package:performance/performance.dart';
import 'package:performance_example/widgets/funvas.dart';
import 'package:performance_example/widgets/link.dart';

void main() {
  usePathUrlStrategy();
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'performance overlay demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Colors.amber,
          accentColor: Colors.amberAccent,
        ),
      ),
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  late final _funvas = ExampleFunvas();

  var _funvasSize = 3 / 4;
  var _overlaySize = 1.0;
  var _funvasPlaying = false;
  var _overlayEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPerformanceOverlay(
        enabled: _overlayEnabled,
        scale: _overlaySize,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      heightFactor: _funvasSize,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: FunvasContainer(
                                paused: !_funvasPlaying,
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
                      widthFactor: 5 / 8,
                      child: Slider(
                        min: 5 / 9,
                        max: 8 / 9,
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
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('play funvas'),
                          Switch(
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            value: _funvasPlaying,
                            onChanged: (value) {
                              setState(() {
                                _funvasPlaying = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('enable overlay'),
                          Switch(
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            value: _overlayEnabled,
                            onChanged: (value) {
                              setState(() {
                                _overlayEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Text(
                        'interact with the demo to observe performance :)',
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16,
                        ),
                        child: FractionallySizedBox(
                          widthFactor: 5 / 8,
                          child: Slider(
                            min: 1 / 2,
                            max: 3,
                            value: _overlaySize,
                            onChanged: (value) {
                              setState(() {
                                _overlaySize = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
