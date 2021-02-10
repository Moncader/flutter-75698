import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const MethodChannel _channel =
      const MethodChannel('com.example/exoflutter');
  static dynamic get _createExoPlayer async {
    final dynamic result = await _channel.invokeMethod('createPlayer');
    return result;
  }

  Key _key;

  @override
  void initState() {
    super.initState();
    // Android Versionを表示する
    _createExoPlayer.then((value) => print(value));
    _key = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _createExoPlayer,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PlatformViewLink(
              key: _key,
              viewType: 'com.exoplayer.playerview',
              surfaceFactory: (context, viewController) {
                return AndroidViewSurface(
                  controller: viewController,
                  hitTestBehavior: PlatformViewHitTestBehavior.transparent,
                  gestureRecognizers: const <
                      Factory<OneSequenceGestureRecognizer>>{},
                );
              },
              onCreatePlatformView: (params) {
                return PlatformViewsService.initSurfaceAndroidView(
                  id: params.id,
                  viewType: params.viewType,
                  layoutDirection: Directionality.of(context),
                  creationParams: const <String, dynamic>{},
                  creationParamsCodec: const StandardMessageCodec(),
                )
                  ..addOnPlatformViewCreatedListener(
                      params.onPlatformViewCreated)
                  ..create();
              },
            );
          } else {
            return Center(
              child: Text("Loading"),
            );
          }
        },
      ),
      // body: PlatformViewLink(
      //   key: GlobalKey(),
      //   viewType: 'com.exoplayer.playerview',
      //   surfaceFactory: (context, viewController) {
      //     return AndroidViewSurface(
      //       controller: viewController,
      //       hitTestBehavior: PlatformViewHitTestBehavior.transparent,
      //       gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
      //     );
      //   },
      //   onCreatePlatformView: (params) {
      //     return PlatformViewsService.initSurfaceAndroidView(
      //       id: params.id,
      //       viewType: params.viewType,
      //       layoutDirection: Directionality.of(context),
      //       creationParams: const <String, dynamic>{},
      //       creationParamsCodec: const StandardMessageCodec(),
      //     )
      //       ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
      //       ..create();
      //   },
      // ),
    );
  }
}
