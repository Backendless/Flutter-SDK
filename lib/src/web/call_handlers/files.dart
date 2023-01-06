@JS()

library backendless_files_web;

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

class FilesCallHandler {
  FilesCallHandler();

  Future<dynamic> handleMethodCall(MethodCall call) {
    switch (call.method) {
      case "Backendless.Files.copyFile":
        return promiseToFuture(copyFile(
            call.arguments['sourcePathName'], call.arguments['targetPath']));
      case "Backendless.Files.exists":
        return promiseToFuture(exists(call.arguments['path']));
      case "Backendless.Files.getFileCount":
        return promiseToFuture(getFileCount(
            call.arguments['path'],
            call.arguments['pattern'],
            call.arguments['recursive'],
            call.arguments['countDirectories']));
      case "Backendless.Files.listing":
        return promiseToFuture(listing(
            call.arguments['path'],
            call.arguments['pattern'],
            call.arguments['recursive'],
            call.arguments['pagesize'],
            call.arguments['offset']));
      case "Backendless.Files.moveFile":
        return promiseToFuture(moveFile(
            call.arguments['sourcePathName'], call.arguments['targetPath']));
      case "Backendless.Files.remove":
        return promiseToFuture(remove(call.arguments['fileUrl']));
      case "Backendless.Files.removeDirectory":
        return promiseToFuture(
            removeDirectory(call.arguments['directoryPath']));
      case "Backendless.Files.renameFile":
        return promiseToFuture(renameFile(
            call.arguments['oldPathName'], call.arguments['newName']));
      case "Backendless.Files.saveFile":
        return promiseToFuture(saveFile(
            call.arguments['path'],
            call.arguments['fileName'],
            call.arguments['fileContent'],
            call.arguments['overwrite']));
      case "Backendless.Files.upload":
        return promiseToFuture(upload(call.arguments['file'],
            call.arguments['path'], call.arguments['overwrite']));
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "Backendless plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }
}

@JS('Backendless.Files.copyFile')
external String copyFile(String sourcePathName, String targetPath);

@JS('Backendless.Files.exists')
external bool exists(String path);

@JS('Backendless.Files.getFileCount')
external int getFileCount(String path,
    [String? pattern, bool? recursive, bool? countDirectories]);

@JS('Backendless.Files.listing')
external dynamic listing(String path,
    [String? pattern, bool? recursive, int? pagesize, int? offset]);

@JS('Backendless.Files.moveFile')
external String moveFile(String sourcePathName, String targetPath);

@JS('Backendless.Files.remove')
external int remove(String fileUrl);

@JS('Backendless.Files.removeDirectory')
external int removeDirectory(String directoryPath,
    [String? pattern, bool? recursive]);

@JS('Backendless.Files.renameFile')
external String renameFile(String oldPathName, String newName);

@JS('Backendless.Files.saveFile')
external String saveFile(
    String path, String fileName, Uint8List fileContent, bool overwrite);

@JS('Backendless.Files.upload')
external String upload(File file, String path, bool overwrite);
