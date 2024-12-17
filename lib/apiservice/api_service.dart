import 'package:bank/model/transaction_model.dart';
import 'package:bank/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://bankapi.efrosine.my.id/api',
    headers: {'Accept': 'application/json'},
  ));
  final SharedPreferencesAsync pref = SharedPreferencesAsync();

  Future<String> login(String email, String password) async {
    try {
      final response = await _dio
          .post('/login', data: {"email": email, "password": password});
      String token = response.data['token'];
      await pref.setString('token', token);
      return 'Login Berhasil';
    } on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }

  Future<String> register(String name, String email, String password,
      String confirmPassowrd) async {
    try {
      final response = await _dio.post('/register', data: {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": confirmPassowrd
      });
      return response.data['message'] ?? 'Berhasil';
    } on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }

  Future<String> logout() async {
    try {
      String? token = await pref.getString('token');
      final response = await _dio.post('/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      await pref.remove('token');
      return response.data['message'] ?? 'Berhasil';
    } on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }

  Future<UserModel> getUserAccount() async {
    try {
      String? token = await pref.getString('token');
      final response = await _dio.get('/user/account',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }

  Future<String> topUp(int amount) async {
    try {
      String? token = await pref.getString('token');
      final response = await _dio.post('/user/top-up',
          data: {"amount": amount},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response.data['message'] ?? 'Berhasil';
    } on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }

  Future<List<TransactionModel>> getTransaction() async {
    try{
      String? token = await pref.getString('token');
      final response = await _dio.get('/user/transactions',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
       List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    }on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }
}
