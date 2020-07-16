@JS()

library backendless_users_web;

import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../../../backendless_sdk.dart';
import '../js_util.dart';

class UserServiceCallHandler {
  Future<dynamic> handleMethodCall(MethodCall call) {
    switch (call.method) {
      case "Backendless.UserService.currentUser":
        return Future(
            () => BackendlessUser.fromJson(convertFromJs(currentUser())));
      case "Backendless.UserService.describeUserClass":
        return promiseToFuture(describeUserClass());
      case "Backendless.UserService.findById":
        return promiseToFuture(findById(call.arguments['id']))
            .then((value) => BackendlessUser.fromJson(convertFromJs(value)));
      case "Backendless.UserService.getUserRoles":
        return promiseToFuture(getUserRoles());
      case "Backendless.UserService.isValidLogin":
        return promiseToFuture(isValidLogin());
      case "Backendless.UserService.loggedInUser":
        return Future(() => loggedInUser());
      case "Backendless.UserService.login":
        return promiseToFuture(login(call.arguments['login'],
                call.arguments['password'], call.arguments['stayLoggedIn']))
            .then((value) => BackendlessUser.fromJson(convertFromJs(value)));
      case "Backendless.UserService.logout":
        return promiseToFuture(logout());
      case "Backendless.UserService.register":
        BackendlessUser user = call.arguments['user'];
        return promiseToFuture(
                register(convertToJs(user.properties['properties'])))
            .then((value) => BackendlessUser.fromJson(convertFromJs(value)));
      case "Backendless.UserService.resendEmailConfirmation":
        return promiseToFuture(
            resendEmailConfirmation(call.arguments['email']));
      case "Backendless.UserService.restorePassword":
        return promiseToFuture(restorePassword(call.arguments['identity']));
      case "Backendless.UserService.update":
        BackendlessUser user = call.arguments['user'];
        return promiseToFuture(
                update(convertToJs(user.properties['properties'])))
            .then((value) => BackendlessUser.fromJson(convertFromJs(value)));
      case "Backendless.UserService.getUserToken":
        return Future(() => getUserToken());
      case "Backendless.UserService.setUserToken":
        return Future(() => setUserToken(call.arguments['userToken']));
      case "Backendless.UserService.loginAsGuest":
        return promiseToFuture(loginAsGuest(call.arguments['stayLoggedIn']))
            .then((value) => BackendlessUser.fromJson(convertFromJs(value)));

      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "Backendless plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }
}

@JS('Backendless.UserService.getLocalCurrentUser')
external dynamic currentUser();

@JS('Backendless.UserService.describeUserClass')
external List<UserProperty> describeUserClass();

@JS('Backendless.UserService.findById')
external dynamic findById(String id);

@JS('Backendless.UserService.getUserRoles')
external List<String> getUserRoles();

@JS('Backendless.UserService.isValidLogin')
external bool isValidLogin();

@JS('Backendless.UserService.loggedInUser')
external String loggedInUser();

@JS('Backendless.UserService.login')
external dynamic login(String login, String password, [bool stayLoggedIn]);

@JS('Backendless.UserService.logout')
external dynamic logout();

@JS('Backendless.UserService.register')
external dynamic register(dynamic user);

@JS('Backendless.UserService.resendEmailConfirmation')
external dynamic resendEmailConfirmation(String email);

@JS('Backendless.UserService.restorePassword')
external dynamic restorePassword(String identity);

@JS('Backendless.UserService.update')
external dynamic update(dynamic user);

@JS('Backendless.UserService.getCurrentUserToken')
external String getUserToken();

@JS('Backendless.UserService.setCurrentUserToken')
external dynamic setUserToken(String userToken);

@JS('Backendless.UserService.loginAsGuest')
external dynamic loginAsGuest([bool stayLoggedIn]);
