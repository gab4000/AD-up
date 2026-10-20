import 'package:ad_up/ade/ade_types.dart';
import 'package:ad_up/components/class.dart';
import 'package:http/http.dart';

Set<Class> classes = {};

Future<String> getStrIcal(ADESessionParams params, String classID) async {
  final response = await get(Uri.parse("https://edt.grenoble-inp.fr/directCal/2026-2027/etudiant/prepaINPGrenoble?resources=$classID"),
    headers: <String, String>{
      "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
      "Authorization": "Basic ${params.credentials}",
      "Content-Type": "application/x-www-form-urlencoded",
      "Cookie": params.cookies,
    }
  );
  return response.body.toString();
}