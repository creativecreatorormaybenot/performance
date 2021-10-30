# performance [![Pub version][pub shield]][pub] [![demo badge]][demo] [![Twitter Follow][twitter badge]][twitter]

Performance overlay for Flutter apps that works on web.

![sample]

## Reading the charts

You can read the charts in the performance overlay like this:

* Every bar represents a single frame.
* The height of each bar represents the total time it took to render the frame.
* The line indicates the target frame time (e.g. 16ms for 60 FPS) and frames
  that cross that line turn red.
* The overlay is divided into three charts.
  - UI: the time it takes the UI to build.
  - Raster: the time it takes to rasterize the frame.
  - High latency: the total time between vsync start and raster finish, i.e. the
    time it takes from an input to seeing the next frame.
* The "max" value shows how long the worst sample in the displayed range took.
* The "avg" value represents the average of all samples in the displayed range.
* The displayed FPS value indicates the *best logically possible* number of
  frames that could have been rendered per second. This might not be the actual
  value, but the actual value is definitely not greater than this. This is
  computed based on the average.

## Limitations

The package is based on the [`FrameTiming` API][frame timing api]. Everything
documented there applies. This should correspond one to one with the values you
see in the framework performance overlay on mobile and on native desktop. So if
you like how this looks better, you can also use this package on mobile and
native desktop :)

On web, however, it shows somewhat limited data. This is because performance
data from the GPU on web is not available in the `FrameTiming` instances (which
would be part of the raster duration on native). What is included in the raster
duration on web are only parts of what is done on the GPU thread on native (due
to limitations on the web which require running the computations on the UI
thread).
If you want to access the GPU performance data, you can use Chrome DevTools or
`chrome://tracing` for example.

### Repo structure

This repo currently contains the following packages:

| Package                      | Contents                                                                                                                                                                                         |
| :--------------------------- | :----------------------------------------------------------------------------------------------- |
| [`performance`][performance] | The actual `performance` Flutter package for the performance overlay that is also hosted on Pub. |

[sample]: https://user-images.githubusercontent.com/19204050/139553925-73c30ef5-8756-4032-a6fb-55866a8979b6.png
[twitter]: https://twitter.com/creativemaybeno
[twitter badge]: https://img.shields.io/twitter/follow/creativemaybeno?label=Follow&style=social
[demo]: https://performance.creativemaybeno.dev
[demo badge]: https://img.shields.io/badge/web-demo-yellow
[performance]: https://github.com/creativecreatorormaybenot/performance/tree/main/performance
[pub]: https://pub.dev/packages/performance
[pub shield]: https://img.shields.io/pub/v/performance.svg
[frame timing api]: https://api.flutter.dev/flutter/dart-ui/FrameTiming-class.html
