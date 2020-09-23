part of backendless_sdk;

enum JsonOperation { SET, INSERT, REPLACE, REMOVE, ARRAY_APPEND, ARRAY_INSERT }

class JSONUpdateBuilder {
  static const String OPERATION_FIELD_NAME = "___operation";
  static const String ARGS_FIELD_NAME = "args";

  final Map<String, Object> _jsonUpdate = new Map();

  JSONUpdateBuilder._(JsonOperation op) {
    _jsonUpdate[OPERATION_FIELD_NAME] = "JSON_${describeEnum(op)}";
  }

  static GeneralArgHolder set() {
    return new GeneralArgHolder._(new JSONUpdateBuilder._(JsonOperation.SET));
  }

  static GeneralArgHolder insert() {
    return new GeneralArgHolder._(new JSONUpdateBuilder._(JsonOperation.INSERT));
  }

  static GeneralArgHolder replace() {
    return new GeneralArgHolder._(new JSONUpdateBuilder._(JsonOperation.REPLACE));
  }

  static GeneralArgHolder arrayAppend() {
    return new GeneralArgHolder._(
        new JSONUpdateBuilder._(JsonOperation.ARRAY_APPEND));
  }

  static GeneralArgHolder arrayInsert() {
    return new GeneralArgHolder._(
        new JSONUpdateBuilder._(JsonOperation.ARRAY_INSERT));
  }

  static RemoveArgHolder remove() {
    return new RemoveArgHolder._(new JSONUpdateBuilder._(JsonOperation.REMOVE));
  }
}

class GeneralArgHolder extends ArgHolder {
  Map<String, dynamic> _jsonUpdateArgs = new Map();

  GeneralArgHolder._(JSONUpdateBuilder jsonUpdateBuilder)
      : super(jsonUpdateBuilder) {
    this.jsonUpdateBuilder._jsonUpdate[JSONUpdateBuilder.ARGS_FIELD_NAME] =
        _jsonUpdateArgs;
  }

  GeneralArgHolder addArgument(String jsonPath, Object value) {
    _jsonUpdateArgs[jsonPath] = value;
    return this;
  }
}

class RemoveArgHolder extends ArgHolder {
  RemoveArgHolder._(JSONUpdateBuilder jsonUpdateBuilder)
      : super(jsonUpdateBuilder) {
    this.jsonUpdateBuilder._jsonUpdate[JSONUpdateBuilder.ARGS_FIELD_NAME] =
        _jsonUpdateArgs;
  }

  Set<String> _jsonUpdateArgs = new Set();

  RemoveArgHolder addArgument(String jsonPath) {
    _jsonUpdateArgs.add(jsonPath);
    return this;
  }
}

abstract class ArgHolder {
  JSONUpdateBuilder jsonUpdateBuilder;

  ArgHolder(this.jsonUpdateBuilder);

  Map<String, Object> create() {
    return jsonUpdateBuilder._jsonUpdate;
  }
}
