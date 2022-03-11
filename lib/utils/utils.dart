import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:collection/collection.dart' show IterableExtension;

T? stringToEnum<T>(Iterable<T> enumValues, String? stringValue) {
  if (stringValue == null) return null;
  return enumValues.firstWhereOrNull((type) =>
      type.toString().split(".").last.toLowerCase() ==
      stringValue.toLowerCase());
}

Future<String?> toQueryString(DataQueryBuilder? queryBuilder) async {
  if (queryBuilder == null) return null;

  List queryTokens = [];

  if (queryBuilder.pageSize > 0)
    queryTokens.add('pageSize=${queryBuilder.pageSize}');

  if (queryBuilder.offset > 0) queryTokens.add('offset=${queryBuilder.offset}');

  if (queryBuilder.properties?.isNotEmpty ?? false)
    queryBuilder.properties!
        .map((property) => queryTokens.add('property=$property'));

  if (queryBuilder.excludeProperties?.isNotEmpty ?? false)
    queryTokens
        .add('excludeProps=${queryBuilder.excludeProperties!.join(',')}');

  if (queryBuilder.whereClause?.isNotEmpty ?? false)
    queryTokens.add('where=${queryBuilder.whereClause}');

  if (queryBuilder.havingClause?.isNotEmpty ?? false)
    queryTokens.add('having=${queryBuilder.havingClause}');

  if (queryBuilder.sortBy?.isNotEmpty ?? false)
    queryTokens.add('sortBy=${queryBuilder.sortBy!.join(',')}');

  if (queryBuilder.groupBy?.isNotEmpty ?? false)
    queryTokens.add('groupBy=${queryBuilder.groupBy!.join(',')}');

  if (queryBuilder.related?.isNotEmpty ?? false)
    queryTokens.add('loadRelations=${queryBuilder.related!.join(',')}');

  if (queryBuilder.relationsPageSize != null &&
      queryBuilder.relationsPageSize! > 0)
    queryTokens.add('relationsPageSize=${queryBuilder.relationsPageSize}');

  if (queryBuilder.relationsDepth != null && queryBuilder.relationsDepth! > 0)
    queryTokens.add('relationsDepth=${queryBuilder.relationsDepth}');

  if (queryBuilder.distinct ?? false)
    queryTokens.add('distinct=${queryBuilder.distinct}');

  return queryTokens.join('&');
}
