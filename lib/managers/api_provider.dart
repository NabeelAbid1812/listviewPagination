import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
//import 'package:dio_log/interceptor/dio_log_interceptor.dart';


import 'package:get/get.dart' as Get;


class APIProvider {
  
  static const requestTimeOut = Duration(seconds: 25);
  final _client = Dio(BaseOptions(
      receiveDataWhenStatusError: true,
      followRedirects: true,
      maxRedirects: 3,
      connectTimeout: Duration(seconds: 30), // 60 seconds
      receiveTimeout: Duration(seconds: 30)
  ));
  APIProvider() {
   // _client.interceptors.add(DioLogInterceptor());
  }

  // static final _singleton = APIProvider();

  // static APIProvider get instance => _singleton;

  Future get(
    url,
    auth,
    context,
  ) async {
    try {
      Response response;
      if (auth == null || auth == true) {
        // print(
        //     "[APIProvider.baseGetAPI Authed] called with : ${SessionController().token}");
        response = await _client.get( url,
            options: Options(headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              // 'authorization': "Bearer ${SessionController().token}"
            }));
      } else {
        // print( Urls.apiUrl + url);
        // print("[APIProvider.baseGetAPI unAuthed] called");
        response = await _client.get(  url,
            options: Options(
                headers: <String, String>{'Content-Type': 'application/json'}));
      }
      return _returnResponse(response,context);
    } on TimeoutException catch (_) {
      throw TimeOutException(null);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on DioError catch (e) {
      
     
      if (e.response != null) {
        return _returnResponse(e.response!,context);
      } else {
        return "No internet connection";
      }
    }
  }

 

  
     dynamic _returnResponse(Response<dynamic> response,context ) async{
    switch (response.statusCode) {
      case 200:
        return response.data ;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
        _client.close();
        // token issue
        throw BadRequestException(response.data.toString());
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 404:
        throw BadRequestException('Not found');
      case 501:
       
        _client.close();
      case 500:

       
//print(serverDecryptedResponse);
        return jsonDecode(response.data) ;
      default:
        print("default");
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }


   


   

  
}

class AppException implements Exception {
  final code;
  final message;
  final details;

  AppException({this.code, this.message, this.details});

  String toString() {
    return "[$code]: $message \n $details";
  }
}

class FetchDataException extends AppException {
  FetchDataException(String? details)
      : super(
          code: "fetch-data",
          message: "Error During Communication",
          details: details,
        );
}

class BadRequestException extends AppException {
  BadRequestException(String? details)
      : super(
          code: "invalid-request",
          message: "Invalid Request",
          details: details,
        );
}

class UnauthorisedException extends AppException {
  UnauthorisedException(String? details)
      : super(
          code: "unauthorised",
          message: "Unauthorised",
          details: details,
        );
}

class InvalidInputException extends AppException {
  InvalidInputException(String? details)
      : super(
          code: "invalid-input",
          message: "Invalid Input",
          details: details,
        );
}

class AuthenticationException extends AppException {
  AuthenticationException(String? details)
      : super(
          code: "authentication-failed",
          message: "Authentication Failed",
          details: details,
        );
}

class TimeOutException extends AppException {
  TimeOutException(String? details)
      : super(
          code: "request-timeout",
          message: "Request TimeOut",
          details: details,
        );
}
