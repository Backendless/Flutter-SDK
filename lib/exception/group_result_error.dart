part of '../backendless_sdk.dart';

class GroupResultError implements Exception {
  GroupResultError.groupsNotFound() {
    throw BackendlessException(ExceptionMessage.groupsNotFound);
  }

  GroupResultError.itemsNotFound() {
    throw BackendlessException(ExceptionMessage.itemsNotFound);
  }
}
