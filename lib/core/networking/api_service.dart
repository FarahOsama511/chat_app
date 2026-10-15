import 'package:chatapp/core/di/service_locator.dart';
import 'package:dio/dio.dart';
import '../helpers/security_sharedpref.dart';
import 'api_constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHelper {
  late Dio dio;
  DioHelper() {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 90),
      receiveTimeout: const Duration(seconds: 90),
      maxRedirects: 5,
      headers: {"Accept": "application/json",},
    );
    dio = Dio(baseOptions);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getIt<SecuritySharedpref>().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }

  Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    return await dio.get(
      url,
      queryParameters: query,
      cancelToken: cancelToken,
      options: Options(responseType: ResponseType.json),
    );
  }

  Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    dynamic data,
    String? token,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.post(url, queryParameters: query, data: data, options: Options(headers: headers));
  }

  Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    dynamic data,
    String? token,
  }) async {
    return await dio.put(url, queryParameters: query, data: data);
  }

  Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    return await dio.delete(url, queryParameters: query);
  }
}

// String _handleDioError(DioException error) {
//   if (error.response != null && error.response?.data != null) {
//     final data = error.response!.data;
//     if (data is Map<String, dynamic>) {
//       if (data.containsKey('message')) {
//         return data['message'].toString();
//       }
//       if (data.containsKey('error')) {
//         return data['error'].toString();
//       }
//     }
//     return 'Server error (${error.response?.statusCode})';
//   }

//   switch (error.type) {
//     case DioExceptionType.connectionTimeout:
//     case DioExceptionType.sendTimeout:
//     case DioExceptionType.receiveTimeout:
//       return 'Connection timed out. Please check your internet connection.';
//     case DioExceptionType.connectionError:
//       return 'Unable to connect to the server. Please check the network.';
//     case DioExceptionType.cancel:
//       return 'Request was cancelled.';
//     default:
//       return 'An unexpected network error occurred.';
//   }
// }
