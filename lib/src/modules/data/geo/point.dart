part of backendless_sdk;

class Point extends Geometry {
  static final double precision = 0.000000001;
  static const String geoJsonType = "Point";
  static const String wktType = "POINT";

  double x;
  double get longitude => x;
  set longitude(double longitude) => x = longitude;

  double y;
  double get latitude => y;
  set latitude(double latitude) => y = latitude;

  @override
  bool operator ==(other) =>
      other is Point &&
      (other.x - x).abs() < Point.precision &&
      (other.y - y).abs() < Point.precision;

  @override
  int get hashCode => hashValues(x, y, srs);

  Point({this.x, this.y, SpatialReferenceSystem srs}) : super(srs: srs) {
    this.x = x != null ? x : 0.0;
    this.y = y != null ? y : 0.0;
  }

  @override
  String getWktType() => Point.wktType;

  @override
  String getGeoJsonType() => Point.geoJsonType;

  @override
  String getWktCoordinatePairs() {
    return "$x" + " " + "$y";
  }

  @override
  String getJsonCoordinatePairs() {
    return "[" + "$x" + "," + "$y" + "]";
  }
}
