import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medis/util.dart';

import '../database.dart';

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

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  Widget build(BuildContext context) {
    final slots = ref.watch(slotsProvider);
    return slots.when(error: (error, stack) {
      return Center(child: Text(error.toString()));
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    }, data: (slots) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (int i = 0; i <= 2; i++) SlotCard(slot: slots.get(i), id: i + 1),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text('Schedules'),
        ),
        for (final schedule in schedules) buildScheduleTile(context, schedule),
      ]);
    });
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
}

class SlotCard extends StatelessWidget {
  final Slot? slot;
  final int id;
  const SlotCard({super.key, this.slot, required this.id});

  @override
  Widget build(BuildContext context) {
    return buildCard(
      context,
      title: slot?.name ?? 'Unassigned',
      subtitle: 'Slot $id',
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
        child: Row(
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            const Spacer(),
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
