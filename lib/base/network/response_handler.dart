import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:my_app/base/network/resource.dart';

Resource handleResponse(http.Response response) {
  if (response.statusCode == 200) {
    return Resource.successState(response.body);
  } else if (response.statusCode == 401 || response.statusCode == 403) {
    var errorResponse = BaseErrorResponse.fromJson(jsonDecode(response.body));
    var errorMessage = errorResponse.message ?? (errorResponse.detail ?? '');
    log(errorMessage);
    return Resource.errorState(errorMessage);
  } else if (response.statusCode == 500) {
    return const Resource.errorState(
        'Something went wrong on server side please try again later.');
  } else if (response.statusCode == 404) {
    return const Resource.errorState(
        'Something went wrong on server side please try again later.');
  } else {
    log(response.body);
    var errorResponse = BaseErrorResponse.fromJson(jsonDecode(response.body));
    var errorMessage = errorResponse.message ??
        errorResponse.detail ??
        errorResponse.nonFieldErrors?.first.toString() ??
        '';
    log(errorMessage);
    return Resource.errorState(errorMessage);
  }
}

class BaseErrorResponse {
  String? message;
  String? status;
  String? detail;
  List<dynamic>? nonFieldErrors;

  BaseErrorResponse(
      {this.message, this.status, this.detail, this.nonFieldErrors});

  factory BaseErrorResponse.fromJson(Map<String, dynamic> json) =>
      BaseErrorResponse(
        message: json['message'],
        status: json['status'],
        detail: json['detail'],
        nonFieldErrors: json['non_field_errors'],
      );
}

class BaseResponseEntity {
  String? message;

  BaseResponseEntity({this.message});

  factory BaseResponseEntity.fromJson(Map<String, dynamic> json) =>
      BaseResponseEntity(message: json['message']);
}
