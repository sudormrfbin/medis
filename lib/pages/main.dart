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

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class Heading extends StatelessWidget {
  final String text;
  const Heading(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class _MainPageState extends ConsumerState<MainPage> {
  Widget buildSlots() {
    final slots = ref.watch(slotsProvider);
    return slots.when(
      error: (error, stack) {
        return Center(child: Text(error.toString()));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      data: (slots) {
        return Column(
          children: [
            for (int i = 0; i <= 2; i++)
              SlotCard(slot: slots.get(i), id: i + 1),
          ],
        );
      },
    );
  }

  Widget buildSchedules() {
    final schedules = ref.watch(schedulesProvider);
    return schedules.when(
      error: (error, stack) {
        return Center(child: Text(error.toString()));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      data: (schedules) {
        return Column(
          children: [
            for (final schedule in schedules) ScheduleTile(schedule: schedule),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Heading('Slots'),
        buildSlots(),
        const Heading('Schedules'),
        buildSchedules(),
      ]),
    );
  }
}

class ScheduleTile extends ConsumerWidget {
  const ScheduleTile({
    super.key,
    required this.schedule,
  });

  final Schedule schedule;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pillName = 'Unassigned';
    if (schedule.slotId != null) {
      final slot = ref.watch(slotsByIdProvider(schedule.slotId!));
      pillName = slot.when(
        error: (_, __) => 'Error',
        loading: () => 'Loading',
        data: (data) => data?.name ?? pillName,
      );
    }

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            InkWell(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: schedule.time,
                );
                if (time == null) return;

                final updatedSchedule = Schedule(
                  schedule.slotId,
                  time,
                  id: schedule.id,
                );
                await ref
                    .read(databaseProvider)
                    .scheduleDao
                    .updateSchedule(updatedSchedule);
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: TimeDisplay(time: schedule.time),
              ),
            ),
            const Spacer(),
            Text(pillName, style: Theme.of(context).textTheme.bodyLarge)
          ],
        ),
      ),
    );
  }
}

class TimeDisplay extends StatelessWidget {
  final TimeOfDay time;
  const TimeDisplay({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class SlotCard extends ConsumerWidget {
  final Slot? slot;
  final int id;

  const SlotCard({super.key, this.slot, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return buildCard(
      context,
      title: slot?.name ?? 'Unassigned',
      subtitle: 'Slot $id',
      ref: ref,
    );
  }

  Widget buildCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required WidgetRef ref,
  }) {
    var theme = Theme.of(context);
    final radius = BorderRadius.circular(30);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: radius),
      child: InkWell(
        borderRadius: radius,
        onTap: () async {
          final controller = TextEditingController()..text = slot?.name ?? '';
          final name = await showDialog<String>(
            context: context,
            builder: (context) => SlotEditDialog(slotName: slot?.name),
          );
          controller.dispose();
          if (name == null || name == '') return;

          final updatedSlot = Slot(slot?.id, name);
          final slotDao = ref.read(databaseProvider).slotDao;
          if (slot == null) {
            await slotDao.insertSlot(updatedSlot);
          } else {
            await slotDao.updateSlot(updatedSlot);
          }
        },
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
      ),
    );
  }
}

class SlotEditDialog extends StatefulWidget {
  final String? slotName;

  const SlotEditDialog({super.key, this.slotName});

  @override
  State<SlotEditDialog> createState() => _SlotEditDialogState();
}

class _SlotEditDialogState extends State<SlotEditDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController()..text = widget.slotName ?? '';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Slot'),
      content: TextField(
        autofocus: true,
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Name of medicine',
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
        ),
      ],
    );
  }
}
