part of backendless_sdk;

class DataQueryBuilder {
  static const int DEFAULT_RELATIONS_DEPTH = 0;
  late PagedQueryBuilder _pagedQueryBuilder = new PagedQueryBuilder();

  late List<String>? sortBy;
  late List<String>? groupBy;

  late List<String>? properties;
  late List<String>? excludeProperties;

  late String? whereClause;
  late String? havingClause;

  late List<String>? related;
  late int? relationsDepth;
  late int? relationsPageSize;

  late bool? distinct;

  DataQueryBuilder() {
    this.sortBy = null;
    this.groupBy = null;

    this.properties = null;
    this.excludeProperties = null;

    this.whereClause = null;
    this.havingClause = null;

    this.related = null;
    this.relationsDepth = null;
    this.relationsPageSize = null;

    this.distinct = null;
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

  /*String _toRequestBody({DataQueryBuilder? queryBuilder}) {
    var query = queryBuilder != null ? queryBuilder.toJson() : {};
    query.forEach((key, value) {

    })
  }*/
}
