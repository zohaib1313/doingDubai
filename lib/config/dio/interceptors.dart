import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:req_fun/req_fun.dart';

import '../app_urls.dart';
import '../keys/headers.dart';
import '../keys/pref_keys.dart';

class AppDioInterceptor extends Interceptor {
  final BuildContext context;
  String token = "";

  AppDioInterceptor(this.context) {
    Prefs.getPrefs().then((prefs) {
      token = prefs.getString(PrefKey.AUTHORIZATION) ?? "";
    });
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(">>>>> onError start <<<<<");
    print(err.type);
    print(err.message);
    print(err.response!.statusCode);
    print(err.response!.statusMessage);
    print(err.response!.headers);
    print("Data: ");
    print(err.response!.data);
    print("End Data");
    print(err.response!.extra);
    print(err);
    print(err.response);
    print(">>>>> onError end <<<<<");

    // handler.next(err);
    handler.resolve(err.response!);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(">>>>> onResponse start <<<<<");
    print(response.statusCode);
    print(response.statusMessage);
    print(response.headers);
    print(response.data);
    print(response.extra);
    print(">>>>> onResponse end <<<<<");

    handler.next(response);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print(">>>>> onRequest start <<<<<");
    options..baseUrl = AppUrl.baseUrl;
    if (token.isNotEmpty) {
      options..headers.addAll({"${RequestHeader.authorization}": "${RequestHeader.bearer} $token"});
    }
    print(options.baseUrl);
    print(options.path);
    print(options.method);
    print(options.queryParameters);
    print(options.headers);
    print(options.data);
    print(">>>>> onRequest end <<<<<");

    handler.next(options);
  }
}
