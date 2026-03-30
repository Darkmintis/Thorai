import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import 'login_request.dart';
import 'user.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  Future<User> login(LoginRequest req) async {
    try{
      Response response;
      try{
        response = await _dio.post(
          ApiConstants.login,
          data: {'email': req.email, 'password':req.password},
        );
      } on DioException catch (e){
        if (e.response?.statusCode == 400){
          response = await _dio.post(
            ApiConstants.login,
            data: {'username': req.email, 'password': req.password},
          );
        } else {
          rethrow;
        }
      }
      
      return _handleResponse(response);
    } on DioException catch (e){
      _handleError(e);
      throw Exception('login failed');
    }
  }

  User _handleResponse(Response response){
    if (response.statusCode == 200 || response.statusCode == 201){
      final data = response.data as Map<String, dynamic>;
      return User.fromJson(data);
    }
    throw Exception('login failed');
  }

  void _handleError(DioException e){
    if (e.response != null){
      final statusCode = e.response!.statusCode;

      if (statusCode == 400 || statusCode == 401 || statusCode == 403){
        String message = 'Invalid email or password';
      try{
      final data = e.response!.data;
      if (data is Map && data['detail'] != null){
        message = data['detail'];
      }
    } catch (_) {}

    throw Exception(message);
  }

  throw Exception('Server error: ${e.response?.statusCode}');
}

if (e.type == DioExceptionType.connectionTimeout ||
e.type == DioExceptionType.receiveTimeout){
  throw Exception('Connection timeout. Please try again');
}

if (e.type == DioExceptionType.connectionError){
  throw Exception('No internet connection. Please check your network.');
}

throw Exception('Something went wrong. Please try again');
}
}