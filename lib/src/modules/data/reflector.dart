part of backendless_sdk;

class Reflector extends Reflectable {
  const Reflector()
      : super(declarationsCapability, invokingCapability, metadataCapability,
            reflectedTypeCapability, reflectedTypeCapability);

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

      // if property is a Map
      if (value is Map) {
        instanceMirror.invokeSetter(propertyName,
            _deserializeInnerMap(value, columnName, declarations));
        // if property is a List
      } else if (value is List) {
        // empty list
        if (value.isEmpty) {
          instanceMirror.invokeSetter(propertyName, List());
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

  Object _deserializeInnerMap(Map value, String columnName,
      Map<String, DeclarationMirror> declarations) {
    var classMirror = _getClassMirror(columnName, value, declarations);
    if (classMirror != null) {
      return _deserialize(value, classMirror);
    } else {
      return value;
    }
  }

  DateTime _deserializeDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  ClassMirror _getClassMirror(
      String columnName, Map map, Map<String, DeclarationMirror> declarations) {
    // get object type from server's ___class field if exists
    if (map.containsKey("___class")) {
      String clientClassName = Types.getMappedClientClass(map["___class"]);
      return annotatedClasses.firstWhere(
          (annotatedClass) => annotatedClass.simpleName == clientClassName,
          orElse: () => null);
      // else get user-defined variable type
    } else {
      var declarationMirror = declarations[columnName];
      if (declarationMirror != null) {
        if (declarationMirror is VariableMirror) {
          try {
            return declarationMirror.type;
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
  Point,
  LineString,
  Polygon
];
