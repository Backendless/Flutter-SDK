part of backendless_sdk;

class Types {
  static final HashMap<String, String> serverMappings = HashMap();

  static void addClientClassMapping<T>(String tableName, Type type) {
    String serverClassName = reflector.reflectType(type).simpleName;
    serverMappings[serverClassName] = tableName;
  }

  static String getMappedClientClass(String serverClassName) => serverMappings[serverClassName];
}