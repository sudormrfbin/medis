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

class Slot {
  final int id;
  final String name;

  Slot(this.id, this.name);
}

class Schedule {
  final int slotId;
  final TimeOfDay time;

  Schedule(this.slotId, this.time);
}

final slots = [
  Slot(1, 'Anthrazene'),
  Slot(2, 'Betadine'),
  Slot(3, 'Dolo'),
  Slot(4, 'Insulin'),
];

final schedules = [
  Schedule(1, const TimeOfDay(hour: 9, minute: 0)),
  Schedule(2, const TimeOfDay(hour: 19, minute: 0)),
];

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        buildPillCard(context, slots[0]),
        buildPillCard(context, slots[1]),
      ]),
      Row(children: [
        buildPillCard(context, slots[2]),
        buildPillCard(context, slots[3]),
      ]),
      const SizedBox(height: 20),
      for (final schedule in schedules) buildScheduleTile(context, schedule),
    ]);
  }

  Widget buildScheduleTile(
    BuildContext context,
    Schedule schedule,
  ) {
    final pillName = slots[schedule.slotId].name;
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  '${schedule.time.hourOfPeriod.toString().padLeft(2, '0')}:${schedule.time.minute.toString().padLeft(2, '0')}',
                  // time.format(context),
                  // '09:00',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  schedule.time.period == DayPeriod.am ? ' AM' : ' PM',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const Spacer(),
            Text(pillName, style: Theme.of(context).textTheme.bodyLarge)
          ],
        ),
      ),
    );
  }

  Widget buildPillCard(BuildContext context, Slot slot) {
    return Expanded(
      child: buildCard(
        context,
        title: slot.name,
        subtitle: 'Slot ${slot.id.toString()}',
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
