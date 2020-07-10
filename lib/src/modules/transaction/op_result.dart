part of backendless_sdk;

class OpResult {
  final String tableName;
  final OperationType operationType;
  String _opResultId;

  get opResultId => _opResultId;

  OpResult(this.tableName, this.operationType, this._opResultId);

  OpResultValueReference resolveTo({int resultIndex, String propName}) {
    return OpResultValueReference(this,
        resultIndex: resultIndex, propName: propName);
  }

  Map makeReference() {
    return {
      UnitOfWork.REFERENCE_MARKER: true,
      UnitOfWork.OP_RESULT_ID: _opResultId
    };
  }

  void setOpResultId(UnitOfWork unitOfWork, String newOpResultId) {
    if (unitOfWork.opResultIdStrings.contains(newOpResultId))
      throw new ArgumentError(
          "This opResultId already present. OpResultId must be unique");

    for (Operation operation in unitOfWork.operations)
      if (operation.opResultId == _opResultId) {
        operation.opResultId = newOpResultId;
        break;
      }

    _opResultId = newOpResultId;
  }
}

class OpResultIdGenerator {
  List<String> opResultIdStrings;
  final Map<String, int> opResultIdMaps = new Map();

  OpResultIdGenerator(List<String> opResultIdStrings) {
    this.opResultIdStrings = opResultIdStrings;
  }

  String generateOpResultId(OperationType operationType, String tableName) {
    String opResultIdGenerated;
    final String key = operationType.operationName + tableName;
    if (opResultIdMaps.containsKey(key)) {
      int count = opResultIdMaps[key];
      opResultIdMaps[key] = ++count;
      opResultIdGenerated = key + count.toString();
    } else {
      opResultIdMaps[key] = 1;
      opResultIdGenerated = key + "1";
    }
    opResultIdStrings.add(opResultIdGenerated);
    return opResultIdGenerated;
  }
}

class OpResultValueReference {
  final OpResult opResult;
  final int resultIndex;
  final String propName;

  OpResultValueReference(this.opResult, {this.resultIndex, this.propName});

  OpResultValueReference resolveTo(String propName) {
    return new OpResultValueReference(this.opResult,
        resultIndex: this.resultIndex, propName: propName);
  }

  Map makeReference() {
    Map referenceMap = opResult.makeReference();

    if (resultIndex != null)
      referenceMap[UnitOfWork.RESULT_INDEX] = resultIndex;

    if (propName != null) referenceMap[UnitOfWork.PROP_NAME] = propName;

    return referenceMap;
  }
}
