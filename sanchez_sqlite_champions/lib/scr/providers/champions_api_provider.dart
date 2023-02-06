import 'package:sanchez_sqlite_champions/scr/models/champions_model.dart';
import 'package:sanchez_sqlite_champions/scr/providers/db_providers.dart';
import 'package:dio/dio.dart';

class ChampionsApiProvider {
  Future<List<Champions?>> getAllChampions() async {
    var url = "https://63974d5e77359127a0336fbf.mockapi.io/champions/champions";
    Response response = await Dio().get(url);

    return (response.data as List).map((champions) {
      // ignore: avoid_print
      print('Inserting $champions');
      DBProvider.db.createChampions(Champions.fromJson(champions));
    }).toList();
  }
}
