part of backendless_sdk;

class FileService {
  Future<bool?> exists(String path) async {
    if (!path.startsWith('/')) {
      path = '/$path';
    }

    String methodName = '/files$path?action=exists';

    return await Invoker.get(methodName);
  }

  Future<String?> copyFile(String sourcePath, String targetPath) async {
    if (sourcePath.isEmpty || targetPath.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.emptySourceOrTargetPaths);
    }

    Map<String, dynamic> parameters = {
      'sourcePath': sourcePath,
      'targetPath': targetPath,
    };
    return await Invoker.put('/files/copy', parameters);
  }

  Future<int?> getFileCount(String path,
      {String pattern = '*',
      bool recursive = false,
      bool countDirectories = false}) async {
    if (path.isEmpty) throw ArgumentError.value(ExceptionMessage.emptyPath);

    var methodName =
        '/files/$path/?action=count&pattern$pattern&sub=$recursive&countDirectories=$countDirectories';

    return await Invoker.get(methodName);
  }

  Future<int?> remove(
    String path, {
    String pattern = '*',
    bool recursive = false,
  }) async {
    if (path.isEmpty) throw ArgumentError.value(ExceptionMessage.emptyPath);

    var methodName = '/files/$path?pattern=$pattern&sub=$recursive';

    return await Invoker.delete(methodName);
  }

  Future<String?> rename(String path, String newName) async {
    if (path.isEmpty || newName.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.emptyPath);
    }

    Map<String, dynamic> parameters = {
      'oldPathName': path,
      'newName': newName,
    };

    return await Invoker.put('/files/rename', parameters);
  }

  Future<String?> moveFile(String sourcePath, String targetPath) async {
    if (sourcePath.isEmpty || targetPath.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.emptyPath);
    }

    Map<String, dynamic> parameters = {
      'sourcePath': sourcePath,
      'targetPath': targetPath,
    };

    return await Invoker.put('/files/move', parameters);
  }

  Future<FileInfo?> listing(String path,
      {String pattern = '*',
      bool recursive = false,
      int? pageSize,
      int? offset}) async {
    if (path.isEmpty) throw ArgumentError.value(ExceptionMessage.emptyPath);
    var methodName = 'files/$path?pattern=$pattern&recursive=$recursive';

    if (pageSize != null) methodName += '&pagesize=$pageSize';

    if (offset != null) methodName += '&offset=$offset';

    return await Invoker.get(methodName);
  }

  ///Save a file to the specified path.
  ///File content should be encoded in base64.
  ///Example:
  ///```dart
  ///var base64Str = base64.encode('The quick brown fox jumps over the lazy dog'.codeUnits);
  ///```
  Future<String?> saveFile(String fileContent, String path, String fileName,
      {bool overwrite = false}) async {
    String methodName = '/files/binary/$path/$fileName';
    if (overwrite) methodName += '?overwrite=$overwrite';

    var parameters = fileContent;
    var headers = <String, String>{
      'Content-Type': 'text/plain',
    };

    return await Invoker.put(methodName, parameters, customHeaders: headers);
  }

  ///Upload a file from the specified URL at the specified path.
  Future<String?> upload(String urlToFile, String backendlessPath,
      {bool overwrite = false}) async {
    Map<String, dynamic> parameters = {'url': urlToFile};
    String methodName = '/files/$backendlessPath?overwrite=$overwrite';

    return await Invoker.post(methodName, parameters);
  }

  ///This method adds data to the content of your file from one of the key parameters.
  ///You need to specify only one of the key parameters: [base64Content], [urlToFile], [dataContent].
  ///If more than one of the key parameters is specified. Only one of the specifications will be executed.
  ///The priority looks like this:
  ///1. [base64Content] - take file and decode from base64 like for [saveFile] method.
  ///2. [urlToFile] - take file  from URL like in [upload] method.
  ///3. [dataContent] - take body as is and append to file.
  Future<String> append(String filePath, String fileName,
      {String? base64Content, String? urlToFile, String? dataContent}) async {
    if (base64Content?.isNotEmpty ?? false) {
      String methodName = '/files/append/binary/$filePath/$fileName';
      var headers = <String, String>{
        'Content-Type': 'text/plain',
      };

      return await Invoker.put(methodName, base64Content,
          customHeaders: headers);
    }

    if (urlToFile?.isNotEmpty ?? false) {
      String methodName = '/files/append/$filePath/$fileName';
      var parameters = <String, String>{'url': urlToFile!};

      return await Invoker.post(methodName, parameters);
    }

    if (dataContent?.isNotEmpty ?? false) {
      String methodName = '/files/append/$filePath/$fileName';
      var headers = <String, String>{
        'Content-Type': 'text/plain',
      };

      return await Invoker.put(methodName, dataContent, customHeaders: headers);
    }

    throw ArgumentError(
        "${ExceptionMessage.noOneKeyArgumentSpecified}: 'base64Content', 'urlToFile' or 'dataContent'");
  }
}
