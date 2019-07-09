part of backendless_sdk;

typedef void GeofenceCallback(
    String geofenceName, String geofenceId, double latitude, double longitude);

class BackendlessGeo {
  static const MethodChannel _channel = const MethodChannel(
      'backendless/geo', StandardMethodCodec(BackendlessMessageCodec()));
  final Map<int, ClientGeofenceCallback> _geofenceCallbacks =
      <int, ClientGeofenceCallback>{};
  int _nextHandle = 0;

  factory BackendlessGeo() => _instance;
  static final BackendlessGeo _instance = new BackendlessGeo._internal();

  BackendlessGeo._internal() {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "Backendless.Geo.GeofenceMonitoring") {
        Map<dynamic, dynamic> arguments = call.arguments;
        int handle = arguments["handle"];
        String geofenceName = arguments["geofenceName"];
        String geofenceId = arguments["geofenceId"];
        double latitude = arguments["latitude"];
        double longitude = arguments["longitude"];
        String method = arguments["method"];

        ClientGeofenceCallback callback = _geofenceCallbacks[handle];
        switch (method) {
          case "geoPointEntered":
            if (callback.geoPointEntered != null)
              callback.geoPointEntered(
                  geofenceName, geofenceId, latitude, longitude);
            break;
          case "geoPointStayed":
            if (callback.geoPointStayed != null)
              callback.geoPointStayed(
                  geofenceName, geofenceId, latitude, longitude);
            break;
          case "geoPointExited":
            if (callback.geoPointExited != null)
              callback.geoPointExited(
                  geofenceName, geofenceId, latitude, longitude);
            break;
        }
      }
    });
  }

  Future<GeoCategory> addCategory(String categoryName) => _channel.invokeMethod(
      "Backendless.Geo.addCategory",
      <String, dynamic>{"categoryName": categoryName});

  Future<bool> deleteCategory(String categoryName) => _channel.invokeMethod(
      "Backendless.Geo.deleteCategory",
      <String, dynamic>{"categoryName": categoryName});

  Future<List<GeoCategory>> getCategories() =>
      _channel.invokeMethod("Backendless.Geo.getCategories");

  Future<int> getGeopointCount(BackendlessGeoQuery query,
          [String geoFenceName]) =>
      _channel.invokeMethod("Backendless.Geo.getGeopointCount",
          <String, dynamic>{"query": query, "geoFenceName": geoFenceName});

  Future<List<GeoPoint>> getPoints(
      {String geofenceName,
      BackendlessGeoQuery query,
      GeoCluster geoCluster}) async {
    if (geoCluster != null && (query != null || geofenceName != null))
      throw new ArgumentError(
          "Either 'geoCluster' or 'geofenceName/query' should be defined");
    return (await _channel.invokeMethod(
            "Backendless.Geo.getPoints", <String, dynamic>{
      "query": query,
      "geofenceName": geofenceName,
      "geoCluster": geoCluster
    }))
        .cast<GeoPoint>();
  }

  Future<GeoPoint> loadMetadata(GeoPoint geoPoint) => _channel.invokeMethod(
      "Backendless.Geo.loadMetadata", <String, dynamic>{"geoPoint": geoPoint});

  Future<List<SearchMatchesResult>> relativeFind(
          BackendlessGeoQuery geoQuery) async =>
      (await _channel.invokeMethod("Backendless.Geo.relativeFind",
              <String, dynamic>{"geoQuery": geoQuery}))
          .cast<SearchMatchesResult>();

  Future<void> removePoint(GeoPoint geoPoint) => _channel.invokeMethod(
      "Backendless.Geo.removePoint", <String, dynamic>{"geoPoint": geoPoint});

  Future<void> runOnEnterAction(String geoFenceName, [GeoPoint geoPoint]) =>
      _channel.invokeMethod(
          "Backendless.Geo.runOnEnterAction", <String, dynamic>{
        "geoFenceName": geoFenceName,
        "geoPoint": geoPoint
      });

  Future<void> runOnExitAction(String geoFenceName, [GeoPoint geoPoint]) =>
      _channel.invokeMethod(
          "Backendless.Geo.runOnExitAction", <String, dynamic>{
        "geoFenceName": geoFenceName,
        "geoPoint": geoPoint
      });

  Future<void> runOnStayAction(String geoFenceName, [GeoPoint geoPoint]) =>
      _channel.invokeMethod(
          "Backendless.Geo.runOnStayAction", <String, dynamic>{
        "geoFenceName": geoFenceName,
        "geoPoint": geoPoint
      });

  Future<GeoPoint> savePoint(GeoPoint geoPoint) => _channel.invokeMethod(
      "Backendless.Geo.savePoint", <String, dynamic>{"geoPoint": geoPoint});

  Future<GeoPoint> savePointLatLon(
          double latitude, double longitude, Map<String, Object> metadata,
          [List<String> categories]) =>
      _channel.invokeMethod("Backendless.Geo.savePoint", <String, dynamic>{
        "latitude": latitude,
        "longitude": longitude,
        "categories": categories,
        "metadata": metadata
      });

  Future<void> setLocationTrackerParameters(
          int minTime, int minDistance, int acceptedDistanceAfterReboot) =>
      _channel.invokeMethod(
          "Backendless.Geo.setLocationTrackerParameters", <String, dynamic>{
        "minTime": minTime,
        "minDistance": minDistance,
        "acceptedDistanceAfterReboot": acceptedDistanceAfterReboot,
      });

  Future<void> startClientGeofenceMonitoring(
      {String geofenceName,
      GeofenceCallback geoPointEntered,
      GeofenceCallback geoPointStayed,
      GeofenceCallback geoPointExited}) {
    int handle = _nextHandle++;
    ClientGeofenceCallback callback = new ClientGeofenceCallback(
        geoPointEntered, geoPointStayed, geoPointExited);
    _geofenceCallbacks[handle] = callback;

    return _channel.invokeMethod(
        "Backendless.Geo.startClientGeofenceMonitoring",
        <String, dynamic>{"geofenceName": geofenceName, "handle": handle});
  }

  Future<void> startServerGeofenceMonitoring(GeoPoint geoPoint,
          [String geofenceName]) =>
      _channel.invokeMethod(
          "Backendless.Geo.startServerGeofenceMonitoring", <String, dynamic>{
        "geoPoint": geoPoint,
        "geofenceName": geofenceName
      });

  Future<void> stopGeofenceMonitoring([String geofenceName]) =>
      _channel.invokeMethod("Backendless.Geo.stopGeofenceMonitoring",
          <String, dynamic>{"geofenceName": geofenceName});
}

