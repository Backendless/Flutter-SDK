part of backendless_sdk;

class SpatialReferenceManager {
  static const SpatialReferenceSystem defaultSrs = SpatialReferenceSystem.WGS84;

  static int? getSrsId(SpatialReferenceSystem srs) {
    switch (srs) {
      case SpatialReferenceSystem.CARTESIAN:
        return (0);
      case SpatialReferenceSystem.PULKOVO_1995:
        return (4200);
      case SpatialReferenceSystem.WGS84:
        return (4326);
      case SpatialReferenceSystem.WGS84_PSEUDO_MERCATOR:
        return (3857);
      case SpatialReferenceSystem.WGS84_WORLD_MERCATOR:
        return (3395);
      default:
        return null;
    }
  }

  static String? getSrsName(SpatialReferenceSystem srs) {
    switch (srs) {
      case SpatialReferenceSystem.CARTESIAN:
        return ("Cartesian");
      case SpatialReferenceSystem.PULKOVO_1995:
        return ("Pulkovo 1995");
      case SpatialReferenceSystem.WGS84:
        return ("WGS 84");
      case SpatialReferenceSystem.WGS84_PSEUDO_MERCATOR:
        return ("WGS 84 / Pseudo-Mercator");
      case SpatialReferenceSystem.WGS84_WORLD_MERCATOR:
        return ("WGS 84 / World Mercator");
      default:
        return null;
    }
  }

  static SpatialReferenceSystem? srsById(int id) {
    for (SpatialReferenceSystem srs in SpatialReferenceSystem.values) {
      if (SpatialReferenceManager.getSrsId(srs) == id) {
        return (srs);
      }
    }
    return (null);
  }

  static String srsToString(SpatialReferenceSystem srs) {
    return "${SpatialReferenceManager.getSrsName(srs)}(${SpatialReferenceManager.getSrsId(srs)})";
  }
}
