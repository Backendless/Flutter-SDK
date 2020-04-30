part of backendless_sdk;


class UnitOfWorkExecutor {

  final UnitOfWork unitOfWork;

  UnitOfWorkExecutor( this.unitOfWork );

  Future<UnitOfWorkResult> execute() async {
    print("Execute UnitOfWork");
    if( unitOfWork.operations == null || unitOfWork.operations.isEmpty )
      throw new ArgumentError( "List of operations in unitOfWork can not be null or empty" );

    String appId = "D6CD378E-DC9D-11E1-FF64-5F02BBE23C00";
    String apiKey = "B6976DD7-75AA-48F8-9846-B51709D6C956";

    String url = "https://api.backendless.com/$appId/$apiKey/transaction/unit-of-work";
    String body = parseUow(unitOfWork);

    print("Body: $body");

    final response = await http.post(url, 
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: body);
    print("Execution result: ${response.body}");

    Map json = jsonDecode(response.body.toString());
    UnitOfWorkResult unitOfWorkResult = UnitOfWorkResult.fromJson(json);
    print("UnitOfWorkResult: $unitOfWorkResult");
    return unitOfWorkResult;
  }

  String parseUow(UnitOfWork uow) {
    String isolation = describeEnum(unitOfWork.transactionIsolation);
    String operations = '[';

    uow.operations.forEach((o) {
      String payload;
      if (o.payload is Map || o.payload is List || o.payload is DataQueryBuilder)
        payload = jsonEncode(o.payload);
      else if (o.payload is String)
        payload = '"${o.payload}"';
      else
        payload = o.payload.toJson();

      operations += '{"operationType": "${describeEnum(o.operationType)}", "table": "${o.table}", "payload" : $payload, "opResultId": "${o.opResultId}"},';
    });
    operations = operations.substring(0, operations.length - 1) + ']';

    return '{"isolationLevelEnum": "$isolation", "operations": $operations}';
  }
}