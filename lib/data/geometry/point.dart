part of backendless_sdk;

class Point extends Geometry {
  static const double precision = 0.000000001;
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
  int get hashCode => Object.hash(x, y, srs);

  Point({this.x = 0.0, this.y = 0.0, SpatialReferenceSystemEnum? srs})
      : super(srs: srs);

  @override
  String getWktType() => Point.wktType;

  @override
  String getGeoJsonType() => Point.geoJsonType;

  @override
  String getWktCoordinatePairs() {
    return "$x $y";
  }

  @override
  String getJsonCoordinatePairs() {
    return "[$x,$y]";
  }
}
