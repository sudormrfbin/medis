import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';
import 'pages/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      await $FloorMedisDatabase.databaseBuilder('medis.db').build();
  runApp(ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(database),
    ],
    child: const MedisApp(),
  ));
}

class MedisApp extends ConsumerWidget {
  const MedisApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Palm',
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Medis'),
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton.extended(
            label: const Text('Add Schedule'),
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time == null) return;

              final newSchedule = Schedule(null, time);
              await ref
                  .read(databaseProvider)
                  .scheduleDao
                  .insertSchedule(newSchedule);
            },
            icon: const Icon(Icons.add),
          );
        }),
        body: Padding(
          padding: const EdgeInsets.all(8).copyWith(top: 0),
          child: const MainPage(),
        ),
      ),
    );
  }
}
