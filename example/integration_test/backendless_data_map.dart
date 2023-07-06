// ignore_for_file: unnecessary_null_comparison

import 'dart:math';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'util.dart';

class DataMapTest {
  static final table = Backendless.data.of('FlutterTestTable');
  static final relationTable = Backendless.data.of('FlutterRelationTable');
  static String? targetObjectId;

  static void start() {
    group('Data Map Test', () {
      // ----
      test('Data of table is not null', () {
        // 1
        bool isNull = table == null;

        // 3
        expect(isNull, false);
      });

      // ----
      test('Save object(create)', () async {
        String foo = 'test create';
        // 1
        var expectedObj = {
          '___class': 'FlutterTestTable',
          'ownerId': null,
          'updated': null,
          'foo': foo
        };

        // 2
        var result = await table.save({'foo': foo});

        // 3
        expect(result?.isNotEmpty ?? false, true, reason: 'ObjectId was empty');
        bool containObjectId = result!.containsKey('objectId');
        expect(containObjectId, true);

        bool containCreated = result.containsKey('created');
        expect(containCreated, true);

        result.remove('created');
        targetObjectId = result['objectId'];
        result.remove('objectId');
        expect(result, expectedObj);
      });

      // ----
      test('Save object(update)', () async {
        // 1
        String? objectId = targetObjectId;
        String foo = 'test update';
        var expectedObj = {
          '___class': 'FlutterTestTable',
          'ownerId': null,
          'objectId': objectId,
          'foo': foo
        };

        // 2
        var res = await table.save({'objectId': objectId, 'foo': foo});

        // 3
        expect(res?.isEmpty ?? false, false);

        bool containsUpdated = res!.containsKey('updated');
        expect(containsUpdated, true);

        bool updateIsNull = res['updated'] == null;
        expect(updateIsNull, false);

        res.removeWhere((key, value) => key == 'updated' || key == 'created');
        expect(res, expectedObj);

        await table.remove({'objectId': objectId});
      });

      // ----
      test('Save to wrong table', () async {
        try {
          // 2
          await Backendless.data.of('undefined').save({});

          // 3
          expect(1, 0);
        } catch (ex) {
          // 3
          expect(0, 0);
        }
      });

      // ----
      test('Update non-existent object', () async {
        // 1
        String objectId = '2';
        String foo = 'wrong update';

        // 2
        try {
          await table.save({'objectId': objectId, 'foo': foo});

          // 3
          expect(0, 1);
        } catch (ex) {
          // 3
          expect(1, 1);
        }
      });

      // ----
      test('Save with upsert(created). objectId is specified', () async {
        // 1
        String objectId = '2';
        String foo = 'upsert create';

        // 2
        var res = await table
            .save({'objectId': objectId, 'foo': foo}, isUpsert: true);

        // 3
        bool isNull = res == null;
        expect(isNull, false);

        bool containsUpdated = res!.containsKey('updated');
        expect(containsUpdated, true);

        bool updatedIsNull = res['updated'] == null;
        expect(updatedIsNull, true);
      });

      // ----
      test('Save with upsert(updated). objectId is specified', () async {
        // 1
        String objectId = '2';
        String foo = 'upsert update';

        // 2
        var res = await table
            .save({'objectId': objectId, 'foo': foo}, isUpsert: true);
        await table.remove(res!);

        // 3
        bool isNull = res == null;
        expect(isNull, false);

        bool containsUpdated = res.containsKey('updated');
        expect(containsUpdated, true);

        bool updatedIsNull = res['updated'] == null;
        expect(updatedIsNull, false);
      });

      // ----
      test('Save with upsert. Object NOT specified', () async {
        // 1
        String foo = 'test upsert without objectId';
        // 2
        var res = await table.save({'foo': foo}, isUpsert: true);
        await table.remove(res!);
        // 3
        bool isNull = res == null;
        expect(isNull, false, reason: 'Object is null');

        String? actualFoo = res['foo'];
        expect(actualFoo, foo, reason: 'Foo is different');
      });

      // ----
      test('General Find method(empty table)', () async {
        // 1
        var expectedArr = [];
        // 2
        var res = await table.find();

        // 3
        expect(res, expectedArr);
      });

      // --
      test('General Find method(with objects)', () async {
        // 1
        var firstObj = await table.save({'foo': 'first obj'});
        var secondObj = await table.save({'foo': 'second obj'});
        var thirdObj = await table.save({'foo': 'third obj'});
        var expectedArr = [firstObj, secondObj, thirdObj];

        // 2
        var res = await table.find();
        await table.bulkRemove('updated is null');

        // 3
        res!.sort(
            (a, b) => (a!['created'] as int).compareTo(b!['created'] as int));
        expect(res.length, expectedArr.length);
        expect(expectedArr, res);
      });

      test('General Find method with DataQueryBuild', () async {
        // 1
        var firstObject = await table.save({'foo': 'first obj'});
        var secondObj = await table.save({'foo': 'second obj'});
        await table.save({'foo': 'third obj'});
        var expectedData = [firstObject, secondObj];
        DataQueryBuilder queryBuilder = DataQueryBuilder()
          ..pageSize = 2
          ..sortBy = ['created asc'];
        // 2
        var res = await table.find(queryBuilder: queryBuilder);

        //3
        expect(res!.length, 2);
        expect(res, expectedData);
        await table.bulkRemove('updated is null');
      });

      test('FindFirst method(empty res)', () async {
        // 1
        dynamic expectedValue;
        // 2
        var res = await table.findFirst();
        // 3
        expect(res, expectedValue);
      });

      test('FindFirst method', () async {
        // 1
        var expectedObj = await table.save({'foo': 'first obj'});

        // 2
        var res = await table.findFirst();

        // 3
        expect(res, expectedObj);
        await table.remove(expectedObj!);
      });

      test('FindFirst with several obj', () async {
        // 1
        var expectedObj = await table.save({'foo': 'first'});
        await table.save({'foo': 'second'});

        // 2
        var res = await table.findFirst();

        // 3
        expect(res, expectedObj);
        await table.bulkRemove('updated is null');
      });

      test('FindFirst with DataQueryBuilder', () async {
        // 1
        var parentObj = await relationTable.save({});
        var childObj = await table.save({'foo': 'actual rel'});
        await relationTable.addRelation(parentObj!['objectId'], 'fooRel',
            childrenObjectIds: [childObj!['objectId']]);

        // 2
        var resTemp = await relationTable.findFirst();
        var res = await relationTable.findFirst(relations: ['fooRel']);
        await relationTable.remove(parentObj);
        await table.remove(childObj);

        // 3
        expect(resTemp!.containsKey('fooRel'), false);
        expect(res!.containsKey('fooRel'), true);
        expect(res['fooRel'][0], childObj);
      });

      test('FindLast method(empty res)', () async {
        // 1
        dynamic expectedValue;
        // 2
        var res = await table.findLast();
        // 3
        expect(res, expectedValue);
      });

      test('FindLast method', () async {
        // 1
        var expectedObj = await table.save({'foo': 'first obj'});

        // 2
        var res = await table.findLast();

        // 3
        expect(res, expectedObj);
        await table.remove(expectedObj!);
      });

      test('FindLast with several objects', () async {
        // 1
        await table.save({'foo': 'first'});
        var expectedObj = await table.save({'foo': 'second'});

        // 2
        var res = await table.findLast();

        // 3
        expect(res, expectedObj);
        await table.bulkRemove('updated is null');
      });

      test('FindLast with DataQueryBuilder', () async {
        // 1
        var parentObj = await relationTable.save({});
        var childObj = await table.save({'foo': 'actual rel'});
        await relationTable.addRelation(parentObj!['objectId'], 'fooRel',
            childrenObjectIds: [childObj!['objectId']]);

        // 2
        var resTemp = await relationTable.findLast();
        var res = await relationTable.findLast(relations: ['fooRel']);
        await relationTable.remove(parentObj);
        await table.remove(childObj);

        // 3
        expect(resTemp!.containsKey('fooRel'), false);
        expect(res!.containsKey('fooRel'), true);
        expect(res['fooRel'][0], childObj);
      });

      test('FindById with error', () async {
        try {
          // 2
          await table.findById('1');

          // 3
          expect(0, 1);
        } catch (ex) {
          // 3
          expect(1, 1);
        }
      });

      test('FindById method', () async {
        // 1
        var expectedObj = await table.save({'foo': 'first'});
        String searchingId = expectedObj!['objectId'];

        // 2
        var res = await table.findById(searchingId);
        await table.remove(expectedObj);

        // 3
        bool isNull = res == null;
        expect(isNull, false);

        bool isEmpty = res!.isEmpty;
        expect(isEmpty, false);
        expect(res, expectedObj);
      });

      test('FindById with several objects', () async {
        // 1
        var expectedObj1 = await table.save({'foo': 'first'});
        var expectedObj2 = await table.save({'foo': 'second'});
        String searchingId = expectedObj1!['objectId'];
        String searchingId2 = expectedObj2!['objectId'];

        // 2
        var res1 = await table.findById(searchingId);
        var res2 = await table.findById(searchingId2);

        // 3
        expect(res1, expectedObj1);
        expect(res2, expectedObj2);
        await table.bulkRemove('updated is null');
      });

      test('FindById with DataQueryBuilder', () async {
        // 1
        var parentObj = await relationTable.save({});
        var childObj = await table.save({'foo': 'actual rel'});
        await relationTable.addRelation(parentObj!['objectId'], 'fooRel',
            childrenObjectIds: [childObj!['objectId']]);
        String searchingId = parentObj['objectId'];

        // 2
        var resTemp = await relationTable.findById(searchingId);
        var res =
            await relationTable.findById(searchingId, relations: ['fooRel']);
        await relationTable.remove(parentObj);
        await table.remove(childObj);

        // 3
        expect(resTemp!.containsKey('fooRel'), false);
        expect(res!.containsKey('fooRel'), true);
        expect(res['fooRel'][0], childObj);
      });

      test('Remove non-existent object', () async {
        try {
          // 2
          await table.remove({'objectId': 'non-existent'});

          // 3
          expect(1, 0);
        } catch (ex) {
          // 3
          expect(1, 1);
        }
      });

      test('Remove method in general implementation', () async {
        // 1
        var savedObj = await table.save({'foo': 'obj to remove'});

        // 2
        bool savedIsNullOrEmpty = savedObj == null || savedObj.isEmpty;
        expect(savedIsNullOrEmpty, false,
            reason:
                'Error when trying to save object to remove that.\nObject was null or empty');

        var res = await table.remove(savedObj!);

        // 3
        bool isNull = res == null;
        expect(isNull, false);

        try {
          await table.findById(savedObj['id']);
          expect(1, 0,
              reason: 'Object should have been deleted, but it was not');
        } catch (ex) {
          expect(1, 1);
        }
      });

      test('Get object count with empty', () async {
        // 1
        int expectedCount = 0;

        // 2
        int? res = await table.getObjectCount();

        // 3
        expect(res, expectedCount,
            reason: 'Object count should have been equal to 0, but was not');
      });

      test('GetObjectCount with 1-20 Count', () async {
        // 1
        int expectedCount = Random().nextInt(20) + 1;
        List<Map> listOfEmptyMaps = [];
        for (int i = 0; i < expectedCount; i++) {
          listOfEmptyMaps.add({});
        }

        var iteration = await table.bulkCreate(listOfEmptyMaps);
        bool isNull = iteration == null;

        expect(isNull, false);
        expect(iteration!.length, expectedCount,
            reason:
                'Should have been saved $expectedCount objects, but was not');

        // 2
        int? res = await table.getObjectCount();

        // 3
        expect(res, expectedCount,
            reason:
                'Object count should have been equal to $expectedCount, but was not');
      });

      test('GetObjectCount with whereClause', () async {
        // 1
        int expectedCount = 2;
        var mapsToUpdate =
            await table.find(queryBuilder: DataQueryBuilder()..pageSize = 2);
        bool isNull = mapsToUpdate == null;
        expect(isNull, false,
            reason:
                'When trying to find $expectedCount object to update those, error was thrown');

        for (var element in mapsToUpdate!) {
          element!['foo'] = 'updated value';
          var res = await table.save(element);
          if (kDebugMode) {
            print(res);
          }
        }

        // 2
        int? res =
            await table.getObjectCount(whereClause: 'foo=\'updated value\'');
        await removeAllObjectsInTable('FlutterTestTable');

        // 3
        expect(res, expectedCount,
            reason:
                'Object count should have been equal to $expectedCount, but was not');
      });

      test('BulkCreate default', () async {
        // 1
        List<Map> listMaps = [{}, {}];
        int expectedCountOfObjects = 2;

        // 2
        var listOfIds = await table.bulkCreate(listMaps);
        await removeAllObjectsInTable('FlutterTestTable');
        // 3
        bool isNull = listOfIds == null;
        expect(isNull, false);
        expect(listOfIds!.length, expectedCountOfObjects);
      });

      test('Bulk Create empty list', () async {
        // 1
        int expectedCountOfObjects = 0;

        // 2
        var listOfIds = await table.bulkCreate([]);

        // 3
        bool isNull = listOfIds == null;
        expect(isNull, false);
        expect(listOfIds!.length, expectedCountOfObjects);
      });

      test('Bulk Update default', () async {
        // 1
        List<Map> listMaps = [
          {},
          {},
          {'foo': 'not upd'}
        ];
        await table.bulkCreate(listMaps);

        int expectedCountOfUpdatedObjects = 2;
        // 2
        var result =
            await table.bulkUpdate('foo is null', {'foo': 'already not null'});
        await removeAllObjectsInTable('FlutterTestTable');
        // 3
        bool isNull = result == null;

        expect(isNull, false, reason: 'Count of updated objects was null');
        expect(result, expectedCountOfUpdatedObjects,
            reason: 'The number of updated objects is not as expected');
      });

      test('Bulk Upsert', () async {
        final entities = [
          {'foo': 'value1'},
          {'foo': 'value2'}
        ];
        final result = await table.bulkUpsert(entities);

        removeAllObjectsInTable('FlutterTestTable');
        expect(result, isNotNull);
        expect(result, isA<List<String>>());
        expect(result!.length, equals(2));
      });

      test('Bulk Remove', () async {
        // 1
        var listOfObjectsToCreate = [
          {},
          {},
          {'foo': 'need remove'}
        ];
        await table.bulkCreate(listOfObjectsToCreate);
        int expectedRemovedCount = 2;
        // 2
        var removedObjectsCount =
            await table.bulkRemove('foo!=\'need remove\'');

        expect(removedObjectsCount, expectedRemovedCount,
            reason: 'Removed objects count not equal expected');
        var lastObjectThatNeedToRemove = await table.find();
        expect(lastObjectThatNeedToRemove!.length, 1);

        var res = await table.bulkRemove(
            'objectId=\'${lastObjectThatNeedToRemove[0]!['objectId']}\'');
        expect(res, 1);
      });
    });

    test('DeepSave', () async {
      // 1
      Map map = {
        'fooRel': [
          {'foo': 'hello'}
        ]
      };

      var res = await relationTable.deepSave(map);
      await removeAllObjectsInTable('FlutterRelationTable');
      await removeAllObjectsInTable('FlutterTestTable');

      expect(res == null, false);
      expect(res!.containsKey('fooRel'), true);

      var child = res['fooRel'][0];
      expect(child == null, false);
      expect(child, isA<Map>());
      expect(child, containsPair('foo', 'hello'));
    });

    test('addRelations with children object ids', () async {
      var tempSavedParentObject = await relationTable.save({});
      final parentObjectId = tempSavedParentObject!['objectId'];
      const relationColumnName = 'fooRel';

      var tempSavedChildrenObjectIds = await table.bulkCreate([{}, {}]);
      final childrenObjectIds = [
        tempSavedChildrenObjectIds![1],
        tempSavedChildrenObjectIds[1]
      ];

      final result = await relationTable.addRelation(
          parentObjectId, relationColumnName,
          childrenObjectIds: childrenObjectIds);
      await removeAllObjectsInTable('FlutterTestTable');
      targetObjectId = parentObjectId;

      expect(result, isNotNull);
      expect(result, isA<int>());
      expect(result, 2);
    });

    test('addRelations with whereClause', () async {
      final parentObjectId = targetObjectId!;
      const relationColumnName = 'fooRel';
      const whereClause = 'foo = \'ThisNeedAdd\'';
      await table.bulkCreate([
        {},
        {'foo': 'ThisNeedAdd'}
      ]);

      final result = await relationTable.addRelation(
          parentObjectId, relationColumnName,
          whereClause: whereClause);
      await removeAllObjectsInTable('FlutterTestTable');

      expect(result, isNotNull);
      expect(result, isA<int>());
      expect(result, 1);
    });

    test('addRelation with error', () async {
      final parentObjectId = targetObjectId!;
      const relationColumnName = 'fooRel';

      try {
        await relationTable.addRelation(parentObjectId, relationColumnName);

        expect(1, 0);
      } on ArgumentError {
        expect(1, 1);
      } catch (ex) {
        expect(1, 0);
      }
    });
  }
}
