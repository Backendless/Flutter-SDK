part of backendless_sdk;

class GroupDataQueryBuilder extends DataQueryBuilder {
  int groupDepth = 3;
  int groupPageSize = 10;
  int recordsPageSize = 10;
  List<GroupColumnValue>? groupPath;

  GroupDataQueryBuilder() : super();

  GroupDataQueryBuilder.fromJson(Map json) : super.fromJson(json) {
    groupDepth = json['groupDepth'];
    groupPageSize = json['groupPageSize'];
    recordsPageSize = json['recordsPageSize'];
    groupPath = json['groupPath'];
  }

  @override
  Map toJson() {
    Map json = super.toJson();
    json['groupDepth'] = groupDepth;
    json['groupPageSize'] = groupPageSize;
    json['recordsPageSize'] = recordsPageSize;
    json['groupPath'] = groupPath;

    return json;
  }
}
