import 'package:ad_up/ade/ade_tree_ids.dart';
import 'package:ad_up/ade/ade_types.dart';
import 'package:ad_up/components/button.dart';
import 'package:ad_up/screens/schedule_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ClassSelectScreen extends StatefulWidget {
  const ClassSelectScreen(this.params, {super.key});

  final ADESessionParams params;

  @override
  State<ClassSelectScreen> createState() => _ClassSelectScreenState();
}

class _ClassSelectScreenState extends State<ClassSelectScreen> {
  bool isLoading = false;

  void selectClass(BuildContext context, String classID) {
    setState(() => isLoading = true);
    FlutterSecureStorage().write(key: "class", value: classID);
    load(context, widget.params, classID);
    setState(() => isLoading = false);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScheduleScreen()));
  }

  List<Widget> getClassBtns(BuildContext context) {
    List<Widget> list = [];
    classID.forEach((key, value) {
      CupertinoButton button = getCupertinoButton(
          context,
          key,
          Icons.class_rounded,
          () => selectClass(context, value)
      );
      list.add(button);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          Center(
            child: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
                child: Column(
                  spacing: 10,
                  children: [
                    Text("Sélectionnez votre groupe TD",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    ...getClassBtns(context)
                  ],
                )
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
        ]
      )
    );
  }
}