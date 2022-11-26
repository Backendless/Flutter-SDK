part of backendless_sdk;

class RTMethod {
  static Map<String, List<RTMethodRequest>> _methods =
      Map<String, List<RTMethodRequest>>();

  static void sendCommand(
    String type,
    Map<String, dynamic> options,
  ) {
    String methodId = Uuid().v4();
    var data = <String, dynamic>{
      'id': methodId,
      'name': type,
      'options': options
    };

    var method = RTMethodRequest();
    method.methodId = methodId;
    method.type = type;
    method.options = options;

    var methodStack = RTMethod._methods[type];
    if (methodStack == null) {
      methodStack = List<RTMethodRequest>.empty(growable: true);
    }

    methodStack.add(method);
    RTMethod._methods[type] = methodStack;

    RTListener.clientInstance!.sendCommand(data, method);
  }
}
