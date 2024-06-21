import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, String> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final String language = arguments['language']!;

    return Scaffold(
        appBar: AppBar(
          title: Text('$language Details'),
        ),
        body: Center(
            child: Text(
              'Details for $language',
              style: TextStyle(fontSize: 24),
            ),
        ),
        );
    }
}