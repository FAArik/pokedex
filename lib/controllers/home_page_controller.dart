import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/page_data.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/services/http_service.dart';

class HomePageController extends StateNotifier<HomePageData> {
  final GetIt _getIt = GetIt.instance;

  late HttpService _httpService;

  HomePageController(
    super._state,
  ) {
    _httpService = _getIt.get<HttpService>();
    _setup();
  }

  Future<void> _setup() async {
    loadData();
  }

  Future<void> loadData() async {
    if (state.data == null) {
      Response? res = await _httpService.get("/pokemon?limit=20&offset=0");
      // Response? res = await _httpService
      // .get("https://jsonplaceholder.typicode.com/todos/1");

      if (res != null && res.data != null) {
        PokemonListData data = PokemonListData.fromJson(res.data);
        state = state.copyWith(data: data);
      }
    } else {
      if (state.data != null && state.data?.next != null) {
        Response? res = await _httpService.get(state.data!.next!);
        if (res != null && res.data != null) {
          PokemonListData data = PokemonListData.fromJson(res.data);
          state = state.copyWith(
              data: data.copyWith(
                  results: [...?state.data!.results, ...?data.results]));
        }
      }
    }
  }
}