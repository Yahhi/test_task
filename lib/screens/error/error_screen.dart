import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({super.key, this.message = 'Problem in app'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(title: const Text("Error"), centerTitle: true, backgroundColor: Colors.redAccent),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GFCard(
            boxFit: BoxFit.cover,
            title: const GFListTile(
              avatar: GFAvatar(
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.error, color: Colors.white),
              ),
              titleText: "Something went wrong",
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16))],
            ),
          ),
        ),
      ),
    );
  }
}
