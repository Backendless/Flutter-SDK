part of backendless_sdk;

class AbstractBackendlessGeoQuery {
  static const int CLUSTER_SIZE_DEFAULT_VALUE = 100;
  double latitude;
  double longitude;
  double radius;
  List<String> _categories = new List();
  Map<String, Object> metadata = new Map();
  Map<String, String> relativeFindMetadata = new Map();
  double relativeFindPercentThreshold = 0.0;
  String whereClause;
  Iterable<String> sortBy = new List();
  double dpp;
  int clusterGridSize;

  AbstractBackendlessGeoQuery();

  set categories(Iterable<String> categories) =>
      _categories = new List.of(categories);

  Iterable<String> get categories => _categories;

  void setClusteringParamsFromDpp(double degreePerPixel, int clusterSize) {
    this.dpp = degreePerPixel;
    this.clusterGridSize = clusterSize;
  }
}

class BackendlessGeoQuery extends AbstractBackendlessGeoQuery {
  static const int DEFAULT_PAGE_SIZE = 100;
  static const int DEFAULT_OFFSET = 0;
  PagedQueryBuilder pagedQueryBuilder =
      PagedQueryBuilder(DEFAULT_PAGE_SIZE, DEFAULT_OFFSET);
  Units units;
  bool includeMeta;
  Float64List _searchRectangle;

  BackendlessGeoQuery();

  BackendlessGeoQuery.fromJson(Map json) {
    latitude = json['latitude'].toDouble();
    longitude = json['longitude'].toDouble();
    radius = json['radius'].toDouble();
    _categories = json['categories'].cast<String>();
    metadata = json['metadata'].cast<String, Object>();
    relativeFindMetadata = json['relativeFindMetadata'].cast<String, String>();
    relativeFindPercentThreshold =
        json['relativeFindPercentThreshold'].toDouble();
    whereClause = json['whereClause'];
    sortBy = json['sortBy'].cast<String>();
    dpp = json['dpp'].toDouble();
    clusterGridSize = json['clusterGridSize'];
    pageSize = json['pageSize'];
    offset = json['offset'];
    units = Units.values[json['units']];
    includeMeta = json['includeMeta'];
    List dynamicValues = json['searchRectangle'];
    List<double> rectangle = dynamicValues.map((v) => v as double).toList();
    _searchRectangle = Float64List.fromList(rectangle);
  }

