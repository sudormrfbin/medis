// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorMedisDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$MedisDatabaseBuilder databaseBuilder(String name) =>
      _$MedisDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$MedisDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$MedisDatabaseBuilder(null);
}

class _$MedisDatabaseBuilder {
  _$MedisDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$MedisDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$MedisDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<MedisDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$MedisDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$MedisDatabase extends MedisDatabase {
  _$MedisDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SlotDao? _slotDaoInstance;

  ScheduleDao? _scheduleDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Slot` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Schedule` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `slotId` INTEGER, `time` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SlotDao get slotDao {
    return _slotDaoInstance ??= _$SlotDao(database, changeListener);
  }

  @override
  ScheduleDao get scheduleDao {
    return _scheduleDaoInstance ??= _$ScheduleDao(database, changeListener);
  }
}

class _$SlotDao extends SlotDao {
  _$SlotDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _slotInsertionAdapter = InsertionAdapter(
            database,
            'Slot',
            (Slot item) => <String, Object?>{'id': item.id, 'name': item.name},
            changeListener),
        _slotUpdateAdapter = UpdateAdapter(
            database,
            'Slot',
            ['id'],
            (Slot item) => <String, Object?>{'id': item.id, 'name': item.name},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Slot> _slotInsertionAdapter;

  final UpdateAdapter<Slot> _slotUpdateAdapter;

  @override
  Stream<List<Slot>> getAllSlots() {
    return _queryAdapter.queryListStream('SELECT * FROM Slot',
        mapper: (Map<String, Object?> row) =>
            Slot(row['id'] as int?, row['name'] as String),
        queryableName: 'Slot',
        isView: false);
  }

  @override
  Future<Slot?> getSlotById(int id) async {
    return _queryAdapter.query('SELECT * FROM Slot WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Slot(row['id'] as int?, row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertSlot(Slot slot) async {
    await _slotInsertionAdapter.insert(slot, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSlot(Slot slot) async {
    await _slotUpdateAdapter.update(slot, OnConflictStrategy.abort);
  }
}

class _$ScheduleDao extends ScheduleDao {
  _$ScheduleDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _scheduleInsertionAdapter = InsertionAdapter(
            database,
            'Schedule',
            (Schedule item) => <String, Object?>{
                  'id': item.id,
                  'slotId': item.slotId,
                  'time': _timeOfDayConverter.encode(item.time)
                },
            changeListener),
        _scheduleUpdateAdapter = UpdateAdapter(
            database,
            'Schedule',
            ['id'],
            (Schedule item) => <String, Object?>{
                  'id': item.id,
                  'slotId': item.slotId,
                  'time': _timeOfDayConverter.encode(item.time)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Schedule> _scheduleInsertionAdapter;

  final UpdateAdapter<Schedule> _scheduleUpdateAdapter;

  @override
  Stream<List<Schedule>> getAllSchedules() {
    return _queryAdapter.queryListStream('SELECT * FROM Schedule',
        mapper: (Map<String, Object?> row) => Schedule(row['slotId'] as int?,
            _timeOfDayConverter.decode(row['time'] as int),
            id: row['id'] as int?),
        queryableName: 'Schedule',
        isView: false);
  }

  @override
  Future<Schedule?> getScheduleById(int id) async {
    return _queryAdapter.query('SELECT * FROM Schedule WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Schedule(row['slotId'] as int?,
            _timeOfDayConverter.decode(row['time'] as int),
            id: row['id'] as int?),
        arguments: [id]);
  }

  @override
  Future<void> insertSchedule(Schedule schedule) async {
    await _scheduleInsertionAdapter.insert(schedule, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSchedule(Schedule schedule) async {
    await _scheduleUpdateAdapter.update(schedule, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _timeOfDayConverter = TimeOfDayConverter();

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$slotsByIdHash() => r'23e8767bb09e9bd634d6c724bf230840e83a6589';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef SlotsByIdRef = AutoDisposeFutureProviderRef<Slot?>;

/// See also [slotsById].
@ProviderFor(slotsById)
const slotsByIdProvider = SlotsByIdFamily();

/// See also [slotsById].
class SlotsByIdFamily extends Family<AsyncValue<Slot?>> {
  /// See also [slotsById].
  const SlotsByIdFamily();

  /// See also [slotsById].
  SlotsByIdProvider call(
    int id,
  ) {
    return SlotsByIdProvider(
      id,
    );
  }

  @override
  SlotsByIdProvider getProviderOverride(
    covariant SlotsByIdProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'slotsByIdProvider';
}

/// See also [slotsById].
class SlotsByIdProvider extends AutoDisposeFutureProvider<Slot?> {
  /// See also [slotsById].
  SlotsByIdProvider(
    this.id,
  ) : super.internal(
          (ref) => slotsById(
            ref,
            id,
          ),
          from: slotsByIdProvider,
          name: r'slotsByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$slotsByIdHash,
          dependencies: SlotsByIdFamily._dependencies,
          allTransitiveDependencies: SlotsByIdFamily._allTransitiveDependencies,
        );

  final int id;

  @override
  bool operator ==(Object other) {
    return other is SlotsByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
