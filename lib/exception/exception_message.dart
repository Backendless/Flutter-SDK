part of backendless_sdk;

class ExceptionMessage {
  static const String EMPTY_NULL_OBJECT_ID =
      'Object id cannot be null or empty.';
  static const String EMPTY_NULL_API_KEY = 'Api key cannot be null or empty.';
  static const String EMPTY_NULL_APP_ID =
      'Application id cannot be null or empty.';
  static const String EMPTY_NULL_USER_ID = 'User id cannot be null or empty.';
  static const String EMPTY_IDENTITY = 'Identity cannot be empty.';
  static const String EMPTY_MAP = 'Map cannot be empty.';
  static const String EMPTY_ENTITY = 'Entity cannot be empty.';
  static const String EMPTY_RELATION_NAME = 'relationName cannot be empty.';
  static const String NO_ONE_ARGUMENT_SPECIFIED =
      'At least one argument must be specified.';
  static const String NULL_WHERE = 'whereClause cannot be null.';
  static const String EMPTY_SOURCE_OR_TARGET_PATHS =
      'sourcePath or targetPath cannot be null.';
  static const String EMPTY_PATH = 'Path cannot be null.';
  static const String NO_INTERNET_CONNECTION = 'No internet connection.';
  static const String ERROR_DURING_REMOVE_SUB =
      'An error occurred while deleting a subscription.\n'
      'Perhaps you are trying to delete a subscription that does not exist.';
  static const String CANNOT_COMPARE_TYPES =
      'Subscription types cannot be different for the same object.';
  static const String NO_ONE_SUB =
      'Not one event was set. First subscribe to the event and then subscribe to the connection.';
}
