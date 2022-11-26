part of backendless_sdk;

class LoginStorage {
  final storage = const FlutterSecureStorage();
  String? _objectId;
  String? _userToken;
  bool _hasData = false;

  LoginStorage() {
    loadData();
  }

  Future<void> saveData() async {
    storage.write(key: 'userToken', value: _userToken);
    storage.write(key: 'userId', value: _objectId);
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

  Future deleteData() async {
    storage.delete(key: 'userToken');
    storage.delete(key: 'userId');
  }
}
