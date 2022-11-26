part of backendless_sdk;

class Reflector extends Reflectable {
  const Reflector()
      : super(declarationsCapability, invokingCapability, metadataCapability,
            reflectedTypeCapability, typeCapability);

  Map<String, dynamic>? serialize<T>(T? object) {
    if (object == null) return null;
    if (object is BackendlessUser)
      return object.properties.cast<String, dynamic>();

    Map<String, dynamic> result = Map();

    ClassMirror classMirror;

    try {
      classMirror = reflectType(T) as ClassMirror;
    } on NoSuchCapabilityError {
      classMirror = reflectType(object.runtimeType) as ClassMirror;
    }
    InstanceMirror instanceMirror = reflect(object);

    classMirror.declarations.forEach((propertyName, value) {
      if (value is VariableMirror) {
        var variable = instanceMirror.invokeGetter(propertyName);
        var columnName = Types.getColumnNameForProperty(propertyName, value);
        if (_canSerializeObject(variable)) {
          result[columnName] = variable;
        } else if (isCustomClass(variable)) {
          result[columnName] = serialize(variable);
        }
      }
    });

    return result;
  }

  T? deserializeList<T>(List list) {
    throw UnimplementedError('TODO');
  }

  T? deserialize<T>(Map map) {
    if (T == BackendlessUser) {
      return BackendlessUser.fromJson(map) as T;
    }
    if (T == UserProperty) {
      return UserProperty.fromJson(map) as T;
    }
    if (T == DeviceRegistrationResult) {
      return DeviceRegistrationResult.fromJson(map) as T;
    }
    return _deserialize(map, reflectType(T) as ClassMirror) as T;
  }

  Object? _deserialize(Map? map, ClassMirror? classMirror) {
    if (map == null || classMirror == null) return null;

    var object = classMirror.newInstance("", []);
    var declarations = classMirror.declarations;
    InstanceMirror instanceMirror = reflect(object);

    map.forEach((columnName, value) {
      var propertyName =
          Types.getPropertyNameForColumn(columnName, declarations);
      if (propertyName == null) return;

      // if property is a Map
      if (value is Map) {
        instanceMirror.invokeSetter(propertyName,
            _deserializeInnerMap(value, columnName, declarations));
        // if property is a List
      } else if (value is List) {
        // empty list
        if (value.isEmpty) {
          instanceMirror.invokeSetter(propertyName, []);
          // list of objects
        } else if (value.first is Map) {
          var deserializedList = List.from(value.map((listItem) =>
              _deserializeInnerMap(listItem, columnName, declarations)));
          instanceMirror.invokeSetter(propertyName, deserializedList);
          // list of primitives
        } else {
          instanceMirror.invokeSetter(propertyName, value);
        }
        // if property is a standard object
      } else {
        VariableMirror variableMirror =
            classMirror.declarations[propertyName] as VariableMirror;
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

  Object? _deserializeInnerMap(Map value, String columnName,
      Map<String, DeclarationMirror> declarations) {
    var classMirror = _getClassMirror(columnName, value, declarations);
    if (classMirror != null) {
      return _deserialize(value, classMirror);
    } else {
      return value;
    }
  }

  DateTime? _deserializeDateTime(dynamic value) {
    var dateValue = value;
    if (value is Map) dateValue = value['deletionTime'];
    if (dateValue == null) return null;
    if (dateValue is DateTime) return dateValue;
    if (dateValue is int) return DateTime.fromMillisecondsSinceEpoch(dateValue);
    return null;
  }

  ClassMirror? _getClassMirror(
      String columnName, Map map, Map<String, DeclarationMirror> declarations) {
    // get object type from server's ___class field if exists
    if (map.containsKey("___class")) {
      String? clientClassName = Types.getMappedClientClass(map["___class"]);
      return annotatedClasses.firstWhereOrNull(
          (annotatedClass) => annotatedClass.simpleName == clientClassName);
      // else get user-defined variable type
    } else {
      var declarationMirror = declarations[columnName];
      if (declarationMirror != null) {
        if (declarationMirror is VariableMirror) {
          try {
            return declarationMirror.type as ClassMirror;
          } on NoSuchCapabilityError {
            return null;
          }
          // if object is a list, user should declare public getter for it
        } else if (declarationMirror is MethodMirror &&
            declarationMirror.hasReflectedReturnType) {
          // get object type from getter's return type
          var variableType = declarationMirror.reflectedReturnType.toString();
          if (variableType.startsWith("List<")) {
            for (var annotatedClass in annotatedClasses) {
              if (variableType == "List<${annotatedClass.simpleName}>") {
                return annotatedClass;
              }
            }
          }
        }
      }
    }
    return null;
  }

  String? getServerName(Type type) {
    if (type == BackendlessUser) return "Users";

    String clientClassName = reflectType(type).simpleName;
    return Types.getMappedServerClass(clientClassName);
  }

  bool isCustomClass<T>([T? object]) {
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

    ClassMirror classMirror;
    try {
      classMirror = reflectType(T) as ClassMirror;
    } on NoSuchCapabilityError {
      classMirror = reflectType(object.runtimeType) as ClassMirror;
    }

    for (Object metadata in classMirror.metadata) {
      if (metadata is Reflector) return true;
    }
    return false;
  }
}

const reflector = const Reflector();

bool _canSerializeObject(Object? object) =>
    _isNativeType(object) || _isSdkType(object);

bool _isNativeType(Object? object) => nativeTypes.contains(object.runtimeType);

bool _isSdkType(Object? object) =>
    sdkSerializableTypes.contains(object.runtimeType);

const List<Type> nativeTypes = [String, DateTime, int, double, bool];
const List<Type> sdkSerializableTypes = [
  BackendlessUser,
  // Point,
  // LineString,
  // Polygon
];
