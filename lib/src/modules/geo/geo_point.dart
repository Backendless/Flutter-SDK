part of backendless_sdk;

class BaseGeoPoint extends EntityDescription {
  String objectId;
  double latitude;
  double longitude;
  List<String> _categories;
  Map<String, Object> metadata;

  BaseGeoPoint() {
    _categories = new List();
    metadata = new Map();
  }

  static BaseGeoPoint create(String line) {
    BaseGeoPoint geoPoint = new BaseGeoPoint();
    List<String> data = line.split(",");
    geoPoint.latitude = double.parse(data[0]);
    geoPoint.longitude = double.parse(data[1]);
    geoPoint._categories = new List.from(data[2].split("\\|"));
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

  List<String> get categories => (_categories != null && _categories.isNotEmpty)
      ? _categories
      : new List.from(["Default"]);

  set categories(Iterable<String> categories) =>
      _categories = (categories != null ? List.from(categories) : new List());

  void addCategory(String category) {
    if (_categories == null) {
      _categories = new List();
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
    return map;
  }

  bool operator ==(o) =>
      o is BaseGeoPoint &&
      o.objectId == objectId &&
      o.latitude == latitude &&
      o.longitude == longitude &&
      IterableEquality().equals(o._categories, _categories) &&
      MapEquality().equals(o.metadata, metadata);

  @override
  int get hashCode => hashValues(
      objectId, latitude, longitude, ListEquality().hash(_categories));
}

class GeoPoint extends BaseGeoPoint {
  static final int multiplier = 1000000;

  GeoPoint();

  GeoPoint.fromJson(Map json) {
    objectId = json['objectId'];
    latitude = json['latitude'].toDouble();
    longitude = json['longitude'].toDouble();
    categories = json['categories']?.cast<String>();
    metadata = json['metadata']?.cast<String, Object>();
  }

  Map toJson() => {
        'objectId': objectId,
        'latitude': latitude,
        'longitude': longitude,
        'categories': categories,
        'metadata': metadata,
      };

  GeoPoint.fromLatLng(double latitude, double longitude,
      [List<String> categories, Map<String, Object> metadata]) {
    this.latitude = latitude;
    this.longitude = longitude;
    if (categories != null) _categories = new List.from(categories);
    this.metadata = metadata;
  }

  GeoPoint.fromLatLngE6(int latitudeE6, int longitudeE6,
      [List<String> categories, Map<String, Object> metadata]) {
    this.latitude = latitudeE6 / multiplier;
    this.longitude = longitudeE6 / multiplier;
    if (categories != null) _categories = new List.from(categories);
    this.metadata = metadata;
  }

  int get latitudeE6 => (latitude * multiplier).round();

  set latitudeE6(int latitudeE6) => this.latitude = latitudeE6 / multiplier;

  int get longitudeE6 => (longitude * multiplier).round();

  set longitudeE6(int longitudeE6) => this.longitude = longitudeE6 / multiplier;

  void addCategory(String category) {
    if (_categories == null) _categories = new List<String>();

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
    _categories = new List<String>.from(categories);
  }

  @override
  String toString() =>
      "GeoPoint{objectId='$objectId', latitute=$latitude, longitude=$longitude, categories=$_categories, metadata=$metadata}";
}

class GeoCluster extends GeoPoint {
  int totalPoints;
  BackendlessGeoQuery geoQuery;

  GeoCluster();

  GeoCluster.fromJson(Map json)
      : totalPoints = json['totalPoints'],
        geoQuery = json['geoQuery'] == null
            ? null
            : BackendlessGeoQuery.fromJson(json['geoQuery']),
        super.fromJson(json);

  Map toJson() => {
        'objectId': objectId,
        'latitude': latitude,
        'longitude': longitude,
        'categories': categories,
        'metadata': metadata,
        'totalPoints': totalPoints,
        'geoQuery': geoQuery?.toJson(),
      };

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
          ListEquality().equals(_categories, other._categories);

  @override
  int get hashCode => hashValues(
      objectId, totalPoints, latitude, longitude, _categories, metadata);

  @override
  String toString() =>
      "GeoCluster{objectId=\'$objectId\', latitute=$latitude, longitude=$longitude, categories=$_categories, metadata=$metadata, totalPoints=$totalPoints}";
}
