import 'package:flutter/material.dart';

import 'src/editor_page.dart';

void main() {
  runApp(QuickStartApp());
}

class QuickStartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Start',
      home: HomePage(),
      routes: {
        '/editor': (context) => EditorPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Quick Start')),
      body: Center(
        child: TextButton(
          child: Text('Open editor'),
          onPressed: () => navigator.pushNamed('/editor'),
        ),
      ),
    );
  }
}
