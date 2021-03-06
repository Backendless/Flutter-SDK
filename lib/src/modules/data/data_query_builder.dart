part of backendless_sdk;

class DataQueryBuilder {
  static const int DEFAULT_RELATIONS_DEPTH = 0;
  PagedQueryBuilder _pagedQueryBuilder = new PagedQueryBuilder();
  late List<String> properties;
  late List<String> excludeProperties;
  late String whereClause;
  late List<String> groupBy;
  late String havingClause;
  late List<String> sortBy;
  late List<String> related;
  late int relationsDepth;
  int? relationsPageSize;
  late bool distinct;

  DataQueryBuilder() {
    properties = [];
    excludeProperties = [];
    whereClause = "";
    groupBy = [];
    havingClause = "";
    sortBy = [];
    related = [];
    relationsDepth = DEFAULT_RELATIONS_DEPTH;
    distinct = false;
  }

  DataQueryBuilder.fromJson(Map json) {
    pageSize = json['pageSize'];
    offset = json['offset'];
    properties = json['properties']?.cast<String>();
    excludeProperties = json['excludeProperties']?.cast<String>();
    whereClause = json['whereClause'];
    groupBy = json['groupBy']?.cast<String>();
    havingClause = json['havingClause'];
    sortBy = json['sortBy']?.cast<String>();
    related = json['related']?.cast<String>();
    if (json['relationsDepth'] != null)
      relationsDepth = json['relationsDepth'];
    else
      relationsDepth = DEFAULT_RELATIONS_DEPTH;
    relationsPageSize = json['relationsPageSize'];
    distinct = json['distinct'];
  }

  Map toJson() => {
        'pageSize': pageSize,
        'offset': offset,
        'properties': properties,
        'excludeProperties': excludeProperties,
        'whereClause': whereClause,
        'groupBy': groupBy,
        'havingClause': havingClause,
        'sortBy': sortBy,
        'related': related,
        'relationsDepth': relationsDepth,
        'relationsPageSize': relationsPageSize,
        'distinct': distinct,
      };

  set pageSize(int pageSize) => _pagedQueryBuilder.pageSize = pageSize;

  int get pageSize => _pagedQueryBuilder.pageSize;

  set offset(int offset) => _pagedQueryBuilder.offset = offset;

  int get offset => _pagedQueryBuilder.offset;

  void prepareNextPage() => _pagedQueryBuilder.prepareNextPage();

  void preparePreviousPage() => _pagedQueryBuilder.preparePreviousPage();

  void addAllProperties() => properties.add("*");
}

/// This class does not support relation types other than Map for now.
class LoadRelationsQueryBuilder<R> {
  PagedQueryBuilder pagedQueryBuilder = new PagedQueryBuilder();
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
