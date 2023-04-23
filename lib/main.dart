import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/main.dart';

void main() async {
  runApp(const ProviderScope(child: PalmApp()));
}

class PalmApp extends StatelessWidget {
  const PalmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palm',
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Medis'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Add Schedule'),
          onPressed: () => {},
          icon: const Icon(Icons.add),
        ),
        body: const Padding(
          padding: EdgeInsets.all(8),
          child: MainPage(),
        ),
      ),
    );
  }
}
