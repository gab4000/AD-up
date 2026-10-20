import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

CupertinoButton getCupertinoButton(BuildContext context, String text, IconData icon, Function()? callback) {
  return CupertinoButton(
    onPressed: callback,
    color: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
    minimumSize: Size(.infinity, 100),
    borderRadius: BorderRadius.all(Radius.circular(12)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 30,
      children: [
        Icon(icon,
          color: Theme.of(context).buttonTheme.colorScheme?.onSurface,
          size: 36,
        ),
        Text(text,
          style: TextStyle(
              color: Theme.of(context).buttonTheme.colorScheme?.onSurface,
              fontSize: 24
          ),
        )
      ],
    ),
  );
}