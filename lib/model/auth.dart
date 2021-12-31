import 'package:blue/global/constant.dart';
import 'package:http/http.dart' as http;

class Auth {
  static validateMerchant(email, password) async {
    var response =
        await http.post('${Api.SUPER_BASE_URL}validateMerchent', body: {
      'email': email,
      'password': password,
    });

    print('-------------------------------------------');
    print(response.body);
    return response.body;
  }
  static updateApp() async {
    var response =
    await http.get('https://superadmin.ordere.co.uk/api/get_app_link');

    print('-------------------------------------------');
    print(response.body);
    return response.body;
  }


  static Future<String> updateToken(domain, token) async {
    var response = await http.post('${Api.businessBaseUrl}updateToken', body: {
      'token': token,
    });

    print('-------------------------------------------');
    print(response.body);
    return response.body;
  }
}
