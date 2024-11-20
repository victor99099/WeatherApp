import 'package:flutter/material.dart';
import 'package:weatherapp/controllers/weathrControllers/dateTime.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return AlertDialog(
      backgroundColor: currentTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: currentTheme.primaryColorDark),
      ),
      content: Text(
        content,
        style: TextStyle(fontSize: 18, color: currentTheme.primaryColorDark),
      ),
      actions: <Widget>[
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(currentTheme.canvasColor)
          ),
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: TextStyle(color:currentTheme.primaryColorDark),
          ),
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(currentTheme.shadowColor)
          ),
          onPressed: onConfirm,
          child: Text(
            'Confirm',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
