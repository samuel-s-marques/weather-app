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
        db.execute(
          'CREATE TABLE favoritePlaces('
              'id INTEGER PRIMARY KEY,'
              'placeId TEXT,'
              'placeName TEXT)',
        );
      }, version: 1);
    });
  }

  Future<int> saveRecentSearch(Place place) async {
    int count = await getCount("recentSearches");

    return createDatabase().then((db) async {
      final Map<String, String> searchMap = {};

      searchMap['placeId'] = place.placeId;
      searchMap['placeDescription'] = place.placeDescription;

      if (count >= 5) {
        await deleteAll('recentSearches');
        return await db.insert('recentSearches', searchMap);
      }

      return await db.insert('recentSearches', searchMap);
    });
  }

  Future<int> saveFavoritePlace(Place place) async {
    int count = await getCount("favoritePlaces");

    return createDatabase().then((db) async {
      final Map<String, String> searchMap = {};

      searchMap['placeId'] = place.placeId;
      searchMap['placeName'] = place.placeDescription;

      if (count >= 5) {
        await deleteAll('favoritePlaces');
        return await db.insert('favoritePlaces', searchMap);
      }

      return await db.insert('favoritePlaces', searchMap);
    });
  }

  Future<List<Place>> findAllRecentSearches() {
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

  Future<List<Place>> findAllFavoritePlaces() {
    return createDatabase().then((db) {
      return db.query('favoritePlaces').then((maps) {
        final List<Place> places = [];

        for (Map<String, dynamic> map in maps) {
          final Place place = Place(
            placeId: map['placeId'],
            placeDescription: map['placeName'],
          );

          places.add(place);
        }

        return places;
      });
    });
  }

  Future<int> getCount(String table) async {
    return createDatabase().then((db) async {
      var x = await db.rawQuery("SELECT COUNT (*) FROM $table");

      int count = Sqflite.firstIntValue(x) ?? 0;
      return count;
    });
  }

  Future<int> deleteAll(String table) async {
    return createDatabase().then((db) async {
      return await db.rawDelete("DELETE FROM $table");
    });
  }

  Future<int> deleteWhere(String placeId, String table) async {
    return createDatabase().then((db) async {
      return await db.delete(table, where: 'placeId = ?', whereArgs: [placeId]);
    });
  }
}