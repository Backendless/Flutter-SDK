part of backendless_sdk;

class Polygon extends Geometry {
  static const String geoJsonType = "Polygon";
  static const String wktType = "POLYGON";

  late LineString boundary;
  late List<LineString> holes;

  Polygon(
      {LineString? boundary,
      List<LineString>? holes,
      SpatialReferenceSystemEnum? srs})
      : super(srs: srs) {
    this.boundary = boundary ?? LineString();
    this.holes = holes ?? [];
  }

  @override
  String getWktType() => Polygon.wktType;

  @override
  String getGeoJsonType() => Polygon.geoJsonType;

  @override
  String getWktCoordinatePairs() {
    String result = "";

    result += "(";
    result += boundary.getWktCoordinatePairs();
    result += "),";

    for (var h in holes) {
      result += "(";
      result += h.getWktCoordinatePairs();
      result += "),";
    }

    result = result.substring(0, result.length - 1);

    return result;
  }

  @override
  String getJsonCoordinatePairs() {
    String result = "";

    result += "[";
    result += boundary.getJsonCoordinatePairs();
    result += ",";

    for (var h in holes) {
      result += h.getJsonCoordinatePairs();
      result += "),";
    }

    result = result.substring(0, result.length - 1);
    result += "]";

    return result;
  }
}
