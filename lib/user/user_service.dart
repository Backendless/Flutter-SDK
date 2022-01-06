part of backendless_sdk;

class UserService {
  BackendlessUser? _currentUser;
  LoginStorage? _loginStorage;

  LoginStorage? get loginStorage {
    if (_loginStorage == null) _loginStorage = LoginStorage();

    return _loginStorage;
  }

  Future<BackendlessUser?> getCurrentUser(bool reload) async {
    if (this._currentUser != null && !reload) return this._currentUser;
    if (reload && loginStorage!._hasData) {
      _currentUser = await Backendless.userService
          .findById(loginStorage!._objectId!)
          .catchError((e) {
        throw e;
      });
      return _currentUser;
    }

    return null;
  }

  setCurrentUser(BackendlessUser user) {
    _currentUser = user;
  }

  Future<BackendlessUser?> login(String login, String password,
      [bool stayLoggedIn = false]) async {
    if (await getCurrentUser(false) != null) await logout();

    Map? invokeResult = await Invoker.post<Map?>('/users/login',
        <String, dynamic>{'login': login, 'password': password});

    await handleUserLogin(invokeResult, stayLoggedIn);

    return getCurrentUser(false);
  }

  Future<void> logout() async {
    return Invoker.get('/users/logout')
        .then((value) => loginStorage!.deleteData());
  }

  Future<BackendlessUser?> findById(String id) async {
    Map? mappedUser = await Backendless.data.of('Users').findById(id);
    return Decoder().decode<BackendlessUser>(mappedUser);
  }

  Future<void> handleUserLogin(Map? invokeResult, bool stayLoggedIn) async {
    try {
      BackendlessUser user = Decoder().decode<BackendlessUser>(invokeResult)!;
      this.setCurrentUser(user);
      if (stayLoggedIn) {
        loginStorage!._objectId = (await getCurrentUser(false))!.getObjectId();
        loginStorage!._userToken = invokeResult!['user-token'];
        loginStorage!.saveData();
      }
    } catch (ex) {
      //TODO: -
      throw BackendlessException('Cannot parse user object');
    }
  }
}
