part of backendless_sdk;

class LoginStorage {
  final storage = const FlutterSecureStorage();
  String? _objectId;
  String? _userToken;
  bool _hasData = false;

  static Future<LoginStorage> create() async {
    var temp = LoginStorage._internal();
    await temp.loadData();
    return temp;
  }

  LoginStorage._internal();

  Future<void> saveData() async {
    await storage.write(key: 'userToken', value: _userToken);
    await storage.write(key: 'userId', value: _objectId);
    _hasData = true;
  }

  Future loadData() async {
    try {
      if (await storage.containsKey(key: 'userToken') &&
          await storage.containsKey(key: 'userId')) {
        _userToken = await storage.read(key: 'userToken');
        _objectId = await storage.read(key: 'userId');
        _hasData = _userToken != null && _objectId != null ? true : false;
      } else {
        _hasData = false;
      }
    } catch (e) {
      storage.delete(key: 'userToken');
      storage.delete(key: 'userId');
      _hasData = false;
    }
  }

  Future<void> deleteData() async {
    storage.delete(key: 'userToken');
    storage.delete(key: 'userId');
    _hasData = false;
  }

  Future<void> setUserToken(String? token) async {
    _userToken = token;
    if (_userToken != null) {
      await storage.write(key: 'userToken', value: token);
      _hasData = true;
    } else {
      if (await storage.containsKey(key: 'userToken')) {
        storage.delete(key: 'userToken');
      }

      if (!await storage.containsKey(key: 'userId')) {
        _hasData = false;
      }
    }
  }
}
