import 'package:flutter/material.dart';

import 'src/home.dart';

void main() {
  runApp(ZefyrApp());
}

class ZefyrApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zefyr - rich-text editor for Flutter',
      home: HomePage(),
    );
  }
}
