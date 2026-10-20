import 'package:ad_up/ade/ade_link.dart';
import 'package:ad_up/ade/ade_types.dart';
import 'package:ad_up/screens/class_select_screen.dart';
import 'package:ad_up/screens/schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../ade/ade_tree_ids.dart';
import '../components/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool obscured = true;
  (bool, bool) btnActivated = (false, false);
  late Function()? connectCallback;
  final idController = TextEditingController();
  final pwdController = TextEditingController();
  bool isLoading = false;
  FlutterSecureStorage storage = FlutterSecureStorage();

  void checkSharedPrefs() async {
    String? username = await storage.read(key: "username");
    String? password = await storage.read(key: "password");
    String? classID = await storage.read(key: "class");
    if (username == null || username.isEmpty
        || password == null || password.isEmpty
        || classID == null || classID.isEmpty) {
      return;
    }

    setState(() => isLoading = true);
    try {
      ADESessionParams params = await connect(username, password);
      load(context, params, classID);
      setState(() => isLoading = false);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScheduleScreen()));
    } catch (_) {
      setState(() => isLoading = false);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Erreur de connexion"),
          content: const Text("Une erreur de connexion est survenue"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop('OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    if (btnActivated.$1 == true && btnActivated.$2 == true) {
      connectCallback = () async {
        setState(() => isLoading = true);
        await storage.write(key: "username", value: idController.text);
        await storage.write(key: "password", value: pwdController.text);
        ADESessionParams params = await connect(idController.text, pwdController.text);
        setState(() => isLoading = false);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ClassSelectScreen(params)));
      };
    } else {
      connectCallback = null;
    }

    return Scaffold(
        body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  TextFormField(
                    controller: idController,
                    onChanged: (context) => setState(() => btnActivated = (context.isNotEmpty, btnActivated.$2)),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Identifiant (nomp)",
                    ),
                  ),
                  TextFormField(
                    controller: pwdController,
                    obscureText: obscured,
                    onChanged: (context) => setState(() => btnActivated = (btnActivated.$1, context.isNotEmpty)),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Mot de passe",

                    ),
                  ),
                  CheckboxListTile(
                      title: Text("Afficher le mot de passe"),
                      value: !obscured,
                      tristate: false,
                      onChanged: (value) => setState(() => obscured = !value!)
                  ),
                  getCupertinoButton(context, "Se connecter", Icons.person_rounded, connectCallback),
                  TextButton(
                    child: Text("Plus d'infos"),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("A propos de la connexion AGALAN"),
                          content: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Ce type de connexion demande vos identifiants AGALAN qui sont envoyés directement au système ADE afin d'effectuer les opérations pour récupérer l'emploi du temps.",
                                style: TextStyle(
                                    fontSize: 18
                                ),
                              ),
                              Text("Aucune information n'est sauvegardée, récupérée ou envoyée à l'exterieur de votre appareil ainsi que du système ADE.",
                                style: TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.underline
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        )
                    )
                  )
                ],
              ),
            ),
          ),
          isLoading ? ColoredBox(
              color: Color.fromARGB(192, 0, 0, 0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white70,
                    ),
                    Text("Chargement...",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70
                      ),
                    )
                  ],
                ),
              )
          ) : Stack()
        ],
      )
    );
  }

  @override
  void dispose() {
    idController.dispose();
    pwdController.dispose();
    super.dispose();
  }
}