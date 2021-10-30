# performance [![GitHub stars][github badge]][repository] [![Pub version][pub badge]][pub] [![demo badge]][demo] [![Twitter Follow][twitter badge]][twitter]

Performance overlay package for Flutter apps that works on web.

![sample]

## Getting started

To use this package, follow the [installing guide].

### Usage

Adding the performance overlay is as simple as wrapping your app in the
`CustomPerformanceOverlay` widget:

```dart
return CustomPerformanceOverlay(
  child: child,
);
```

You can also disable it on-demand using the `enabled` parameter:

```dart
return CustomPerformanceOverlay(
  enabled: false,
  child: child,
);
```

Furthermore, you can also use the following parameters for customization:

* `alignment` and `scale` for alignment and sizing of the overlay.
* `sampleSize`, `targetFrameTime`, and `barRangeMax` for how the performance
   data is displayed.
* `backgroundColor`, `textColor`, `textBackgroundColor`, `uiColor`,
  `rasterColor`, and `highLatencyColor` for custom theming.

See the [`CustomPerformanceOverlay` class documentation][class docs] for more
information on each of these members.

---

To understand how to read the charts and limitations, please see the
[main README on GitHub][repository].

[sample]: https://user-images.githubusercontent.com/19204050/139553925-73c30ef5-8756-4032-a6fb-55866a8979b6.png
[installing guide]: https://pub.dev/packages/performance/install
[github badge]: https://img.shields.io/github/stars/creativecreatorormaybenot/performance.svg
[repository]: https://github.com/creativecreatorormaybenot/performance
[pub badge]: https://img.shields.io/pub/v/performance.svg
[pub]: https://pub.dev/packages/performance
[twitter badge]: https://img.shields.io/twitter/follow/creativemaybeno?label=Follow&style=social
[twitter]: https://twitter.com/creativemaybeno
[demo]: https://performance.creativemaybeno.dev
[demo badge]: https://img.shields.io/badge/web-demo-yellow
[class docs]: https://pub.dev/documentation/performance/latest/performance/CustomPerformanceOverlay-class.html
