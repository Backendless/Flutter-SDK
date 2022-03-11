part of backendless_sdk;

class WKTParser {
  static const _SPACE = " ";
  static const _POINT_COORDINATED_LEN = 2;

  SpatialReferenceSystemEnum? srs;

  WKTParser({this.srs = SpatialReferenceSystemEnum.wgs84});

  T read<T extends Geometry>(String wellKnownText) {
    final formatterWKT = wellKnownText.toUpperCase();

    if (formatterWKT.startsWith(Point.wktType))
      return _readPoint(formatterWKT) as T;
    else if (formatterWKT.startsWith(LineString.wktType))
      return _readLineString(formatterWKT) as T;
    else if (formatterWKT.startsWith(Polygon.wktType))
      return _readPolygon(formatterWKT) as T;
    else
      throw ArgumentError("Unknown geometry type: $wellKnownText");
  }

  Geometry? _readPoint(String wellKnownText) {
    final cleanedFromType = wellKnownText.replaceAll(Point.wktType, "").trim();
    final rawPoint = cleanedFromType.substring(1, cleanedFromType.length - 1);
    return _getPoint(rawPoint);
  }

  Point? _getPoint(String rawPoint) {
    final rawCoordinates = rawPoint.trim().split(WKTParser._SPACE);
    if (rawCoordinates.length != _POINT_COORDINATED_LEN) {
      return null;
    }

    final x = double.parse(rawCoordinates.first);
    final y = double.parse(rawCoordinates.last);

    return Point(x: x, y: y, srs: srs);
  }

  Geometry _readLineString(String wellKnownText) {
    final cleanedFromType =
        wellKnownText.replaceAll(LineString.wktType, "").trim();
    final rawLineString =
        cleanedFromType.substring(1, cleanedFromType.length - 1);
    return _getLineString(rawLineString);
  }

  LineString _getLineString(String rawLineString) {
    final rawPoints = rawLineString.split(",");
    final points = rawPoints.map(_getPoint).toList() as List<Point>;

    return LineString(points: points, srs: srs);
  }

  Geometry _readPolygon(String wellKnownText) {
    final cleanedFromType =
        wellKnownText.replaceAll(Polygon.wktType, "").trim();
    final rawPolygon = cleanedFromType.substring(1, cleanedFromType.length - 1);

    return _getPolygon(rawPolygon);
  }

  Polygon _getPolygon(String rawPolygon) {
    final regexp = RegExp(r"\([^)]+\)");
    final matches = regexp.allMatches(rawPolygon).toList();

    final lineStrings = matches
        .map((m) => rawPolygon.substring(m.start, m.end))
        .map((matchedLine) => matchedLine.substring(1, matchedLine.length - 1))
        .map(_getLineString)
        .toList();

    return Polygon(
        boundary: lineStrings.first, holes: lineStrings.sublist(1), srs: srs);
  }
}
