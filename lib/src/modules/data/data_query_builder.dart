part of backendless_sdk;

class DataQueryBuilder {
  static const int DEFAULT_RELATIONS_DEPTH = 0;
  PagedQueryBuilder _pagedQueryBuilder = new PagedQueryBuilder();
  List<String> properties;
  List<String> excludeProperties;
  String whereClause;
  List<String> groupBy;
  String havingClause;
  List<String> sortBy;
  List<String> related;
  int relationsDepth;
  int relationsPageSize;

  DataQueryBuilder() {
    properties = new List();
    excludeProperties = new List();
    whereClause = "";
    groupBy = new List();
    havingClause = "";
    sortBy = new List();
    related = new List();
    relationsDepth = DEFAULT_RELATIONS_DEPTH;
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
        'relationsPageSize': relationsPageSize
      };

  set pageSize(int pageSize) => _pagedQueryBuilder.pageSize = pageSize;

  get pageSize => _pagedQueryBuilder.pageSize;

  set offset(int offset) => _pagedQueryBuilder.offset = offset;

  get offset => _pagedQueryBuilder.offset;

  void prepareNextPage() => _pagedQueryBuilder.prepareNextPage();

  void preparePreviousPage() => _pagedQueryBuilder.preparePreviousPage();

  void addAllProperties() => properties.add("*");
}

/// This class does not support relation types other than Map for now.
class LoadRelationsQueryBuilder<R> {
  PagedQueryBuilder pagedQueryBuilder = new PagedQueryBuilder();
  String relationName;
  List<String> properties;
  List<String> sortBy;

  LoadRelationsQueryBuilder._(this.relationName);

  static LoadRelationsQueryBuilder<R> of<R>(String relationName) {
    return LoadRelationsQueryBuilder<R>._(relationName);
  }

  LoadRelationsQueryBuilder.ofMap(this.relationName);

  LoadRelationsQueryBuilder.fromJson(Map json) {
    relationName = json['relationName'];
    pageSize = json['pageSize'];
    offset = json['offset'];
    properties = json['properties'].cast<String>();
    sortBy = json['sortBy'].cast<String>();
  }

  Map toJson() => {
        'relationName': relationName,
        'pageSize': pageSize,
        'offset': offset,
        'properties': properties,
        'sortBy': sortBy,
      };

  set pageSize(int pageSize) => pagedQueryBuilder.pageSize = pageSize;

  get pageSize => pagedQueryBuilder.pageSize;

  set offset(int offset) => pagedQueryBuilder.offset = offset;

  get offset => pagedQueryBuilder.offset;

  void prepareNextPage() => pagedQueryBuilder.prepareNextPage();

  void preparePreviousPage() => pagedQueryBuilder.preparePreviousPage();
}
