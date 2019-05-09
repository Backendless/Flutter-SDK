import 'dart:collection';

import 'dart:typed_data';
import 'dart:ui' show hashValues;

import 'package:collection/equality.dart';
import 'package:backendless_sdk/src/modules/geo.dart';

class PagedQueryBuilder {
  static const int DEFAULT_PAGE_SIZE = 10;
  static const int DEFAULT_OFFSET = 0;
  int _pageSize;
  int _offset;

  PagedQueryBuilder() {
    _pageSize = DEFAULT_PAGE_SIZE;
    _offset = DEFAULT_OFFSET;
  }

  PagedQueryBuilder.of(this._pageSize, this._offset);

  set pageSize(int pageSize) {
    _validatePageSize(pageSize);
    _pageSize = pageSize;
  }

  get pageSize => _pageSize;

  set offset(int offset) {
    _validateOffset(offset);
    _offset = offset;
  }

  get offset => _offset;

  void prepareNextPage() {
    int newOffset = _offset + _pageSize;
    _validateOffset(newOffset);
    _offset = newOffset;
  }

  void preparePreviousPage() {
    int newOffset = _offset - _pageSize;
    _validateOffset(newOffset);
    _offset = newOffset;
  }
}

class DataQueryBuilder {
  static const int DEFAULT_RELATIONS_DEPTH = 0;
  PagedQueryBuilder _pagedQueryBuilder;
  List<String> properties;
  String whereClause;
  List<String> groupByList;
  String havingClause;
  List<String> sortByList;
  List<String> relatedList;
  int relationsDepth;

  DataQueryBuilder() {
    _pagedQueryBuilder = new PagedQueryBuilder();
    properties = new List();
    groupByList = new List();
    havingClause = "";
    sortByList = new List();
    relatedList = new List();
    relationsDepth = DEFAULT_RELATIONS_DEPTH;
  }

  set pageSize(int pageSize) => _pagedQueryBuilder.pageSize = pageSize;

  get pageSize => _pagedQueryBuilder.pageSize;

  set offset(int offset) => _pagedQueryBuilder.offset = offset;

  get offset => _pagedQueryBuilder.offset;

  void prepareNextPage() => _pagedQueryBuilder.prepareNextPage();

  void preparePreviousPage() => _pagedQueryBuilder.preparePreviousPage();
}

/// This class does not support relation types other than Map for now.
class LoadRelationsQueryBuilder<R> {
  PagedQueryBuilder pagedQueryBuilder;
  String relationName;
  Type relationType;

  /// Currently supports only Map relation type
  LoadRelationsQueryBuilder._(Type relationType) {
    pagedQueryBuilder = new PagedQueryBuilder();
    this.relationType = relationType;
  }

  LoadRelationsQueryBuilder.ofMap() : this._(Map);

  LoadRelationsQueryBuilder.of(Type relationType) {
    throw new UnimplementedError();
  }

  Type getRelationType() {
    return relationType;
  }

  set pageSize(int pageSize) => pagedQueryBuilder.pageSize = pageSize;

  get pageSize => pagedQueryBuilder.pageSize;

  set offset(int offset) => pagedQueryBuilder.offset = offset;

  get offset => pagedQueryBuilder.offset;

  void prepareNextPage() => pagedQueryBuilder.prepareNextPage();

  void preparePreviousPage() => pagedQueryBuilder.preparePreviousPage();
}

class AbstractBackendlessGeoQuery {
  static const int CLUSTER_SIZE_DEFAULT_VALUE = 100;
  double latitude;
  double longitude;
  double radius;
  HashSet<String> _categories = new HashSet();
  Map<String, Object> metadata = new HashMap();
  Map<String, String> relativeFindMetadata = new HashMap();
  double relativeFindPercentThreshold = 0.0;
  String whereClause;
  Iterable<String> sortBy = new List();
  double dpp;
  int clusterGridSize;

  AbstractBackendlessGeoQuery();

