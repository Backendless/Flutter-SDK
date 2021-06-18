part of backendless_sdk;

class RelationStatus {
  String? parentObjectId;
  bool? isConditional;
  String? whereClause;
  List<String>? children;

  RelationStatus();

  RelationStatus.fromJson(Map json) {
    parentObjectId = json['parentObjectId'];
    isConditional = json['isConditional'];
    whereClause = json['whereClause'];
    children = json['children']?.cast<String>();
  }

  Map toJson() => {
        'parentObjectId': parentObjectId,
        'isConditional': isConditional,
        'whereClause': whereClause,
        'children': children,
      };

  @override
  String toString() =>
      "RelationStatus{parentObjectId=$parentObjectId,isConditional=$isConditional,whereClause=$whereClause,children=$children}";
}
