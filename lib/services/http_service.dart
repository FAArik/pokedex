import 'package:dio/dio.dart';

class HttpService {
  HttpService();

  final _dio = Dio(BaseOptions(
    baseUrl: "http://pokeapi.co/api/v2",
    connectTimeout: const Duration(seconds: 5000),
    receiveTimeout: const Duration(seconds: 5000),
  ));

  Future<Response?> get(String path) async {
    try {
      Response res = await _dio.get(path);
      return res;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
