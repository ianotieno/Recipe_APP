import 'package:recepies/models/recipe.dart';
import 'package:recepies/services/http_service.dart';

class DataService {
  static final DataService _singleton = DataService._internal();
  final HTTPService _httpService = HTTPService();

  factory DataService() {
    return _singleton;
  }
  DataService._internal();

  Future<List<Recipe>?> getRecipes() async {
    String path = "recipes/";
   var response = await _httpService.get(path);
    if (response != null && response.statusCode == 200) {
       List data= response.data['recipes'];
       List<Recipe> recipes = data.map((e) => Recipe.fromJson(e)).toList();
        return recipes;
      }
      return null;
  }
}
