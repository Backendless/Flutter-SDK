# Backendless SDK for Flutter

[![pub package](https://img.shields.io/pub/v/backendless_sdk.svg)](https://pub.dartlang.org/packages/backendless_sdk)

A Flutter plugin enabling integration with [Backendless](https://backendless.com).

*Note*: This plugin is still under active development. Some APIs may not be available yet while others may change. 
We will be updating the release history of the plugin and as soon as it reaches the general availability (GA) state, 
the APIs will be consistent for backward-compatibility.

[Feedback](https://github.com/Backendless/Flutter-SDK/issues) and [Pull Requests](https://github.com/Backendless/Flutter-SDK/pulls) are most welcome!

## Getting Started

Follow the steps below to get started with Backendless Flutter SDK:

#### STEP 1. Register the plugin
To use this plugin in your Flutter project, add `backendless_sdk` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/):
```dart
dependencies:
  backendless_sdk: ^0.2.0
```
#### STEP 2. Import the Backendless SDK:
Add the following import to your Dart code
```dart
import 'package:backendless_sdk/backendless_sdk.dart';
```
#### STEP 3: Initialize the Backendless SDK
Use the following call in your code:
```dart
@override
void initState() {
  super.initState();
  Backendless.initApp(APPLICATION_ID, ANDROID_API_KEY, IOS_API_KEY);
}
```
The `APPLICATION_ID`, `ANDROID_API_KEY` and `IOS_API_KEY` values must be obtained in Backendless Console:
1. Login to your [Backendless account](https://develop.backendless.com) and select the application.
2. Click the Manage icon from the vertical icon-menu on the left.
3. The App Settings section is selected by default. The interface contains values for Application ID and API keys for each supported client-side environment.
4. Use the Copy icon to copy the value into the system clipboard.

#### STEP 4. Use the Backendless APIs.
For example, here is a sample code which stores an object in Backendless database:
```dart
Backendless.initApp(APPLICATION_ID, ANDROID_API_KEY, IOS_API_KEY);
// create a Map object. This will become a record in a database table
Map testObject = new Map();

// add a property to the object. 
// The property name ("foo") will become a column in the database table
// The property value ("bar") will be stored as a value for the stored record
testObject["foo"] = "bar";

// Save the object in the database. The name of the database table is "TestTable".
Backendless.data.of("TestTable").save(testObject).then(
  (response) => print("Object is saved in Backendless. Please check in the console."));
```