  set categories(Iterable<String> categories) =>
      _categories = new HashSet.of(categories);

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
      PagedQueryBuilder.of(DEFAULT_PAGE_SIZE, DEFAULT_OFFSET);
  Units units;
  bool includeMeta;
  Float64List searchRectangle;

  BackendlessGeoQuery();

  BackendlessGeoQuery.of(
      double latitude,
      double longitude,
      double radius,
      HashSet<String> _categories,
      Map<String, Object> metadata,
      Map<String, String> relativeFindMetadata,
      double relativeFindPercentThreshold,
      String whereClause,
      Iterable<String> sortBy,
      double dpp,
      int clusterGridSize,
      int pageSize,
      int offset,
      Units units,
      bool includeMeta,
      Float64List searchRectangle) {
    this.latitude = latitude;
    this.longitude = longitude;
    this.radius = radius;
    this.categories = categories;
    this.metadata = metadata;
    this.relativeFindMetadata = relativeFindMetadata;
    this.relativeFindPercentThreshold = relativeFindPercentThreshold;
    this.whereClause = whereClause;
    this.sortBy = sortBy;
    this.dpp = dpp;
    this.clusterGridSize = clusterGridSize;
    this.pageSize = pageSize;
    this.offset = offset;
    this.units = units;
    this.includeMeta = includeMeta;
    this.searchRectangle = searchRectangle;
  }

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
    this.searchRectangle = Float64List.fromList([
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
    this.searchRectangle = Float64List.fromList([nwLat, nwLon, seLat, seLon]);
    this.units = units;
    this.categories = categories;
  }

  BackendlessGeoQuery.byMetadata(Map<String, Object> metadata) {
    this.metadata = metadata;
    if (metadata != null) includeMeta = true;
  }

  set pageSize(int pageSize) => pagedQueryBuilder.pageSize = pageSize;

  get pageSize => pagedQueryBuilder.pageSize;

  set offset(int offset) => pagedQueryBuilder.offset = offset;

  get offset => pagedQueryBuilder.offset;

  void prepareNextPage() => pagedQueryBuilder.prepareNextPage();

  void preparePreviousPage() => pagedQueryBuilder.preparePreviousPage();

  List<String> get categories {
    if (_categories == null) {
      _categories = new HashSet<String>();
    }
    return List.of(_categories);
  }

  void addCategory(String category) {
    if (category == null || category == "") return;
    if (_categories == null) _categories = new HashSet<String>();
    _categories.add(category);
  }

  void putMetadata(String metadataKey, Object metadataValue) {
    if (metadataKey == null || metadataKey == "" || metadataValue == null)
      return;
    if (metadata == null) metadata = new HashMap<String, Object>();
    metadata[metadataKey] = metadataValue;
  }

  void setSearchRectangle(GeoPoint topLeft, GeoPoint bottomRight) {
    searchRectangle = Float64List.fromList([
      topLeft.latitude,
      topLeft.longitude,
      bottomRight.latitude,
      bottomRight.longitude
    ]);
  }

  void putRelativeFindMetadata(String key, String value) {
    if (key == null || key == "" || value == null) return;
    if (relativeFindMetadata == null)
      relativeFindMetadata = new HashMap<String, String>();
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
          SetEquality().equals(_categories, other._categories) &&
          MapEquality().equals(metadata, other.metadata) &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          radius == other.radius &&
          ListEquality().equals(searchRectangle, other.searchRectangle) &&
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
      searchRectangle,
      units,
      relativeFindMetadata,
      relativeFindPercentThreshold,
      whereClause,
      dpp,
      clusterGridSize);
}

void _validateOffset(int offset) {
  if (offset < 0)
    throw new ArgumentError("Offset cannot have a negative value.");
}

void _validatePageSize(int pageSize) {
  if (pageSize <= 0)
    throw new ArgumentError("Page size cannot have a negative value.");
}

enum Units { METERS, MILES, YARDS, KILOMETERS, FEET }
