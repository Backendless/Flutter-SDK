part of backendless_sdk;

class Polygon extends Geometry {
  static const String geoJsonType = "Polygon";
  static const String wktType = "POLYGON";

  late LineString boundary;
  late List<LineString> holes;

  Polygon(
      {LineString? boundary,
      List<LineString>? holes,
      SpatialReferenceSystem? srs})
      : super(srs: srs) {
    this.boundary = boundary != null ? boundary : LineString();
    this.holes = holes != null ? holes : [];
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

    if (holes != null) {
      holes.forEach((h) {
        result += "(";
        result += h.getWktCoordinatePairs();
        result += "),";
      });
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

    if (holes != null) {
      holes.forEach((h) {
        result += h.getJsonCoordinatePairs();
        result += "),";
      });
    }

    result = result.substring(0, result.length - 1);
    result += "]";

    return result;
  }
}
