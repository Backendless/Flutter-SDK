part of backendless_sdk;

class GroupResult {
  bool hasNextPage = false;
  final bool _isGroups = false;
  List<dynamic> items = [];

  GroupResult();

  GroupResult.fromJson(Map json) {
    hasNextPage = json['hasNextPage'];
    items = json['items'];
  }

  Map toJson() => {
        'hasNextPage': hasNextPage,
        'items': items,
      };

  Future<List<GroupedData>> get groupedData async {
    if (!_isGroups) {
      throw GroupResultError.groupsNotFound();
    }

    return items as List<GroupedData>;
  }

  Future<dynamic> get plainItems async {
    if (_isGroups && items.isEmpty) {
      throw GroupResultError.itemsNotFound();
    }

    return items;
  }
}
