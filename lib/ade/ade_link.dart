import 'dart:convert';

import 'package:ad_up/ade/ade_types.dart';
import 'package:ad_up/ade/cookie.dart';
import 'package:http/http.dart';

final adeDefaults = <String>[
  "edt.grenoble-inp.fr",
  "2026-2027",
  "prepaINPGrenoble",
  "etudiant",
  "https://edt.grenoble-inp.fr/"
];

Map<String, Cookie> cookies = {};

Future<ADESessionParams> connect(String id, String password) async {
  ADEAuthenticatedParams params = ADEAuthenticatedParams(credentials: base64.encode(utf8.encode("$id:$password")));

  final response = await get(Uri.parse("${getURLFromParams(params)}/jsp/standard/direct_planning.jsp"), headers: {
    "Authorization": "Basic ${params.credentials}",
    "Referer": "https://${adeDefaults[0]}/"
  });

  ADESessionParams adeSessionParams = ADESessionParams().fromADEAuthenticatedParams(params);
  adeSessionParams.cookies = cookiesToString(cookies..addAll(getCookies(response)));

  return adeSessionParams;
}

String getURLFromParams(ADERequestParams params) {
  String address = params.address.isNotEmpty ? params.address : adeDefaults[0];
  String year = params.year.isNotEmpty ? params.year : adeDefaults[1];
  String location = params.location.isNotEmpty ? params.location : adeDefaults[2];
  String type = params.type.isNotEmpty ? params.type : adeDefaults[3];

  return "https://$address/$year/$location/$type";
}

String getURL() {
  String address = adeDefaults[0];
  String year = adeDefaults[1];
  String location = adeDefaults[2];
  String type = adeDefaults[3];

  return "https://$address/$year/$location/$type";
}

void connectWithLink(String link) async {
  final response = await get(Uri.parse(link));
  print(response.body);
}