part of backendless_sdk;

class UserService {
  BackendlessUser? _currentUser;
  LoginStorage? _loginStorage = LoginStorage();

  LoginStorage get loginStorage {
    return _loginStorage!;
  }

  Future<BackendlessUser?> getCurrentUser(bool reload) async {
    if (this._currentUser != null && !reload) return this._currentUser;
    if (reload && loginStorage._hasData) {
      _currentUser = await Backendless.userService
          .findById(loginStorage._objectId!)
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

  Future<String?> loggedInUser() async {
    if (await getCurrentUser(false) != null)
      return (await getCurrentUser(false))!.getUserId();
    else if (loginStorage._hasData) return loginStorage._objectId;

    return null;
  }

  Future<List<UserProperty>?> describeUserClass() async {
    return await Invoker.get('/users/userclassprops');
  }

  Future<BackendlessUser?> login(String login, String password,
      [bool stayLoggedIn = false]) async {
    if (await getCurrentUser(false) != null) await logout();

    Map? invokeResult = await Invoker.post<Map?>('/users/login',
        <String, dynamic>{'login': login, 'password': password});

    await handleUserLogin(invokeResult, stayLoggedIn);

    return getCurrentUser(false);
  }

  Future<BackendlessUser?> loginAsGuest([bool stayLoggedIn = false]) async {
    Map? invokeResult = await Invoker.post<Map?>('/users/register/guest', null);

    await handleUserLogin(invokeResult, stayLoggedIn);

    return getCurrentUser(false);
  }

  Future<BackendlessUser?> loginWithOAuth1(
      String providerCode,
      String authToken,
      String authTokenSecret,
      Map<String, String> fieldsMappings,
      {BackendlessUser? guestUser,
      bool stayLoggedIn = false}) async {
    Map<String, dynamic> parameters = {
      'accessToken': authToken,
      'accessTokenSecret': authTokenSecret,
      'fieldsMappings': fieldsMappings
    };

    if (guestUser != null) parameters['guestUser'] = jsonEncode(guestUser);

    Map? invokeResult =
        await Invoker.post('/users/social/twitter/login', parameters);

    await handleUserLogin(invokeResult, stayLoggedIn);

    return getCurrentUser(false);
  }

  Future<BackendlessUser?> loginWithOauth2(
      String providerCode, String authToken, Map<String, String> fieldsMappings,
      {BackendlessUser? guestUser, bool stayLoggedIn = false}) async {
    Map<String, dynamic> parameters = {
      'accessToken': authToken,
      'fieldsMappings': fieldsMappings,
    };

    if (guestUser != null) parameters['guestUser'] = jsonEncode(guestUser);

    Map? invokeResult =
        await Invoker.post('users/social/$providerCode/login', parameters);

    await handleUserLogin(invokeResult, stayLoggedIn);

    return getCurrentUser(false);
  }

  Future<BackendlessUser?> register(BackendlessUser user) async {
    return await Invoker.post('/users/register', user);
  }

  Future<void> logout() async {
    return Invoker.get('/users/logout')
        .then((value) => loginStorage.deleteData());
  }

  Future<BackendlessUser?> update(BackendlessUser user) async {
    if (user.getUserId()?.isEmpty ?? false)
      throw ArgumentError.value(ExceptionMessage.EMPTY_NULL_USER_ID);

    return await Invoker.put('/users/${user.getUserId()}', user);
  }

  Future<BackendlessUser?> findById(String id) async {
    Map? mappedUser = await Backendless.data.of('Users').findById(id);
    return Decoder().decode<BackendlessUser>(mappedUser);
  }

  Future<List<BackendlessUser>?> findByRole(String roleName,
      {bool? loadRoles, DataQueryBuilder? queryBuilder}) async {
    String methodName = '/users/role/$roleName';
    if (loadRoles != null && loadRoles == true)
      methodName += '?loadRoles=true';
    else
      methodName += '?loadRoles=false';

    if (queryBuilder != null) methodName += '&';

    return await Invoker.get<List<BackendlessUser>?>('$methodName',
        args: queryBuilder);
  }

  Future<List<String>?> getUserRoles() async {
    return await Invoker.get('/users/userroles');
  }

  Future<String?> createEmailConfirmationURL(String identity) async {
    if (identity.isEmpty)
      throw ArgumentError.value(ExceptionMessage.EMPTY_IDENTITY);

    return await Invoker.post(
        '/users/createEmailConfirmationURL/$identity', null);
  }

  Future<String?> resendEmailConfirmation(String identity) async {
    if (identity.isEmpty)
      throw ArgumentError.value(ExceptionMessage.EMPTY_IDENTITY);

    return await Invoker.post(
        '/users/identity/resendEmailConfirmation/$identity', null);
  }

  Future<void> restorePassword(String identity) async {
    if (identity.isEmpty)
      throw ArgumentError.value(ExceptionMessage.EMPTY_IDENTITY);

    return await Invoker.get('/users/restorePassword/$identity');
  }

  Future<void> handleUserLogin(Map? invokeResult, bool stayLoggedIn) async {
    try {
      BackendlessUser user = Decoder().decode<BackendlessUser>(invokeResult)!;
      this.setCurrentUser(user);
      if (stayLoggedIn) {
        loginStorage._objectId = (await getCurrentUser(false))!.getObjectId();
        loginStorage._userToken = invokeResult!['user-token'];
        loginStorage.saveData();
      }
    } catch (ex) {
      //TODO: -
      throw BackendlessException('Cannot parse user object');
    }
  }

  Future<bool> isValidLogin() async {
    if (!Backendless.userService.loginStorage._hasData) return false;

    return await Invoker.get(
        '/users/isvalidusertoken/${Backendless.userService.loginStorage._userToken}');
  }

  Future<String?> getUserToken() async {
    return Backendless.userService.loginStorage._userToken;
  }

  Future<void> setUserToken(String userToken) async {
    Backendless.userService.loginStorage._userToken = userToken;
    loginStorage.saveData();
  }
}
