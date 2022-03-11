part of backendless_sdk;

enum SpatialReferenceSystemEnum {
  cartesian,
  pulkovo1995,
  wgs84,
  wgs84PseudoMercator,
  wgs84WorldMercator,
  unknown,
}

extension SpatialReferenceSystemEnumExtension on SpatialReferenceSystemEnum {
  String? get name {
    switch (this) {
      case SpatialReferenceSystemEnum.cartesian:
        return 'Cartesian';
      case SpatialReferenceSystemEnum.pulkovo1995:
        return 'Pulkovo 1995';
      case SpatialReferenceSystemEnum.wgs84:
        return 'WGS84';
      case SpatialReferenceSystemEnum.wgs84PseudoMercator:
        return 'WGS 84 / Pseudo-Mercator';
      case SpatialReferenceSystemEnum.wgs84WorldMercator:
        return 'WGS 84 / World-Mercator';
      case SpatialReferenceSystemEnum.unknown:
        return null;
    }
  }

  int? get srsId {
    switch (this) {
      case SpatialReferenceSystemEnum.cartesian:
        return 0;
      case SpatialReferenceSystemEnum.pulkovo1995:
        return 4200;
      case SpatialReferenceSystemEnum.wgs84:
        return 4326;
      case SpatialReferenceSystemEnum.wgs84PseudoMercator:
        return 3857;
      case SpatialReferenceSystemEnum.wgs84WorldMercator:
        return 3395;
      case SpatialReferenceSystemEnum.unknown:
        return null;
    }
  }
}
