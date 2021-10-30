import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Widget that shows a performance overlay based on the [FrameTiming] API.
///
/// This is like the [PerformanceOverlay] from the framework, however, this is
/// supported on all platforms while the framework [PerformanceOverlay] is not
/// supported on Flutter web.
/// Furthermore, the way the information is displayed in this overlay closely
/// resembles the data available via the [FrameTiming] API and is opinionated
/// differently than the native [PerformanceOverlay].
class CustomPerformanceOverlay extends StatelessWidget {
  /// Creates a [CustomPerformanceOverlay] widget wrapped around the given
  /// [child] widget.
  const CustomPerformanceOverlay({
    Key? key,
    this.enabled = true,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.textBackgroundColor = const Color(0x77ffffff),
    this.uiColor = Colors.teal,
    this.rasterColor = Colors.blue,
    this.highLatencyColor = Colors.cyan,
    required this.child,
  }) : super(key: key);

  /// Whether the custom performance overlay should be enabled or not.
  ///
  /// When this is false, the custom performance overlay will not be inserted
  /// into the tree and therefore not be visible. Note that toggling this will
  /// only add or remove a child of a [Stack], which means that it is preferable
  /// to toggle this property instead of returning a completely different
  /// widget tree.
  ///
  /// Defaults to true.
  final bool enabled;

  /// Color that is used for the background of the individual charts.
  ///
  /// Defaults to [Colors.white].
  final Color backgroundColor;

  /// Color that is used for all text displaying stats.
  ///
  /// Defaults to [Colors.black].
  final Color textColor;

  /// Color that is used as the background color for all text.
  ///
  /// Defaults to `Color(0x77ffffff)`.
  final Color textBackgroundColor;

  /// Color that is used for indicating UI times.
  ///
  /// Defaults to [Colors.teal].
  final Color uiColor;

  /// Color that is used for indicating raster times.
  ///
  /// Defaults to [Colors.blue].
  final Color rasterColor;

  /// Color that is used for indicating high latency times.
  ///
  /// Defaults to [Colors.cyan].
  final Color highLatencyColor;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (enabled)
          Positioned(
            top: 0,
            right: 0,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: _CustomPerformanceOverlay(
                backgroundColor: backgroundColor,
                textColor: textColor,
                textBackgroundColor: textBackgroundColor,
                uiColor: uiColor,
                rasterColor: rasterColor,
                highLatencyColor: highLatencyColor,
              ),
            ),
          ),
      ],
    );
  }
}

/// How many frame timings will be stored for extrapolating the FPS (and showing
/// the bar chart).
///
/// The first few readings will be below the sample size.
const _kSampleSize = 32;

/// Indicates the y-axis for the frame timing bars in ms.
///
/// This means that we view the y-axis from 0 to [_kMaxFrameDuration]ms.
const _kMaxFrameDuration = Duration(milliseconds: 24);

/// Draws a line at y = [_kTargetFrameTiming]ms indicating the goal time span
/// for frames.
const _kTargetFrameTiming = Duration(milliseconds: 16);

/// Implementation of a simple custom performance overlay that tries to
/// show the current FPS.
///
/// This is a custom concept for how to use frame begin time and frame
/// end time to draw a bar chart and extrapolate FPS numbers (using
/// [SchedulerBinding.addPersistentFrameCallback] and post frame callbacks
/// for example). But it turns out [SchedulerBinding.addTimingsCallback]
/// already implements curated reports that also work on web :)
///
/// This widget handles both receiving the frame timings, storing a
/// [_kSampleSize], and drawing a stacked bar chart that shows all
/// [FrameTiming] properties.
///
/// See also:
///
/// * The [SchedulerBinding.addTimingsCallback] docs for further
///   information.
/// * [PlatformDispatcher.onReportTimings], which is the source of the data.
class _CustomPerformanceOverlay extends StatefulWidget {
  /// Constructs a [_CustomPerformanceOverlay] widget.
  const _CustomPerformanceOverlay({
    Key? key,
    required this.backgroundColor,
    required this.textColor,
    required this.textBackgroundColor,
    required this.uiColor,
    required this.rasterColor,
    required this.highLatencyColor,
  }) : super(key: key);

  final Color backgroundColor;
  final Color textColor;
  final Color textBackgroundColor;
  final Color uiColor;
  final Color rasterColor;
  final Color highLatencyColor;

  @override
  _CustomPerformanceOverlayState createState() =>
      _CustomPerformanceOverlayState();
}

