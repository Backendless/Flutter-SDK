part of backendless_sdk;

class Reflector extends Reflectable {
  const Reflector() : super(declarationsCapability, invokingCapability);

  Map<String, dynamic> serialize<T>(T object) {
    Map<String, dynamic> result = Map();

    ClassMirror classMirror = reflectType(T);
    InstanceMirror instanceMirror = reflect(object);

    classMirror.declarations.forEach((name, value) {
      if (value is VariableMirror) {
        var variable = instanceMirror.invokeGetter(name);
        if (_isNativeType(variable)) {
          result[name] = variable;
        }
      }
    });

    return result;
  }

  T deserialize<T>(Map map) => _deserialize(map, reflectType(T));

  Object _deserialize(Map map, ClassMirror classMirror) {
    var object = classMirror.newInstance("", []);
    var declarations = classMirror.declarations;

    InstanceMirror instanceMirror = reflect(object);

    map.forEach((name, value) {
      if (declarations.containsKey(name)) {
        if (value is Map) {
          instanceMirror.invokeSetter(name, _deserialize(value, _getClassMirror(value)));
        } else if (value is List) {
          if (value.isNotEmpty) {
            ClassMirror listItemClassMirror = _getClassMirror(value.first);
            var deserializedList = List.from(value.map((listItem) => _deserialize(listItem, listItemClassMirror)));
            instanceMirror.invokeSetter(name, deserializedList);
          } else {
            instanceMirror.invokeSetter(name, List());
          }
        } else {
          instanceMirror.invokeSetter(name, value);
        }
      }
    });

    return object;
  }

  ClassMirror _getClassMirror(Map map) {
    if (map.containsKey("___class")) {
      return annotatedClasses.firstWhere((annotatedClass) => 
        annotatedClass.simpleName == map["___class"]);
    }
    return null;
  }

  String getSimpleName(Type type) => reflectType(type).simpleName;
}

const reflector = const Reflector();

bool _isNativeType(Object object) => nativeTypes.contains(object.runtimeType);

const List<Type> nativeTypes = [String, DateTime, int, double, bool];