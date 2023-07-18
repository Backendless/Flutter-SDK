part of backendless_sdk;

class ExceptionMessage {
  static const String emptyNullChildrenObjectIdsAndWhere =
      'сhildrenObjectIds and whereClause cannot both be null or empty.';
  static const String emptyNullObjectId = 'Object id cannot be null or empty.';
  static const String emptyNullApiKey = 'Api key cannot be null or empty.';
  static const String emptyNullAppId =
      'Application id cannot be null or empty.';
  static const String emptyNullUserId = 'User id cannot be null or empty.';
  static const String emptyNullUserIdOrUserToken =
      'User id(objectId) or user-token cannot be null or empty.';
  static const String emptyIdentity = 'Identity cannot be empty.';
  static const String emptyMap = 'Map cannot be empty.';
  static const String emptyEntity = 'Entity cannot be empty.';
  static const String emptyRelationName = 'relationName cannot be empty.';
  static const String emptyBackendlessExpression =
      'The BackendlessExpression class can be initialized with non empty string value only';
  static const String emptyPath = 'Path cannot be null.';
  static const String emptySourceOrTargetPaths =
      'sourcePath or targetPath cannot be null.';
  static const String emptyNullIdentifier =
      'Identifier in transactions API should not be null or empty';

  static const String noOneArgumentSpecified =
      'At least one argument must be specified.';
  static const String nullWhere = 'whereClause cannot be null.';
  static const String noInternetConnection = 'No internet connection.';
  static const String errorDuringRemoveSub =
      'An error occurred while deleting a subscription.\n'
      'Perhaps you are trying to delete a subscription that does not exist.';
  static const String cannotCompareTypes =
      'Subscription types cannot be different for the same object.';
  static const String noOneSub =
      'Not one event was set. First subscribe to the event and then subscribe to the connection.';
  static const String nullSub =
      'You cannot remove a non-existing subscription.';
  static const String groupsNotFound =
      'List of items does not contain instances of GroupedData. Use the getter \'plainItems\' method to access data.';
  static const String itemsNotFound =
      'List of items contains instances of GroupedData. Use the getter \'groupedData\' method to access data.';
}
