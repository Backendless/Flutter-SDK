import 'package:flutter/services.dart';
import 'package:backendless_sdk/src/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:quiver/core.dart' show hashObjects;

import 'dart:ui' show hashValues;
import 'dart:core';

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
    checkArguments({"geoCluster": geoCluster}, {"geofenceName": geofenceName});
    if (geoCluster != null && query != null)
      throw new ArgumentError(
          "Either 'geoCluster' or 'geofenceName' and 'query' should be defined");
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
  int get hashCode => hashObjects([fields]);
}

class BaseGeoPoint extends EntityDescription {
  static final int _serialVersionUID = 3703240008778337528;
  String objectId;
  double latitude;
  double longitude;
  Set<String> _categories;
  Map<String, Object> metadata;
  double distance;

  BaseGeoPoint() {
    _categories = new Set();
    metadata = new Map();
  }

  static BaseGeoPoint create(String line) {
    BaseGeoPoint geoPoint = new BaseGeoPoint();
    List<String> data = line.split(",");
    geoPoint.latitude = double.parse(data[0]);
    geoPoint.longitude = double.parse(data[1]);
    geoPoint._categories = new Set.from(data[2].split("\\|"));
    Map<String, Object> metadata = new Map();
    List<String> var4 = data[3].split("\\|");
    int var5 = var4.length;

    for (int var6 = 0; var6 < var5; ++var6) {
      String md = var4[var6];
      List<String> keyAndValue = md.split("=");
      metadata[keyAndValue[0]] = keyAndValue[1];
    }

    geoPoint.metadata = metadata;
    return geoPoint;
  }

  Set<String> get categories => (_categories != null && _categories.isNotEmpty)
      ? _categories
      : new Set.from(["Default"]);

  set categories(Iterable<String> categories) =>
      _categories = (categories != null ? Set.from(categories) : new Set());

  void addCategory(String category) {
    if (_categories == null) {
      _categories = new Set();
    }
    _categories.add(category);
  }

  void addMetadata(String key, Object value) {
    if (metadata == null) {
      metadata = new Map();
    }
    metadata[key] = value;
  }

  String get name => this.runtimeType.toString();

  Map<String, Object> getFields() {
    Map<String, Object> map = new Map();
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["metadata"] = metadata;
    map["objectId"] = objectId;
    map["categories"] = categories;
    map["distance"] = distance;
    return map;
  }

  bool operator ==(o) =>
      o is BaseGeoPoint &&
      o.objectId == objectId &&
      o.latitude == latitude &&
      o.longitude == longitude &&
      IterableEquality().equals(o._categories, _categories) &&
      MapEquality().equals(o.metadata, metadata) &&
      o.distance == distance;

  @override
  int get hashCode =>
      hashValues(objectId, latitude, longitude, _categories, distance);
}

class GeoPoint extends BaseGeoPoint {
  static final int _serialVersionUID = -4982310969493523406;
  static final int multiplier = 1000000;

  GeoPoint();

  GeoPoint.of(String objectId, double latitude, double longitude,
      List<String> categories, Map<String, Object> metadata, double distance) {
    this.objectId = objectId;
    this.latitude = latitude;
    this.longitude = longitude;
    this.categories = categories;
    this.metadata = metadata;
    this.distance = distance;
  }

  GeoPoint.fromLatLng(double latitude, double longitude,
      [List<String> categories, Map<String, Object> metadata]) {
    this.latitude = latitude;
    this.longitude = longitude;
    if (categories != null) _categories = new Set.from(categories);
    this.metadata = metadata;
  }

  GeoPoint.fromLatLngE6(int latitudeE6, int longitudeE6,
      [List<String> categories, Map<String, Object> metadata]) {
    this.latitude = latitudeE6 / multiplier;
    this.longitude = longitudeE6 / multiplier;
    if (categories != null) _categories = new Set.from(categories);
    this.metadata = metadata;
  }

  int get latitudeE6 => (latitude * multiplier).round();

  set latitudeE6(int latitudeE6) => this.latitude = latitudeE6 / multiplier;

  int get longitudeE6 => (longitude * multiplier).round();

  set longitudeE6(int longitudeE6) => this.longitude = longitudeE6 / multiplier;

  void addCategory(String category) {
    if (_categories == null) _categories = new Set<String>();

    _categories.add(category);
  }

  Object getMetadata(String key) {
    if (metadata == null) return null;

    return metadata[key];
  }

  void putMetadata(String key, Object value) {
    addMetadata(key, value);
  }

  void putAllMetadata(Map<String, Object> metadata) {
    this.metadata = metadata;
  }

  void clearMetadata() {
    if (this.metadata != null) {
      metadata.clear();
    }
  }

  void setCategories(List<String> categories) {
    _categories = new Set<String>.from(categories);
  }

  @override
  String toString() =>
      "GeoPoint{objectId='$objectId', latitute=$latitude, longitude=$longitude, categories=$_categories, metadata=$metadata, distance=$distance}";
}

class BaseGeoCategory {
  static final String DEFAULT = "Default";
  String objectId;
  String name;
  int size;

  BaseGeoCategory({this.objectId, this.name, this.size});
}

class GeoCategory extends BaseGeoCategory implements Comparable<GeoCategory> {
  GeoCategory({id, name, size}) : super(objectId: id, name: name, size: size);

  String get id => objectId;

  bool operator ==(o) =>
      o is GeoCategory && o.name == name && o.objectId == objectId;

  @override
  int get hashCode => hashValues(name, objectId);

  @override
  String toString() => "GeoCategory{name='$name', size=$size}";

  @override
  int compareTo(GeoCategory other) {
    if (this == other) return 0;

    int nameDiff = this.name == null
        ? (other.name == null ? 0 : -1)
        : this.name.compareTo(other.name);
    if (nameDiff != 0) return nameDiff;

    return this.size - other.size;
  }
}

class GeoCluster extends GeoPoint {
  int totalPoints;
  BackendlessGeoQuery geoQuery;

  GeoCluster.of(
      String objectId,
      double latitude,
      double longitude,
      List<String> categories,
      Map<String, Object> metadata,
      double distance,
      int totalPoints,
      BackendlessGeoQuery geoQuery) {
    this.objectId = objectId;
    this.latitude = latitude;
    this.longitude = longitude;
    this.categories = categories;
    this.metadata = metadata;
    this.distance = distance;
    this.totalPoints = totalPoints;
    this.geoQuery = geoQuery;
  }

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is GeoCluster &&
          runtimeType == other.runtimeType &&
          objectId == other.objectId &&
          totalPoints == other.totalPoints &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          MapEquality().equals(metadata, other.metadata) &&
          SetEquality().equals(_categories, other._categories);

  @override
  int get hashCode => hashValues(
      objectId, totalPoints, latitude, longitude, _categories, metadata);

  @override
  String toString() =>
      "GeoCluster{objectId=\'$objectId\', latitute=$latitude, longitude=$longitude, categories=$_categories, metadata=$metadata, distance=$distance, totalPoints=$totalPoints}";
}

class SearchMatchesResult {
  double matches;
  GeoPoint geoPoint;

  SearchMatchesResult(this.matches, this.geoPoint);
}
