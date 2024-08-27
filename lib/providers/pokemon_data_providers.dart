import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/services/database_service.dart';
import 'package:pokedex/services/http_service.dart';

final pokemonDataProvider =
    FutureProvider.family<Pokemon?, String>((ref, url) async {
  HttpService _httpService = GetIt.instance.get<HttpService>();

  Response? response = await _httpService.get(url);

  if (response != null && response.data != null) {
    return Pokemon.fromJson(response.data);
  }
  return null;
});

final favoritePokemonProvider =
    StateNotifierProvider<FavoritePokemonProvider, List<String>>(
  (ref) => FavoritePokemonProvider([]),
);

class FavoritePokemonProvider extends StateNotifier<List<String>> {
  String FAVORITE_POKEMON_LIST_KEY = 'FAVORITE_POKEMON_LIST_KEY';

  final databaseService = GetIt.instance.get<DatabaseService>();

  FavoritePokemonProvider(super._state) {
    _setup();
  }

  Future<void> _setup() async {
    // Load favorite pokemon from shared preferences
    List<String>? favoritePokemonList =
        await databaseService.getList(FAVORITE_POKEMON_LIST_KEY);

    favoritePokemonList != null ? state = favoritePokemonList : state = [];
  }

  void addFavoritePokemon(String pokemonUrl) {
    state = [...state, pokemonUrl];
    databaseService.saveList(FAVORITE_POKEMON_LIST_KEY, state);
  }

  void removeFavoritePokemon(String pokemonUrl) {
    state = state.where((x) => x != pokemonUrl).toList();
    databaseService.saveList(FAVORITE_POKEMON_LIST_KEY, state);
  }
}
