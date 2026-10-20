import 'package:http/http.dart';

class Cookie {
  const Cookie({required this.value, required this.params});

  final String value;
  final String params;
}

Map<String, Cookie> getCookies(Response response) {
  Map<String, Cookie> cookies = {};
  List<String> rawCookies = [];

  String? setCookie = response.headers["set-cookie"];

  if (setCookie != null) {
    rawCookies = setCookie.split(",");
  }

  for (String cookie in rawCookies) {
    List<String> cookieSplit = cookie.split(";");
    String firstPart = cookieSplit.first.trim();
    int equalIndex = firstPart.indexOf("=");

    if (equalIndex != -1) {
      String key = firstPart.substring(0, equalIndex).toLowerCase();
      String params = cookieSplit.sublist(1).map((e) => e.trim()).join("; ");

      cookies[key] = Cookie(
        value: firstPart,
        params: params
      );
    }
  }

  return cookies;
}

String cookiesToString(Map<String, Cookie> cookies) {
  return cookies.entries.map((e) => e.value.value).join("; ");
}