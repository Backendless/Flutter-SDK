part of backendless_sdk;

class LineString extends Geometry {
  static const String geoJsonType = "LineString";
  static const String wktType = "LINESTRING";

  late List<Point> points;

  @override
  bool operator ==(other) =>
      other is LineString && listEquals(points, other.points);

  @override
  int get hashCode => Object.hash(points, srs);

  LineString({List<Point>? points, SpatialReferenceSystemEnum? srs})
      : super(srs: srs) {
    this.points = points ?? <Point>[];
  }

  @override
  String getWktType() => LineString.wktType;

  @override
  String getGeoJsonType() => LineString.geoJsonType;

  @override
  String getWktCoordinatePairs() {
    String result = "";

    for (var p in points) {
      result += p.getWktCoordinatePairs();
      result += ", ";
    }
    result = result.substring(0, result.length - 2);

    return result;
  }

  @override
  String getJsonCoordinatePairs() {
    String result = "";

    result += "[";
    for (var p in points) {
      result += p.getJsonCoordinatePairs();
      result += ",";
    }

    result = result.substring(0, result.length - 1);
    result += "]";

    return result;
  }
}