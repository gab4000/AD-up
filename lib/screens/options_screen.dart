import 'package:ad_up/ade/ade_ical.dart';
import 'package:ad_up/ade/ade_link.dart';
import 'package:ad_up/components/button.dart';
import 'package:ad_up/utils/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreen();
}

class _OptionsScreen extends State<OptionsScreen> {
  FlutterSecureStorage storage = FlutterSecureStorage();

  void logout() async {
    await storage.delete(key: "username");
    await storage.delete(key: "password");
    await storage.delete(key: "class");
    cookies = {};
    classes = {};
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Options"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              getCupertinoButton(context, "Se déconnecter", Icons.logout_rounded, () => logout()),
              getCupertinoButton(context, "Vérifier les mises à jour", Icons.update_rounded, () => checkVersion(context, true))
            ],
          ),
        ),
      ),
    );
  }
}