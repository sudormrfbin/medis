import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        buildPillCard(context, 'Anthrazene', 1),
        buildPillCard(context, 'Betadine', 2),
      ]),
      Row(children: [
        buildPillCard(context, 'Dolo', 3),
        buildPillCard(context, 'Insulin', 4),
      ]),
      buildScheduleTile(),
    ]);
  }

  Widget buildScheduleTile() {
    return Card(child: Text('er'));
  }

  Widget buildPillCard(BuildContext context, String name, int slot) {
    return Expanded(
      child: buildCard(
        context,
        title: name,
        subtitle: 'Slot ${slot.toString()}',
      ),
    );
  }

  Widget buildCard(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    var theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(left: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            Text(
              subtitle,
              style: TextStyle(color: theme.disabledColor),
            )
          ],
        ),
      ),
    );
  }
}
