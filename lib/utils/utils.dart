import 'package:collection/collection.dart' show IterableExtension;

T? stringToEnum<T>(Iterable<T> enumValues, String? stringValue) {
  if (stringValue == null) return null;
  return enumValues.firstWhereOrNull((type) =>
      type.toString().split(".").last.toLowerCase() ==
      stringValue.toLowerCase());
}
