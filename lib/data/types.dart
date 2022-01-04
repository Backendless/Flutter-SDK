part of backendless_sdk;

class Types {
  static final HashMap<String, String> serverMappings = HashMap();
  static final HashMap<String, String> clientMappings = HashMap();

  static void addClientClassMapping<T>(String serverClassName, Type type) {
    String clientClassName = reflector.reflectType(type).simpleName;
    clientMappings[clientClassName] = serverClassName;
    serverMappings[serverClassName] = clientClassName;
  }

  static String? getMappedClientClass(String serverClassName) {
    if (serverMappings.containsKey(serverClassName)) {
      return serverMappings[serverClassName];
    } else {
      return serverClassName;
    }
  }

  static String? getMappedServerClass(String clientClassName) {
    if (clientMappings.containsKey(clientClassName)) {
      return clientMappings[clientClassName];
    } else {
      return clientClassName;
    }
  }

  static String getColumnNameForProperty(
      String propertyName, VariableMirror variableMirror) {
    var columnName = propertyName;
    variableMirror.metadata.forEach((metadata) {
      if (metadata is MapToProperty) {
        columnName = metadata.property;
      }
    });
    return columnName;
  }

  static String? getPropertyNameForColumn(
      String columnName, Map<String, DeclarationMirror> declarations) {
    for (var entry in declarations.entries) {
      if (entry.value is VariableMirror) {
        for (var metadata in entry.value.metadata) {
          if (metadata is MapToProperty && metadata.property == columnName) {
            return entry.key;
          }
        }
      }
    }

    if (declarations.containsKey(columnName)) {
      var value = declarations[columnName];
      if (value is VariableMirror ||
          value is MethodMirror &&
              !(value.metadata.any((metadata) => metadata is MapToProperty)))
        return columnName;
    }

    return null;
  }
}

class MapToProperty {
  final String property;

  const MapToProperty(this.property);

  @override
  String toString() => "MapToProperty{ property: $property }";
}
