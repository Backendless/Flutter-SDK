# 7.1.5

* Fixed bug with DataQueryBuilder

# 7.1.4

* Fixed a bug in the relationsDepth parameter for IOS
* Now the minimum version of IOS is 10.

# 7.1.3

* Upgrade Android embedding

# 7.1.2

* Added implementation for method findByRole
* Added leave and removeAllMessageListeners methods
* Fixed error with compile app for ios

# 7.1.1

* Bump Backendless Android SDK version to 6.3.1

# 7.1.0

Add:
* `createEmailConfirmationURL` method
* RT listeners for relations
* Deep save

# 7.0.0

> Note: This release has breaking changes.

* Enable null safety
* Require Dart 2.12 or greater
* App initialization with custom domain
* **BREAKING** Update `initApp` method signature with named parameters

# 6.3.3

* Handle `stayLoggedIn` parameter for `loginWithOauth` methods
* Fix `BackendlessUser` encoding
* Add `setCurrentUser()` method. `currentUser()` method renamed to `getCurrentUser()`

# 6.3.2

* Fixes and improvements.

# 6.3.1

* Fix social login with guest user

# 6.3.0

* Add BulkCreateListener for Data RT
* Enable template values for `pushWithTemplate` method
* Support spatial data types for Web
* Fixes and optimizations

# 6.2.0

> Note: This release has breaking changes.

 * Add `distinct` parameter to `DataQueryBuilder`
 * Fix relationsPageSize parameter on Android
 * Rename `providerName` parameter to `providerCode`. 
 * Add new oauth login methods: `loginWithOauth1` & `loginWithOauth2`
 * **BREAKING** Remove old social login methods: `loginWithGoogle`, `loginWithFacebook` & `loginWithTwitter`
 * **BREAKING** Remove deprecated geo service. You should use new spatial data types

# 6.1.0

* Added JSON API

# 6.0.3

* Fix Custom Service invocation for Web

# 6.0.2

* Implement social logins for Web
* Minor fixes for Web platform

# 6.0.1

* Add Web support

# 6.0.0

* Introduce Transactions API
* Bump the plugin version to match the Backendless v.6 release

# 1.1.8

* Fixed error handling for iOS

## 1.1.7

* Fixed a crash on iOS due to Swift SDK update

## 1.1.6

* Added `excludeProperties`.
Usage:
```dart
dataQueryBuilder.excludeProperties = ['excluded-property-1', 'exclude-property-2'];
```
* Fixed `EmailBodyParts` naming

## 1.1.5

* Updated relations method signatures. Now you can just use parent and child object IDs instead of the object itself.
* Fixed crash during `Backendless.data.describe()` call
* Implemented method `removeHeader` that accepts `String` key
* Implemented custom class approach for the `BackendlessUser` class. Call `Backendless.data.withClass<BackendlessUser>()` to start working with `Users` table.

## 1.1.4

* Fixed DateTime deserialization

## 1.1.3

* Fixed iOS methods not returning the result

## 1.1.2

* Fixed inner sdk classes deserialization

## 1.1.1

* Guest login with social account

## 1.1.0

* Support for geometry data types
* Custom classes caching

## 1.0.1

* Fixed crash during `publish()` call

## 1.0.0

* Bump to released version
* Added integration tests
* Fixes and optimizations

## 0.4.1

* Added `relationsPageSize` parameter to `DataQueryBuilder`
* Fixed deserialization of `List<CustomClass>` properties in `ClassDrivenDataStore`
* Fixed `DateTime` deserialization in `ClassDrivenDataStore`
* Fixed encoding/decoding of class `BackendlessGeoQuery`

## 0.4.0

* Fixed method `setRelation` to correctly work with `Map children`
* Fixed deserialization of `DateTime` for `ClassDrivenDataStore` on iOS
* Added AndroidX support in Android example
* Fixed decoding of `EmailEnvelope`
* A lot of fixes and improvements.

## 0.3.1

* Fixed `HeadersEnum` rawValues in iOS.
* Fixed problem with sending BackendlessUser from Flutter to native SDK.

## 0.3.0

* Added `Class to Table Mapping` and `Column Name Mapping`.
* Added `FlutterBackendlessFCMService`. Now you can handle notifications from Flutter.
* Added the ability to publish and subscribe to custom classes.
* A lot of fixes and improvements.

## 0.2.0

* Add support for custom classes. To start working with custom classes, use the following method: `Backendless.data.withClass<TestTable>()`.
* Add methods `Backendless.getHeaders`, `Backendless.setHeader`, `Backendless.removeHeader`, and also `Backendless.userService.getUserToken`, `Backendless.UserService.setUserToken`.
* Fixes and optimizations.

## 0.1.1

* Remove redundant methods.
* Fix encoding issues.

## 0.1.0

* Add support for iOS.

## 0.0.4

* Fixes and improvements.

## 0.0.3

* Restructure the plugin.

## 0.0.2

* Fix all analyzer hints.

## 0.0.1

* Initial version for Android.