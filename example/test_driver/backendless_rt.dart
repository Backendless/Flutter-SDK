import 'dart:async';

import 'package:test/test.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

class TestRT {
  static void start() {
    final dataStore = Backendless.data.of("MapDrivenTest");
    final rt = dataStore.rt();

    final firstFieldValue = "first_test";
    final firstFieldValueUpdated = "first_test_updated";
    final secondFieldValue = "second_test";
    final thirdFieldValue = DateTime.now();
    final fourthFieldValue = 42;
    final fourthFieldValueUpdated = 4242;
    final fifthFieldValue = 42.42;
    final sixthFieldValue = false;

    final numberOfObjectsInBulk = 13;
    final whereClause = "objectId != null";

    Map savedEntity;

    group("RT", () {
      test("Create", () async {
        final createCompleter = Completer();

        final createListener = (entity) {
          if (entity["objectId"] != null &&
              entity["first"] == firstFieldValue &&
              entity["second"] == secondFieldValue &&
              entity["third"] == thirdFieldValue.millisecondsSinceEpoch &&
              entity["fourth"] == fourthFieldValue &&
              entity["fifth"] == fifthFieldValue &&
              entity["sixth"] == sixthFieldValue) {
            createCompleter.complete();
          } else {
            createCompleter.completeError("Create Listener Error");
          }
        };

        rt.addCreateListener(createListener);
        await Future.delayed(Duration(seconds: 4));

        final entityToSave = {
          "first": firstFieldValue,
          "second": secondFieldValue,
          "third": thirdFieldValue,
          "fourth": fourthFieldValue,
          "fifth": fifthFieldValue,
          "sixth": sixthFieldValue
        };

        savedEntity = await dataStore.save(entityToSave);
        await createCompleter.future;
        rt.removeCreateListeners();
      });

      test("Update", () async {
        final updateCompleter = Completer();

        final updateListener = (entity) {
          if (entity["objectId"] == savedEntity["objectId"] &&
              entity["first"] == firstFieldValueUpdated &&
              entity["fourth"] == fourthFieldValueUpdated) {
            updateCompleter.complete();
          } else {
            updateCompleter.completeError("Update Listener Error");
          }
        };

        rt.addUpdateListener(updateListener);
        await Future.delayed(Duration(seconds: 4));

        savedEntity["first"] = firstFieldValueUpdated;
        savedEntity["fourth"] = fourthFieldValueUpdated;

        await dataStore.save(savedEntity);
        await updateCompleter.future;
        rt.removeUpdateListeners();
      });

      test("Delete", () async {
        final deleteCompleter = Completer();

        final deleteListener = (entity) {
          if (entity["objectId"] == savedEntity["objectId"]) {
            deleteCompleter.complete();
          } else {
            deleteCompleter.completeError("Delete Listener Error");
          }
        };

        rt.addDeleteListener(deleteListener);
        await Future.delayed(Duration(seconds: 4));

        await dataStore.remove(entity: savedEntity);
        await deleteCompleter.future;
        rt.removeDeleteListeners();
      });

      test("Bulk Update", () async {
        final bulkUpdateCompleter = Completer();

        final bulkUpdateListener = (BulkEvent event) {
          if (event.count == numberOfObjectsInBulk &&
              event.whereClause == whereClause) {
            bulkUpdateCompleter.complete();
          } else {
            bulkUpdateCompleter.completeError("Bulk Update Listener Error");
          }
        };

        rt.addBulkUpdateListener(bulkUpdateListener);
        await Future.delayed(Duration(seconds: 4));

        final singleEntity = {
          "first": firstFieldValue,
          "second": secondFieldValue,
          "third": thirdFieldValue,
          "fourth": fourthFieldValue,
          "fifth": fifthFieldValue,
          "sixth": sixthFieldValue
        };
        final entitiesToSave = List.filled(numberOfObjectsInBulk, singleEntity);

        await dataStore.create(entitiesToSave);
        final changes = {"fourth": fourthFieldValueUpdated};
        await dataStore.update(whereClause, changes);
        await dataStore.remove(whereClause: whereClause);

        await bulkUpdateCompleter.future;
        rt.removeBulkUpdateListeners();
      });

      // test("Bulk Delete", () async {
      //   final bulkDeleteCompleter = Completer();

      //   final bulkDeleteListener = (BulkEvent event) {
      //     if (event.count == numberOfObjectsInBulk &&
      //         event.whereClause == whereClause) {
      //       bulkDeleteCompleter.complete();
      //     } else {
      //       bulkDeleteCompleter.completeError("Bulk Delete Listener Error");
      //     }
      //   };

      //   rt.addBulkDeleteListener(bulkDeleteListener);
      //   await Future.delayed(Duration(seconds: 20));

      //   final singleEntity = {
      //     "first": firstFieldValue,
      //     "second": secondFieldValue,
      //     "third": thirdFieldValue,
      //     "fourth": fourthFieldValue,
      //     "fifth": fifthFieldValue,
      //     "sixth": sixthFieldValue
      //   };
      //   final entitiesToSave = List.filled(numberOfObjectsInBulk, singleEntity);

      //   await dataStore.create(entitiesToSave);
      //   await dataStore.remove(whereClause: whereClause);

      //   await bulkDeleteCompleter.future;
      //   rt.removeBulkDeleteListeners();
      // });
    });
  }
}
