part of backendless_sdk;

class Reflector extends Reflectable {
  const Reflector()
      : super(declarationsCapability, invokingCapability, metadataCapability, reflectedTypeCapability);

  Map<String, dynamic> serialize<T>(T object) {
    if (object == null) return null;

    Map<String, dynamic> result = Map();

    ClassMirror classMirror = reflectType(T);
    InstanceMirror instanceMirror = reflect(object);

    classMirror.declarations.forEach((propertyName, value) {
      if (value is VariableMirror) {
        var variable = instanceMirror.invokeGetter(propertyName);
        if (_isNativeType(variable)) {
          var columnName = Types.getColumnNameForProperty(propertyName, value);
          result[columnName] = variable;
        }
      }
    });

    return result;
  }

  T deserialize<T>(Map map) => _deserialize(map, reflectType(T));

  Object _deserialize(Map map, ClassMirror classMirror) {
    if (map == null || classMirror == null) return null;

    var object = classMirror.newInstance("", []);
    var declarations = classMirror.declarations;
    InstanceMirror instanceMirror = reflect(object);

    map.forEach((columnName, value) {
      var propertyName =
          Types.getPropertyNameForColumn(columnName, declarations);
      if (propertyName != null) {
        if (value is Map) {
          instanceMirror.invokeSetter(
              propertyName, _deserialize(value, _getClassMirror(value)));
        } else if (value is List) {
          if (value.isNotEmpty) {
            ClassMirror listItemClassMirror = _getClassMirror(value.first);
            var deserializedList = List.from(value.map(
                (listItem) => _deserialize(listItem, listItemClassMirror)));
            instanceMirror.invokeSetter(propertyName, deserializedList);
          } else {
            instanceMirror.invokeSetter(propertyName, List());
          }
        } else {
          VariableMirror variableMirror = classMirror.declarations[propertyName];
          Type variableType = variableMirror.dynamicReflectedType;
          if (variableType == DateTime && Platform.isIOS) {
            DateTime date = value != null ? DateTime.fromMillisecondsSinceEpoch(value): null;
            instanceMirror.invokeSetter(propertyName, date);
          } else {
            instanceMirror.invokeSetter(propertyName, value);
          }
        }
      }
    });

    return object;
  }

  ClassMirror _getClassMirror(Map map) {
    if (map.containsKey("___class")) {
      String clientClassName = Types.getMappedClientClass(map["___class"]);
      return annotatedClasses.firstWhere(
          (annotatedClass) => annotatedClass.simpleName == clientClassName);
    }
    return null;
  }

  String getServerName(Type type) {
    String clientClassName = reflectType(type).simpleName;
    return Types.getMappedServerClass(clientClassName);
  }

  bool isCustomClass<T>(T object) {
    if (!canReflect(object)) return false;
    ClassMirror classMirror = reflectType(T);
    for (Object metadata in classMirror.metadata) {
      if (metadata is Reflector) return true;
    }
    return false;
  }
}

const reflector = const Reflector();

bool _isNativeType(Object object) => nativeTypes.contains(object.runtimeType);

const List<Type> nativeTypes = [String, DateTime, int, double, bool];
