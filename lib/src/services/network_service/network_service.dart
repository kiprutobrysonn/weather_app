import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:weather_app/src/core/entities/api_response.dart';
import 'package:weather_app/src/core/entities/failure.dart';
import 'package:weather_app/src/services/network_service/network_logger.dart';

class NetworkService extends INetworkService {
  Dio _dio = Dio();
  final _logger = Logger();
  final _headers = {'Accept': 'application/json'};

  NetworkService() {
    _dio = Dio();
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);
    _dio.interceptors.addAll([
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseData: true,
          printRequestData: true,
          printResponseMessage: true,
        ),
      ),
      NetworkLoggerInterceptor(),
    ]);
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    // TODO: implement get
    _logger.i("GET $url");
    try {
      if (headers != null) {
        _headers.addAll(headers);
      }
      final res = await _dio.get(url, options: Options(headers: _headers));

      if (res.statusCode == 200 || res.statusCode == 201) {
        return ApiResponse(data: res.data, status: true);
      }
      throw Failure(res.statusMessage ?? "Something went wrong");
    } on DioException catch (e) {
      throw convertException(e);
    } catch (e) {
      _logger.e(e.toString());
      throw Failure(e.toString());
    }
  }

  Failure convertException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Failure("Connection Timed Out");
      case DioExceptionType.sendTimeout:
        return Failure("Connection Timed Out");
      case DioExceptionType.receiveTimeout:
        return Failure("Connection Timed Out");
      case DioExceptionType.badResponse:
        return Failure(
          e.response?.data['message'] ?? e.response?.data['errors'],
        );
      case DioExceptionType.cancel:
        return Failure(
          e.response?.data['message'] ?? e.response?.data['errors'],
        );
      case DioExceptionType.unknown:
        return Failure("No Internet Connection");
      default:
        return Failure("No Internet Connection");
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getWithQuery(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    // TODO: implement getWithQuery

    _logger.i("GET $url");
    try {
      if (headers != null) {
        _headers.addAll(headers);
      }
      final res = await _dio.get(
        url,
        options: Options(headers: _headers),
        queryParameters: queryParameters,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return ApiResponse(data: res.data, status: true);
      }
      throw Failure(res.statusMessage ?? "Something went wrong");
    } on DioException catch (e) {
      throw convertException(e);
    } catch (e) {
      _logger.e(e.toString());
      throw Failure(e.toString());
    }
  }
}

abstract class INetworkService {
  Future<ApiResponse<Map<String, dynamic>>> get(
    String url, {
    Map<String, String>? headers,
  });

  Future<ApiResponse<Map<String, dynamic>>> getWithQuery(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  });
}
