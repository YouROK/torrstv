import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

class HttpResponse {
  final int statusCode;
  final String? data;
  final String? error;

  HttpResponse({required this.statusCode, this.data, this.error});

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

Future<HttpResponse> httpGetCache(String url, {Map<String, String>? headers}) async {
  var file = await DefaultCacheManager().getSingleFile(url, headers: headers);
  return HttpResponse(statusCode: 200, data: await file.readAsString());
}

Future<HttpResponse> httpGet(String url, String? auth, {Map<String, String>? headers}) async {
  final uri = Uri.parse(url);
  final Map<String, String> finalHeaders = {...(headers ?? {})};

  if (auth != null && auth.isNotEmpty) finalHeaders['Authorization'] = 'Basic $auth';

  try {
    final response = await http.get(uri, headers: finalHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return HttpResponse(statusCode: response.statusCode, data: response.body);
    } else {
      return HttpResponse(statusCode: response.statusCode, error: 'HTTP Error: Status code ${response.statusCode}', data: response.body);
    }
  } catch (e) {
    return HttpResponse(statusCode: 0, error: 'Network Error: $e');
  }
}

Future<HttpResponse> httpPost(String url, String? auth, {required Map<String, dynamic> body, Map<String, String>? headers}) async {
  final uri = Uri.parse(url);
  final finalHeaders = {'Content-Type': 'application/json; charset=UTF-8', ...(headers ?? {})};

  if (auth != null && auth.isNotEmpty) finalHeaders['Authorization'] = 'Basic $auth';

  try {
    final response = await http.post(uri, headers: finalHeaders, body: json.encode(body));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return HttpResponse(statusCode: response.statusCode, data: response.body);
    } else {
      return HttpResponse(statusCode: response.statusCode, error: 'HTTP Error: Status code ${response.statusCode}', data: response.body);
    }
  } catch (e) {
    return HttpResponse(statusCode: 0, error: 'Network Error: $e');
  }
}
