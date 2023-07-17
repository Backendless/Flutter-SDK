// ignore_for_file: constant_identifier_names

part of backendless_sdk;

enum RTEventHandlers {
  CREATED,
  UPDATED,
  UPSERTED,
  DELETED,
  BULK_CREATED,
  BULK_UPDATED,
  BULK_UPSERTED,
  BULK_DELETED,
  SET,
  ADD,
  DELETE,
}

extension RTEventHandlerAsString on RTEventHandlers {
  String toShortString() {
    String stringifiedEnum = toString().split('.').last.toLowerCase();

    if (stringifiedEnum.contains('_')) {
      stringifiedEnum = stringifiedEnum.replaceAll('_', '-');
    }

    return stringifiedEnum;
  }
}