class ClientGeofenceCallback {
  GeofenceCallback geoPointEntered;
  GeofenceCallback geoPointStayed;
  GeofenceCallback geoPointExited;

  ClientGeofenceCallback(
      this.geoPointEntered, this.geoPointStayed, this.geoPointExited);
}

class EntityDescription {
  String name;
  Map<String, Object> fields = new Map();

  EntityDescription();

  EntityDescription._(String entityName, Map<String, Object> entity) {
    name = entityName;
    if (entity != null) {
      fields = entity;
    }
  }

  void addField(String name, Object value) {
    fields[name] = value;
  }

  dynamic getField(String key) {
    return fields[key];
  }

  Object getId(String objectId) {
    String id = getField(objectId);
    var delimeterIndex = id.indexOf(".");
    if (delimeterIndex != -1) {
      id = id.substring(0, delimeterIndex);
    }
    return id;
  }

  EntityDescription withNamespace(String namespace) {
    if (namespace != null && namespace.isNotEmpty) {
      name = "$namespace.$name";
    }
    return this;
  }

  bool containsField(String fieldName) {
    return fields.containsKey(fieldName);
  }

  bool operator ==(o) =>
      o is EntityDescription &&
      o.name == name &&
      MapEquality().equals(o.fields, fields);

  @override
  int get hashCode => MapEquality().hash(fields);
}

class SearchMatchesResult {
  double matches;
  GeoPoint geoPoint;

  SearchMatchesResult();

  SearchMatchesResult.fromJson(Map json)
      : matches = json['matches'].toDouble(),
        geoPoint = GeoPoint.fromJson(json['geoPoint']);

  Map toJson() => {
        'matches': matches,
        'geoPoint': geoPoint,
      };
}
