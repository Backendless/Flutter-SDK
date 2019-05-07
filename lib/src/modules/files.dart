import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:backendless_sdk/src/utils/utils.dart';

class BackendlessFiles {
  static const MethodChannel _channel = const MethodChannel(
    'backendless/files', 
    StandardMethodCodec(BackendlessMessageCodec()));
  final Map<int, UploadCallback> _uploadCallbacks = <int, UploadCallback>{};
  int _nextUploadHandle = 0;

  factory BackendlessFiles() => _instance;
  static final BackendlessFiles _instance = new BackendlessFiles._internal();

  BackendlessFiles._internal() {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "Backendless.Data.UploadCallback") {
        int handle = call.arguments["handle"];
        int progress = call.arguments["progress"];
        _uploadCallbacks[handle].onProgressUpdate(progress);
      }
    });
  }

  Future<String> copyFile(String sourcePathName, String targetPath) async =>
    _channel.invokeMethod("Backendless.Files.copyFile", <String, dynamic> {
      "sourcePathName":sourcePathName,
      "targetPath":targetPath
    });

  Future<bool> exists(String path) =>
    _channel.invokeMethod("Backendless.Files.exists", <String, dynamic> {
      "path":path
    });

  Future<int> getFileCount(String path, [String pattern, bool recursive, bool countDirectories]) =>
    _channel.invokeMethod("Backendless.Files.getFileCount", <String, dynamic> {
      "path":path,
      "pattern":pattern,
      "recursive":recursive,
      "countDirectories":countDirectories
    });

  Future<List<FileInfo>> listing(String path, [String pattern, bool recursive, int pagesize, int offset]) async {
    if (pattern != null && recursive == null)
      throw new ArgumentError("Argument 'pattern' should be defined with argument 'recursive'");    
    if (pagesize != null && offset == null)
      throw new ArgumentError("Argument 'pagesize' should be defined with argument 'offset'");    

    return (await _channel.invokeMethod("Backendless.Files.listing", <String, dynamic> {
      "path":path,
      "pattern":pattern,
      "recursive":recursive,
      "pagesize":pagesize,
      "offset":offset
    })).cast<FileInfo>();
  }

  Future<String> moveFile(String sourcePathName, String targetPath) async =>
    _channel.invokeMethod("Backendless.Files.moveFile", <String, dynamic> {
      "sourcePathName":sourcePathName,
      "targetPath":targetPath
    });

  Future<int> remove(String fileUrl) async =>
    _channel.invokeMethod("Backendless.Files.remove", <String, dynamic> {
      "fileUrl":fileUrl
    });
  
  Future<int> removeDirectory(String directoryPath, [String pattern, bool recursive]) async {
    if (pattern != null && recursive == null)
      throw new ArgumentError("Argument 'pattern' should be defined with argument 'recursive'");    
    
    return _channel.invokeMethod("Backendless.Files.removeDirectory", <String, dynamic> {
      "directoryPath":directoryPath,
      "pattern":pattern,
      "recursive":recursive
    });
  }

  Future<String> renameFile(String oldPathName, String newName) async =>
    _channel.invokeMethod("Backendless.Files.renameFile", <String, dynamic> {
      "oldPathName":oldPathName,
      "newName":newName
    });

  Future<String> saveFile(Uint8List fileContent, {String path, String fileName, String filePathName, bool overwrite}) async {
    checkArguments({"path":path, "fileName":fileName}, {"filePathName":filePathName});

    return _channel.invokeMethod("Backendless.Files.saveFile", <String, dynamic> {
      "path":path,
      "fileName":fileName,
      "filePathName":filePathName,
      "fileContent":fileContent,
      "overwrite":overwrite
    });
  }

  Future<String> upload(File file, String path, {bool overwrite, void onProgressUpdate(int progress)}) async {
    Map<String, dynamic> args = <String, dynamic> {
      "filePath":file.path,
      "path":path,
      "overwrite":overwrite
    };

    if (onProgressUpdate != null) {
      int handle = _nextUploadHandle++;
      UploadCallback uploadCallback = new UploadCallback(onProgressUpdate);
      _uploadCallbacks[handle] = uploadCallback;
      args["handle"] = handle;
    }
    return _channel.invokeMethod("Backendless.Files.upload", args);
  }

}

class FileInfo {
  String name;
  int createdOn;
  String publicUrl;
  String url;
  int size;

  FileInfo({this.name, this.createdOn, this.publicUrl, this.url, this.size});
}

class UploadCallback {
  void Function(int progress) onProgressUpdate;

  UploadCallback(this.onProgressUpdate);
}