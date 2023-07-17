part of backendless_sdk;

class GroupResultError implements Exception {
  GroupResultError.groupsNotFound() {
    throw BackendlessException(ExceptionMessage.groupsNotFound);
  }

  GroupResultError.itemsNotFound() {
    throw BackendlessException(ExceptionMessage.itemsNotFound);
  }
}
