# backendless_sdk_example

Demonstrates how to use the backendless_sdk plugin.

## Getting Started

The sample code to store an object in Backendless database:
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