class _CustomPerformanceOverlayState extends State<_CustomPerformanceOverlay> {
  var _samples = <FrameTiming>[];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addTimingsCallback(_timingsCallback);
  }

  @override
  void dispose() {
    SchedulerBinding.instance!.removeTimingsCallback(_timingsCallback);
    super.dispose();
  }

  void _timingsCallback(List<FrameTiming> frameTimings) {
    if (!mounted) return;
    final combinedSamples = [
      ..._samples,
      ...frameTimings,
    ];
    // The timings callback can be called during build on web, which is why we
    // need to defer updating the state to the next frame.
    // Furthermore, this prevents indefinite rebuilds on desktop as setting
    // state after the timings callback triggers another timings callback but
    // doing so in a post frame callback somehow does not.
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      if (!mounted) return;
      setState(() {
        _samples = combinedSamples.sublist(max(
          0,
          // Drop all samples exceeding the sample size to the left.
          combinedSamples.length - _kSampleSize,
        ));
        assert(_samples.length <= _kSampleSize);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: widget.textColor,
      fontSize: 10,
      backgroundColor: widget.textBackgroundColor,
    );

    return SizedBox(
      width: 448,
      height: 64,
      child: ColoredBox(
        color: widget.backgroundColor,
        child: ClipRect(
          child: Row(
            children: [
              Expanded(
                child: _PerformanceChart(
                  type: 'UI',
                  samples: [for (final e in _samples) e.rasterDuration],
                  color: widget.uiColor,
                  textStyle: textStyle,
                ),
              ),
              const VerticalDivider(
                width: 2,
                thickness: 2,
              ),
              Expanded(
                child: _PerformanceChart(
                  type: 'raster',
                  samples: [for (final e in _samples) e.buildDuration],
                  color: widget.rasterColor,
                  textStyle: textStyle,
                ),
              ),
              const VerticalDivider(
                width: 2,
                thickness: 2,
              ),
              Expanded(
                child: _PerformanceChart(
                  type: 'high latency',
                  samples: [for (final e in _samples) e.totalSpan],
                  color: widget.highLatencyColor,
                  textStyle: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Performance chart widget for arbitrary metrics.
class _PerformanceChart extends StatelessWidget {
  /// Constructs a [_PerformanceChart] widget.
  const _PerformanceChart({
    Key? key,
    required this.type,
    required this.samples,
    required this.color,
    required this.textStyle,
  })  : assert(samples.length <= _kSampleSize),
        super(key: key);

  /// The measurement type.
  ///
  /// This would be UI, raster, or high latencies (according to
  /// [PlatformDispatcher.onReportTimings]).
  final String type;

  /// The duration samples for the given [type].
  final List<Duration> samples;

  /// The bar color.
  final Color color;

  /// The text style used for the written stats.
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    var maxDuration = Duration.zero;
    var cumulative = Duration.zero;
    for (var i = 0; i < samples.length; i++) {
      final sample = samples[i];
      maxDuration = sample > maxDuration ? sample : maxDuration;
      cumulative += sample;
    }
    final avg = samples.isEmpty
        ? Duration.zero
        : Duration(microseconds: cumulative.inMicroseconds ~/ samples.length);
    final fps = samples.isEmpty ? 0 : 1e6 / avg.inMicroseconds;

    return Stack(
      children: [
        SizedBox.expand(
          child: CustomPaint(
            painter: _OverlayPainter(samples, color),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'max ${maxDuration.ms}ms ',
                    style: TextStyle(
                      color: maxDuration <= _kTargetFrameTiming
                          ? null
                          : Colors.red,
                    ),
                  ),
                  TextSpan(
                    text: 'avg ${avg.ms}ms\n',
                    style: TextStyle(
                      color: avg <= _kTargetFrameTiming ? null : Colors.red,
                    ),
                  ),
                  TextSpan(
                    text: '$type <= ${fps.toStringAsFixed(1)} FPS',
                  ),
                ],
                style: textStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OverlayPainter extends CustomPainter {
  _OverlayPainter(this.samples, this.color);

  final List<Duration> samples;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final aimHeight =
        size.height * (1 - _kTargetFrameTiming / _kMaxFrameDuration);
    canvas.drawLine(
      Offset(0, aimHeight),
      Offset(size.width, aimHeight),
      Paint()..color = Colors.black,
    );

    final barWidth = size.width / _kSampleSize;
    final paint = Paint()..color = color;
    for (var i = _kSampleSize - 1; i >= 0; i--) {
      final shifted = i - _kSampleSize + samples.length;
      if (shifted < 0) break;
      final timing = samples[shifted];

      final x = barWidth * i;
      final barExtent = timing / _kMaxFrameDuration;
      canvas.drawRect(
        Rect.fromLTWH(x, size.height * (1 - barExtent), barWidth,
            size.height * barExtent),
        timing <= _kTargetFrameTiming ? paint : (Paint()..color = Colors.red),
      );
    }
  }

  @override
  bool shouldRepaint(_OverlayPainter oldDelegate) {
    // Using object equality here rather than list equality because it is
    // cheaper and we *know* that the contents are different when the objects
    // are not equal because above, we are reassigning the samples list
    // whenever new timings are reported.
    return oldDelegate.samples != samples;
  }
}

extension on Duration {
  double operator /(Duration other) => inMicroseconds / other.inMicroseconds;

  /// The duration in milliseconds as a string with 1 decimal place.
  String get ms => inMilliseconds.toStringAsFixed(1);
}
