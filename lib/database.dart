import 'package:flutter/material.dart';
import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

final databaseProvider =
    Provider<MedisDatabase>((ref) => throw UnimplementedError());

StreamProvider<List<Slot>> slotsProvider = StreamProvider((ref) {
  final database = ref.watch(databaseProvider);
  return database.slotDao.getAllSlots();
});

StreamProvider<List<Schedule>> schedulesProvider = StreamProvider((ref) {
  final database = ref.watch(databaseProvider);
  return database.scheduleDao.getAllSchedules();
});

@riverpod
Future<Slot?> slotsById(SlotsByIdRef ref, int id) async {
  final database = ref.watch(databaseProvider);
  return database.slotDao.getSlotById(id);
}

class TimeOfDayConverter extends TypeConverter<TimeOfDay, int> {
  @override
  TimeOfDay decode(int databaseValue) {
    final hour = databaseValue ~/ 60;
    final minute = databaseValue % 60;
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  int encode(TimeOfDay value) {
    return value.hour * 60 + value.minute;
  }
}

@entity
class Slot {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final String name;

  Slot(this.id, this.name);
}

@entity
class Schedule {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final int? slotId;
  final TimeOfDay time;

  Schedule(this.slotId, this.time, {this.id});
}

@TypeConverters([TimeOfDayConverter])
@Database(version: 1, entities: [Slot, Schedule])
abstract class MedisDatabase extends FloorDatabase {
  SlotDao get slotDao;
  ScheduleDao get scheduleDao;
}

@dao
abstract class SlotDao {
  @Query('SELECT * FROM Slot')
  Stream<List<Slot>> getAllSlots();

  @Query('SELECT * FROM Slot WHERE id = :id')
  Future<Slot?> getSlotById(int id);

  @insert
  Future<void> insertSlot(Slot slot);

  @update
  Future<void> updateSlot(Slot slot);
}

@dao
abstract class ScheduleDao {
  @Query('SELECT * FROM Schedule')
  Stream<List<Schedule>> getAllSchedules();

  @Query('SELECT * FROM Schedule WHERE id = :id')
  Future<Schedule?> getScheduleById(int id);

  @insert
  Future<void> insertSchedule(Schedule schedule);

  @update
  Future<void> updateSchedule(Schedule schedule);
}
