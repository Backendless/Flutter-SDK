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
        result[name] = variable;
      }
    });

    return result;
  }

  T deserialize<T>(Map<dynamic, dynamic> map) {
    ClassMirror classMirror = reflectType(T);
    T object = classMirror.newInstance("", []);
    var declarations = classMirror.declarations;

    InstanceMirror instanceMirror = reflect(object);

    map.forEach((name, value) {
      if (declarations.containsKey(name)) {
        instanceMirror.invokeSetter(name, value);
      }
    });

    return object;
  }

  String getSimpleName(Type type) => reflectType(type).simpleName;
}

const reflector = const Reflector();