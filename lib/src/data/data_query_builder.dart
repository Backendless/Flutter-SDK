part of backendless_sdk;

class DataQueryBuilder {
  String? whereClause;
  int? pageSize;
  int? offset;

  Map toJson() {
    return {'offset': offset, 'pageSize': pageSize, 'whereClause': whereClause};
  }
}
