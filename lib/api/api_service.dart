import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late String baseUrl;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Future<void> setBaseUrl(String url) async {
    baseUrl = url;
  }

  Future<Map<String, dynamic>> _postRequest(String url) async {
    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to post data');
    }
  }

  Future<String> processPhone(String phone) async {
    final url = '$baseUrl/auth/auth_phone/?phone=$phone';
    final responseBody = await _postRequest(url);

    // Проверка наличия ключей и возврат соответствующего значения
    if (responseBody.containsKey('message')) {
      return responseBody['message'] as String;
    } else if (responseBody.containsKey('detail')) {
      return responseBody['detail'] as String;
    } else {
      return 'Unknown response format';
    }
  }

  Future<String> proccesCode(String phone, String code) async {
    final url = '$baseUrl/auth/code/?phone=$phone&&code=$code';
    final responseBody = await _postRequest(url);

    if (responseBody.containsKey("message")) {
      return responseBody[
          "message"]; // Код недействителен или времы вышло, обновленный код отправлен в телеграм
    } else if (responseBody.containsKey("role")) {
      return "Успешно";
    } else {
      return "null";
    }
  }
}
