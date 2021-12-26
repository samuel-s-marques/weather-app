import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weatherapp/models/place.dart';

class WeatherDatabase {
  Future<Database> createDatabase() {
    return getDatabasesPath().then((dbPath) {
      final String path = join(dbPath, 'weather.db');
      return openDatabase(path, onCreate: (db, version) {
        db.execute(
          'CREATE TABLE recentSearches('
              'id INTEGER PRIMARY KEY,'
              'placeId TEXT,'
              'placeDescription TEXT)',
        );
      }, version: 1);
    });
  }

  Future<int> save(Place place) async {
    int count = await getCount();

    return createDatabase().then((db) async {
      final Map<String, String> searchMap = {};

      searchMap['placeId'] = place.placeId;
      searchMap['placeDescription'] = place.placeDescription;

      if (count >= 5) {
        await deleteAll();
        return await db.insert('recentSearches', searchMap);
      }

      return await db.insert('recentSearches', searchMap);
    });
  }

  Future<List<Place>> findAll() {
    return createDatabase().then((db) {
      return db.query('recentSearches').then((maps) {
        final List<Place> places = [];

        for (Map<String, dynamic> map in maps) {
          final Place place = Place(
            placeId: map['placeId'],
            placeDescription: map['placeDescription'],
          );

          places.add(place);
        }

        return places;
      });
    });
  }

  Future<int> getCount() async {
    return createDatabase().then((db) async {
      var x = await db.rawQuery("SELECT COUNT (*) FROM recentSearches");

      int count = Sqflite.firstIntValue(x) ?? 0;
      return count;
    });
  }

  Future<int> deleteAll() async {
    return createDatabase().then((db) async {
      return await db.rawDelete("DELETE FROM recentSearches");
    });
  }
}