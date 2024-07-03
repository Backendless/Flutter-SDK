part of '../../../../backendless_sdk.dart';

class OperationFind<T> extends Operation<T> {
  OperationFind(
      OperationType super.operationType, String super.table, String super.opResultId, T super.payload)
      : super.withPayload();

  OperationFind.fromJson(super.json) : super.fromJson();
}
