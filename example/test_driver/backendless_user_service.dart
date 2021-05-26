import 'dart:io';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:test/test.dart';

class TestUserService {
  static void start() {
    group('User Service', () {
      final userService = Backendless.userService;

      final testEmail = "test@backendless.consulting";
      final updatedEmail = "updated_test@backendless.consulting";
      final testPass = "test_password";
      final updatedPass = "updated_test_password";

      final defaultUserProperties = [
        "email",
        "name",
        "password",
        "blUserLocale",
        "created",
        "updated"
      ];

      String registeredWithID;

      test("Describe User Class", () async {
        final properties = await userService.describeUserClass();

        final propertiesNames = properties.map((prop) => prop.name);

        expect(properties, isNotNull);
        defaultUserProperties
            .forEach((name) => expect(propertiesNames, contains(name)));

        properties.forEach((prop) {
          switch (prop.name) {
            case "email":
              expect(prop.type, DataTypeEnum.STRING);
              break;
            case "name":
              expect(prop.type, DataTypeEnum.STRING);
              break;
            case "password":
              expect(prop.type, DataTypeEnum.STRING);
              break;
            case "blUserLocale":
              expect(prop.type, DataTypeEnum.STRING);
              break;
            case "created":
              expect(prop.type, DataTypeEnum.DATETIME);
              break;
            case "updated":
              expect(prop.type, DataTypeEnum.DATETIME);
              break;
          }
        });
      });

      test("Default Current User", () async {
        final user = await userService.getCurrentUser();
        expect(user, null);
      });

      test("Default Logged In", () async {
        final userId = await userService.loggedInUser();

        expect(userId, isEmpty);
      });

      test("Default User Token", () async {
        final token = await userService.getUserToken();
        expect(token, null);
      });

      test("Default User Roles", () async {
        final expectedRoles = Platform.isIOS ? ["IOSUser"] : ["AndroidUser"];
        expectedRoles.add("NotAuthenticatedUser");

        final roles = await userService.getUserRoles();

        expectedRoles.forEach((role) {
          expect(roles, contains(role));
        });
      });

      test("Default Is Valid Login", () async {
        final isValid = await userService.isValidLogin();

        expect(isValid, false);
      });

      test("Register New User", () async {
        final newUser = BackendlessUser()
          ..email = testEmail
          ..password = testPass;

        final registeredUser = await userService.register(newUser);
        registeredWithID = registeredUser.getObjectId();

        expect(registeredUser, isNotNull);
        expect(registeredUser.email, testEmail);
        expect(registeredWithID, isNotNull);
      });

      test("Login", () async {
        final loggedUser = await userService.login(testEmail, testPass);

        expect(loggedUser.getObjectId(), isNotNull);
        expect(loggedUser.email, testEmail);
      });

      test("Update User", () async {
        final userToUpdate = await userService.getCurrentUser();
        userToUpdate.email = updatedEmail;
        userToUpdate.password = updatedPass;

        final updatedUser = await userService.update(userToUpdate);
        expect(updatedUser.email, updatedEmail);
      });

      test("Logout First", () async {
        await userService.logout();
        final user = await userService.getCurrentUser();

        expect(user, null);
      });

      test("Login With New Credentials", () async {
        final loggedUser = await userService.login(updatedEmail, updatedPass);

        expect(loggedUser.getObjectId(), isNotNull);
        expect(loggedUser.email, updatedEmail);
      });

      test("Current User After Login", () async {
        final user = await userService.getCurrentUser();

        expect(user, isNotNull);
      });

      test("Logged In After Login", () async {
        final userId = await userService.loggedInUser();

        expect(userId, isNotNull);
      });

      test("User Roles After Login", () async {
        final expectedRoles = Platform.isIOS ? ["IOSUser"] : ["AndroidUser"];
        expectedRoles.add("AuthenticatedUser");

        final roles = await userService.getUserRoles();

        expectedRoles.forEach((role) {
          expect(roles, contains(role));
        });
      });

      test("Is Valid Login After Login", () async {
        final isValid = await userService.isValidLogin();

        expect(isValid, true);
      });

      test("Set User Token", () async {
        final tokenToSet = "testing_user_token";
        await userService.setUserToken(tokenToSet);
        final userToken = await userService.getUserToken();

        expect(userToken, tokenToSet);
      });

      test("Logout Second", () async {
        await userService.logout();
        final user = await userService.getCurrentUser();

        expect(user, null);
      });

      test("Logged In After Logout", () async {
        final userId = await userService.loggedInUser();

        expect(userId, isEmpty);
      });

      test("User Token After Logout", () async {
        final token = await userService.getUserToken();
        expect(token, null);
      });

      test("User Roles After Logout", () async {
        final expectedRoles = Platform.isIOS ? ["IOSUser"] : ["AndroidUser"];
        expectedRoles.add("NotAuthenticatedUser");

        final roles = await userService.getUserRoles();

        expectedRoles.forEach((role) {
          expect(roles, contains(role));
        });
      });

      test("Is Valid Login After Logout", () async {
        final isValid = await userService.isValidLogin();

        expect(isValid, false);
      });

      test("Find User By ID", () async {
        final user = await userService.findById(registeredWithID);
        expect(user, isNotNull);
        expect(user.getObjectId(), registeredWithID);

        await Backendless.data
            .of("Users")
            .remove(entity: {"objectId": registeredWithID});
      });
    });
  }
}
