part of backendless_sdk;

class Reflector extends Reflectable {
  const Reflector()
      : super(declarationsCapability, invokingCapability, metadataCapability,
            reflectedTypeCapability);

  Map<String, dynamic> serialize<T>(T object) {
    if (object == null) return null;
    if (object is BackendlessUser)
      return object.properties.cast<String, dynamic>();

    Map<String, dynamic> result = Map();

    ClassMirror classMirror;

    try {
      classMirror = reflectType(T);
    } on NoSuchCapabilityError {
      classMirror = reflectType(object.runtimeType);
    }
    InstanceMirror instanceMirror = reflect(object);

    classMirror.declarations.forEach((propertyName, value) {
      if (value is VariableMirror) {
        var variable = instanceMirror.invokeGetter(propertyName);
        if (_canSerializeObject(variable)) {
          var columnName = Types.getColumnNameForProperty(propertyName, value);
          result[columnName] = variable;
        }
      }
    });

    return result;
  }

  T deserialize<T>(Map map) {
    if (T == BackendlessUser) return BackendlessUser.fromJson(map) as T;
    return _deserialize(map, reflectType(T));
  }

  Object _deserialize(Map map, ClassMirror classMirror) {
    if (map == null || classMirror == null) return null;

    var object = classMirror.newInstance("", []);
    var declarations = classMirror.declarations;
    InstanceMirror instanceMirror = reflect(object);

    map.forEach((columnName, value) {
      var propertyName =
          Types.getPropertyNameForColumn(columnName, declarations);
      if (propertyName == null) return;

      if (value is Map) {
        instanceMirror.invokeSetter(
            propertyName, _deserialize(value, _getClassMirror(value)));
      } else if (value is List) {
        if (value.isEmpty) {
          instanceMirror.invokeSetter(propertyName, List());
        } else if (value.first is Map) {
          ClassMirror listItemClassMirror = _getClassMirror(value.first);
          var deserializedList = List.from(value
              .map((listItem) => _deserialize(listItem, listItemClassMirror)));
          instanceMirror.invokeSetter(propertyName, deserializedList);
        } else {
          instanceMirror.invokeSetter(propertyName, value);
        }
      } else {
        VariableMirror variableMirror = classMirror.declarations[propertyName];
        Type variableType = variableMirror.dynamicReflectedType;
        if (variableType == DateTime) {
          instanceMirror.invokeSetter(
              propertyName, _deserializeDateTime(value));
        } else {
          instanceMirror.invokeSetter(propertyName, value);
        }
      }
    });

    return object;
  }

  DateTime _deserializeDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  ClassMirror _getClassMirror(Map map) {
    if (map.containsKey("___class")) {
      String clientClassName = Types.getMappedClientClass(map["___class"]);
      return annotatedClasses.firstWhere(
          (annotatedClass) => annotatedClass.simpleName == clientClassName,
          orElse: () => null);
    }
    return null;
  }

  String getServerName(Type type) {
    if (type == BackendlessUser) return "Users";

    String clientClassName = reflectType(type).simpleName;
    return Types.getMappedServerClass(clientClassName);
  }

  bool isCustomClass<T>([T object]) {
    try {
      if (object == null) {
        if (!canReflectType(T)) {
          return false;
        }
      } else if (!canReflect(object)) {
        return false;
      }
    } catch (e) {
      return false;
    }
    ClassMirror classMirror = reflectType(T);
    for (Object metadata in classMirror.metadata) {
      if (metadata is Reflector) return true;
    }
    return false;
  }
}

const reflector = const Reflector();

bool _canSerializeObject(Object object) =>
    _isNativeType(object) || _isSdkType(object);

bool _isNativeType(Object object) => nativeTypes.contains(object.runtimeType);

bool _isSdkType(Object object) =>
    sdkSerializableTypes.contains(object.runtimeType);

const List<Type> nativeTypes = [String, DateTime, int, double, bool];
const List<Type> sdkSerializableTypes = [
  BackendlessUser,
  GeoPoint,
  Point,
  LineString,
  Polygon
];
