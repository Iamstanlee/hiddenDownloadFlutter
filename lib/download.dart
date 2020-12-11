import 'dart:io';
import 'package:flutter/material.dart' hide Key;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hiddendownload/helpers.dart';
import 'package:hiddendownload/videoPlayer.dart';
import 'package:path_provider/path_provider.dart';

class Download {
  static const String URL =
      "http://mirrors.standaloneinstaller.com/video-sample/small.3gp";
  void enqueue(BuildContext context,
      {Function(String) onDone, Function onError}) async {
    var directory = await getApplicationDocumentsDirectory();
    var saveDir = Directory("${directory.path}/downloads");

    // create the save directory if it does not exist
    if (!saveDir.existsSync()) await saveDir.create();
    var savePath = "${saveDir.path}";
    var filePath = "$savePath/vid.3gp";
    if (File(filePath).existsSync()) {
      // file has already been downloaded, play instead
      onDone(filePath);
      play(context, filePath);
    } else {
      await FlutterDownloader.enqueue(
          url: URL,
          fileName: "vid.3gp",
          savedDir: savePath,
          openFileFromNotification: false);
      // handle the download and tracking of download progress yourself depending on
      // your app design
      // FlutterDownloader.registerCallback((id, status, progress) async {
      //   if (status == DownloadTaskStatus.complete) {
      // onDone(filePath);
      //   }
      // });
      onDone(filePath);
    }
  }

  // clear downloads
  Future<void> delete() async {
    var directory = await getApplicationDocumentsDirectory();
    var downloadDir = Directory("${directory.path}/downloads");
    // delete the directory if it exists
    if (downloadDir.existsSync()) downloadDir.delete(recursive: true);
  }

  void play(BuildContext context, String path) async {
    push(context, Player(path: path));
  }
}
