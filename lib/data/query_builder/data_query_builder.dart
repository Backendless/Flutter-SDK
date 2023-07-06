part of backendless_sdk;

class DataQueryBuilder {
  // ignore: constant_identifier_names
  static const int DEFAULT_RELATIONS_DEPTH = 0;
  final PagedQueryBuilder _pagedQueryBuilder = PagedQueryBuilder();

  List<String>? sortBy;
  List<String>? groupBy;

  List<String>? properties;
  List<String>? excludeProperties;

  String? whereClause;
  String? havingClause;

  List<String>? loadRelations;
  int? relationsDepth;
  int? relationsPageSize;

  bool? distinct;

  DataQueryBuilder() {
    properties = [];
    excludeProperties = [];
    whereClause = '';
    groupBy = [];
    havingClause = '';
    sortBy = [];
    loadRelations = [];
    relationsDepth = DEFAULT_RELATIONS_DEPTH;
    distinct = false;
  }

  DataQueryBuilder.fromJson(Map json) {
    pageSize = json['pageSize'];
    offset = json['offset'];
    properties = json['props']?.cast<String>();
    excludeProperties = json['excludeProps']?.cast<String>();
    whereClause = json['where'];
    groupBy = json['groupBy']?.cast<String>();
    havingClause = json['having'];
    sortBy = json['sortBy']?.cast<String>();
    loadRelations = json['loadRelations']?.cast<String>();
    if (json['relationsDepth'] != null) {
      relationsDepth = json['relationsDepth'];
    } else {
      relationsDepth = DEFAULT_RELATIONS_DEPTH;
    }
    relationsPageSize = json['relationsPageSize'];
    distinct = json['distinct'];
  }

  set pageSize(int pageSize) => _pagedQueryBuilder.pageSize = pageSize;

  int get pageSize => _pagedQueryBuilder.pageSize;

  set offset(int offset) => _pagedQueryBuilder.offset = offset;

  int get offset => _pagedQueryBuilder.offset;

  void prepareNextPage() => _pagedQueryBuilder.prepareNextPage();

  void preparePreviousPage() => _pagedQueryBuilder.preparePreviousPage();

  void addAllProperties() => properties!.add("*");

  Map toJson() => {
        'pageSize': pageSize,
        'offset': offset,
        'props': properties,
        'excludeProps': excludeProperties,
        'where': whereClause,
        'groupBy': groupBy,
        'having': havingClause,
        'sortBy': sortBy,
        'loadRelations': loadRelations?.join(','),
        'relationsDepth': relationsDepth,
        'relationsPageSize': relationsPageSize,
        'distinct': distinct,
      };
}
