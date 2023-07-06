part of backendless_sdk;

class TransactionHelper {
  static const String lastLoginColumnName = "lastLogin";
  static const String passwordKey = "password";
  static const String socialAccountColumnName = "socialAccount";
  static const String userStatusColumnName = "userStatus";

  static void removeSystemField(Map changes) {
    changes.remove(lastLoginColumnName);
    changes.remove(passwordKey);
    changes.remove(socialAccountColumnName);
    changes.remove(userStatusColumnName);
    changes.remove("objectId");
    changes.remove("created");
    changes.remove("updated");
  }

  static OpResult makeOpResult(
      String tableName, String operationResultId, OperationType operationType) {
    return OpResult(tableName, operationType, operationResultId);
  }

  static List<Map?> convertInstancesToMaps<E>(List<E?> instances) {
    if (reflector.canReflectType(E)) {
      return instances.map((e) => reflector.serialize(e)).toList();
    }

    throw ArgumentError("Serialization error. Cannot serialize $E");
  }

  static List convertMapsToObjectIds(List<Map> objectsMaps) {
    return objectsMaps
        .map((e) => convertObjectMapToObjectIdOrLeaveReference(e))
        .toList();
  }

  static Object convertObjectMapToObjectIdOrLeaveReference(Map objectMap) {
    if (objectMap.containsKey(UnitOfWork.referenceMarker)) {
      objectMap[UnitOfWork.propName] = "objectId";
      return objectMap;
    }

    return objectMap['objectId'];
  }

  static Map convertCreateBulkOrFindResultIndexToObjectId(
      OpResultValueReference parentObject) {
    Map referenceToObjectId;
    if (OperationTypeExt.supportCollectionEntityDescriptionType
        .contains(parentObject.opResult.operationType)) {
      referenceToObjectId = parentObject.resolveTo('objectId').makeReference();
    } else if (OperationTypeExt.supportListIdsResultType
        .contains(parentObject.opResult.operationType)) {
      referenceToObjectId = parentObject.makeReference();
    } else {
      throw ArgumentError(
          'This operation result not supported in this operation');
    }

    return referenceToObjectId;
  }

  static void makeReferenceToValueFromOpResult(Map? map) {
    map?.forEach((key, value) {
      if (value is OpResult) {
        if (OperationTypeExt.supportIntResultType
            .contains(value.operationType)) {
          value = value.makeReference();
        } else {
          throw ArgumentError(
              'OpResult/OpResultValueReference from this operation in this place not supported');
        }
      } else if (value is OpResultValueReference) {
        if (_createUpdatePropName(value) ||
            _createBulkResultIndex(value) ||
            _findPropNameResultIndex(value)) {
          value = value.makeReference();
        } else {
          throw ArgumentError(
              'OpResult/OpResultValueReference from this operation in this place not supported');
        }
      }
    });
  }

  static bool _createUpdatePropName(OpResultValueReference reference) {
    return OperationTypeExt.supportEntityDescriptionResultType
            .contains(reference.opResult.operationType) &&
        reference.propName != null &&
        reference.resultIndex == null;
  }

  static bool _createBulkResultIndex(OpResultValueReference reference) {
    return OperationType.CREATE_BULK == reference.opResult.operationType &&
        reference.propName == null &&
        reference.resultIndex != null;
  }

  static bool _findPropNameResultIndex(OpResultValueReference reference) {
    return OperationType.FIND == reference.opResult.operationType &&
        reference.propName != null &&
        reference.resultIndex != null;
  }
}
