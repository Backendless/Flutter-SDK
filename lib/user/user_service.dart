part of backendless_sdk;

class UserService {
  BackendlessUser? _currentUser;
  final Future<LoginStorage> _loginStorage = LoginStorage.create();

  Future<LoginStorage> get loginStorage async {
    return await _loginStorage;
  }

  Future<BackendlessUser?> getCurrentUser(bool reload) async {
    if (_currentUser != null && !reload) {
      return _currentUser;
    }
    if (reload && (await loginStorage)._hasData) {
      _currentUser = await Backendless.userService
          .findById((await loginStorage)._objectId!)
          .catchError((e) {
        throw e;
      });
      return _currentUser;
    }

    return null;
  }

  Future<void> setCurrentUser(BackendlessUser user,
      {bool stayLoggedIn = false}) async {
    String? objectId;
    String? userToken;
    try {
      objectId = user.getObjectId();
      userToken = user.getProperty('user-token');
    } catch (ex) {
      throw ArgumentError.value(ExceptionMessage.emptyNullUserIdOrUserToken);
    }

    await Backendless.setHeader(userToken!, key: 'user-token');

    if (stayLoggedIn) {
      (await loginStorage)._userToken = userToken;
      (await loginStorage)._objectId = objectId;
      (await loginStorage).saveData();
    }

    _currentUser = user;
  }

  Future<String?> loggedInUser() async {
    if (await getCurrentUser(false) != null) {
      return (await getCurrentUser(false))!.getUserId();
    } else if ((await loginStorage)._hasData) {
      return (await loginStorage)._objectId;
    }

    return null;
  }

  Future<List<UserProperty>?> describeUserClass() async {
    return await Invoker.get('/users/userclassprops');
  }

  Future<BackendlessUser?> login(String login, String password,
      {bool stayLoggedIn = false}) async {
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

  Future<String?> getAuthorizationUrlLink(String providerCode,
      {String? callbackUrlDomain,
      Map<String, String>? fieldsMappings,
      List<String>? scope}) async {
    Map parameters = {};
    if (fieldsMappings != null) {
      parameters['fieldsMappings'] = fieldsMappings;
    }

    if (callbackUrlDomain?.isNotEmpty ?? false) {
      parameters['callbackUrlDomain'] = callbackUrlDomain;
    }

    if (scope != null) {
      parameters['scope'] = scope;
    }

    return await Invoker.post(
        'users/oauth/$providerCode/request_url', parameters);
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
        await Invoker.post('/users/social/$providerCode/login', parameters);

    await handleUserLogin(invokeResult, stayLoggedIn);

    return getCurrentUser(false);
  }

  Future<BackendlessUser?> register(BackendlessUser user) async {
    return await Invoker.post('/users/register', user);
  }

  Future<void> logout() async {
    await Invoker.get('/users/logout');
    await Backendless.removeHeader(enumKey: HeadersEnum.userToken);
  }

  Future<BackendlessUser?> update(BackendlessUser user) async {
    if (user.getUserId()?.isEmpty ?? false) {
      throw ArgumentError.value(ExceptionMessage.emptyNullUserId);
    }

    return await Invoker.put('/users/${user.getUserId()}', user);
  }

  Future<BackendlessUser?> findById(String id) async {
    Map? mappedUser = await Backendless.data.of('Users').findById(id);
    return Decoder().decode<BackendlessUser>(mappedUser);
  }

  Future<List<BackendlessUser>?> findByRole(String roleName,
      {bool? loadRoles, DataQueryBuilder? queryBuilder}) async {
    String methodName = '/users/role/$roleName';
    if (loadRoles != null && loadRoles == true) {
      methodName += '?loadRoles=true';
    } else {
      methodName += '?loadRoles=false';
    }

    if (queryBuilder != null) {
      methodName += '&';
      methodName += (await toQueryString(queryBuilder))!;
    }

    return await Invoker.get<List<BackendlessUser>?>(methodName);
  }

  Future<List<String>?> getUserRoles() async {
    return await Invoker.get('/users/userroles');
  }

  Future<String?> createEmailConfirmationURL(String identity) async {
    if (identity.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.emptyIdentity);
    }

    return await Invoker.post(
        '/users/createEmailConfirmationURL/$identity', null);
  }

  Future<String?> resendEmailConfirmation(String identity) async {
    if (identity.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.emptyIdentity);
    }

    return await Invoker.post('/users/resendEmailConfirmation/$identity', null);
  }

  Future<void> restorePassword(String identity) async {
    if (identity.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.emptyIdentity);
    }

    return await Invoker.get('/users/restorepassword/$identity');
  }

  Future<void> handleUserLogin(Map? invokeResult, bool stayLoggedIn) async {
    try {
      BackendlessUser user = Decoder().decode<BackendlessUser>(invokeResult)!;
      await setCurrentUser(user, stayLoggedIn: true);

      /*if (stayLoggedIn) {
        loginStorage._objectId = (await getCurrentUser(false))!.getObjectId();
        loginStorage._userToken = invokeResult!['user-token'];
        loginStorage.saveData();
      }*/
    } catch (ex) {
      //TODO: -
      throw BackendlessException('Cannot parse user object');
    }
  }

  Future<bool> isValidLogin() async {
    var currentToken = await Backendless.userService.getUserToken();

    if (currentToken == null) {
      return false;
    }

    return await Invoker.get('/users/isvalidusertoken/$currentToken');
  }

  Future<String?> getUserToken() async {
    if (Backendless._prefs.headers.containsKey('user-token')) {
      return Backendless._prefs.headers['user-token'];
    }

    return (await Backendless.userService.loginStorage)._userToken;
  }

  Future<void> setUserToken(String userToken) async {
    Backendless._prefs.headers['user-token'] = userToken;

    if ((await loginStorage)._hasData) {
      (await loginStorage).setUserToken(userToken);
      await (await loginStorage).saveData();
    }
  }

  Future<void> removeUserToken() async {
    if (Backendless._prefs.headers.containsKey('user-token')) {
      Backendless._prefs.headers.remove('user-token');
    }

    (await Backendless.userService.loginStorage)._userToken = null;
    await (await Backendless.userService.loginStorage).deleteData();
  }
}
