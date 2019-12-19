import 'package:test/test.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

@reflector
class ChildTest {
  String objectId;
  String ownerId;
  DateTime created;
  DateTime updated;
  String first;
  String second;
  DateTime third;
  int fourth;
  double fifth;
  bool sixth;
}

@reflector
class ClassDrivenTest {
  String objectId;
  String ownerId;
  DateTime created;
  DateTime updated;
  String first;
  String second;
  DateTime third;
  int fourth;
  double fifth;
  bool sixth;

  List<ChildTest> _seventh;
  set seventh(List value) => _seventh = value.cast<ChildTest>();
  get seventh => _seventh;
}

class TestDataClassDriven {
  static void start() {
    final dataStore = Backendless.data.withClass<ClassDrivenTest>();
    final childStore = Backendless.data.withClass<ChildTest>();

    final classDrivenProperties = [
      "created",
      "updated",
      "first",
      "second",
      "third",
      "fourth",
      "fifth",
      "sixth",
      "seventh"
    ];

    final firstFieldValue = "first_test";
    final firstFieldValueUpdated = "first_test_updated";
    final secondFieldValue = "second_test";
    final thirdFieldValue = DateTime.now();
    final fourthFieldValue = 42;
    final fourthFieldValueUpdated = 4242;
    final fifthFieldValue = 42.42;
    final sixthFieldValue = false;

    String firstEntityId;
    String secondEntityId;

    String firstChildId;
    String secondChildId;

    final defaultPageSize = 10;
    final numberOfObjectsInBulk = 13;
    int createdOneByOne = 0;
    int childrenOneByOne = 0;
    int updatedOneByOne = 0;

    group("", () {
      test("Describe Table", () async {
        final properties = await Backendless.data.describe("ClassDrivenTest");

        final names = properties.map((prop) => prop.name).toList();

        expect(properties, isNotNull);
        expect(properties.length, 11);

        classDrivenProperties.forEach((name) => expect(names, contains(name)));

        properties.forEach((prop) {
          switch (prop.name) {
            case "first":
              expect(prop.type, DataTypeEnum.STRING);
              break;
            case "second":
              expect(prop.type, DataTypeEnum.TEXT);
              break;
            case "third":
              expect(prop.type, DataTypeEnum.DATETIME);
              break;
            case "fourth":
              expect(prop.type, DataTypeEnum.INT);
              break;
            case "fifth":
              expect(prop.type, DataTypeEnum.DOUBLE);
              break;
            case "sixth":
              expect(prop.type, DataTypeEnum.BOOLEAN);
              break;
            case "seventh":
              expect(prop.type, DataTypeEnum.RELATION_LIST);
              break;
            case "objectId":
              expect(prop.type, DataTypeEnum.STRING_ID);
              break;
            case "ownerId":
              expect(prop.type, DataTypeEnum.STRING);
              break;
            case "created":
              expect(prop.type, DataTypeEnum.DATETIME);
              break;
            case "updated":
              expect(prop.type, DataTypeEnum.DATETIME);
              break;
          }
        });
      });

      test("Create First", () async {
        final entityToSave = ClassDrivenTest()
          ..first = firstFieldValue
          ..second = secondFieldValue
          ..third = thirdFieldValue
          ..fourth = fourthFieldValue
          ..fifth = fifthFieldValue
          ..sixth = sixthFieldValue;

        final childToSave = ChildTest()
          ..first = firstFieldValue
          ..second = secondFieldValue
          ..third = thirdFieldValue
          ..fourth = fourthFieldValue
          ..fifth = fifthFieldValue
          ..sixth = sixthFieldValue;

        final savedEntity = await dataStore.save(entityToSave);
        firstEntityId = savedEntity.objectId;

        final savedChild = await childStore.save(childToSave);
        firstChildId = savedChild.objectId;

        expect(savedEntity, isNotNull);
        expect(savedEntity.objectId, isNotNull);
        expect(savedEntity.created, isNotNull);
        expect(savedEntity.first, firstFieldValue);
        expect(savedEntity.second, secondFieldValue);
        expect(savedEntity.fourth, fourthFieldValue);
        expect(savedEntity.fifth, fifthFieldValue);
        expect(savedEntity.sixth, sixthFieldValue);
        createdOneByOne++;

        expect(savedChild, isNotNull);
        expect(savedChild.objectId, isNotNull);
        expect(savedChild.created, isNotNull);
        expect(savedChild.first, firstFieldValue);
        expect(savedChild.second, secondFieldValue);
        expect(savedChild.fourth, fourthFieldValue);
        expect(savedChild.fifth, fifthFieldValue);
        expect(savedChild.sixth, sixthFieldValue);
        childrenOneByOne++;
      });

      test("Create Second", () async {
        final entityToSave = ClassDrivenTest()
          ..first = firstFieldValue
          ..second = secondFieldValue
          ..third = thirdFieldValue
          ..fourth = fourthFieldValue
          ..fifth = fifthFieldValue
          ..sixth = sixthFieldValue;

        final childToSave = ChildTest()
          ..first = firstFieldValue
          ..second = secondFieldValue
          ..third = thirdFieldValue
          ..fourth = fourthFieldValue
          ..fifth = fifthFieldValue
          ..sixth = sixthFieldValue;

        final savedEntity = await dataStore.save(entityToSave);
        secondEntityId = savedEntity.objectId;

        final savedChild = await childStore.save(childToSave);
        secondChildId = savedChild.objectId;

        expect(savedEntity, isNotNull);
        expect(savedEntity.objectId, isNotNull);
        expect(savedEntity.created, isNotNull);
        expect(savedEntity.first, firstFieldValue);
        expect(savedEntity.second, secondFieldValue);
        expect(savedEntity.fourth, fourthFieldValue);
        expect(savedEntity.fifth, fifthFieldValue);
        expect(savedEntity.sixth, sixthFieldValue);
        createdOneByOne++;

        expect(savedChild, isNotNull);
        expect(savedChild.objectId, isNotNull);
        expect(savedChild.created, isNotNull);
        expect(savedChild.first, firstFieldValue);
        expect(savedChild.second, secondFieldValue);
        expect(savedChild.fourth, fourthFieldValue);
        expect(savedChild.fifth, fifthFieldValue);
        expect(savedChild.sixth, sixthFieldValue);
        childrenOneByOne++;
      });

      test("Find First", () async {
        final first = await dataStore.findFirst();

        expect(first.objectId, firstEntityId);
      });

      test("Find Last", () async {
        final last = await dataStore.findLast();

        expect(last.objectId, secondEntityId);
      });

      test("Create Bulk", () async {
        final entityToSave = ClassDrivenTest()
          ..first = firstFieldValue
          ..second = secondFieldValue
          ..third = thirdFieldValue
          ..fourth = fourthFieldValue
          ..fifth = fifthFieldValue
          ..sixth = sixthFieldValue;

        final objects = List.filled(numberOfObjectsInBulk, entityToSave);

        final ids = await dataStore.create(objects);

        expect(ids, isNotNull);
        expect(ids.length, numberOfObjectsInBulk);
      });

      test("Find By Id", () async {
        final found = await dataStore.findById(firstEntityId);

        expect(found, isNotNull);
        expect(found.objectId, firstEntityId);
      });

      test("Find Without WhereClause", () async {
        final found = await dataStore.find();

        expect(found, isNotNull);
        expect(found.length, defaultPageSize);

        found.forEach((obj) => expect(obj.objectId, isNotNull));
      });

      test("Find With WhereClause", () async {
        final exactQueryBuilder = DataQueryBuilder()
          ..whereClause = "objectId = '$secondEntityId'";
        final commonQueryBuilder = DataQueryBuilder()
          ..whereClause = "first = '$firstFieldValue'"
          ..pageSize = 50;

        final exactFound = await dataStore.find(exactQueryBuilder);
        final commonFound = await dataStore.find(commonQueryBuilder);

        expect(exactFound, isNotNull);
        expect(exactFound.length, 1);
        expect(exactFound.first.objectId, secondEntityId);

        expect(commonFound, isNotNull);
        expect(commonFound.length, numberOfObjectsInBulk + createdOneByOne);

        commonFound.forEach((obj) => expect(obj.first, firstFieldValue));
      });

      test("Get Object Count After Creating", () async {
        final objectCount = await dataStore.getObjectCount();
        final childrenCount = await childStore.getObjectCount();

        expect(objectCount, numberOfObjectsInBulk + createdOneByOne);
        expect(childrenCount, childrenOneByOne);
      });

      test("Save", () async {
        final entityToSave = ClassDrivenTest()
          ..objectId = firstEntityId
          ..first = firstFieldValueUpdated
          ..fourth = fourthFieldValueUpdated;

        final updatedObject = await dataStore.save(entityToSave);

        expect(updatedObject, isNotNull);
        expect(updatedObject.objectId, firstEntityId);
        expect(updatedObject.updated, isNotNull);
        expect(updatedObject.first, firstFieldValueUpdated);
        expect(updatedObject.fourth, fourthFieldValueUpdated);

        updatedOneByOne++;
      });

      test("Update", () async {
        final whereClause = "first = '$firstFieldValue'";
        final changes = {"first": firstFieldValueUpdated};

        final queryBuilder = DataQueryBuilder()
          ..whereClause = "objectId != '$firstEntityId'"
          ..pageSize = 40;

        final updatedAmount = await dataStore.update(whereClause, changes);
        final updatedEntities = await dataStore.find(queryBuilder);
        final amountToBeUpdated =
            numberOfObjectsInBulk + createdOneByOne - updatedOneByOne;

        expect(updatedAmount, amountToBeUpdated);
        expect(updatedEntities.length, amountToBeUpdated);

        updatedEntities.forEach((entity) {
          expect(entity.first, firstFieldValueUpdated);
          expect(entity.updated, isNotNull);
        });
      });

      test("Set relation", () async {
        final parent = ClassDrivenTest()..objectId = firstEntityId;
        final child = {"objectId": firstChildId};
        final relations =
            await dataStore.setRelation(parent, "seventh", children: [child]);

        expect(relations, isNotNull);
        expect(relations, 1);
      });

      test("Load Relations", () async {
        final queryBuilder = LoadRelationsQueryBuilder.of<ChildTest>("seventh");
        final relations =
            await dataStore.loadRelations(firstEntityId, queryBuilder);

        expect(relations, isNotNull);
        expect(relations.length, 1);

        final childEntity = relations.first;
        expect(childEntity.objectId, firstChildId);
        expect(childEntity.first, firstFieldValue);
        expect(childEntity.second, secondFieldValue);
        expect(childEntity.fourth, fourthFieldValue);
        expect(childEntity.fifth, fifthFieldValue);
        expect(childEntity.sixth, sixthFieldValue);
      });

      test("Add relation", () async {
        final parent = ClassDrivenTest()..objectId = firstEntityId;
        final firstChild = {"objectId": firstChildId};
        final secondChild = {"objectId": secondChildId};

        final addedRelations = await dataStore.addRelation(parent, "seventh",
            children: [firstChild, secondChild]);

        expect(addedRelations, isNotNull);
        expect(addedRelations, 1);
      });

      test("Load Relations After Adding", () async {
        final queryBuilder = LoadRelationsQueryBuilder.of<ChildTest>("seventh");
        final relations =
            await dataStore.loadRelations(firstEntityId, queryBuilder);

        expect(relations, isNotNull);
        expect(relations.length, 2);

        final childrenIdsList = [firstChildId, secondChildId];
        expect(childrenIdsList, contains(relations[0].objectId));
        expect(childrenIdsList, contains(relations[1].objectId));

        relations.forEach((child) {
          expect(child.first, firstFieldValue);
          expect(child.second, secondFieldValue);
          expect(child.fourth, fourthFieldValue);
          expect(child.fifth, fifthFieldValue);
          expect(child.sixth, sixthFieldValue);
          expect(child.created, isNotNull);
        });
      });

      test("Find With Relations By Name", () async {
        final relations = ["seventh"];
        final queryBuilder = DataQueryBuilder()
          ..related = relations
          ..whereClause = "objectId = '$firstEntityId'";

        final foundEntities = await dataStore.find(queryBuilder);
        expect(foundEntities.length, 1);

        final firstEntity = foundEntities.first;

        expect(firstEntity.objectId, firstEntityId);
        expect(firstEntity.seventh, isNotNull);
        expect(firstEntity.seventh.length, 2);
      });

      test("Find With Relations By Depth", () async {
        final queryBuilder = DataQueryBuilder()
          ..relationsDepth = 1
          ..whereClause = "objectId = '$firstEntityId'";

        final foundEntities = await dataStore.find(queryBuilder);
        expect(foundEntities.length, 1);

        final firstEntity = foundEntities.first;

        expect(firstEntity.objectId, firstEntityId);
        expect(firstEntity.seventh, isNotNull);
        expect(firstEntity.seventh.length, 2);
      });

      test("Remove One", () async {
        final firstToRemove = ClassDrivenTest()..objectId = firstEntityId;
        final firstRemoved = await dataStore.remove(entity: firstToRemove);
        final secondToRemove = ClassDrivenTest()..objectId = secondEntityId;
        final secondRemoved = await dataStore.remove(entity: secondToRemove);

        expect(firstRemoved, isNotNull);
        expect(secondRemoved, isNotNull);
      });

      test("Remove Bulk", () async {
        final whereClause = "objectId != null";

        final deletedAmount = await dataStore.remove(whereClause: whereClause);
        final deletedChildrenAmount =
            await childStore.remove(whereClause: whereClause);

        expect(deletedAmount, isNotNull);
        expect(deletedAmount, numberOfObjectsInBulk);

        expect(deletedChildrenAmount, isNotNull);
        expect(deletedChildrenAmount, childrenOneByOne);
      });

      test("Get Object Count After Removing", () async {
        final objectCount = await dataStore.getObjectCount();
        final childrenCount = await childStore.getObjectCount();

        expect(objectCount, 0);
        expect(childrenCount, 0);
      });
    });
  }
}
