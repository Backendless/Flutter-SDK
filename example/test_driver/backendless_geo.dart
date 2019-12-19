import 'package:test/test.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

class TestGeo {
  static void start() {
    group("Geo Tests", () {
      final geo = Backendless.geo;
      final defaultCategoryName = "Default";
      final testCategoryName = "Test_Category";
      final metaKey = "test_key";
      final metaValue = 42;
      final testLat = 45.4242;
      final testLong = 0.1111;

      List<GeoPoint> defaultPoints;
      List<GeoPoint> testPoints;

      group("Before adding", () {
        test("Get Categories", () async {
          final categories = await geo.getCategories();
          final names = categories.map((category) => category.name).toList();

          expect(names.length, 1);
          expect(names, contains(defaultCategoryName));
        });

        test("Get Geopoint Count", () async {
          final query = BackendlessGeoQuery();
          final pointsCount = await geo.getGeopointCount(query);

          expect(pointsCount, 0);
        });

        test("Get Points", () async {
          final query = BackendlessGeoQuery();
          final points = await geo.getPoints(query: query);

          expect(points.length, 0);
        });
      });

      group("Adding", () {
        test("Add Category", () async {
          final addedCategory = await geo.addCategory(testCategoryName);

          expect(addedCategory, isNotNull);
          expect(addedCategory.size, 0);
        });

        test("Save Point", () async {
          final pointToDefaultCategory = GeoPoint()
            ..latitude = testLat
            ..longitude = testLong
            ..addCategory(defaultCategoryName)
            ..addMetadata(metaKey, metaValue);

          final pointToTestCategory = GeoPoint()
            ..latitude = testLat
            ..longitude = testLong
            ..addCategory(testCategoryName)
            ..addMetadata(metaKey, metaValue);

          final savedToDefaultPoint =
              await geo.savePoint(pointToDefaultCategory);
          final savedToTestPoint = await geo.savePoint(pointToTestCategory);

          expect(savedToDefaultPoint, isNotNull);
          expect(savedToDefaultPoint.objectId, isNotNull);
          expect(savedToDefaultPoint.latitude, testLat);
          expect(savedToDefaultPoint.longitude, testLong);
          expect(savedToDefaultPoint.categories, contains(defaultCategoryName));

          expect(savedToTestPoint, isNotNull);
          expect(savedToTestPoint.objectId, isNotNull);
          expect(savedToTestPoint.latitude, testLat);
          expect(savedToTestPoint.longitude, testLong);
          expect(savedToTestPoint.categories, contains(testCategoryName));
        });

        test("Save Point From Sources", () async {
          final savedToDefaultPoint = await geo.savePointLatLon(
              testLat, testLong, {metaKey: metaValue}, [defaultCategoryName]);

          final savedToTestPoint = await geo.savePointLatLon(
              testLat, testLong, {metaKey: metaValue}, [testCategoryName]);

          expect(savedToDefaultPoint, isNotNull);
          expect(savedToDefaultPoint.objectId, isNotNull);
          expect(savedToDefaultPoint.latitude, testLat);
          expect(savedToDefaultPoint.longitude, testLong);
          expect(savedToDefaultPoint.categories, contains(defaultCategoryName));

          expect(savedToTestPoint, isNotNull);
          expect(savedToTestPoint.objectId, isNotNull);
          expect(savedToTestPoint.latitude, testLat);
          expect(savedToTestPoint.longitude, testLong);
          expect(savedToTestPoint.categories, contains(testCategoryName));
        });
      });

      group("After Adding", () {
        test("Get Categories", () async {
          final categories = await geo.getCategories();
          final names = categories.map((category) => category.name).toList();

          expect(names.length, 2);
          expect(names, contains(defaultCategoryName));
          expect(names, contains(testCategoryName));
        });

        test("Get Points", () async {
          final defaultQuery = BackendlessGeoQuery();
          final dPoints = await geo.getPoints(query: defaultQuery);
          defaultPoints = dPoints;
          final testQuery = BackendlessGeoQuery()
            ..addCategory(testCategoryName);
          final tPoints = await geo.getPoints(query: testQuery);
          testPoints = tPoints;

          expect(dPoints.length, 2);
          expect(tPoints.length, 2);
        });

        test("Load Metadata", () async {
          List<GeoPoint> pointsWithMeta = [];

          for (GeoPoint point in defaultPoints) {
            final loadedPoint = await geo.loadMetadata(point);
            pointsWithMeta.add(loadedPoint);
          }
          expect(pointsWithMeta.length, 2);
          pointsWithMeta.forEach((p) {
            expect(p.metadata, isNotEmpty);
          });
        });
      });

      group("Deleting", () {
        test("Delete Point", () async {
          defaultPoints.forEach((point) async {
            await geo.removePoint(point);
          });
          testPoints.forEach((point) async {
            await geo.removePoint(point);
          });

          final defaultQuery = BackendlessGeoQuery();
          final dPoints = await geo.getPoints(query: defaultQuery);
          final testQuery = BackendlessGeoQuery()
            ..addCategory(testCategoryName);
          final tPoints = await geo.getPoints(query: testQuery);

          expect(dPoints, isEmpty);
          expect(tPoints, isEmpty);
        });

        test("Delete Category", () async {
          final isDeleted = await geo.deleteCategory(testCategoryName);

          expect(isDeleted, true);
        });
      });

      group("After Deleting", () {
        test("Get Categories", () async {
          final categories = await geo.getCategories();
          final names = categories.map((category) => category.name).toList();

          expect(names.length, 1);
          expect(names, contains(defaultCategoryName));
        });

        test("Get Geopoint Count", () async {
          final query = BackendlessGeoQuery();
          final pointsCount = await geo.getGeopointCount(query);

          expect(pointsCount, 0);
        });

        test("Get Points", () async {
          final query = BackendlessGeoQuery();
          final points = await geo.getPoints(query: query);

          expect(points.length, 0);
        });
      });
    });
  }
}
