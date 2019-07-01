part of backendless_sdk;

class BaseGeoCategory {
  static final String defaultCategory = "Default";
  String objectId;
  String name;
  int size;

  BaseGeoCategory({this.objectId, this.name, this.size});
}

class GeoCategory extends BaseGeoCategory implements Comparable<GeoCategory> {
  GeoCategory();

  GeoCategory.fromJson(Map json) {
    objectId = json['objectId'];
    name = json['name'];
    size = json['size'];
  }

  Map toJson() => {
        'objectId': objectId,
        'name': name,
        'size': size,
      };

  String get id => objectId;

  bool operator ==(o) =>
      o is GeoCategory && o.name == name && o.objectId == objectId;

  @override
  int get hashCode => hashValues(name, objectId);

  @override
  String toString() => "GeoCategory{name='$name', size=$size}";

  @override
  int compareTo(GeoCategory other) {
    if (this == other) return 0;

    int nameDiff = this.name == null
        ? (other.name == null ? 0 : -1)
        : this.name.compareTo(other.name);
    if (nameDiff != 0) return nameDiff;

    return this.size - other.size;
  }
}