  Map toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
        'categories': _categories,
        'metadata': metadata,
        'relativeFindMetadata': relativeFindMetadata,
        'relativeFindPercentThreshold': relativeFindPercentThreshold,
        'whereClause': whereClause,
        'sortBy': sortBy,
        'dpp': dpp,
        'clusterGridSize': clusterGridSize,
        'pageSize': pageSize,
        'offset': offset,
        'units': units?.index,
        'includeMeta': includeMeta,
        'searchRectangle': _searchRectangle,
      };

  BackendlessGeoQuery.byLatLon(double latitude, double longitude,
      [double radius,
      Units units,
      List<String> categories,
      Map<String, Object> metadata]) {
    if (radius != null && units == null)
      throw new ArgumentError(
          "Parameter 'radius' should be daclared with parameter 'units'");
    this.latitude = latitude;
    this.longitude = longitude;
    this.radius = radius;
    this.units = units;
    this.categories = categories;
    this.metadata = metadata;

    if (metadata != null) includeMeta = true;
  }

  BackendlessGeoQuery.byCategories(List<String> categories) {
    this.categories = categories;
  }

  BackendlessGeoQuery.relative(Map<String, String> relativeFindMetadata,
      double relativeFindPercentThreshold) {
    this.relativeFindMetadata = relativeFindMetadata;
    this.relativeFindPercentThreshold = relativeFindPercentThreshold;
  }

  BackendlessGeoQuery.rectangle(GeoPoint topLeft, GeoPoint bottomRight) {
    this._searchRectangle = Float64List.fromList([
      topLeft.latitude,
      topLeft.longitude,
      bottomRight.latitude,
      bottomRight.longitude
    ]);
  }

  BackendlessGeoQuery.neswRectangle(
      double nwLat, double nwLon, double seLat, double seLon,
      [Units units, List<String> categories]) {
    if (units != null && categories == null)
      throw new ArgumentError(
          "Parameter 'units' should be declared with parameter 'categories'");
    this._searchRectangle = Float64List.fromList([nwLat, nwLon, seLat, seLon]);
    this.units = units;
    this.categories = categories;
  }

  BackendlessGeoQuery.byMetadata(Map<String, Object> metadata) {
    this.metadata = metadata;
    if (metadata != null) includeMeta = true;
  }

  set searchRectangle(List<double> searchRectangle) {
    _searchRectangle = Float64List.fromList(searchRectangle);
  }

  List<double> get searchRectangle => _searchRectangle?.toList();

  set pageSize(int pageSize) {
    if (pageSize != null)
      pagedQueryBuilder.pageSize = pageSize;
    else
      pagedQueryBuilder.pageSize = DEFAULT_PAGE_SIZE;
  }

  get pageSize => pagedQueryBuilder.pageSize;

  set offset(int offset) {
    if (offset != null)
      pagedQueryBuilder.offset = offset;
    else
      pagedQueryBuilder.offset = DEFAULT_OFFSET;
  }

  get offset => pagedQueryBuilder.offset;

  void prepareNextPage() => pagedQueryBuilder.prepareNextPage();

  void preparePreviousPage() => pagedQueryBuilder.preparePreviousPage();

  List<String> get categories {
    if (_categories == null) {
      _categories = new List<String>();
    }
    return _categories;
  }

  void addCategory(String category) {
    if (category == null || category == "") return;
    if (_categories == null) _categories = new List<String>();
    _categories.add(category);
  }

  void putMetadata(String metadataKey, Object metadataValue) {
    if (metadataKey == null || metadataKey == "" || metadataValue == null)
      return;
    if (metadata == null) metadata = new Map<String, Object>();
    metadata[metadataKey] = metadataValue;
  }

  void setSearchRectangle(GeoPoint topLeft, GeoPoint bottomRight) {
    _searchRectangle = Float64List.fromList([
      topLeft.latitude,
      topLeft.longitude,
      bottomRight.latitude,
      bottomRight.longitude
    ]);
  }

  void putRelativeFindMetadata(String key, String value) {
    if (key == null || key == "" || value == null) return;
    if (relativeFindMetadata == null)
      relativeFindMetadata = new Map<String, String>();
    relativeFindMetadata[key] = value;
  }

  void setClusteringParams(
      double westLongitude, double eastLongitude, int mapWidth,
      [int clusterGridSize =
          AbstractBackendlessGeoQuery.CLUSTER_SIZE_DEFAULT_VALUE]) {
    double longDiff = eastLongitude - westLongitude;
    if (longDiff < 0) {
      longDiff += 360;
    }
    double degreePerPixel = longDiff / mapWidth;
    setClusteringParamsFromDpp(degreePerPixel, clusterGridSize);
  }

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is BackendlessGeoQuery &&
          runtimeType == other.runtimeType &&
          ListEquality().equals(_categories, other._categories) &&
          MapEquality().equals(metadata, other.metadata) &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          radius == other.radius &&
          ListEquality().equals(_searchRectangle, other._searchRectangle) &&
          units == other.units &&
          relativeFindPercentThreshold == other.relativeFindPercentThreshold &&
          MapEquality()
              .equals(relativeFindMetadata, other.relativeFindMetadata) &&
          whereClause == other.whereClause &&
          clusterGridSize == other.clusterGridSize &&
          dpp == other.dpp;

  @override
  int get hashCode => hashValues(
      _categories,
      metadata,
      latitude,
      longitude,
      radius,
      _searchRectangle,
      units,
      relativeFindMetadata,
      relativeFindPercentThreshold,
      whereClause,
      dpp,
      clusterGridSize);
}

enum Units { METERS, MILES, YARDS, KILOMETERS, FEET }
