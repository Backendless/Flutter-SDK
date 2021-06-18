package com.backendless.backendless_sdk.call_handlers;

import com.backendless.Backendless;
import com.backendless.BackendlessUser;
import com.backendless.HeadersManager;
import com.backendless.backendless_sdk.utils.FlutterCallback;
import com.backendless.property.UserProperty;

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class UserServiceCallHandler implements MethodChannel.MethodCallHandler {

    public UserServiceCallHandler() {

    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "Backendless.UserService.getCurrentUser":
                getCurrentUser(result);
                break;
            case "Backendless.UserService.setCurrentUser":
                setCurrentUser(call, result);
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
          case "Backendless.UserService.createEmailConfirmationURL":
                createEmailConfirmationURL(call, result);
                break;
            case "Backendless.UserService.restorePassword":
                restorePassword(call, result);
                break;
            case "Backendless.UserService.update":
                update(call, result);
                break;
            case "Backendless.UserService.loginAsGuest":
                loginAsGuest(call, result);
                break;
            case "Backendless.UserService.getUserToken":
                getUserToken(result);
                break;
            case "Backendless.UserService.setUserToken":
                setUserToken(call, result);
                break;
            case "Backendless.UserService.loginWithOauth1":
                loginWithOauth1(call, result);
                break;
            case "Backendless.UserService.loginWithOauth2":
                loginWithOauth2(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void getCurrentUser(MethodChannel.Result result) {
        result.success(Backendless.UserService.CurrentUser());
    }

    private void setCurrentUser(MethodCall call, MethodChannel.Result result) {
        BackendlessUser currentUser = call.argument("currentUser");
        Backendless.UserService.setCurrentUser(currentUser);
        result.success(null);
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
        String identity = call.argument("identity");
        Backendless.UserService.resendEmailConfirmation(identity, new FlutterCallback<Void>(result));
    }

    private void createEmailConfirmationURL(MethodCall call, MethodChannel.Result result) {
        String identity = call.argument("identity");
        Backendless.UserService.createEmailConfirmationURL(identity, new FlutterCallback<String>(result));
    }

    private void restorePassword(MethodCall call, MethodChannel.Result result) {
        String identity = call.argument("identity");
        Backendless.UserService.restorePassword(identity, new FlutterCallback<Void>(result));
    }

    private void update(MethodCall call, MethodChannel.Result result) {
        BackendlessUser user = call.argument("user");
        Backendless.UserService.update(user, new FlutterCallback<BackendlessUser>(result));
    }

    private void loginAsGuest(MethodCall call, MethodChannel.Result result) {
        Boolean stayLoggedIn = call.argument("stayLoggedIn");

        FlutterCallback<BackendlessUser> callback = new FlutterCallback<>(result);

        if (stayLoggedIn != null) {
            Backendless.UserService.loginAsGuest(callback, stayLoggedIn);
        } else {
            Backendless.UserService.loginAsGuest(callback);
        }
    }

    private void getUserToken(MethodChannel.Result result) {
        String userToken = HeadersManager.getInstance().getHeader(HeadersManager.HeadersEnum.USER_TOKEN_KEY);
        result.success(userToken);
    }

    private void setUserToken(MethodCall call, MethodChannel.Result result) {
        String userToken = call.argument("userToken");
        HeadersManager.getInstance().addHeader(HeadersManager.HeadersEnum.USER_TOKEN_KEY, userToken);
        result.success(null);
    }

    private void loginWithOauth1(MethodCall call, MethodChannel.Result result) {
        String authProviderCode = call.argument("authProviderCode");
        String authToken = call.argument("authToken");
        String authTokenSecret = call.argument("authTokenSecret");
        Map fieldsMappings = call.argument("fieldsMappings");
        boolean stayLoggedIn = call.argument("stayLoggedIn");
        BackendlessUser guestUser = call.argument("guestUser");

        FlutterCallback<BackendlessUser> callback = new FlutterCallback<>(result);

        if (guestUser != null)
            Backendless.UserService.loginWithOAuth1(authProviderCode, authToken, authTokenSecret, guestUser, fieldsMappings, callback, stayLoggedIn);
        else
            Backendless.UserService.loginWithOAuth1(authProviderCode, authToken, authTokenSecret, fieldsMappings, callback, stayLoggedIn);
    }

    private void loginWithOauth2(MethodCall call, MethodChannel.Result result) {
        String authProviderCode = call.argument("authProviderCode");
        String accessToken = call.argument("accessToken");
        Map fieldsMappings = call.argument("fieldsMappings");
        boolean stayLoggedIn = call.argument("stayLoggedIn");
        BackendlessUser guestUser = call.argument("guestUser");

        FlutterCallback<BackendlessUser> callback = new FlutterCallback<>(result);

        if (guestUser != null)
            Backendless.UserService.loginWithOAuth2(authProviderCode, accessToken, guestUser, fieldsMappings, callback, stayLoggedIn);
        else
            Backendless.UserService.loginWithOAuth2(authProviderCode, accessToken, fieldsMappings, callback, stayLoggedIn);
    }
}
