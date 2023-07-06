// ignore_for_file: annotate_overrides, overridden_fields

part of backendless_sdk;

class LoadRelationsQueryBuilder<T> extends DataQueryBuilder {
  PagedQueryBuilder pagedQueryBuilder = PagedQueryBuilder();
  late String relationName;
  List<String>? properties;
  List<String>? sortBy;

  LoadRelationsQueryBuilder._(this.relationName);

  static LoadRelationsQueryBuilder<R> of<R>(String relationName) {
    return LoadRelationsQueryBuilder<R>._(relationName);
  }

  LoadRelationsQueryBuilder.ofMap(this.relationName);

  LoadRelationsQueryBuilder.fromJson(Map json) {
    relationName = json['relationName'];
    pageSize = json['pageSize'];
    offset = json['offset'];
    properties = json['properties']?.cast<String>();
    sortBy = json['sortBy']?.cast<String>();
  }

  Map toJson() => {
        'relationName': relationName,
        'pageSize': pageSize,
        'offset': offset,
        'properties': properties,
        'sortBy': sortBy,
      };

  set pageSize(int pageSize) => pagedQueryBuilder.pageSize = pageSize;

  int get pageSize => pagedQueryBuilder.pageSize;

  set offset(int offset) => pagedQueryBuilder.offset = offset;

  int get offset => pagedQueryBuilder.offset;

  void prepareNextPage() => pagedQueryBuilder.prepareNextPage();

  void preparePreviousPage() => pagedQueryBuilder.preparePreviousPage();
}
