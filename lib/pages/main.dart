import 'package:flutter/material.dart';

String dayIntToString(int day) {
  switch (day) {
    case DateTime.monday:
      return 'Mon';
    case DateTime.tuesday:
      return 'Tue';
    case DateTime.wednesday:
      return 'Wed';
    case DateTime.thursday:
      return 'Thur';
    case DateTime.friday:
      return 'Fri';
    case DateTime.saturday:
      return 'Sat';
    case DateTime.sunday:
      return 'Sun';
  }

  throw 'Invalid date int';
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        buildPillCard(context, 'Anthrazene', 1),
        buildPillCard(context, 'Betadine', 2),
      ]),
      Row(children: [
        buildPillCard(context, 'Dolo', 3),
        buildPillCard(context, 'Insulin', 4),
      ]),
      const SizedBox(height: 20),
      buildScheduleTile(
          context, const TimeOfDay(hour: 9, minute: 0), [1, 3, 5], 'Insulin'),
      buildScheduleTile(
          context, const TimeOfDay(hour: 19, minute: 0), [6, 7], 'Dolo'),
    ]);
  }

  Widget buildScheduleTile(
    BuildContext context,
    TimeOfDay time,
    List<int> days,
    String pillName,
  ) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Text(
                    '${time.hourOfPeriod.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                    // time.format(context),
                    // '09:00',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    time.period == DayPeriod.am ? ' AM' : ' PM',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Text(days.map(dayIntToString).join(", ")),
            ]),
            const Spacer(),
            Text(pillName, style: Theme.of(context).textTheme.bodyLarge)
          ],
        ),
      ),
    );
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
