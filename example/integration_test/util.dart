import 'package:backendless_sdk/backendless_sdk.dart';

Future<void> removeAllObjectsInTable(String table) async {
  await Backendless.data
      .of(table)
      .bulkRemove('objectId!=\'1\' or objectId!=\'0\'');
}
