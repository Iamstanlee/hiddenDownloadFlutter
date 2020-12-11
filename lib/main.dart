import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hiddendownload/download.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hidden Download',
      theme: ThemeData(fontFamily: 'Chococooky'),
      home: MyApp(title: 'Hidden Download'),
    );
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Download download = new Download();
  String state;
  String path =
      ''; // path of the downloaded video, this is returned from the [download.enqueue] method
  double kHorizontalPadding = 64;

  @override
  void initState() {
    super.initState();
  }

  // update local app state
  void updateState(String value) => setState(() => state = value);

  Widget btn({@required Function onTap, @required String label}) => Container(
      margin:
          EdgeInsets.symmetric(horizontal: kHorizontalPadding, vertical: 10),
      color: Colors.black.withOpacity(0.2),
      child: InkWell(
          onTap: onTap,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: Text('$label', style: TextStyle(color: Colors.black)))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Align(
                  alignment: Alignment.center, child: Text('${state ?? ''}')),
            )
          ],
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          btn(
              label: 'Download',
              onTap: () {
                // don't download if the video has already been downloaded, you should implement this
                // in a better way that's inline with your app design
                if (path.isEmpty) {
                  updateState('Downloading');
                  download.enqueue(context, onDone: (savePath) {
                    setState(() {
                      path = savePath;
                    });
                    updateState('Downloaded');
                  }, onError: () {
                    updateState('Error Downloading');
                  });
                }
              }),
          btn(
              label: 'Play Downloaded Video',
              onTap: () {
                updateState('');
                if (path.isNotEmpty) download.play(context, path);
              }),
          btn(
              label: 'Delete All Downloads',
              onTap: () async {
                path = '';
                updateState('Deleting');
                await download.delete();
                updateState('');
              })
        ]));
  }
}
