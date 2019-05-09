package com.backendless.backendless_sdk.call_handlers;

import com.backendless.Backendless;
import com.backendless.BackendlessUser;
import com.backendless.backendless_sdk.utils.FlutterCallback;
import com.backendless.property.UserProperty;

import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class UserServiceCallHandler implements MethodChannel.MethodCallHandler {

    public UserServiceCallHandler() {

    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "Backendless.UserService.assignRole":
                assignRole(call, result);
                break;
            case "Backendless.UserService.currentUser":
                currentUser(result);
                break;
            case "Backendless.UserService.describeUserClass":
                describeUserClass(result);
                break;
            case "Backendless.UserService.findById":
                findById(call, result);
                break;
            case "Backendless.UserService.getUserRoles":
                getUserRoles(result);
                break;
            case "Backendless.UserService.isValidLogin":
                isValidLogin(result);
                break;
            case "Backendless.UserService.loggedInUser":
                loggedInUser(result);
                break;
            case "Backendless.UserService.login":
                login(call, result);
                break;
            case "Backendless.UserService.logout":
                logout(result);
                break;
            case "Backendless.UserService.register":
                register(call, result);
                break;
            case "Backendless.UserService.resendEmailConfirmation":
                resendEmailConfirmation(call, result);
                break;
            case "Backendless.UserService.restorePassword":
                restorePassword(call, result);
                break;
            case "Backendless.UserService.setCurrentUser":
                setCurrentUser(call, result);
                break;
            case "Backendless.UserService.unassignRole":
                unassignRole(call, result);
                break;
            case "Backendless.UserService.update":
                update(call, result);
                break;
        }
    }

    private void assignRole(MethodCall call, MethodChannel.Result result) {
        String identity = call.argument("identity");
        String roleName = call.argument("roleName");

        Backendless.UserService.assignRole(identity, roleName, new FlutterCallback<Void>(result));

    }

    private void currentUser(MethodChannel.Result result) {
        result.success(Backendless.UserService.CurrentUser());
    }

    private void describeUserClass(MethodChannel.Result result) {
        Backendless.UserService.describeUserClass(new FlutterCallback<List<UserProperty>>(result));
    }

    private void findById(MethodCall call, MethodChannel.Result result) {
        String id = call.argument("id");
        Backendless.UserService.findById(id, new FlutterCallback<BackendlessUser>(result));
    }

    private void getUserRoles(MethodChannel.Result result) {
        Backendless.UserService.getUserRoles(new FlutterCallback<List<String>>(result));
    }

    private void isValidLogin(MethodChannel.Result result) {
        Backendless.UserService.isValidLogin(new FlutterCallback<Boolean>(result));
    }

    private void loggedInUser(MethodChannel.Result result) {
        result.success(Backendless.UserService.loggedInUser());
    }

    private void login(MethodCall call, MethodChannel.Result result) {
        String login = call.argument("login");
        String password = call.argument("password");
        Boolean stayLoggedIn = call.argument("stayLoggedIn");

        FlutterCallback<BackendlessUser> callback = new FlutterCallback<>(result);

        if (stayLoggedIn != null)
            Backendless.UserService.login(login, password, callback, stayLoggedIn);
        else
            Backendless.UserService.login(login, password, callback);
    }

    private void logout(MethodChannel.Result result) {
        Backendless.UserService.logout(new FlutterCallback<Void>(result));
    }

    private void register(MethodCall call, MethodChannel.Result result) {
        BackendlessUser user = call.argument("user");
        Backendless.UserService.register(user, new FlutterCallback<BackendlessUser>(result));
    }

    private void resendEmailConfirmation(MethodCall call, MethodChannel.Result result) {
        String email = call.argument("email");
        Backendless.UserService.resendEmailConfirmation(email, new FlutterCallback<Void>(result));
    }

    private void restorePassword(MethodCall call, MethodChannel.Result result) {
        String identity = call.argument("identity");
        Backendless.UserService.restorePassword(identity, new FlutterCallback<Void>(result));
    }

    private void setCurrentUser(MethodCall call, MethodChannel.Result result) {
        BackendlessUser user = call.argument("user");
        Backendless.UserService.setCurrentUser(user);
        result.success(null);
    }

    private void unassignRole(MethodCall call, MethodChannel.Result result) {
        String identity = call.argument("identity");
        String roleName = call.argument("roleName");

        Backendless.UserService.unassignRole(identity, roleName, new FlutterCallback<Void>(result));
    }

    private void update(MethodCall call, MethodChannel.Result result) {
        BackendlessUser user = call.argument("user");
        Backendless.UserService.update(user, new FlutterCallback<BackendlessUser>(result));
    }
}
