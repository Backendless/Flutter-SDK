part of backendless_sdk;

abstract class Geometry {
  static T fromWKT<T extends Geometry>(String wellKnownText,
      {SpatialReferenceSystemEnum? srs}) {
    return (WKTParser(srs: srs).read(wellKnownText));
  }

  static T? fromGeoJSON<T extends Geometry>(String geoJson,
      {SpatialReferenceSystemEnum? srs}) {
    return (GeoJSONParser(srs: srs).read(geoJson));
  }

  SpatialReferenceSystemEnum? srs;

  String getWktCoordinatePairs();

  String getJsonCoordinatePairs();

  Geometry({this.srs = SpatialReferenceSystemEnum.wgs84});

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
