// Check that either first or second list of arguments is completely defined
void checkArguments(
    Map<String, dynamic> firstArgs, Map<String, dynamic> secondArgs,
    {bool isRequired = true}) {
  if ((firstArgs.values.every((arg) => arg != null) &&
          secondArgs.values.every((arg) => arg == null)) ||
      (firstArgs.values.every((arg) => arg == null) &&
          secondArgs.values.every((arg) => arg != null))) {
    return;
  } else if (!isRequired &&
      firstArgs.values.every((arg) => arg == null) &&
      secondArgs.values.every((arg) => arg == null)) {
    return;
  } else {
    throw new ArgumentError(
        "Either ${firstArgs.keys.toString()} or ${secondArgs.keys.toString()} ${!isRequired ? 'or none of them' : ''}should be defined");
  }
}

T stringToEnum<T>(Iterable<T> enumValues, String stringValue) {
  return enumValues.firstWhere(
      (type) => type.toString().split(".").last == stringValue,
      orElse: () => null);
}

// Wrapper that contains callbacks for events
class EventCallback {
  Function handleResponse;
  void Function(String fault) _handleFault;
  Map<String, dynamic> args;

  EventCallback(this.handleResponse, this._handleFault, [this.args]);

  void handleFault(String fault) {
    if (_handleFault != null) _handleFault(fault);
  }
}

class CallbackHadler<T> {
  final Map<int, T> callbacks = <int, T>{};
}
