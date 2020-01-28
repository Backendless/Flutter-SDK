part of backendless_sdk;

abstract class Geometry {
  static T fromWKT<T extends Geometry>(String wellKnownText,
      {SpatialReferenceSystem srs}) {
    return (WKTParser(srs: srs).read(wellKnownText));
  }

  static T fromGeoJSON<T extends Geometry>(String geoJson,
      {SpatialReferenceSystem srs}) {
    return (GeoJSONParser(srs: srs).read(geoJson));
  }

  SpatialReferenceSystem srs;

  String getWktCoordinatePairs();

  String getJsonCoordinatePairs();

  Geometry({this.srs}) {
    this.srs = srs != null ? srs : SpatialReferenceManager.defaultSrs;
  }

  String getWktType();

  String getGeoJsonType();

  String asWKT() {
    return getWktType() + " (" + getWktCoordinatePairs() + ")";
  }

  String asGeoJson() {
    return "{\"type\":\"" +
        getGeoJsonType() +
        "\",\"coordinates\":" +
        getJsonCoordinatePairs() +
        "}";
  }

  @override
  String toString() {
    return "'" + this.asWKT() + "'";
  }
}
