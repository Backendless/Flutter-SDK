part of backendless_sdk;


class UnitOfWorkExecutor {

  final UnitOfWork unitOfWork;

  UnitOfWorkExecutor( this.unitOfWork );

  Future<UnitOfWorkResult> execute() async {
    print("Execute UnitOfWork");
    if( unitOfWork.operations == null || unitOfWork.operations.isEmpty )
      throw new ArgumentError( "List of operations in unitOfWork can not be null or empty" );

    String url = "https://api.backendless.com/0B83DD7F-A769-898E-FF28-6EC3B93C4200/39FC3C80-CC40-5CBE-FF5A-EED6A995DA00/transaction/unit-of-work";
    String body = parseUow(unitOfWork);

    print("Body: $body");

    final response = await http.post(url, 
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: body);
    print("Execution result: ${response.body}");
    

  }

  String parseUow(UnitOfWork uow) {
    String isolation = describeEnum(unitOfWork.transactionIsolation);
    String operations = '[';

    uow.operations.forEach((o) {
      String payload = jsonEncode(o.payload);
      operations += '{"operationType": "${describeEnum(o.operationType)}", "table": "${o.table}", "payload" : $payload, "opResultId": "${o.opResultId}"},';
    });
    operations = operations.substring(0, operations.length - 1) + ']';

    return '{"isolationLevelEnum": "$isolation", "operations": $operations}';
  }



// Map
// List<Map>
// String
// DeleteBulkPayload
// BackendlessDataQuery/DataQueryBuilder
// Relation
// UpdateBulkPayload





  // Future<List<User>> fetchUsersFromGitHub() async {
  //   final response = await http.get(‘https://api.github.com/users');
  //   print(response.body);
  //   List responseJson = json.decode(response.body.toString());
  //   List<User> userList = createUserList(responseJson);
  //   return userList;
  // }
}