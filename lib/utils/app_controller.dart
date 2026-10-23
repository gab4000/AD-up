import 'dart:convert';
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yaml/yaml.dart';

var currentVersion = ''.obs;
var latestVersion = ''.obs;
var downloadUrl = ''.obs;
var releaseNode = ''.obs;
var isDownloading = false.obs;
var downloadProgress = 0.0.obs;
var isInstalling = false.obs;
var count = 0.obs;
bool availableUpdate = false;

void counter() {
  count++;
}

void requestStoragePermission() async {
  if (await Permission.manageExternalStorage.isGranted) {
    print("Storage permission already granted.");
    return;
  }

  final status = await Permission.manageExternalStorage.request();
  if (status.isGranted) {
    print("Storage permission granted.");
  } else if (status.isPermanentlyDenied) {
    print("Storage permission permanently denied. Opening settings...");
    await openAppSettings();
  }
}

void requestInstallPackagesPermission() async {
  if (Platform.isAndroid) {
    if (await Permission.requestInstallPackages.isGranted) {
      print("Install packages permission already granted.");
    } else {
      final status = await Permission.requestInstallPackages.request();
      if (status.isGranted) {
        print("Install packages permission granted.");
      } else {
        print("Install packages permission denied.");
      }
    }
  }
}

void requestInstallUnknownSourcesPermission() async {
  if (Platform.isAndroid &&
      await Permission.requestInstallPackages.isDenied) {
    final packageInfo = await PackageInfo.fromPlatform();
    final intent = AndroidIntent(
      action: 'android.settings.MANAGE_UNKNOWN_APP_SOURCES',
      data: 'package:${packageInfo.packageName}',
    );

    try {
      await intent.launch();
    } catch (e) {
      print('Error opening unknown sources settings: $e');
    }
  }
}

void checkVersion(BuildContext context) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  currentVersion.value = packageInfo.version;

  Response response = await Dio().get('https://raw.githubusercontent.com/gab4000/AD-up/refs/heads/main/pubspec.yaml');
  final mapData = loadYaml(response.data);
  latestVersion.value = mapData['version'];

  if (currentVersion.value != latestVersion.value) {
    final String releaseLink = "https://github.com/gab4000/AD-up/releases/download/${latestVersion.value}";
    Response releaseResponse = await Dio().get("https://api.github.com/repos/gab4000/AD-up/releases/tags/${latestVersion.value}");
    final releaseData = jsonDecode(releaseResponse.data);
    releaseNode.value = releaseData['body'];
    downloadUrl.value = "$releaseLink/AD-up_${latestVersion.value}.apk";
    showUpdateDialog(context);
  }
}

void showUpdateDialog(BuildContext context) {
  showDialog(context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "Mise à jour disponible",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Une nouvelle version (${latestVersion.value}) de l'application est disponible.",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Changements : ${releaseNode.value}.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Plus tard"),
        ),
        SizedBox(
          width: 10,
        ),
        TextButton(
          onPressed: () {
            requestStoragePermission();
            requestInstallPackagesPermission();
            downloadAndInstallUpdate();
            Navigator.pop(context);
          },
          child: Text("Mettre à jour"),
        ),
      ],
    ),
  );
}

void downloadAndInstallUpdate() async {
  try {
    isDownloading.value = true;

    if (await Permission.manageExternalStorage.request().isGranted) {
      final dir = await getExternalStorageDirectory();
      final filePath = '${dir!.path}/AD-up_${latestVersion.value}.apk';

      await Dio().download(
        downloadUrl.value,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = (received / total * 100);
          }
        },
      );
      print('APK downloaded at: $filePath');

      isDownloading.value = false;

      requestInstallUnknownSourcesPermission();
      isInstalling.value = true;

      final result = await OpenFilex.open(filePath);
      print("OpenFile result: ${result.message}");

      isInstalling.value = false;
    } else {
      print('Storage permission denied');
    }
  } catch (e) {
    isDownloading.value = false;
    isInstalling.value = false;
    print('Error downloading or installing update: $e');
  }
}