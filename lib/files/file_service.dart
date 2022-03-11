part of backendless_sdk;

class FileService {
  Future<bool?> exists(String path) async {
    return await Invoker.get('/files/$path?action=exists');
  }

  Future<String?> copyFile(String sourcePath, String targetPath) async {
    if (sourcePath.isEmpty || targetPath.isEmpty)
      throw ArgumentError.value(ExceptionMessage.EMPTY_SOURCE_OR_TARGET_PATHS);

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
    if (path.isEmpty) throw ArgumentError.value(ExceptionMessage.EMPTY_PATH);

    var methodName =
        '/files/$path/?action=count&pattern$pattern&sub=$recursive&countDirectories=$countDirectories';

    return await Invoker.get(methodName);
  }

  Future<int?> remove(
    String path, {
    String pattern = '*',
    bool recursive = false,
  }) async {
    if (path.isEmpty) throw ArgumentError.value(ExceptionMessage.EMPTY_PATH);

    var methodName = '/files/$path?pattern=$pattern&sub=$recursive';

    return await Invoker.delete(methodName);
  }

  Future<String?> rename(String path, String newName) async {
    if (path.isEmpty || newName.isEmpty)
      throw ArgumentError.value(ExceptionMessage.EMPTY_PATH);

    Map<String, dynamic> parameters = {
      'oldPathName': path,
      'newName': newName,
    };

    return await Invoker.put('/files/rename', parameters);
  }

  Future<String?> moveFile(String sourcePath, String targetPath) async {
    if (sourcePath.isEmpty || targetPath.isEmpty)
      throw ArgumentError.value(ExceptionMessage.EMPTY_PATH);

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
    if (path.isEmpty) throw ArgumentError.value(ExceptionMessage.EMPTY_PATH);
    var methodName = 'files/$path?pattern=$pattern&recursive=$recursive';

    if (pageSize != null) methodName += '&pagesize=$pageSize';

    if (offset != null) methodName += '&offset=$offset';

    return await Invoker.get(methodName);
  }

  Future<String?> saveFile(Uint8List fileContent, String path, String fileName,
      {bool overwrite = false}) async {
    var methodName = '/files/binary/$path/$fileName';
    if (overwrite) methodName += '?overwrite=$overwrite';

    var parameters = fileContent;

    return await Invoker.put(methodName, parameters);
  }

  Future<String?> upload(String urlToFile, String backendlessPath,
      {bool overwrite = false}) async {
    Map<String, dynamic> parameters = {'url': urlToFile};
    String methodName = '/files/$backendlessPath?overwrite=$overwrite';

    return await Invoker.post(methodName, parameters);
  }
}
