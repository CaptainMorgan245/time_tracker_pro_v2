// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, DbSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _employeeNumberPrefixMeta =
      const VerificationMeta('employeeNumberPrefix');
  @override
  late final GeneratedColumn<String> employeeNumberPrefix =
      GeneratedColumn<String>(
        'employee_number_prefix',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nextEmployeeNumberMeta =
      const VerificationMeta('nextEmployeeNumber');
  @override
  late final GeneratedColumn<int> nextEmployeeNumber = GeneratedColumn<int>(
    'next_employee_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vehicleDesignationsMeta =
      const VerificationMeta('vehicleDesignations');
  @override
  late final GeneratedColumn<String> vehicleDesignations =
      GeneratedColumn<String>(
        'vehicle_designations',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _vendorsMeta = const VerificationMeta(
    'vendors',
  );
  @override
  late final GeneratedColumn<String> vendors = GeneratedColumn<String>(
    'vendors',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyHourlyRateMeta = const VerificationMeta(
    'companyHourlyRate',
  );
  @override
  late final GeneratedColumn<int> companyHourlyRate = GeneratedColumn<int>(
    'company_hourly_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _burdenRateMeta = const VerificationMeta(
    'burdenRate',
  );
  @override
  late final GeneratedColumn<double> burdenRate = GeneratedColumn<double>(
    'burden_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeRoundingIntervalMeta =
      const VerificationMeta('timeRoundingInterval');
  @override
  late final GeneratedColumn<int> timeRoundingInterval = GeneratedColumn<int>(
    'time_rounding_interval',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _autoBackupReminderFrequencyMeta =
      const VerificationMeta('autoBackupReminderFrequency');
  @override
  late final GeneratedColumn<int> autoBackupReminderFrequency =
      GeneratedColumn<int>(
        'auto_backup_reminder_frequency',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _appRunsSinceBackupMeta =
      const VerificationMeta('appRunsSinceBackup');
  @override
  late final GeneratedColumn<int> appRunsSinceBackup = GeneratedColumn<int>(
    'app_runs_since_backup',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _measurementSystemMeta = const VerificationMeta(
    'measurementSystem',
  );
  @override
  late final GeneratedColumn<String> measurementSystem =
      GeneratedColumn<String>(
        'measurement_system',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _defaultReportMonthsMeta =
      const VerificationMeta('defaultReportMonths');
  @override
  late final GeneratedColumn<int> defaultReportMonths = GeneratedColumn<int>(
    'default_report_months',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expenseMarkupPercentageMeta =
      const VerificationMeta('expenseMarkupPercentage');
  @override
  late final GeneratedColumn<double> expenseMarkupPercentage =
      GeneratedColumn<double>(
        'expense_markup_percentage',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _setupCompletedMeta = const VerificationMeta(
    'setupCompleted',
  );
  @override
  late final GeneratedColumn<int> setupCompleted = GeneratedColumn<int>(
    'setup_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeNumberPrefix,
    nextEmployeeNumber,
    vehicleDesignations,
    vendors,
    companyHourlyRate,
    burdenRate,
    timeRoundingInterval,
    autoBackupReminderFrequency,
    appRunsSinceBackup,
    measurementSystem,
    defaultReportMonths,
    expenseMarkupPercentage,
    setupCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_number_prefix')) {
      context.handle(
        _employeeNumberPrefixMeta,
        employeeNumberPrefix.isAcceptableOrUnknown(
          data['employee_number_prefix']!,
          _employeeNumberPrefixMeta,
        ),
      );
    }
    if (data.containsKey('next_employee_number')) {
      context.handle(
        _nextEmployeeNumberMeta,
        nextEmployeeNumber.isAcceptableOrUnknown(
          data['next_employee_number']!,
          _nextEmployeeNumberMeta,
        ),
      );
    }
    if (data.containsKey('vehicle_designations')) {
      context.handle(
        _vehicleDesignationsMeta,
        vehicleDesignations.isAcceptableOrUnknown(
          data['vehicle_designations']!,
          _vehicleDesignationsMeta,
        ),
      );
    }
    if (data.containsKey('vendors')) {
      context.handle(
        _vendorsMeta,
        vendors.isAcceptableOrUnknown(data['vendors']!, _vendorsMeta),
      );
    }
    if (data.containsKey('company_hourly_rate')) {
      context.handle(
        _companyHourlyRateMeta,
        companyHourlyRate.isAcceptableOrUnknown(
          data['company_hourly_rate']!,
          _companyHourlyRateMeta,
        ),
      );
    }
    if (data.containsKey('burden_rate')) {
      context.handle(
        _burdenRateMeta,
        burdenRate.isAcceptableOrUnknown(data['burden_rate']!, _burdenRateMeta),
      );
    }
    if (data.containsKey('time_rounding_interval')) {
      context.handle(
        _timeRoundingIntervalMeta,
        timeRoundingInterval.isAcceptableOrUnknown(
          data['time_rounding_interval']!,
          _timeRoundingIntervalMeta,
        ),
      );
    }
    if (data.containsKey('auto_backup_reminder_frequency')) {
      context.handle(
        _autoBackupReminderFrequencyMeta,
        autoBackupReminderFrequency.isAcceptableOrUnknown(
          data['auto_backup_reminder_frequency']!,
          _autoBackupReminderFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('app_runs_since_backup')) {
      context.handle(
        _appRunsSinceBackupMeta,
        appRunsSinceBackup.isAcceptableOrUnknown(
          data['app_runs_since_backup']!,
          _appRunsSinceBackupMeta,
        ),
      );
    }
    if (data.containsKey('measurement_system')) {
      context.handle(
        _measurementSystemMeta,
        measurementSystem.isAcceptableOrUnknown(
          data['measurement_system']!,
          _measurementSystemMeta,
        ),
      );
    }
    if (data.containsKey('default_report_months')) {
      context.handle(
        _defaultReportMonthsMeta,
        defaultReportMonths.isAcceptableOrUnknown(
          data['default_report_months']!,
          _defaultReportMonthsMeta,
        ),
      );
    }
    if (data.containsKey('expense_markup_percentage')) {
      context.handle(
        _expenseMarkupPercentageMeta,
        expenseMarkupPercentage.isAcceptableOrUnknown(
          data['expense_markup_percentage']!,
          _expenseMarkupPercentageMeta,
        ),
      );
    }
    if (data.containsKey('setup_completed')) {
      context.handle(
        _setupCompletedMeta,
        setupCompleted.isAcceptableOrUnknown(
          data['setup_completed']!,
          _setupCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      employeeNumberPrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_number_prefix'],
      ),
      nextEmployeeNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_employee_number'],
      ),
      vehicleDesignations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_designations'],
      ),
      vendors: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendors'],
      ),
      companyHourlyRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}company_hourly_rate'],
      ),
      burdenRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}burden_rate'],
      ),
      timeRoundingInterval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_rounding_interval'],
      ),
      autoBackupReminderFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}auto_backup_reminder_frequency'],
      ),
      appRunsSinceBackup: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}app_runs_since_backup'],
      ),
      measurementSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_system'],
      ),
      defaultReportMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_report_months'],
      ),
      expenseMarkupPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}expense_markup_percentage'],
      ),
      setupCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}setup_completed'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class DbSetting extends DataClass implements Insertable<DbSetting> {
  final int id;
  final String? employeeNumberPrefix;
  final int? nextEmployeeNumber;
  final String? vehicleDesignations;
  final String? vendors;
  final int? companyHourlyRate;
  final double? burdenRate;
  final int? timeRoundingInterval;
  final int? autoBackupReminderFrequency;
  final int? appRunsSinceBackup;
  final String? measurementSystem;
  final int? defaultReportMonths;
  final double? expenseMarkupPercentage;
  final int setupCompleted;
  const DbSetting({
    required this.id,
    this.employeeNumberPrefix,
    this.nextEmployeeNumber,
    this.vehicleDesignations,
    this.vendors,
    this.companyHourlyRate,
    this.burdenRate,
    this.timeRoundingInterval,
    this.autoBackupReminderFrequency,
    this.appRunsSinceBackup,
    this.measurementSystem,
    this.defaultReportMonths,
    this.expenseMarkupPercentage,
    required this.setupCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || employeeNumberPrefix != null) {
      map['employee_number_prefix'] = Variable<String>(employeeNumberPrefix);
    }
    if (!nullToAbsent || nextEmployeeNumber != null) {
      map['next_employee_number'] = Variable<int>(nextEmployeeNumber);
    }
    if (!nullToAbsent || vehicleDesignations != null) {
      map['vehicle_designations'] = Variable<String>(vehicleDesignations);
    }
    if (!nullToAbsent || vendors != null) {
      map['vendors'] = Variable<String>(vendors);
    }
    if (!nullToAbsent || companyHourlyRate != null) {
      map['company_hourly_rate'] = Variable<int>(companyHourlyRate);
    }
    if (!nullToAbsent || burdenRate != null) {
      map['burden_rate'] = Variable<double>(burdenRate);
    }
    if (!nullToAbsent || timeRoundingInterval != null) {
      map['time_rounding_interval'] = Variable<int>(timeRoundingInterval);
    }
    if (!nullToAbsent || autoBackupReminderFrequency != null) {
      map['auto_backup_reminder_frequency'] = Variable<int>(
        autoBackupReminderFrequency,
      );
    }
    if (!nullToAbsent || appRunsSinceBackup != null) {
      map['app_runs_since_backup'] = Variable<int>(appRunsSinceBackup);
    }
    if (!nullToAbsent || measurementSystem != null) {
      map['measurement_system'] = Variable<String>(measurementSystem);
    }
    if (!nullToAbsent || defaultReportMonths != null) {
      map['default_report_months'] = Variable<int>(defaultReportMonths);
    }
    if (!nullToAbsent || expenseMarkupPercentage != null) {
      map['expense_markup_percentage'] = Variable<double>(
        expenseMarkupPercentage,
      );
    }
    map['setup_completed'] = Variable<int>(setupCompleted);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      employeeNumberPrefix: employeeNumberPrefix == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeNumberPrefix),
      nextEmployeeNumber: nextEmployeeNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(nextEmployeeNumber),
      vehicleDesignations: vehicleDesignations == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleDesignations),
      vendors: vendors == null && nullToAbsent
          ? const Value.absent()
          : Value(vendors),
      companyHourlyRate: companyHourlyRate == null && nullToAbsent
          ? const Value.absent()
          : Value(companyHourlyRate),
      burdenRate: burdenRate == null && nullToAbsent
          ? const Value.absent()
          : Value(burdenRate),
      timeRoundingInterval: timeRoundingInterval == null && nullToAbsent
          ? const Value.absent()
          : Value(timeRoundingInterval),
      autoBackupReminderFrequency:
          autoBackupReminderFrequency == null && nullToAbsent
          ? const Value.absent()
          : Value(autoBackupReminderFrequency),
      appRunsSinceBackup: appRunsSinceBackup == null && nullToAbsent
          ? const Value.absent()
          : Value(appRunsSinceBackup),
      measurementSystem: measurementSystem == null && nullToAbsent
          ? const Value.absent()
          : Value(measurementSystem),
      defaultReportMonths: defaultReportMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultReportMonths),
      expenseMarkupPercentage: expenseMarkupPercentage == null && nullToAbsent
          ? const Value.absent()
          : Value(expenseMarkupPercentage),
      setupCompleted: Value(setupCompleted),
    );
  }

  factory DbSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbSetting(
      id: serializer.fromJson<int>(json['id']),
      employeeNumberPrefix: serializer.fromJson<String?>(
        json['employeeNumberPrefix'],
      ),
      nextEmployeeNumber: serializer.fromJson<int?>(json['nextEmployeeNumber']),
      vehicleDesignations: serializer.fromJson<String?>(
        json['vehicleDesignations'],
      ),
      vendors: serializer.fromJson<String?>(json['vendors']),
      companyHourlyRate: serializer.fromJson<int?>(json['companyHourlyRate']),
      burdenRate: serializer.fromJson<double?>(json['burdenRate']),
      timeRoundingInterval: serializer.fromJson<int?>(
        json['timeRoundingInterval'],
      ),
      autoBackupReminderFrequency: serializer.fromJson<int?>(
        json['autoBackupReminderFrequency'],
      ),
      appRunsSinceBackup: serializer.fromJson<int?>(json['appRunsSinceBackup']),
      measurementSystem: serializer.fromJson<String?>(
        json['measurementSystem'],
      ),
      defaultReportMonths: serializer.fromJson<int?>(
        json['defaultReportMonths'],
      ),
      expenseMarkupPercentage: serializer.fromJson<double?>(
        json['expenseMarkupPercentage'],
      ),
      setupCompleted: serializer.fromJson<int>(json['setupCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'employeeNumberPrefix': serializer.toJson<String?>(employeeNumberPrefix),
      'nextEmployeeNumber': serializer.toJson<int?>(nextEmployeeNumber),
      'vehicleDesignations': serializer.toJson<String?>(vehicleDesignations),
      'vendors': serializer.toJson<String?>(vendors),
      'companyHourlyRate': serializer.toJson<int?>(companyHourlyRate),
      'burdenRate': serializer.toJson<double?>(burdenRate),
      'timeRoundingInterval': serializer.toJson<int?>(timeRoundingInterval),
      'autoBackupReminderFrequency': serializer.toJson<int?>(
        autoBackupReminderFrequency,
      ),
      'appRunsSinceBackup': serializer.toJson<int?>(appRunsSinceBackup),
      'measurementSystem': serializer.toJson<String?>(measurementSystem),
      'defaultReportMonths': serializer.toJson<int?>(defaultReportMonths),
      'expenseMarkupPercentage': serializer.toJson<double?>(
        expenseMarkupPercentage,
      ),
      'setupCompleted': serializer.toJson<int>(setupCompleted),
    };
  }

  DbSetting copyWith({
    int? id,
    Value<String?> employeeNumberPrefix = const Value.absent(),
    Value<int?> nextEmployeeNumber = const Value.absent(),
    Value<String?> vehicleDesignations = const Value.absent(),
    Value<String?> vendors = const Value.absent(),
    Value<int?> companyHourlyRate = const Value.absent(),
    Value<double?> burdenRate = const Value.absent(),
    Value<int?> timeRoundingInterval = const Value.absent(),
    Value<int?> autoBackupReminderFrequency = const Value.absent(),
    Value<int?> appRunsSinceBackup = const Value.absent(),
    Value<String?> measurementSystem = const Value.absent(),
    Value<int?> defaultReportMonths = const Value.absent(),
    Value<double?> expenseMarkupPercentage = const Value.absent(),
    int? setupCompleted,
  }) => DbSetting(
    id: id ?? this.id,
    employeeNumberPrefix: employeeNumberPrefix.present
        ? employeeNumberPrefix.value
        : this.employeeNumberPrefix,
    nextEmployeeNumber: nextEmployeeNumber.present
        ? nextEmployeeNumber.value
        : this.nextEmployeeNumber,
    vehicleDesignations: vehicleDesignations.present
        ? vehicleDesignations.value
        : this.vehicleDesignations,
    vendors: vendors.present ? vendors.value : this.vendors,
    companyHourlyRate: companyHourlyRate.present
        ? companyHourlyRate.value
        : this.companyHourlyRate,
    burdenRate: burdenRate.present ? burdenRate.value : this.burdenRate,
    timeRoundingInterval: timeRoundingInterval.present
        ? timeRoundingInterval.value
        : this.timeRoundingInterval,
    autoBackupReminderFrequency: autoBackupReminderFrequency.present
        ? autoBackupReminderFrequency.value
        : this.autoBackupReminderFrequency,
    appRunsSinceBackup: appRunsSinceBackup.present
        ? appRunsSinceBackup.value
        : this.appRunsSinceBackup,
    measurementSystem: measurementSystem.present
        ? measurementSystem.value
        : this.measurementSystem,
    defaultReportMonths: defaultReportMonths.present
        ? defaultReportMonths.value
        : this.defaultReportMonths,
    expenseMarkupPercentage: expenseMarkupPercentage.present
        ? expenseMarkupPercentage.value
        : this.expenseMarkupPercentage,
    setupCompleted: setupCompleted ?? this.setupCompleted,
  );
  DbSetting copyWithCompanion(SettingsCompanion data) {
    return DbSetting(
      id: data.id.present ? data.id.value : this.id,
      employeeNumberPrefix: data.employeeNumberPrefix.present
          ? data.employeeNumberPrefix.value
          : this.employeeNumberPrefix,
      nextEmployeeNumber: data.nextEmployeeNumber.present
          ? data.nextEmployeeNumber.value
          : this.nextEmployeeNumber,
      vehicleDesignations: data.vehicleDesignations.present
          ? data.vehicleDesignations.value
          : this.vehicleDesignations,
      vendors: data.vendors.present ? data.vendors.value : this.vendors,
      companyHourlyRate: data.companyHourlyRate.present
          ? data.companyHourlyRate.value
          : this.companyHourlyRate,
      burdenRate: data.burdenRate.present
          ? data.burdenRate.value
          : this.burdenRate,
      timeRoundingInterval: data.timeRoundingInterval.present
          ? data.timeRoundingInterval.value
          : this.timeRoundingInterval,
      autoBackupReminderFrequency: data.autoBackupReminderFrequency.present
          ? data.autoBackupReminderFrequency.value
          : this.autoBackupReminderFrequency,
      appRunsSinceBackup: data.appRunsSinceBackup.present
          ? data.appRunsSinceBackup.value
          : this.appRunsSinceBackup,
      measurementSystem: data.measurementSystem.present
          ? data.measurementSystem.value
          : this.measurementSystem,
      defaultReportMonths: data.defaultReportMonths.present
          ? data.defaultReportMonths.value
          : this.defaultReportMonths,
      expenseMarkupPercentage: data.expenseMarkupPercentage.present
          ? data.expenseMarkupPercentage.value
          : this.expenseMarkupPercentage,
      setupCompleted: data.setupCompleted.present
          ? data.setupCompleted.value
          : this.setupCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbSetting(')
          ..write('id: $id, ')
          ..write('employeeNumberPrefix: $employeeNumberPrefix, ')
          ..write('nextEmployeeNumber: $nextEmployeeNumber, ')
          ..write('vehicleDesignations: $vehicleDesignations, ')
          ..write('vendors: $vendors, ')
          ..write('companyHourlyRate: $companyHourlyRate, ')
          ..write('burdenRate: $burdenRate, ')
          ..write('timeRoundingInterval: $timeRoundingInterval, ')
          ..write('autoBackupReminderFrequency: $autoBackupReminderFrequency, ')
          ..write('appRunsSinceBackup: $appRunsSinceBackup, ')
          ..write('measurementSystem: $measurementSystem, ')
          ..write('defaultReportMonths: $defaultReportMonths, ')
          ..write('expenseMarkupPercentage: $expenseMarkupPercentage, ')
          ..write('setupCompleted: $setupCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    employeeNumberPrefix,
    nextEmployeeNumber,
    vehicleDesignations,
    vendors,
    companyHourlyRate,
    burdenRate,
    timeRoundingInterval,
    autoBackupReminderFrequency,
    appRunsSinceBackup,
    measurementSystem,
    defaultReportMonths,
    expenseMarkupPercentage,
    setupCompleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbSetting &&
          other.id == this.id &&
          other.employeeNumberPrefix == this.employeeNumberPrefix &&
          other.nextEmployeeNumber == this.nextEmployeeNumber &&
          other.vehicleDesignations == this.vehicleDesignations &&
          other.vendors == this.vendors &&
          other.companyHourlyRate == this.companyHourlyRate &&
          other.burdenRate == this.burdenRate &&
          other.timeRoundingInterval == this.timeRoundingInterval &&
          other.autoBackupReminderFrequency ==
              this.autoBackupReminderFrequency &&
          other.appRunsSinceBackup == this.appRunsSinceBackup &&
          other.measurementSystem == this.measurementSystem &&
          other.defaultReportMonths == this.defaultReportMonths &&
          other.expenseMarkupPercentage == this.expenseMarkupPercentage &&
          other.setupCompleted == this.setupCompleted);
}

class SettingsCompanion extends UpdateCompanion<DbSetting> {
  final Value<int> id;
  final Value<String?> employeeNumberPrefix;
  final Value<int?> nextEmployeeNumber;
  final Value<String?> vehicleDesignations;
  final Value<String?> vendors;
  final Value<int?> companyHourlyRate;
  final Value<double?> burdenRate;
  final Value<int?> timeRoundingInterval;
  final Value<int?> autoBackupReminderFrequency;
  final Value<int?> appRunsSinceBackup;
  final Value<String?> measurementSystem;
  final Value<int?> defaultReportMonths;
  final Value<double?> expenseMarkupPercentage;
  final Value<int> setupCompleted;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.employeeNumberPrefix = const Value.absent(),
    this.nextEmployeeNumber = const Value.absent(),
    this.vehicleDesignations = const Value.absent(),
    this.vendors = const Value.absent(),
    this.companyHourlyRate = const Value.absent(),
    this.burdenRate = const Value.absent(),
    this.timeRoundingInterval = const Value.absent(),
    this.autoBackupReminderFrequency = const Value.absent(),
    this.appRunsSinceBackup = const Value.absent(),
    this.measurementSystem = const Value.absent(),
    this.defaultReportMonths = const Value.absent(),
    this.expenseMarkupPercentage = const Value.absent(),
    this.setupCompleted = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.employeeNumberPrefix = const Value.absent(),
    this.nextEmployeeNumber = const Value.absent(),
    this.vehicleDesignations = const Value.absent(),
    this.vendors = const Value.absent(),
    this.companyHourlyRate = const Value.absent(),
    this.burdenRate = const Value.absent(),
    this.timeRoundingInterval = const Value.absent(),
    this.autoBackupReminderFrequency = const Value.absent(),
    this.appRunsSinceBackup = const Value.absent(),
    this.measurementSystem = const Value.absent(),
    this.defaultReportMonths = const Value.absent(),
    this.expenseMarkupPercentage = const Value.absent(),
    this.setupCompleted = const Value.absent(),
  });
  static Insertable<DbSetting> custom({
    Expression<int>? id,
    Expression<String>? employeeNumberPrefix,
    Expression<int>? nextEmployeeNumber,
    Expression<String>? vehicleDesignations,
    Expression<String>? vendors,
    Expression<int>? companyHourlyRate,
    Expression<double>? burdenRate,
    Expression<int>? timeRoundingInterval,
    Expression<int>? autoBackupReminderFrequency,
    Expression<int>? appRunsSinceBackup,
    Expression<String>? measurementSystem,
    Expression<int>? defaultReportMonths,
    Expression<double>? expenseMarkupPercentage,
    Expression<int>? setupCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeNumberPrefix != null)
        'employee_number_prefix': employeeNumberPrefix,
      if (nextEmployeeNumber != null)
        'next_employee_number': nextEmployeeNumber,
      if (vehicleDesignations != null)
        'vehicle_designations': vehicleDesignations,
      if (vendors != null) 'vendors': vendors,
      if (companyHourlyRate != null) 'company_hourly_rate': companyHourlyRate,
      if (burdenRate != null) 'burden_rate': burdenRate,
      if (timeRoundingInterval != null)
        'time_rounding_interval': timeRoundingInterval,
      if (autoBackupReminderFrequency != null)
        'auto_backup_reminder_frequency': autoBackupReminderFrequency,
      if (appRunsSinceBackup != null)
        'app_runs_since_backup': appRunsSinceBackup,
      if (measurementSystem != null) 'measurement_system': measurementSystem,
      if (defaultReportMonths != null)
        'default_report_months': defaultReportMonths,
      if (expenseMarkupPercentage != null)
        'expense_markup_percentage': expenseMarkupPercentage,
      if (setupCompleted != null) 'setup_completed': setupCompleted,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<String?>? employeeNumberPrefix,
    Value<int?>? nextEmployeeNumber,
    Value<String?>? vehicleDesignations,
    Value<String?>? vendors,
    Value<int?>? companyHourlyRate,
    Value<double?>? burdenRate,
    Value<int?>? timeRoundingInterval,
    Value<int?>? autoBackupReminderFrequency,
    Value<int?>? appRunsSinceBackup,
    Value<String?>? measurementSystem,
    Value<int?>? defaultReportMonths,
    Value<double?>? expenseMarkupPercentage,
    Value<int>? setupCompleted,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      employeeNumberPrefix: employeeNumberPrefix ?? this.employeeNumberPrefix,
      nextEmployeeNumber: nextEmployeeNumber ?? this.nextEmployeeNumber,
      vehicleDesignations: vehicleDesignations ?? this.vehicleDesignations,
      vendors: vendors ?? this.vendors,
      companyHourlyRate: companyHourlyRate ?? this.companyHourlyRate,
      burdenRate: burdenRate ?? this.burdenRate,
      timeRoundingInterval: timeRoundingInterval ?? this.timeRoundingInterval,
      autoBackupReminderFrequency:
          autoBackupReminderFrequency ?? this.autoBackupReminderFrequency,
      appRunsSinceBackup: appRunsSinceBackup ?? this.appRunsSinceBackup,
      measurementSystem: measurementSystem ?? this.measurementSystem,
      defaultReportMonths: defaultReportMonths ?? this.defaultReportMonths,
      expenseMarkupPercentage:
          expenseMarkupPercentage ?? this.expenseMarkupPercentage,
      setupCompleted: setupCompleted ?? this.setupCompleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (employeeNumberPrefix.present) {
      map['employee_number_prefix'] = Variable<String>(
        employeeNumberPrefix.value,
      );
    }
    if (nextEmployeeNumber.present) {
      map['next_employee_number'] = Variable<int>(nextEmployeeNumber.value);
    }
    if (vehicleDesignations.present) {
      map['vehicle_designations'] = Variable<String>(vehicleDesignations.value);
    }
    if (vendors.present) {
      map['vendors'] = Variable<String>(vendors.value);
    }
    if (companyHourlyRate.present) {
      map['company_hourly_rate'] = Variable<int>(companyHourlyRate.value);
    }
    if (burdenRate.present) {
      map['burden_rate'] = Variable<double>(burdenRate.value);
    }
    if (timeRoundingInterval.present) {
      map['time_rounding_interval'] = Variable<int>(timeRoundingInterval.value);
    }
    if (autoBackupReminderFrequency.present) {
      map['auto_backup_reminder_frequency'] = Variable<int>(
        autoBackupReminderFrequency.value,
      );
    }
    if (appRunsSinceBackup.present) {
      map['app_runs_since_backup'] = Variable<int>(appRunsSinceBackup.value);
    }
    if (measurementSystem.present) {
      map['measurement_system'] = Variable<String>(measurementSystem.value);
    }
    if (defaultReportMonths.present) {
      map['default_report_months'] = Variable<int>(defaultReportMonths.value);
    }
    if (expenseMarkupPercentage.present) {
      map['expense_markup_percentage'] = Variable<double>(
        expenseMarkupPercentage.value,
      );
    }
    if (setupCompleted.present) {
      map['setup_completed'] = Variable<int>(setupCompleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('employeeNumberPrefix: $employeeNumberPrefix, ')
          ..write('nextEmployeeNumber: $nextEmployeeNumber, ')
          ..write('vehicleDesignations: $vehicleDesignations, ')
          ..write('vendors: $vendors, ')
          ..write('companyHourlyRate: $companyHourlyRate, ')
          ..write('burdenRate: $burdenRate, ')
          ..write('timeRoundingInterval: $timeRoundingInterval, ')
          ..write('autoBackupReminderFrequency: $autoBackupReminderFrequency, ')
          ..write('appRunsSinceBackup: $appRunsSinceBackup, ')
          ..write('measurementSystem: $measurementSystem, ')
          ..write('defaultReportMonths: $defaultReportMonths, ')
          ..write('expenseMarkupPercentage: $expenseMarkupPercentage, ')
          ..write('setupCompleted: $setupCompleted')
          ..write(')'))
        .toString();
  }
}

class $ClientsTable extends Clients with TableInfo<$ClientsTable, DbClient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _contactPersonMeta = const VerificationMeta(
    'contactPerson',
  );
  @override
  late final GeneratedColumn<String> contactPerson = GeneratedColumn<String>(
    'contact_person',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isActive,
    contactPerson,
    phoneNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbClient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('contact_person')) {
      context.handle(
        _contactPersonMeta,
        contactPerson.isAcceptableOrUnknown(
          data['contact_person']!,
          _contactPersonMeta,
        ),
      );
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbClient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbClient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      )!,
      contactPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_person'],
      ),
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }
}

class DbClient extends DataClass implements Insertable<DbClient> {
  final int id;
  final String name;
  final int isActive;
  final String? contactPerson;
  final String? phoneNumber;
  const DbClient({
    required this.id,
    required this.name,
    required this.isActive,
    this.contactPerson,
    this.phoneNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<int>(isActive);
    if (!nullToAbsent || contactPerson != null) {
      map['contact_person'] = Variable<String>(contactPerson);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      name: Value(name),
      isActive: Value(isActive),
      contactPerson: contactPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPerson),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
    );
  }

  factory DbClient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbClient(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<int>(json['isActive']),
      contactPerson: serializer.fromJson<String?>(json['contactPerson']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<int>(isActive),
      'contactPerson': serializer.toJson<String?>(contactPerson),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
    };
  }

  DbClient copyWith({
    int? id,
    String? name,
    int? isActive,
    Value<String?> contactPerson = const Value.absent(),
    Value<String?> phoneNumber = const Value.absent(),
  }) => DbClient(
    id: id ?? this.id,
    name: name ?? this.name,
    isActive: isActive ?? this.isActive,
    contactPerson: contactPerson.present
        ? contactPerson.value
        : this.contactPerson,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
  );
  DbClient copyWithCompanion(ClientsCompanion data) {
    return DbClient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      contactPerson: data.contactPerson.present
          ? data.contactPerson.value
          : this.contactPerson,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbClient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('phoneNumber: $phoneNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, isActive, contactPerson, phoneNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbClient &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.contactPerson == this.contactPerson &&
          other.phoneNumber == this.phoneNumber);
}

class ClientsCompanion extends UpdateCompanion<DbClient> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> isActive;
  final Value<String?> contactPerson;
  final Value<String?> phoneNumber;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.contactPerson = const Value.absent(),
    this.phoneNumber = const Value.absent(),
  });
  ClientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isActive = const Value.absent(),
    this.contactPerson = const Value.absent(),
    this.phoneNumber = const Value.absent(),
  }) : name = Value(name);
  static Insertable<DbClient> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? isActive,
    Expression<String>? contactPerson,
    Expression<String>? phoneNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (contactPerson != null) 'contact_person': contactPerson,
      if (phoneNumber != null) 'phone_number': phoneNumber,
    });
  }

  ClientsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? isActive,
    Value<String?>? contactPerson,
    Value<String?>? phoneNumber,
  }) {
    return ClientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      contactPerson: contactPerson ?? this.contactPerson,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (contactPerson.present) {
      map['contact_person'] = Variable<String>(contactPerson.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('phoneNumber: $phoneNumber')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects
    with TableInfo<$ProjectsTable, DbProject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _projectNameMeta = const VerificationMeta(
    'projectName',
  );
  @override
  late final GeneratedColumn<String> projectName = GeneratedColumn<String>(
    'project_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id)',
    ),
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _streetAddressMeta = const VerificationMeta(
    'streetAddress',
  );
  @override
  late final GeneratedColumn<String> streetAddress = GeneratedColumn<String>(
    'street_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _postalCodeMeta = const VerificationMeta(
    'postalCode',
  );
  @override
  late final GeneratedColumn<String> postalCode = GeneratedColumn<String>(
    'postal_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pricingModelMeta = const VerificationMeta(
    'pricingModel',
  );
  @override
  late final GeneratedColumn<String> pricingModel = GeneratedColumn<String>(
    'pricing_model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('hourly'),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<int> isCompleted = GeneratedColumn<int>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completionDateMeta = const VerificationMeta(
    'completionDate',
  );
  @override
  late final GeneratedColumn<String> completionDate = GeneratedColumn<String>(
    'completion_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isInternalMeta = const VerificationMeta(
    'isInternal',
  );
  @override
  late final GeneratedColumn<int> isInternal = GeneratedColumn<int>(
    'is_internal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _billedHourlyRateMeta = const VerificationMeta(
    'billedHourlyRate',
  );
  @override
  late final GeneratedColumn<int> billedHourlyRate = GeneratedColumn<int>(
    'billed_hourly_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _projectPriceMeta = const VerificationMeta(
    'projectPrice',
  );
  @override
  late final GeneratedColumn<int> projectPrice = GeneratedColumn<int>(
    'project_price',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expenseMarkupPercentageMeta =
      const VerificationMeta('expenseMarkupPercentage');
  @override
  late final GeneratedColumn<double> expenseMarkupPercentage =
      GeneratedColumn<double>(
        'expense_markup_percentage',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(15.0),
      );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(5.0),
  );
  static const VerificationMeta _parentProjectIdMeta = const VerificationMeta(
    'parentProjectId',
  );
  @override
  late final GeneratedColumn<int> parentProjectId = GeneratedColumn<int>(
    'parent_project_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectName,
    clientId,
    city,
    streetAddress,
    region,
    postalCode,
    pricingModel,
    isCompleted,
    completionDate,
    isInternal,
    billedHourlyRate,
    projectPrice,
    expenseMarkupPercentage,
    taxRate,
    parentProjectId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbProject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_name')) {
      context.handle(
        _projectNameMeta,
        projectName.isAcceptableOrUnknown(
          data['project_name']!,
          _projectNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_projectNameMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('street_address')) {
      context.handle(
        _streetAddressMeta,
        streetAddress.isAcceptableOrUnknown(
          data['street_address']!,
          _streetAddressMeta,
        ),
      );
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('postal_code')) {
      context.handle(
        _postalCodeMeta,
        postalCode.isAcceptableOrUnknown(data['postal_code']!, _postalCodeMeta),
      );
    }
    if (data.containsKey('pricing_model')) {
      context.handle(
        _pricingModelMeta,
        pricingModel.isAcceptableOrUnknown(
          data['pricing_model']!,
          _pricingModelMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completion_date')) {
      context.handle(
        _completionDateMeta,
        completionDate.isAcceptableOrUnknown(
          data['completion_date']!,
          _completionDateMeta,
        ),
      );
    }
    if (data.containsKey('is_internal')) {
      context.handle(
        _isInternalMeta,
        isInternal.isAcceptableOrUnknown(data['is_internal']!, _isInternalMeta),
      );
    }
    if (data.containsKey('billed_hourly_rate')) {
      context.handle(
        _billedHourlyRateMeta,
        billedHourlyRate.isAcceptableOrUnknown(
          data['billed_hourly_rate']!,
          _billedHourlyRateMeta,
        ),
      );
    }
    if (data.containsKey('project_price')) {
      context.handle(
        _projectPriceMeta,
        projectPrice.isAcceptableOrUnknown(
          data['project_price']!,
          _projectPriceMeta,
        ),
      );
    }
    if (data.containsKey('expense_markup_percentage')) {
      context.handle(
        _expenseMarkupPercentageMeta,
        expenseMarkupPercentage.isAcceptableOrUnknown(
          data['expense_markup_percentage']!,
          _expenseMarkupPercentageMeta,
        ),
      );
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    }
    if (data.containsKey('parent_project_id')) {
      context.handle(
        _parentProjectIdMeta,
        parentProjectId.isAcceptableOrUnknown(
          data['parent_project_id']!,
          _parentProjectIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbProject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbProject(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_name'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_id'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      streetAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}street_address'],
      ),
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      ),
      postalCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}postal_code'],
      ),
      pricingModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pricing_model'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_completed'],
      )!,
      completionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completion_date'],
      ),
      isInternal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_internal'],
      )!,
      billedHourlyRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}billed_hourly_rate'],
      ),
      projectPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_price'],
      ),
      expenseMarkupPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}expense_markup_percentage'],
      )!,
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      parentProjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_project_id'],
      ),
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class DbProject extends DataClass implements Insertable<DbProject> {
  final int id;
  final String projectName;
  final int clientId;
  final String? city;
  final String? streetAddress;
  final String? region;
  final String? postalCode;
  final String pricingModel;
  final int isCompleted;
  final String? completionDate;
  final int isInternal;
  final int? billedHourlyRate;
  final int? projectPrice;
  final double expenseMarkupPercentage;
  final double taxRate;
  final int? parentProjectId;
  const DbProject({
    required this.id,
    required this.projectName,
    required this.clientId,
    this.city,
    this.streetAddress,
    this.region,
    this.postalCode,
    required this.pricingModel,
    required this.isCompleted,
    this.completionDate,
    required this.isInternal,
    this.billedHourlyRate,
    this.projectPrice,
    required this.expenseMarkupPercentage,
    required this.taxRate,
    this.parentProjectId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_name'] = Variable<String>(projectName);
    map['client_id'] = Variable<int>(clientId);
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || streetAddress != null) {
      map['street_address'] = Variable<String>(streetAddress);
    }
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
    if (!nullToAbsent || postalCode != null) {
      map['postal_code'] = Variable<String>(postalCode);
    }
    map['pricing_model'] = Variable<String>(pricingModel);
    map['is_completed'] = Variable<int>(isCompleted);
    if (!nullToAbsent || completionDate != null) {
      map['completion_date'] = Variable<String>(completionDate);
    }
    map['is_internal'] = Variable<int>(isInternal);
    if (!nullToAbsent || billedHourlyRate != null) {
      map['billed_hourly_rate'] = Variable<int>(billedHourlyRate);
    }
    if (!nullToAbsent || projectPrice != null) {
      map['project_price'] = Variable<int>(projectPrice);
    }
    map['expense_markup_percentage'] = Variable<double>(
      expenseMarkupPercentage,
    );
    map['tax_rate'] = Variable<double>(taxRate);
    if (!nullToAbsent || parentProjectId != null) {
      map['parent_project_id'] = Variable<int>(parentProjectId);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      projectName: Value(projectName),
      clientId: Value(clientId),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      streetAddress: streetAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(streetAddress),
      region: region == null && nullToAbsent
          ? const Value.absent()
          : Value(region),
      postalCode: postalCode == null && nullToAbsent
          ? const Value.absent()
          : Value(postalCode),
      pricingModel: Value(pricingModel),
      isCompleted: Value(isCompleted),
      completionDate: completionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(completionDate),
      isInternal: Value(isInternal),
      billedHourlyRate: billedHourlyRate == null && nullToAbsent
          ? const Value.absent()
          : Value(billedHourlyRate),
      projectPrice: projectPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(projectPrice),
      expenseMarkupPercentage: Value(expenseMarkupPercentage),
      taxRate: Value(taxRate),
      parentProjectId: parentProjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentProjectId),
    );
  }

  factory DbProject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbProject(
      id: serializer.fromJson<int>(json['id']),
      projectName: serializer.fromJson<String>(json['projectName']),
      clientId: serializer.fromJson<int>(json['clientId']),
      city: serializer.fromJson<String?>(json['city']),
      streetAddress: serializer.fromJson<String?>(json['streetAddress']),
      region: serializer.fromJson<String?>(json['region']),
      postalCode: serializer.fromJson<String?>(json['postalCode']),
      pricingModel: serializer.fromJson<String>(json['pricingModel']),
      isCompleted: serializer.fromJson<int>(json['isCompleted']),
      completionDate: serializer.fromJson<String?>(json['completionDate']),
      isInternal: serializer.fromJson<int>(json['isInternal']),
      billedHourlyRate: serializer.fromJson<int?>(json['billedHourlyRate']),
      projectPrice: serializer.fromJson<int?>(json['projectPrice']),
      expenseMarkupPercentage: serializer.fromJson<double>(
        json['expenseMarkupPercentage'],
      ),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      parentProjectId: serializer.fromJson<int?>(json['parentProjectId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectName': serializer.toJson<String>(projectName),
      'clientId': serializer.toJson<int>(clientId),
      'city': serializer.toJson<String?>(city),
      'streetAddress': serializer.toJson<String?>(streetAddress),
      'region': serializer.toJson<String?>(region),
      'postalCode': serializer.toJson<String?>(postalCode),
      'pricingModel': serializer.toJson<String>(pricingModel),
      'isCompleted': serializer.toJson<int>(isCompleted),
      'completionDate': serializer.toJson<String?>(completionDate),
      'isInternal': serializer.toJson<int>(isInternal),
      'billedHourlyRate': serializer.toJson<int?>(billedHourlyRate),
      'projectPrice': serializer.toJson<int?>(projectPrice),
      'expenseMarkupPercentage': serializer.toJson<double>(
        expenseMarkupPercentage,
      ),
      'taxRate': serializer.toJson<double>(taxRate),
      'parentProjectId': serializer.toJson<int?>(parentProjectId),
    };
  }

  DbProject copyWith({
    int? id,
    String? projectName,
    int? clientId,
    Value<String?> city = const Value.absent(),
    Value<String?> streetAddress = const Value.absent(),
    Value<String?> region = const Value.absent(),
    Value<String?> postalCode = const Value.absent(),
    String? pricingModel,
    int? isCompleted,
    Value<String?> completionDate = const Value.absent(),
    int? isInternal,
    Value<int?> billedHourlyRate = const Value.absent(),
    Value<int?> projectPrice = const Value.absent(),
    double? expenseMarkupPercentage,
    double? taxRate,
    Value<int?> parentProjectId = const Value.absent(),
  }) => DbProject(
    id: id ?? this.id,
    projectName: projectName ?? this.projectName,
    clientId: clientId ?? this.clientId,
    city: city.present ? city.value : this.city,
    streetAddress: streetAddress.present
        ? streetAddress.value
        : this.streetAddress,
    region: region.present ? region.value : this.region,
    postalCode: postalCode.present ? postalCode.value : this.postalCode,
    pricingModel: pricingModel ?? this.pricingModel,
    isCompleted: isCompleted ?? this.isCompleted,
    completionDate: completionDate.present
        ? completionDate.value
        : this.completionDate,
    isInternal: isInternal ?? this.isInternal,
    billedHourlyRate: billedHourlyRate.present
        ? billedHourlyRate.value
        : this.billedHourlyRate,
    projectPrice: projectPrice.present ? projectPrice.value : this.projectPrice,
    expenseMarkupPercentage:
        expenseMarkupPercentage ?? this.expenseMarkupPercentage,
    taxRate: taxRate ?? this.taxRate,
    parentProjectId: parentProjectId.present
        ? parentProjectId.value
        : this.parentProjectId,
  );
  DbProject copyWithCompanion(ProjectsCompanion data) {
    return DbProject(
      id: data.id.present ? data.id.value : this.id,
      projectName: data.projectName.present
          ? data.projectName.value
          : this.projectName,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      city: data.city.present ? data.city.value : this.city,
      streetAddress: data.streetAddress.present
          ? data.streetAddress.value
          : this.streetAddress,
      region: data.region.present ? data.region.value : this.region,
      postalCode: data.postalCode.present
          ? data.postalCode.value
          : this.postalCode,
      pricingModel: data.pricingModel.present
          ? data.pricingModel.value
          : this.pricingModel,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completionDate: data.completionDate.present
          ? data.completionDate.value
          : this.completionDate,
      isInternal: data.isInternal.present
          ? data.isInternal.value
          : this.isInternal,
      billedHourlyRate: data.billedHourlyRate.present
          ? data.billedHourlyRate.value
          : this.billedHourlyRate,
      projectPrice: data.projectPrice.present
          ? data.projectPrice.value
          : this.projectPrice,
      expenseMarkupPercentage: data.expenseMarkupPercentage.present
          ? data.expenseMarkupPercentage.value
          : this.expenseMarkupPercentage,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      parentProjectId: data.parentProjectId.present
          ? data.parentProjectId.value
          : this.parentProjectId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbProject(')
          ..write('id: $id, ')
          ..write('projectName: $projectName, ')
          ..write('clientId: $clientId, ')
          ..write('city: $city, ')
          ..write('streetAddress: $streetAddress, ')
          ..write('region: $region, ')
          ..write('postalCode: $postalCode, ')
          ..write('pricingModel: $pricingModel, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completionDate: $completionDate, ')
          ..write('isInternal: $isInternal, ')
          ..write('billedHourlyRate: $billedHourlyRate, ')
          ..write('projectPrice: $projectPrice, ')
          ..write('expenseMarkupPercentage: $expenseMarkupPercentage, ')
          ..write('taxRate: $taxRate, ')
          ..write('parentProjectId: $parentProjectId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectName,
    clientId,
    city,
    streetAddress,
    region,
    postalCode,
    pricingModel,
    isCompleted,
    completionDate,
    isInternal,
    billedHourlyRate,
    projectPrice,
    expenseMarkupPercentage,
    taxRate,
    parentProjectId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbProject &&
          other.id == this.id &&
          other.projectName == this.projectName &&
          other.clientId == this.clientId &&
          other.city == this.city &&
          other.streetAddress == this.streetAddress &&
          other.region == this.region &&
          other.postalCode == this.postalCode &&
          other.pricingModel == this.pricingModel &&
          other.isCompleted == this.isCompleted &&
          other.completionDate == this.completionDate &&
          other.isInternal == this.isInternal &&
          other.billedHourlyRate == this.billedHourlyRate &&
          other.projectPrice == this.projectPrice &&
          other.expenseMarkupPercentage == this.expenseMarkupPercentage &&
          other.taxRate == this.taxRate &&
          other.parentProjectId == this.parentProjectId);
}

class ProjectsCompanion extends UpdateCompanion<DbProject> {
  final Value<int> id;
  final Value<String> projectName;
  final Value<int> clientId;
  final Value<String?> city;
  final Value<String?> streetAddress;
  final Value<String?> region;
  final Value<String?> postalCode;
  final Value<String> pricingModel;
  final Value<int> isCompleted;
  final Value<String?> completionDate;
  final Value<int> isInternal;
  final Value<int?> billedHourlyRate;
  final Value<int?> projectPrice;
  final Value<double> expenseMarkupPercentage;
  final Value<double> taxRate;
  final Value<int?> parentProjectId;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.projectName = const Value.absent(),
    this.clientId = const Value.absent(),
    this.city = const Value.absent(),
    this.streetAddress = const Value.absent(),
    this.region = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.pricingModel = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completionDate = const Value.absent(),
    this.isInternal = const Value.absent(),
    this.billedHourlyRate = const Value.absent(),
    this.projectPrice = const Value.absent(),
    this.expenseMarkupPercentage = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.parentProjectId = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String projectName,
    required int clientId,
    this.city = const Value.absent(),
    this.streetAddress = const Value.absent(),
    this.region = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.pricingModel = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completionDate = const Value.absent(),
    this.isInternal = const Value.absent(),
    this.billedHourlyRate = const Value.absent(),
    this.projectPrice = const Value.absent(),
    this.expenseMarkupPercentage = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.parentProjectId = const Value.absent(),
  }) : projectName = Value(projectName),
       clientId = Value(clientId);
  static Insertable<DbProject> custom({
    Expression<int>? id,
    Expression<String>? projectName,
    Expression<int>? clientId,
    Expression<String>? city,
    Expression<String>? streetAddress,
    Expression<String>? region,
    Expression<String>? postalCode,
    Expression<String>? pricingModel,
    Expression<int>? isCompleted,
    Expression<String>? completionDate,
    Expression<int>? isInternal,
    Expression<int>? billedHourlyRate,
    Expression<int>? projectPrice,
    Expression<double>? expenseMarkupPercentage,
    Expression<double>? taxRate,
    Expression<int>? parentProjectId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectName != null) 'project_name': projectName,
      if (clientId != null) 'client_id': clientId,
      if (city != null) 'city': city,
      if (streetAddress != null) 'street_address': streetAddress,
      if (region != null) 'region': region,
      if (postalCode != null) 'postal_code': postalCode,
      if (pricingModel != null) 'pricing_model': pricingModel,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completionDate != null) 'completion_date': completionDate,
      if (isInternal != null) 'is_internal': isInternal,
      if (billedHourlyRate != null) 'billed_hourly_rate': billedHourlyRate,
      if (projectPrice != null) 'project_price': projectPrice,
      if (expenseMarkupPercentage != null)
        'expense_markup_percentage': expenseMarkupPercentage,
      if (taxRate != null) 'tax_rate': taxRate,
      if (parentProjectId != null) 'parent_project_id': parentProjectId,
    });
  }

  ProjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? projectName,
    Value<int>? clientId,
    Value<String?>? city,
    Value<String?>? streetAddress,
    Value<String?>? region,
    Value<String?>? postalCode,
    Value<String>? pricingModel,
    Value<int>? isCompleted,
    Value<String?>? completionDate,
    Value<int>? isInternal,
    Value<int?>? billedHourlyRate,
    Value<int?>? projectPrice,
    Value<double>? expenseMarkupPercentage,
    Value<double>? taxRate,
    Value<int?>? parentProjectId,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      clientId: clientId ?? this.clientId,
      city: city ?? this.city,
      streetAddress: streetAddress ?? this.streetAddress,
      region: region ?? this.region,
      postalCode: postalCode ?? this.postalCode,
      pricingModel: pricingModel ?? this.pricingModel,
      isCompleted: isCompleted ?? this.isCompleted,
      completionDate: completionDate ?? this.completionDate,
      isInternal: isInternal ?? this.isInternal,
      billedHourlyRate: billedHourlyRate ?? this.billedHourlyRate,
      projectPrice: projectPrice ?? this.projectPrice,
      expenseMarkupPercentage:
          expenseMarkupPercentage ?? this.expenseMarkupPercentage,
      taxRate: taxRate ?? this.taxRate,
      parentProjectId: parentProjectId ?? this.parentProjectId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectName.present) {
      map['project_name'] = Variable<String>(projectName.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (streetAddress.present) {
      map['street_address'] = Variable<String>(streetAddress.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (postalCode.present) {
      map['postal_code'] = Variable<String>(postalCode.value);
    }
    if (pricingModel.present) {
      map['pricing_model'] = Variable<String>(pricingModel.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<int>(isCompleted.value);
    }
    if (completionDate.present) {
      map['completion_date'] = Variable<String>(completionDate.value);
    }
    if (isInternal.present) {
      map['is_internal'] = Variable<int>(isInternal.value);
    }
    if (billedHourlyRate.present) {
      map['billed_hourly_rate'] = Variable<int>(billedHourlyRate.value);
    }
    if (projectPrice.present) {
      map['project_price'] = Variable<int>(projectPrice.value);
    }
    if (expenseMarkupPercentage.present) {
      map['expense_markup_percentage'] = Variable<double>(
        expenseMarkupPercentage.value,
      );
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (parentProjectId.present) {
      map['parent_project_id'] = Variable<int>(parentProjectId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('projectName: $projectName, ')
          ..write('clientId: $clientId, ')
          ..write('city: $city, ')
          ..write('streetAddress: $streetAddress, ')
          ..write('region: $region, ')
          ..write('postalCode: $postalCode, ')
          ..write('pricingModel: $pricingModel, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completionDate: $completionDate, ')
          ..write('isInternal: $isInternal, ')
          ..write('billedHourlyRate: $billedHourlyRate, ')
          ..write('projectPrice: $projectPrice, ')
          ..write('expenseMarkupPercentage: $expenseMarkupPercentage, ')
          ..write('taxRate: $taxRate, ')
          ..write('parentProjectId: $parentProjectId')
          ..write(')'))
        .toString();
  }
}

class $RolesTable extends Roles with TableInfo<$RolesTable, DbRole> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RolesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _standardRateMeta = const VerificationMeta(
    'standardRate',
  );
  @override
  late final GeneratedColumn<int> standardRate = GeneratedColumn<int>(
    'standard_rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, standardRate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roles';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbRole> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('standard_rate')) {
      context.handle(
        _standardRateMeta,
        standardRate.isAcceptableOrUnknown(
          data['standard_rate']!,
          _standardRateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbRole map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbRole(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      standardRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}standard_rate'],
      )!,
    );
  }

  @override
  $RolesTable createAlias(String alias) {
    return $RolesTable(attachedDatabase, alias);
  }
}

class DbRole extends DataClass implements Insertable<DbRole> {
  final int id;
  final String name;
  final int standardRate;
  const DbRole({
    required this.id,
    required this.name,
    required this.standardRate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['standard_rate'] = Variable<int>(standardRate);
    return map;
  }

  RolesCompanion toCompanion(bool nullToAbsent) {
    return RolesCompanion(
      id: Value(id),
      name: Value(name),
      standardRate: Value(standardRate),
    );
  }

  factory DbRole.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbRole(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      standardRate: serializer.fromJson<int>(json['standardRate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'standardRate': serializer.toJson<int>(standardRate),
    };
  }

  DbRole copyWith({int? id, String? name, int? standardRate}) => DbRole(
    id: id ?? this.id,
    name: name ?? this.name,
    standardRate: standardRate ?? this.standardRate,
  );
  DbRole copyWithCompanion(RolesCompanion data) {
    return DbRole(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      standardRate: data.standardRate.present
          ? data.standardRate.value
          : this.standardRate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbRole(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('standardRate: $standardRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, standardRate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbRole &&
          other.id == this.id &&
          other.name == this.name &&
          other.standardRate == this.standardRate);
}

class RolesCompanion extends UpdateCompanion<DbRole> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> standardRate;
  const RolesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.standardRate = const Value.absent(),
  });
  RolesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.standardRate = const Value.absent(),
  }) : name = Value(name);
  static Insertable<DbRole> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? standardRate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (standardRate != null) 'standard_rate': standardRate,
    });
  }

  RolesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? standardRate,
  }) {
    return RolesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      standardRate: standardRate ?? this.standardRate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (standardRate.present) {
      map['standard_rate'] = Variable<int>(standardRate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RolesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('standardRate: $standardRate')
          ..write(')'))
        .toString();
  }
}

class $EmployeesTable extends Employees
    with TableInfo<$EmployeesTable, DbEmployee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _employeeNumberMeta = const VerificationMeta(
    'employeeNumber',
  );
  @override
  late final GeneratedColumn<String> employeeNumber = GeneratedColumn<String>(
    'employee_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleIdMeta = const VerificationMeta(
    'titleId',
  );
  @override
  late final GeneratedColumn<int> titleId = GeneratedColumn<int>(
    'title_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES roles (id)',
    ),
  );
  static const VerificationMeta _hourlyRateMeta = const VerificationMeta(
    'hourlyRate',
  );
  @override
  late final GeneratedColumn<int> hourlyRate = GeneratedColumn<int>(
    'hourly_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeNumber,
    name,
    titleId,
    hourlyRate,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbEmployee> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_number')) {
      context.handle(
        _employeeNumberMeta,
        employeeNumber.isAcceptableOrUnknown(
          data['employee_number']!,
          _employeeNumberMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('title_id')) {
      context.handle(
        _titleIdMeta,
        titleId.isAcceptableOrUnknown(data['title_id']!, _titleIdMeta),
      );
    }
    if (data.containsKey('hourly_rate')) {
      context.handle(
        _hourlyRateMeta,
        hourlyRate.isAcceptableOrUnknown(data['hourly_rate']!, _hourlyRateMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbEmployee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbEmployee(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      employeeNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_number'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      titleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}title_id'],
      ),
      hourlyRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hourly_rate'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $EmployeesTable createAlias(String alias) {
    return $EmployeesTable(attachedDatabase, alias);
  }
}

class DbEmployee extends DataClass implements Insertable<DbEmployee> {
  final int id;
  final String? employeeNumber;
  final String name;
  final int? titleId;
  final int? hourlyRate;
  final int isDeleted;
  const DbEmployee({
    required this.id,
    this.employeeNumber,
    required this.name,
    this.titleId,
    this.hourlyRate,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || employeeNumber != null) {
      map['employee_number'] = Variable<String>(employeeNumber);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || titleId != null) {
      map['title_id'] = Variable<int>(titleId);
    }
    if (!nullToAbsent || hourlyRate != null) {
      map['hourly_rate'] = Variable<int>(hourlyRate);
    }
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  EmployeesCompanion toCompanion(bool nullToAbsent) {
    return EmployeesCompanion(
      id: Value(id),
      employeeNumber: employeeNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeNumber),
      name: Value(name),
      titleId: titleId == null && nullToAbsent
          ? const Value.absent()
          : Value(titleId),
      hourlyRate: hourlyRate == null && nullToAbsent
          ? const Value.absent()
          : Value(hourlyRate),
      isDeleted: Value(isDeleted),
    );
  }

  factory DbEmployee.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbEmployee(
      id: serializer.fromJson<int>(json['id']),
      employeeNumber: serializer.fromJson<String?>(json['employeeNumber']),
      name: serializer.fromJson<String>(json['name']),
      titleId: serializer.fromJson<int?>(json['titleId']),
      hourlyRate: serializer.fromJson<int?>(json['hourlyRate']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'employeeNumber': serializer.toJson<String?>(employeeNumber),
      'name': serializer.toJson<String>(name),
      'titleId': serializer.toJson<int?>(titleId),
      'hourlyRate': serializer.toJson<int?>(hourlyRate),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  DbEmployee copyWith({
    int? id,
    Value<String?> employeeNumber = const Value.absent(),
    String? name,
    Value<int?> titleId = const Value.absent(),
    Value<int?> hourlyRate = const Value.absent(),
    int? isDeleted,
  }) => DbEmployee(
    id: id ?? this.id,
    employeeNumber: employeeNumber.present
        ? employeeNumber.value
        : this.employeeNumber,
    name: name ?? this.name,
    titleId: titleId.present ? titleId.value : this.titleId,
    hourlyRate: hourlyRate.present ? hourlyRate.value : this.hourlyRate,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  DbEmployee copyWithCompanion(EmployeesCompanion data) {
    return DbEmployee(
      id: data.id.present ? data.id.value : this.id,
      employeeNumber: data.employeeNumber.present
          ? data.employeeNumber.value
          : this.employeeNumber,
      name: data.name.present ? data.name.value : this.name,
      titleId: data.titleId.present ? data.titleId.value : this.titleId,
      hourlyRate: data.hourlyRate.present
          ? data.hourlyRate.value
          : this.hourlyRate,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbEmployee(')
          ..write('id: $id, ')
          ..write('employeeNumber: $employeeNumber, ')
          ..write('name: $name, ')
          ..write('titleId: $titleId, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, employeeNumber, name, titleId, hourlyRate, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbEmployee &&
          other.id == this.id &&
          other.employeeNumber == this.employeeNumber &&
          other.name == this.name &&
          other.titleId == this.titleId &&
          other.hourlyRate == this.hourlyRate &&
          other.isDeleted == this.isDeleted);
}

class EmployeesCompanion extends UpdateCompanion<DbEmployee> {
  final Value<int> id;
  final Value<String?> employeeNumber;
  final Value<String> name;
  final Value<int?> titleId;
  final Value<int?> hourlyRate;
  final Value<int> isDeleted;
  const EmployeesCompanion({
    this.id = const Value.absent(),
    this.employeeNumber = const Value.absent(),
    this.name = const Value.absent(),
    this.titleId = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  EmployeesCompanion.insert({
    this.id = const Value.absent(),
    this.employeeNumber = const Value.absent(),
    required String name,
    this.titleId = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : name = Value(name);
  static Insertable<DbEmployee> custom({
    Expression<int>? id,
    Expression<String>? employeeNumber,
    Expression<String>? name,
    Expression<int>? titleId,
    Expression<int>? hourlyRate,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeNumber != null) 'employee_number': employeeNumber,
      if (name != null) 'name': name,
      if (titleId != null) 'title_id': titleId,
      if (hourlyRate != null) 'hourly_rate': hourlyRate,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  EmployeesCompanion copyWith({
    Value<int>? id,
    Value<String?>? employeeNumber,
    Value<String>? name,
    Value<int?>? titleId,
    Value<int?>? hourlyRate,
    Value<int>? isDeleted,
  }) {
    return EmployeesCompanion(
      id: id ?? this.id,
      employeeNumber: employeeNumber ?? this.employeeNumber,
      name: name ?? this.name,
      titleId: titleId ?? this.titleId,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (employeeNumber.present) {
      map['employee_number'] = Variable<String>(employeeNumber.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (titleId.present) {
      map['title_id'] = Variable<int>(titleId.value);
    }
    if (hourlyRate.present) {
      map['hourly_rate'] = Variable<int>(hourlyRate.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesCompanion(')
          ..write('id: $id, ')
          ..write('employeeNumber: $employeeNumber, ')
          ..write('name: $name, ')
          ..write('titleId: $titleId, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $CostCodesTable extends CostCodes
    with TableInfo<$CostCodesTable, DbCostCode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CostCodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _isBillableMeta = const VerificationMeta(
    'isBillable',
  );
  @override
  late final GeneratedColumn<int> isBillable = GeneratedColumn<int>(
    'is_billable',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, isBillable];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cost_codes';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbCostCode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_billable')) {
      context.handle(
        _isBillableMeta,
        isBillable.isAcceptableOrUnknown(data['is_billable']!, _isBillableMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbCostCode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbCostCode(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isBillable: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_billable'],
      )!,
    );
  }

  @override
  $CostCodesTable createAlias(String alias) {
    return $CostCodesTable(attachedDatabase, alias);
  }
}

class DbCostCode extends DataClass implements Insertable<DbCostCode> {
  final int id;
  final String name;
  final int isBillable;
  const DbCostCode({
    required this.id,
    required this.name,
    required this.isBillable,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_billable'] = Variable<int>(isBillable);
    return map;
  }

  CostCodesCompanion toCompanion(bool nullToAbsent) {
    return CostCodesCompanion(
      id: Value(id),
      name: Value(name),
      isBillable: Value(isBillable),
    );
  }

  factory DbCostCode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbCostCode(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isBillable: serializer.fromJson<int>(json['isBillable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isBillable': serializer.toJson<int>(isBillable),
    };
  }

  DbCostCode copyWith({int? id, String? name, int? isBillable}) => DbCostCode(
    id: id ?? this.id,
    name: name ?? this.name,
    isBillable: isBillable ?? this.isBillable,
  );
  DbCostCode copyWithCompanion(CostCodesCompanion data) {
    return DbCostCode(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isBillable: data.isBillable.present
          ? data.isBillable.value
          : this.isBillable,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbCostCode(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isBillable: $isBillable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isBillable);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbCostCode &&
          other.id == this.id &&
          other.name == this.name &&
          other.isBillable == this.isBillable);
}

class CostCodesCompanion extends UpdateCompanion<DbCostCode> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> isBillable;
  const CostCodesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isBillable = const Value.absent(),
  });
  CostCodesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isBillable = const Value.absent(),
  }) : name = Value(name);
  static Insertable<DbCostCode> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? isBillable,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isBillable != null) 'is_billable': isBillable,
    });
  }

  CostCodesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? isBillable,
  }) {
    return CostCodesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isBillable: isBillable ?? this.isBillable,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isBillable.present) {
      map['is_billable'] = Variable<int>(isBillable.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CostCodesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isBillable: $isBillable')
          ..write(')'))
        .toString();
  }
}

class $ExpenseCategoriesTable extends ExpenseCategories
    with TableInfo<$ExpenseCategoriesTable, DbExpenseCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbExpenseCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbExpenseCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbExpenseCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $ExpenseCategoriesTable createAlias(String alias) {
    return $ExpenseCategoriesTable(attachedDatabase, alias);
  }
}

class DbExpenseCategory extends DataClass
    implements Insertable<DbExpenseCategory> {
  final int id;
  final String name;
  const DbExpenseCategory({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  ExpenseCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCategoriesCompanion(id: Value(id), name: Value(name));
  }

  factory DbExpenseCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbExpenseCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  DbExpenseCategory copyWith({int? id, String? name}) =>
      DbExpenseCategory(id: id ?? this.id, name: name ?? this.name);
  DbExpenseCategory copyWithCompanion(ExpenseCategoriesCompanion data) {
    return DbExpenseCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbExpenseCategory(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbExpenseCategory &&
          other.id == this.id &&
          other.name == this.name);
}

class ExpenseCategoriesCompanion extends UpdateCompanion<DbExpenseCategory> {
  final Value<int> id;
  final Value<String> name;
  const ExpenseCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ExpenseCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<DbExpenseCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  ExpenseCategoriesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return ExpenseCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices
    with TableInfo<$InvoicesTable, DbInvoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _invoiceDateMeta = const VerificationMeta(
    'invoiceDate',
  );
  @override
  late final GeneratedColumn<String> invoiceDate = GeneratedColumn<String>(
    'invoice_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id)',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _projectAddressMeta = const VerificationMeta(
    'projectAddress',
  );
  @override
  late final GeneratedColumn<String> projectAddress = GeneratedColumn<String>(
    'project_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _labourSubtotalMeta = const VerificationMeta(
    'labourSubtotal',
  );
  @override
  late final GeneratedColumn<int> labourSubtotal = GeneratedColumn<int>(
    'labour_subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _materialsSubtotalMeta = const VerificationMeta(
    'materialsSubtotal',
  );
  @override
  late final GeneratedColumn<int> materialsSubtotal = GeneratedColumn<int>(
    'materials_subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _materialsPickupCostMeta =
      const VerificationMeta('materialsPickupCost');
  @override
  late final GeneratedColumn<int> materialsPickupCost = GeneratedColumn<int>(
    'materials_pickup_cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _otherCostsMeta = const VerificationMeta(
    'otherCosts',
  );
  @override
  late final GeneratedColumn<int> otherCosts = GeneratedColumn<int>(
    'other_costs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _otherCostsDescriptionMeta =
      const VerificationMeta('otherCostsDescription');
  @override
  late final GeneratedColumn<String> otherCostsDescription =
      GeneratedColumn<String>(
        'other_costs_description',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _discountAmountMeta = const VerificationMeta(
    'discountAmount',
  );
  @override
  late final GeneratedColumn<int> discountAmount = GeneratedColumn<int>(
    'discount_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _discountDescriptionMeta =
      const VerificationMeta('discountDescription');
  @override
  late final GeneratedColumn<String> discountDescription =
      GeneratedColumn<String>(
        'discount_description',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _discountPercentMeta = const VerificationMeta(
    'discountPercent',
  );
  @override
  late final GeneratedColumn<double> discountPercent = GeneratedColumn<double>(
    'discount_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tax1NameMeta = const VerificationMeta(
    'tax1Name',
  );
  @override
  late final GeneratedColumn<String> tax1Name = GeneratedColumn<String>(
    'tax1_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tax1RateMeta = const VerificationMeta(
    'tax1Rate',
  );
  @override
  late final GeneratedColumn<double> tax1Rate = GeneratedColumn<double>(
    'tax1_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tax1AmountMeta = const VerificationMeta(
    'tax1Amount',
  );
  @override
  late final GeneratedColumn<int> tax1Amount = GeneratedColumn<int>(
    'tax1_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tax1RegistrationNumberMeta =
      const VerificationMeta('tax1RegistrationNumber');
  @override
  late final GeneratedColumn<String> tax1RegistrationNumber =
      GeneratedColumn<String>(
        'tax1_registration_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _tax2NameMeta = const VerificationMeta(
    'tax2Name',
  );
  @override
  late final GeneratedColumn<String> tax2Name = GeneratedColumn<String>(
    'tax2_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tax2RateMeta = const VerificationMeta(
    'tax2Rate',
  );
  @override
  late final GeneratedColumn<double> tax2Rate = GeneratedColumn<double>(
    'tax2_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tax2AmountMeta = const VerificationMeta(
    'tax2Amount',
  );
  @override
  late final GeneratedColumn<int> tax2Amount = GeneratedColumn<int>(
    'tax2_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tax2RegistrationNumberMeta =
      const VerificationMeta('tax2RegistrationNumber');
  @override
  late final GeneratedColumn<String> tax2RegistrationNumber =
      GeneratedColumn<String>(
        'tax2_registration_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<int> subtotal = GeneratedColumn<int>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<int> totalAmount = GeneratedColumn<int>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _termsMeta = const VerificationMeta('terms');
  @override
  late final GeneratedColumn<String> terms = GeneratedColumn<String>(
    'terms',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Payable on Receipt'),
  );
  static const VerificationMeta _poNumberMeta = const VerificationMeta(
    'poNumber',
  );
  @override
  late final GeneratedColumn<String> poNumber = GeneratedColumn<String>(
    'po_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deletedReasonCodeMeta = const VerificationMeta(
    'deletedReasonCode',
  );
  @override
  late final GeneratedColumn<String> deletedReasonCode =
      GeneratedColumn<String>(
        'deleted_reason_code',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deletedDateMeta = const VerificationMeta(
    'deletedDate',
  );
  @override
  late final GeneratedColumn<String> deletedDate = GeneratedColumn<String>(
    'deleted_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedNotesMeta = const VerificationMeta(
    'deletedNotes',
  );
  @override
  late final GeneratedColumn<String> deletedNotes = GeneratedColumn<String>(
    'deleted_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supersededByInvoiceIdMeta =
      const VerificationMeta('supersededByInvoiceId');
  @override
  late final GeneratedColumn<int> supersededByInvoiceId = GeneratedColumn<int>(
    'superseded_by_invoice_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _internalNotesMeta = const VerificationMeta(
    'internalNotes',
  );
  @override
  late final GeneratedColumn<String> internalNotes = GeneratedColumn<String>(
    'internal_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workDescriptionMeta = const VerificationMeta(
    'workDescription',
  );
  @override
  late final GeneratedColumn<String> workDescription = GeneratedColumn<String>(
    'work_description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSentMeta = const VerificationMeta('isSent');
  @override
  late final GeneratedColumn<int> isSent = GeneratedColumn<int>(
    'is_sent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _invoiceTypeMeta = const VerificationMeta(
    'invoiceType',
  );
  @override
  late final GeneratedColumn<String> invoiceType = GeneratedColumn<String>(
    'invoice_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('progress'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceNumber,
    invoiceDate,
    clientId,
    projectId,
    projectAddress,
    labourSubtotal,
    materialsSubtotal,
    materialsPickupCost,
    otherCosts,
    otherCostsDescription,
    discountAmount,
    discountDescription,
    discountPercent,
    tax1Name,
    tax1Rate,
    tax1Amount,
    tax1RegistrationNumber,
    tax2Name,
    tax2Rate,
    tax2Amount,
    tax2RegistrationNumber,
    subtotal,
    totalAmount,
    terms,
    poNumber,
    isDeleted,
    deletedReasonCode,
    deletedDate,
    deletedNotes,
    supersededByInvoiceId,
    notes,
    internalNotes,
    workDescription,
    isSent,
    invoiceType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbInvoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('invoice_date')) {
      context.handle(
        _invoiceDateMeta,
        invoiceDate.isAcceptableOrUnknown(
          data['invoice_date']!,
          _invoiceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceDateMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('project_address')) {
      context.handle(
        _projectAddressMeta,
        projectAddress.isAcceptableOrUnknown(
          data['project_address']!,
          _projectAddressMeta,
        ),
      );
    }
    if (data.containsKey('labour_subtotal')) {
      context.handle(
        _labourSubtotalMeta,
        labourSubtotal.isAcceptableOrUnknown(
          data['labour_subtotal']!,
          _labourSubtotalMeta,
        ),
      );
    }
    if (data.containsKey('materials_subtotal')) {
      context.handle(
        _materialsSubtotalMeta,
        materialsSubtotal.isAcceptableOrUnknown(
          data['materials_subtotal']!,
          _materialsSubtotalMeta,
        ),
      );
    }
    if (data.containsKey('materials_pickup_cost')) {
      context.handle(
        _materialsPickupCostMeta,
        materialsPickupCost.isAcceptableOrUnknown(
          data['materials_pickup_cost']!,
          _materialsPickupCostMeta,
        ),
      );
    }
    if (data.containsKey('other_costs')) {
      context.handle(
        _otherCostsMeta,
        otherCosts.isAcceptableOrUnknown(data['other_costs']!, _otherCostsMeta),
      );
    }
    if (data.containsKey('other_costs_description')) {
      context.handle(
        _otherCostsDescriptionMeta,
        otherCostsDescription.isAcceptableOrUnknown(
          data['other_costs_description']!,
          _otherCostsDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
        _discountAmountMeta,
        discountAmount.isAcceptableOrUnknown(
          data['discount_amount']!,
          _discountAmountMeta,
        ),
      );
    }
    if (data.containsKey('discount_description')) {
      context.handle(
        _discountDescriptionMeta,
        discountDescription.isAcceptableOrUnknown(
          data['discount_description']!,
          _discountDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('discount_percent')) {
      context.handle(
        _discountPercentMeta,
        discountPercent.isAcceptableOrUnknown(
          data['discount_percent']!,
          _discountPercentMeta,
        ),
      );
    }
    if (data.containsKey('tax1_name')) {
      context.handle(
        _tax1NameMeta,
        tax1Name.isAcceptableOrUnknown(data['tax1_name']!, _tax1NameMeta),
      );
    }
    if (data.containsKey('tax1_rate')) {
      context.handle(
        _tax1RateMeta,
        tax1Rate.isAcceptableOrUnknown(data['tax1_rate']!, _tax1RateMeta),
      );
    }
    if (data.containsKey('tax1_amount')) {
      context.handle(
        _tax1AmountMeta,
        tax1Amount.isAcceptableOrUnknown(data['tax1_amount']!, _tax1AmountMeta),
      );
    }
    if (data.containsKey('tax1_registration_number')) {
      context.handle(
        _tax1RegistrationNumberMeta,
        tax1RegistrationNumber.isAcceptableOrUnknown(
          data['tax1_registration_number']!,
          _tax1RegistrationNumberMeta,
        ),
      );
    }
    if (data.containsKey('tax2_name')) {
      context.handle(
        _tax2NameMeta,
        tax2Name.isAcceptableOrUnknown(data['tax2_name']!, _tax2NameMeta),
      );
    }
    if (data.containsKey('tax2_rate')) {
      context.handle(
        _tax2RateMeta,
        tax2Rate.isAcceptableOrUnknown(data['tax2_rate']!, _tax2RateMeta),
      );
    }
    if (data.containsKey('tax2_amount')) {
      context.handle(
        _tax2AmountMeta,
        tax2Amount.isAcceptableOrUnknown(data['tax2_amount']!, _tax2AmountMeta),
      );
    }
    if (data.containsKey('tax2_registration_number')) {
      context.handle(
        _tax2RegistrationNumberMeta,
        tax2RegistrationNumber.isAcceptableOrUnknown(
          data['tax2_registration_number']!,
          _tax2RegistrationNumberMeta,
        ),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('terms')) {
      context.handle(
        _termsMeta,
        terms.isAcceptableOrUnknown(data['terms']!, _termsMeta),
      );
    }
    if (data.containsKey('po_number')) {
      context.handle(
        _poNumberMeta,
        poNumber.isAcceptableOrUnknown(data['po_number']!, _poNumberMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_reason_code')) {
      context.handle(
        _deletedReasonCodeMeta,
        deletedReasonCode.isAcceptableOrUnknown(
          data['deleted_reason_code']!,
          _deletedReasonCodeMeta,
        ),
      );
    }
    if (data.containsKey('deleted_date')) {
      context.handle(
        _deletedDateMeta,
        deletedDate.isAcceptableOrUnknown(
          data['deleted_date']!,
          _deletedDateMeta,
        ),
      );
    }
    if (data.containsKey('deleted_notes')) {
      context.handle(
        _deletedNotesMeta,
        deletedNotes.isAcceptableOrUnknown(
          data['deleted_notes']!,
          _deletedNotesMeta,
        ),
      );
    }
    if (data.containsKey('superseded_by_invoice_id')) {
      context.handle(
        _supersededByInvoiceIdMeta,
        supersededByInvoiceId.isAcceptableOrUnknown(
          data['superseded_by_invoice_id']!,
          _supersededByInvoiceIdMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('internal_notes')) {
      context.handle(
        _internalNotesMeta,
        internalNotes.isAcceptableOrUnknown(
          data['internal_notes']!,
          _internalNotesMeta,
        ),
      );
    }
    if (data.containsKey('work_description')) {
      context.handle(
        _workDescriptionMeta,
        workDescription.isAcceptableOrUnknown(
          data['work_description']!,
          _workDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_sent')) {
      context.handle(
        _isSentMeta,
        isSent.isAcceptableOrUnknown(data['is_sent']!, _isSentMeta),
      );
    }
    if (data.containsKey('invoice_type')) {
      context.handle(
        _invoiceTypeMeta,
        invoiceType.isAcceptableOrUnknown(
          data['invoice_type']!,
          _invoiceTypeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbInvoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbInvoice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      )!,
      invoiceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_date'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      projectAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_address'],
      ),
      labourSubtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}labour_subtotal'],
      )!,
      materialsSubtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}materials_subtotal'],
      )!,
      materialsPickupCost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}materials_pickup_cost'],
      )!,
      otherCosts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}other_costs'],
      )!,
      otherCostsDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_costs_description'],
      ),
      discountAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_amount'],
      )!,
      discountDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_description'],
      ),
      discountPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_percent'],
      )!,
      tax1Name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax1_name'],
      ),
      tax1Rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax1_rate'],
      ),
      tax1Amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax1_amount'],
      )!,
      tax1RegistrationNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax1_registration_number'],
      ),
      tax2Name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax2_name'],
      ),
      tax2Rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax2_rate'],
      ),
      tax2Amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax2_amount'],
      )!,
      tax2RegistrationNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax2_registration_number'],
      ),
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount'],
      )!,
      terms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}terms'],
      )!,
      poNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}po_number'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedReasonCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_reason_code'],
      ),
      deletedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_date'],
      ),
      deletedNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_notes'],
      ),
      supersededByInvoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}superseded_by_invoice_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      internalNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}internal_notes'],
      ),
      workDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_description'],
      ),
      isSent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_sent'],
      )!,
      invoiceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_type'],
      )!,
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class DbInvoice extends DataClass implements Insertable<DbInvoice> {
  final int id;
  final String invoiceNumber;
  final String invoiceDate;
  final int clientId;
  final int projectId;
  final String? projectAddress;
  final int labourSubtotal;
  final int materialsSubtotal;
  final int materialsPickupCost;
  final int otherCosts;
  final String? otherCostsDescription;
  final int discountAmount;
  final String? discountDescription;
  final double discountPercent;
  final String? tax1Name;
  final double? tax1Rate;
  final int tax1Amount;
  final String? tax1RegistrationNumber;
  final String? tax2Name;
  final double? tax2Rate;
  final int tax2Amount;
  final String? tax2RegistrationNumber;
  final int subtotal;
  final int totalAmount;
  final String terms;
  final String? poNumber;
  final int isDeleted;
  final String? deletedReasonCode;
  final String? deletedDate;
  final String? deletedNotes;
  final int? supersededByInvoiceId;
  final String? notes;
  final String? internalNotes;
  final String? workDescription;
  final int isSent;
  final String invoiceType;
  const DbInvoice({
    required this.id,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.clientId,
    required this.projectId,
    this.projectAddress,
    required this.labourSubtotal,
    required this.materialsSubtotal,
    required this.materialsPickupCost,
    required this.otherCosts,
    this.otherCostsDescription,
    required this.discountAmount,
    this.discountDescription,
    required this.discountPercent,
    this.tax1Name,
    this.tax1Rate,
    required this.tax1Amount,
    this.tax1RegistrationNumber,
    this.tax2Name,
    this.tax2Rate,
    required this.tax2Amount,
    this.tax2RegistrationNumber,
    required this.subtotal,
    required this.totalAmount,
    required this.terms,
    this.poNumber,
    required this.isDeleted,
    this.deletedReasonCode,
    this.deletedDate,
    this.deletedNotes,
    this.supersededByInvoiceId,
    this.notes,
    this.internalNotes,
    this.workDescription,
    required this.isSent,
    required this.invoiceType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['invoice_date'] = Variable<String>(invoiceDate);
    map['client_id'] = Variable<int>(clientId);
    map['project_id'] = Variable<int>(projectId);
    if (!nullToAbsent || projectAddress != null) {
      map['project_address'] = Variable<String>(projectAddress);
    }
    map['labour_subtotal'] = Variable<int>(labourSubtotal);
    map['materials_subtotal'] = Variable<int>(materialsSubtotal);
    map['materials_pickup_cost'] = Variable<int>(materialsPickupCost);
    map['other_costs'] = Variable<int>(otherCosts);
    if (!nullToAbsent || otherCostsDescription != null) {
      map['other_costs_description'] = Variable<String>(otherCostsDescription);
    }
    map['discount_amount'] = Variable<int>(discountAmount);
    if (!nullToAbsent || discountDescription != null) {
      map['discount_description'] = Variable<String>(discountDescription);
    }
    map['discount_percent'] = Variable<double>(discountPercent);
    if (!nullToAbsent || tax1Name != null) {
      map['tax1_name'] = Variable<String>(tax1Name);
    }
    if (!nullToAbsent || tax1Rate != null) {
      map['tax1_rate'] = Variable<double>(tax1Rate);
    }
    map['tax1_amount'] = Variable<int>(tax1Amount);
    if (!nullToAbsent || tax1RegistrationNumber != null) {
      map['tax1_registration_number'] = Variable<String>(
        tax1RegistrationNumber,
      );
    }
    if (!nullToAbsent || tax2Name != null) {
      map['tax2_name'] = Variable<String>(tax2Name);
    }
    if (!nullToAbsent || tax2Rate != null) {
      map['tax2_rate'] = Variable<double>(tax2Rate);
    }
    map['tax2_amount'] = Variable<int>(tax2Amount);
    if (!nullToAbsent || tax2RegistrationNumber != null) {
      map['tax2_registration_number'] = Variable<String>(
        tax2RegistrationNumber,
      );
    }
    map['subtotal'] = Variable<int>(subtotal);
    map['total_amount'] = Variable<int>(totalAmount);
    map['terms'] = Variable<String>(terms);
    if (!nullToAbsent || poNumber != null) {
      map['po_number'] = Variable<String>(poNumber);
    }
    map['is_deleted'] = Variable<int>(isDeleted);
    if (!nullToAbsent || deletedReasonCode != null) {
      map['deleted_reason_code'] = Variable<String>(deletedReasonCode);
    }
    if (!nullToAbsent || deletedDate != null) {
      map['deleted_date'] = Variable<String>(deletedDate);
    }
    if (!nullToAbsent || deletedNotes != null) {
      map['deleted_notes'] = Variable<String>(deletedNotes);
    }
    if (!nullToAbsent || supersededByInvoiceId != null) {
      map['superseded_by_invoice_id'] = Variable<int>(supersededByInvoiceId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || internalNotes != null) {
      map['internal_notes'] = Variable<String>(internalNotes);
    }
    if (!nullToAbsent || workDescription != null) {
      map['work_description'] = Variable<String>(workDescription);
    }
    map['is_sent'] = Variable<int>(isSent);
    map['invoice_type'] = Variable<String>(invoiceType);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      invoiceNumber: Value(invoiceNumber),
      invoiceDate: Value(invoiceDate),
      clientId: Value(clientId),
      projectId: Value(projectId),
      projectAddress: projectAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(projectAddress),
      labourSubtotal: Value(labourSubtotal),
      materialsSubtotal: Value(materialsSubtotal),
      materialsPickupCost: Value(materialsPickupCost),
      otherCosts: Value(otherCosts),
      otherCostsDescription: otherCostsDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(otherCostsDescription),
      discountAmount: Value(discountAmount),
      discountDescription: discountDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(discountDescription),
      discountPercent: Value(discountPercent),
      tax1Name: tax1Name == null && nullToAbsent
          ? const Value.absent()
          : Value(tax1Name),
      tax1Rate: tax1Rate == null && nullToAbsent
          ? const Value.absent()
          : Value(tax1Rate),
      tax1Amount: Value(tax1Amount),
      tax1RegistrationNumber: tax1RegistrationNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(tax1RegistrationNumber),
      tax2Name: tax2Name == null && nullToAbsent
          ? const Value.absent()
          : Value(tax2Name),
      tax2Rate: tax2Rate == null && nullToAbsent
          ? const Value.absent()
          : Value(tax2Rate),
      tax2Amount: Value(tax2Amount),
      tax2RegistrationNumber: tax2RegistrationNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(tax2RegistrationNumber),
      subtotal: Value(subtotal),
      totalAmount: Value(totalAmount),
      terms: Value(terms),
      poNumber: poNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(poNumber),
      isDeleted: Value(isDeleted),
      deletedReasonCode: deletedReasonCode == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedReasonCode),
      deletedDate: deletedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedDate),
      deletedNotes: deletedNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedNotes),
      supersededByInvoiceId: supersededByInvoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(supersededByInvoiceId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      internalNotes: internalNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(internalNotes),
      workDescription: workDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(workDescription),
      isSent: Value(isSent),
      invoiceType: Value(invoiceType),
    );
  }

  factory DbInvoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbInvoice(
      id: serializer.fromJson<int>(json['id']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      invoiceDate: serializer.fromJson<String>(json['invoiceDate']),
      clientId: serializer.fromJson<int>(json['clientId']),
      projectId: serializer.fromJson<int>(json['projectId']),
      projectAddress: serializer.fromJson<String?>(json['projectAddress']),
      labourSubtotal: serializer.fromJson<int>(json['labourSubtotal']),
      materialsSubtotal: serializer.fromJson<int>(json['materialsSubtotal']),
      materialsPickupCost: serializer.fromJson<int>(
        json['materialsPickupCost'],
      ),
      otherCosts: serializer.fromJson<int>(json['otherCosts']),
      otherCostsDescription: serializer.fromJson<String?>(
        json['otherCostsDescription'],
      ),
      discountAmount: serializer.fromJson<int>(json['discountAmount']),
      discountDescription: serializer.fromJson<String?>(
        json['discountDescription'],
      ),
      discountPercent: serializer.fromJson<double>(json['discountPercent']),
      tax1Name: serializer.fromJson<String?>(json['tax1Name']),
      tax1Rate: serializer.fromJson<double?>(json['tax1Rate']),
      tax1Amount: serializer.fromJson<int>(json['tax1Amount']),
      tax1RegistrationNumber: serializer.fromJson<String?>(
        json['tax1RegistrationNumber'],
      ),
      tax2Name: serializer.fromJson<String?>(json['tax2Name']),
      tax2Rate: serializer.fromJson<double?>(json['tax2Rate']),
      tax2Amount: serializer.fromJson<int>(json['tax2Amount']),
      tax2RegistrationNumber: serializer.fromJson<String?>(
        json['tax2RegistrationNumber'],
      ),
      subtotal: serializer.fromJson<int>(json['subtotal']),
      totalAmount: serializer.fromJson<int>(json['totalAmount']),
      terms: serializer.fromJson<String>(json['terms']),
      poNumber: serializer.fromJson<String?>(json['poNumber']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
      deletedReasonCode: serializer.fromJson<String?>(
        json['deletedReasonCode'],
      ),
      deletedDate: serializer.fromJson<String?>(json['deletedDate']),
      deletedNotes: serializer.fromJson<String?>(json['deletedNotes']),
      supersededByInvoiceId: serializer.fromJson<int?>(
        json['supersededByInvoiceId'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      internalNotes: serializer.fromJson<String?>(json['internalNotes']),
      workDescription: serializer.fromJson<String?>(json['workDescription']),
      isSent: serializer.fromJson<int>(json['isSent']),
      invoiceType: serializer.fromJson<String>(json['invoiceType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'invoiceDate': serializer.toJson<String>(invoiceDate),
      'clientId': serializer.toJson<int>(clientId),
      'projectId': serializer.toJson<int>(projectId),
      'projectAddress': serializer.toJson<String?>(projectAddress),
      'labourSubtotal': serializer.toJson<int>(labourSubtotal),
      'materialsSubtotal': serializer.toJson<int>(materialsSubtotal),
      'materialsPickupCost': serializer.toJson<int>(materialsPickupCost),
      'otherCosts': serializer.toJson<int>(otherCosts),
      'otherCostsDescription': serializer.toJson<String?>(
        otherCostsDescription,
      ),
      'discountAmount': serializer.toJson<int>(discountAmount),
      'discountDescription': serializer.toJson<String?>(discountDescription),
      'discountPercent': serializer.toJson<double>(discountPercent),
      'tax1Name': serializer.toJson<String?>(tax1Name),
      'tax1Rate': serializer.toJson<double?>(tax1Rate),
      'tax1Amount': serializer.toJson<int>(tax1Amount),
      'tax1RegistrationNumber': serializer.toJson<String?>(
        tax1RegistrationNumber,
      ),
      'tax2Name': serializer.toJson<String?>(tax2Name),
      'tax2Rate': serializer.toJson<double?>(tax2Rate),
      'tax2Amount': serializer.toJson<int>(tax2Amount),
      'tax2RegistrationNumber': serializer.toJson<String?>(
        tax2RegistrationNumber,
      ),
      'subtotal': serializer.toJson<int>(subtotal),
      'totalAmount': serializer.toJson<int>(totalAmount),
      'terms': serializer.toJson<String>(terms),
      'poNumber': serializer.toJson<String?>(poNumber),
      'isDeleted': serializer.toJson<int>(isDeleted),
      'deletedReasonCode': serializer.toJson<String?>(deletedReasonCode),
      'deletedDate': serializer.toJson<String?>(deletedDate),
      'deletedNotes': serializer.toJson<String?>(deletedNotes),
      'supersededByInvoiceId': serializer.toJson<int?>(supersededByInvoiceId),
      'notes': serializer.toJson<String?>(notes),
      'internalNotes': serializer.toJson<String?>(internalNotes),
      'workDescription': serializer.toJson<String?>(workDescription),
      'isSent': serializer.toJson<int>(isSent),
      'invoiceType': serializer.toJson<String>(invoiceType),
    };
  }

  DbInvoice copyWith({
    int? id,
    String? invoiceNumber,
    String? invoiceDate,
    int? clientId,
    int? projectId,
    Value<String?> projectAddress = const Value.absent(),
    int? labourSubtotal,
    int? materialsSubtotal,
    int? materialsPickupCost,
    int? otherCosts,
    Value<String?> otherCostsDescription = const Value.absent(),
    int? discountAmount,
    Value<String?> discountDescription = const Value.absent(),
    double? discountPercent,
    Value<String?> tax1Name = const Value.absent(),
    Value<double?> tax1Rate = const Value.absent(),
    int? tax1Amount,
    Value<String?> tax1RegistrationNumber = const Value.absent(),
    Value<String?> tax2Name = const Value.absent(),
    Value<double?> tax2Rate = const Value.absent(),
    int? tax2Amount,
    Value<String?> tax2RegistrationNumber = const Value.absent(),
    int? subtotal,
    int? totalAmount,
    String? terms,
    Value<String?> poNumber = const Value.absent(),
    int? isDeleted,
    Value<String?> deletedReasonCode = const Value.absent(),
    Value<String?> deletedDate = const Value.absent(),
    Value<String?> deletedNotes = const Value.absent(),
    Value<int?> supersededByInvoiceId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> internalNotes = const Value.absent(),
    Value<String?> workDescription = const Value.absent(),
    int? isSent,
    String? invoiceType,
  }) => DbInvoice(
    id: id ?? this.id,
    invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    invoiceDate: invoiceDate ?? this.invoiceDate,
    clientId: clientId ?? this.clientId,
    projectId: projectId ?? this.projectId,
    projectAddress: projectAddress.present
        ? projectAddress.value
        : this.projectAddress,
    labourSubtotal: labourSubtotal ?? this.labourSubtotal,
    materialsSubtotal: materialsSubtotal ?? this.materialsSubtotal,
    materialsPickupCost: materialsPickupCost ?? this.materialsPickupCost,
    otherCosts: otherCosts ?? this.otherCosts,
    otherCostsDescription: otherCostsDescription.present
        ? otherCostsDescription.value
        : this.otherCostsDescription,
    discountAmount: discountAmount ?? this.discountAmount,
    discountDescription: discountDescription.present
        ? discountDescription.value
        : this.discountDescription,
    discountPercent: discountPercent ?? this.discountPercent,
    tax1Name: tax1Name.present ? tax1Name.value : this.tax1Name,
    tax1Rate: tax1Rate.present ? tax1Rate.value : this.tax1Rate,
    tax1Amount: tax1Amount ?? this.tax1Amount,
    tax1RegistrationNumber: tax1RegistrationNumber.present
        ? tax1RegistrationNumber.value
        : this.tax1RegistrationNumber,
    tax2Name: tax2Name.present ? tax2Name.value : this.tax2Name,
    tax2Rate: tax2Rate.present ? tax2Rate.value : this.tax2Rate,
    tax2Amount: tax2Amount ?? this.tax2Amount,
    tax2RegistrationNumber: tax2RegistrationNumber.present
        ? tax2RegistrationNumber.value
        : this.tax2RegistrationNumber,
    subtotal: subtotal ?? this.subtotal,
    totalAmount: totalAmount ?? this.totalAmount,
    terms: terms ?? this.terms,
    poNumber: poNumber.present ? poNumber.value : this.poNumber,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedReasonCode: deletedReasonCode.present
        ? deletedReasonCode.value
        : this.deletedReasonCode,
    deletedDate: deletedDate.present ? deletedDate.value : this.deletedDate,
    deletedNotes: deletedNotes.present ? deletedNotes.value : this.deletedNotes,
    supersededByInvoiceId: supersededByInvoiceId.present
        ? supersededByInvoiceId.value
        : this.supersededByInvoiceId,
    notes: notes.present ? notes.value : this.notes,
    internalNotes: internalNotes.present
        ? internalNotes.value
        : this.internalNotes,
    workDescription: workDescription.present
        ? workDescription.value
        : this.workDescription,
    isSent: isSent ?? this.isSent,
    invoiceType: invoiceType ?? this.invoiceType,
  );
  DbInvoice copyWithCompanion(InvoicesCompanion data) {
    return DbInvoice(
      id: data.id.present ? data.id.value : this.id,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      invoiceDate: data.invoiceDate.present
          ? data.invoiceDate.value
          : this.invoiceDate,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      projectAddress: data.projectAddress.present
          ? data.projectAddress.value
          : this.projectAddress,
      labourSubtotal: data.labourSubtotal.present
          ? data.labourSubtotal.value
          : this.labourSubtotal,
      materialsSubtotal: data.materialsSubtotal.present
          ? data.materialsSubtotal.value
          : this.materialsSubtotal,
      materialsPickupCost: data.materialsPickupCost.present
          ? data.materialsPickupCost.value
          : this.materialsPickupCost,
      otherCosts: data.otherCosts.present
          ? data.otherCosts.value
          : this.otherCosts,
      otherCostsDescription: data.otherCostsDescription.present
          ? data.otherCostsDescription.value
          : this.otherCostsDescription,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      discountDescription: data.discountDescription.present
          ? data.discountDescription.value
          : this.discountDescription,
      discountPercent: data.discountPercent.present
          ? data.discountPercent.value
          : this.discountPercent,
      tax1Name: data.tax1Name.present ? data.tax1Name.value : this.tax1Name,
      tax1Rate: data.tax1Rate.present ? data.tax1Rate.value : this.tax1Rate,
      tax1Amount: data.tax1Amount.present
          ? data.tax1Amount.value
          : this.tax1Amount,
      tax1RegistrationNumber: data.tax1RegistrationNumber.present
          ? data.tax1RegistrationNumber.value
          : this.tax1RegistrationNumber,
      tax2Name: data.tax2Name.present ? data.tax2Name.value : this.tax2Name,
      tax2Rate: data.tax2Rate.present ? data.tax2Rate.value : this.tax2Rate,
      tax2Amount: data.tax2Amount.present
          ? data.tax2Amount.value
          : this.tax2Amount,
      tax2RegistrationNumber: data.tax2RegistrationNumber.present
          ? data.tax2RegistrationNumber.value
          : this.tax2RegistrationNumber,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      terms: data.terms.present ? data.terms.value : this.terms,
      poNumber: data.poNumber.present ? data.poNumber.value : this.poNumber,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedReasonCode: data.deletedReasonCode.present
          ? data.deletedReasonCode.value
          : this.deletedReasonCode,
      deletedDate: data.deletedDate.present
          ? data.deletedDate.value
          : this.deletedDate,
      deletedNotes: data.deletedNotes.present
          ? data.deletedNotes.value
          : this.deletedNotes,
      supersededByInvoiceId: data.supersededByInvoiceId.present
          ? data.supersededByInvoiceId.value
          : this.supersededByInvoiceId,
      notes: data.notes.present ? data.notes.value : this.notes,
      internalNotes: data.internalNotes.present
          ? data.internalNotes.value
          : this.internalNotes,
      workDescription: data.workDescription.present
          ? data.workDescription.value
          : this.workDescription,
      isSent: data.isSent.present ? data.isSent.value : this.isSent,
      invoiceType: data.invoiceType.present
          ? data.invoiceType.value
          : this.invoiceType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbInvoice(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('clientId: $clientId, ')
          ..write('projectId: $projectId, ')
          ..write('projectAddress: $projectAddress, ')
          ..write('labourSubtotal: $labourSubtotal, ')
          ..write('materialsSubtotal: $materialsSubtotal, ')
          ..write('materialsPickupCost: $materialsPickupCost, ')
          ..write('otherCosts: $otherCosts, ')
          ..write('otherCostsDescription: $otherCostsDescription, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('discountDescription: $discountDescription, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('tax1Name: $tax1Name, ')
          ..write('tax1Rate: $tax1Rate, ')
          ..write('tax1Amount: $tax1Amount, ')
          ..write('tax1RegistrationNumber: $tax1RegistrationNumber, ')
          ..write('tax2Name: $tax2Name, ')
          ..write('tax2Rate: $tax2Rate, ')
          ..write('tax2Amount: $tax2Amount, ')
          ..write('tax2RegistrationNumber: $tax2RegistrationNumber, ')
          ..write('subtotal: $subtotal, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('terms: $terms, ')
          ..write('poNumber: $poNumber, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedReasonCode: $deletedReasonCode, ')
          ..write('deletedDate: $deletedDate, ')
          ..write('deletedNotes: $deletedNotes, ')
          ..write('supersededByInvoiceId: $supersededByInvoiceId, ')
          ..write('notes: $notes, ')
          ..write('internalNotes: $internalNotes, ')
          ..write('workDescription: $workDescription, ')
          ..write('isSent: $isSent, ')
          ..write('invoiceType: $invoiceType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    invoiceNumber,
    invoiceDate,
    clientId,
    projectId,
    projectAddress,
    labourSubtotal,
    materialsSubtotal,
    materialsPickupCost,
    otherCosts,
    otherCostsDescription,
    discountAmount,
    discountDescription,
    discountPercent,
    tax1Name,
    tax1Rate,
    tax1Amount,
    tax1RegistrationNumber,
    tax2Name,
    tax2Rate,
    tax2Amount,
    tax2RegistrationNumber,
    subtotal,
    totalAmount,
    terms,
    poNumber,
    isDeleted,
    deletedReasonCode,
    deletedDate,
    deletedNotes,
    supersededByInvoiceId,
    notes,
    internalNotes,
    workDescription,
    isSent,
    invoiceType,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbInvoice &&
          other.id == this.id &&
          other.invoiceNumber == this.invoiceNumber &&
          other.invoiceDate == this.invoiceDate &&
          other.clientId == this.clientId &&
          other.projectId == this.projectId &&
          other.projectAddress == this.projectAddress &&
          other.labourSubtotal == this.labourSubtotal &&
          other.materialsSubtotal == this.materialsSubtotal &&
          other.materialsPickupCost == this.materialsPickupCost &&
          other.otherCosts == this.otherCosts &&
          other.otherCostsDescription == this.otherCostsDescription &&
          other.discountAmount == this.discountAmount &&
          other.discountDescription == this.discountDescription &&
          other.discountPercent == this.discountPercent &&
          other.tax1Name == this.tax1Name &&
          other.tax1Rate == this.tax1Rate &&
          other.tax1Amount == this.tax1Amount &&
          other.tax1RegistrationNumber == this.tax1RegistrationNumber &&
          other.tax2Name == this.tax2Name &&
          other.tax2Rate == this.tax2Rate &&
          other.tax2Amount == this.tax2Amount &&
          other.tax2RegistrationNumber == this.tax2RegistrationNumber &&
          other.subtotal == this.subtotal &&
          other.totalAmount == this.totalAmount &&
          other.terms == this.terms &&
          other.poNumber == this.poNumber &&
          other.isDeleted == this.isDeleted &&
          other.deletedReasonCode == this.deletedReasonCode &&
          other.deletedDate == this.deletedDate &&
          other.deletedNotes == this.deletedNotes &&
          other.supersededByInvoiceId == this.supersededByInvoiceId &&
          other.notes == this.notes &&
          other.internalNotes == this.internalNotes &&
          other.workDescription == this.workDescription &&
          other.isSent == this.isSent &&
          other.invoiceType == this.invoiceType);
}

class InvoicesCompanion extends UpdateCompanion<DbInvoice> {
  final Value<int> id;
  final Value<String> invoiceNumber;
  final Value<String> invoiceDate;
  final Value<int> clientId;
  final Value<int> projectId;
  final Value<String?> projectAddress;
  final Value<int> labourSubtotal;
  final Value<int> materialsSubtotal;
  final Value<int> materialsPickupCost;
  final Value<int> otherCosts;
  final Value<String?> otherCostsDescription;
  final Value<int> discountAmount;
  final Value<String?> discountDescription;
  final Value<double> discountPercent;
  final Value<String?> tax1Name;
  final Value<double?> tax1Rate;
  final Value<int> tax1Amount;
  final Value<String?> tax1RegistrationNumber;
  final Value<String?> tax2Name;
  final Value<double?> tax2Rate;
  final Value<int> tax2Amount;
  final Value<String?> tax2RegistrationNumber;
  final Value<int> subtotal;
  final Value<int> totalAmount;
  final Value<String> terms;
  final Value<String?> poNumber;
  final Value<int> isDeleted;
  final Value<String?> deletedReasonCode;
  final Value<String?> deletedDate;
  final Value<String?> deletedNotes;
  final Value<int?> supersededByInvoiceId;
  final Value<String?> notes;
  final Value<String?> internalNotes;
  final Value<String?> workDescription;
  final Value<int> isSent;
  final Value<String> invoiceType;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.invoiceDate = const Value.absent(),
    this.clientId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.projectAddress = const Value.absent(),
    this.labourSubtotal = const Value.absent(),
    this.materialsSubtotal = const Value.absent(),
    this.materialsPickupCost = const Value.absent(),
    this.otherCosts = const Value.absent(),
    this.otherCostsDescription = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.discountDescription = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.tax1Name = const Value.absent(),
    this.tax1Rate = const Value.absent(),
    this.tax1Amount = const Value.absent(),
    this.tax1RegistrationNumber = const Value.absent(),
    this.tax2Name = const Value.absent(),
    this.tax2Rate = const Value.absent(),
    this.tax2Amount = const Value.absent(),
    this.tax2RegistrationNumber = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.terms = const Value.absent(),
    this.poNumber = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedReasonCode = const Value.absent(),
    this.deletedDate = const Value.absent(),
    this.deletedNotes = const Value.absent(),
    this.supersededByInvoiceId = const Value.absent(),
    this.notes = const Value.absent(),
    this.internalNotes = const Value.absent(),
    this.workDescription = const Value.absent(),
    this.isSent = const Value.absent(),
    this.invoiceType = const Value.absent(),
  });
  InvoicesCompanion.insert({
    this.id = const Value.absent(),
    required String invoiceNumber,
    required String invoiceDate,
    required int clientId,
    required int projectId,
    this.projectAddress = const Value.absent(),
    this.labourSubtotal = const Value.absent(),
    this.materialsSubtotal = const Value.absent(),
    this.materialsPickupCost = const Value.absent(),
    this.otherCosts = const Value.absent(),
    this.otherCostsDescription = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.discountDescription = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.tax1Name = const Value.absent(),
    this.tax1Rate = const Value.absent(),
    this.tax1Amount = const Value.absent(),
    this.tax1RegistrationNumber = const Value.absent(),
    this.tax2Name = const Value.absent(),
    this.tax2Rate = const Value.absent(),
    this.tax2Amount = const Value.absent(),
    this.tax2RegistrationNumber = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.terms = const Value.absent(),
    this.poNumber = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedReasonCode = const Value.absent(),
    this.deletedDate = const Value.absent(),
    this.deletedNotes = const Value.absent(),
    this.supersededByInvoiceId = const Value.absent(),
    this.notes = const Value.absent(),
    this.internalNotes = const Value.absent(),
    this.workDescription = const Value.absent(),
    this.isSent = const Value.absent(),
    this.invoiceType = const Value.absent(),
  }) : invoiceNumber = Value(invoiceNumber),
       invoiceDate = Value(invoiceDate),
       clientId = Value(clientId),
       projectId = Value(projectId);
  static Insertable<DbInvoice> custom({
    Expression<int>? id,
    Expression<String>? invoiceNumber,
    Expression<String>? invoiceDate,
    Expression<int>? clientId,
    Expression<int>? projectId,
    Expression<String>? projectAddress,
    Expression<int>? labourSubtotal,
    Expression<int>? materialsSubtotal,
    Expression<int>? materialsPickupCost,
    Expression<int>? otherCosts,
    Expression<String>? otherCostsDescription,
    Expression<int>? discountAmount,
    Expression<String>? discountDescription,
    Expression<double>? discountPercent,
    Expression<String>? tax1Name,
    Expression<double>? tax1Rate,
    Expression<int>? tax1Amount,
    Expression<String>? tax1RegistrationNumber,
    Expression<String>? tax2Name,
    Expression<double>? tax2Rate,
    Expression<int>? tax2Amount,
    Expression<String>? tax2RegistrationNumber,
    Expression<int>? subtotal,
    Expression<int>? totalAmount,
    Expression<String>? terms,
    Expression<String>? poNumber,
    Expression<int>? isDeleted,
    Expression<String>? deletedReasonCode,
    Expression<String>? deletedDate,
    Expression<String>? deletedNotes,
    Expression<int>? supersededByInvoiceId,
    Expression<String>? notes,
    Expression<String>? internalNotes,
    Expression<String>? workDescription,
    Expression<int>? isSent,
    Expression<String>? invoiceType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (invoiceDate != null) 'invoice_date': invoiceDate,
      if (clientId != null) 'client_id': clientId,
      if (projectId != null) 'project_id': projectId,
      if (projectAddress != null) 'project_address': projectAddress,
      if (labourSubtotal != null) 'labour_subtotal': labourSubtotal,
      if (materialsSubtotal != null) 'materials_subtotal': materialsSubtotal,
      if (materialsPickupCost != null)
        'materials_pickup_cost': materialsPickupCost,
      if (otherCosts != null) 'other_costs': otherCosts,
      if (otherCostsDescription != null)
        'other_costs_description': otherCostsDescription,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (discountDescription != null)
        'discount_description': discountDescription,
      if (discountPercent != null) 'discount_percent': discountPercent,
      if (tax1Name != null) 'tax1_name': tax1Name,
      if (tax1Rate != null) 'tax1_rate': tax1Rate,
      if (tax1Amount != null) 'tax1_amount': tax1Amount,
      if (tax1RegistrationNumber != null)
        'tax1_registration_number': tax1RegistrationNumber,
      if (tax2Name != null) 'tax2_name': tax2Name,
      if (tax2Rate != null) 'tax2_rate': tax2Rate,
      if (tax2Amount != null) 'tax2_amount': tax2Amount,
      if (tax2RegistrationNumber != null)
        'tax2_registration_number': tax2RegistrationNumber,
      if (subtotal != null) 'subtotal': subtotal,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (terms != null) 'terms': terms,
      if (poNumber != null) 'po_number': poNumber,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedReasonCode != null) 'deleted_reason_code': deletedReasonCode,
      if (deletedDate != null) 'deleted_date': deletedDate,
      if (deletedNotes != null) 'deleted_notes': deletedNotes,
      if (supersededByInvoiceId != null)
        'superseded_by_invoice_id': supersededByInvoiceId,
      if (notes != null) 'notes': notes,
      if (internalNotes != null) 'internal_notes': internalNotes,
      if (workDescription != null) 'work_description': workDescription,
      if (isSent != null) 'is_sent': isSent,
      if (invoiceType != null) 'invoice_type': invoiceType,
    });
  }

  InvoicesCompanion copyWith({
    Value<int>? id,
    Value<String>? invoiceNumber,
    Value<String>? invoiceDate,
    Value<int>? clientId,
    Value<int>? projectId,
    Value<String?>? projectAddress,
    Value<int>? labourSubtotal,
    Value<int>? materialsSubtotal,
    Value<int>? materialsPickupCost,
    Value<int>? otherCosts,
    Value<String?>? otherCostsDescription,
    Value<int>? discountAmount,
    Value<String?>? discountDescription,
    Value<double>? discountPercent,
    Value<String?>? tax1Name,
    Value<double?>? tax1Rate,
    Value<int>? tax1Amount,
    Value<String?>? tax1RegistrationNumber,
    Value<String?>? tax2Name,
    Value<double?>? tax2Rate,
    Value<int>? tax2Amount,
    Value<String?>? tax2RegistrationNumber,
    Value<int>? subtotal,
    Value<int>? totalAmount,
    Value<String>? terms,
    Value<String?>? poNumber,
    Value<int>? isDeleted,
    Value<String?>? deletedReasonCode,
    Value<String?>? deletedDate,
    Value<String?>? deletedNotes,
    Value<int?>? supersededByInvoiceId,
    Value<String?>? notes,
    Value<String?>? internalNotes,
    Value<String?>? workDescription,
    Value<int>? isSent,
    Value<String>? invoiceType,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      clientId: clientId ?? this.clientId,
      projectId: projectId ?? this.projectId,
      projectAddress: projectAddress ?? this.projectAddress,
      labourSubtotal: labourSubtotal ?? this.labourSubtotal,
      materialsSubtotal: materialsSubtotal ?? this.materialsSubtotal,
      materialsPickupCost: materialsPickupCost ?? this.materialsPickupCost,
      otherCosts: otherCosts ?? this.otherCosts,
      otherCostsDescription:
          otherCostsDescription ?? this.otherCostsDescription,
      discountAmount: discountAmount ?? this.discountAmount,
      discountDescription: discountDescription ?? this.discountDescription,
      discountPercent: discountPercent ?? this.discountPercent,
      tax1Name: tax1Name ?? this.tax1Name,
      tax1Rate: tax1Rate ?? this.tax1Rate,
      tax1Amount: tax1Amount ?? this.tax1Amount,
      tax1RegistrationNumber:
          tax1RegistrationNumber ?? this.tax1RegistrationNumber,
      tax2Name: tax2Name ?? this.tax2Name,
      tax2Rate: tax2Rate ?? this.tax2Rate,
      tax2Amount: tax2Amount ?? this.tax2Amount,
      tax2RegistrationNumber:
          tax2RegistrationNumber ?? this.tax2RegistrationNumber,
      subtotal: subtotal ?? this.subtotal,
      totalAmount: totalAmount ?? this.totalAmount,
      terms: terms ?? this.terms,
      poNumber: poNumber ?? this.poNumber,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedReasonCode: deletedReasonCode ?? this.deletedReasonCode,
      deletedDate: deletedDate ?? this.deletedDate,
      deletedNotes: deletedNotes ?? this.deletedNotes,
      supersededByInvoiceId:
          supersededByInvoiceId ?? this.supersededByInvoiceId,
      notes: notes ?? this.notes,
      internalNotes: internalNotes ?? this.internalNotes,
      workDescription: workDescription ?? this.workDescription,
      isSent: isSent ?? this.isSent,
      invoiceType: invoiceType ?? this.invoiceType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (invoiceDate.present) {
      map['invoice_date'] = Variable<String>(invoiceDate.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (projectAddress.present) {
      map['project_address'] = Variable<String>(projectAddress.value);
    }
    if (labourSubtotal.present) {
      map['labour_subtotal'] = Variable<int>(labourSubtotal.value);
    }
    if (materialsSubtotal.present) {
      map['materials_subtotal'] = Variable<int>(materialsSubtotal.value);
    }
    if (materialsPickupCost.present) {
      map['materials_pickup_cost'] = Variable<int>(materialsPickupCost.value);
    }
    if (otherCosts.present) {
      map['other_costs'] = Variable<int>(otherCosts.value);
    }
    if (otherCostsDescription.present) {
      map['other_costs_description'] = Variable<String>(
        otherCostsDescription.value,
      );
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<int>(discountAmount.value);
    }
    if (discountDescription.present) {
      map['discount_description'] = Variable<String>(discountDescription.value);
    }
    if (discountPercent.present) {
      map['discount_percent'] = Variable<double>(discountPercent.value);
    }
    if (tax1Name.present) {
      map['tax1_name'] = Variable<String>(tax1Name.value);
    }
    if (tax1Rate.present) {
      map['tax1_rate'] = Variable<double>(tax1Rate.value);
    }
    if (tax1Amount.present) {
      map['tax1_amount'] = Variable<int>(tax1Amount.value);
    }
    if (tax1RegistrationNumber.present) {
      map['tax1_registration_number'] = Variable<String>(
        tax1RegistrationNumber.value,
      );
    }
    if (tax2Name.present) {
      map['tax2_name'] = Variable<String>(tax2Name.value);
    }
    if (tax2Rate.present) {
      map['tax2_rate'] = Variable<double>(tax2Rate.value);
    }
    if (tax2Amount.present) {
      map['tax2_amount'] = Variable<int>(tax2Amount.value);
    }
    if (tax2RegistrationNumber.present) {
      map['tax2_registration_number'] = Variable<String>(
        tax2RegistrationNumber.value,
      );
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<int>(subtotal.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<int>(totalAmount.value);
    }
    if (terms.present) {
      map['terms'] = Variable<String>(terms.value);
    }
    if (poNumber.present) {
      map['po_number'] = Variable<String>(poNumber.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    if (deletedReasonCode.present) {
      map['deleted_reason_code'] = Variable<String>(deletedReasonCode.value);
    }
    if (deletedDate.present) {
      map['deleted_date'] = Variable<String>(deletedDate.value);
    }
    if (deletedNotes.present) {
      map['deleted_notes'] = Variable<String>(deletedNotes.value);
    }
    if (supersededByInvoiceId.present) {
      map['superseded_by_invoice_id'] = Variable<int>(
        supersededByInvoiceId.value,
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (internalNotes.present) {
      map['internal_notes'] = Variable<String>(internalNotes.value);
    }
    if (workDescription.present) {
      map['work_description'] = Variable<String>(workDescription.value);
    }
    if (isSent.present) {
      map['is_sent'] = Variable<int>(isSent.value);
    }
    if (invoiceType.present) {
      map['invoice_type'] = Variable<String>(invoiceType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('clientId: $clientId, ')
          ..write('projectId: $projectId, ')
          ..write('projectAddress: $projectAddress, ')
          ..write('labourSubtotal: $labourSubtotal, ')
          ..write('materialsSubtotal: $materialsSubtotal, ')
          ..write('materialsPickupCost: $materialsPickupCost, ')
          ..write('otherCosts: $otherCosts, ')
          ..write('otherCostsDescription: $otherCostsDescription, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('discountDescription: $discountDescription, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('tax1Name: $tax1Name, ')
          ..write('tax1Rate: $tax1Rate, ')
          ..write('tax1Amount: $tax1Amount, ')
          ..write('tax1RegistrationNumber: $tax1RegistrationNumber, ')
          ..write('tax2Name: $tax2Name, ')
          ..write('tax2Rate: $tax2Rate, ')
          ..write('tax2Amount: $tax2Amount, ')
          ..write('tax2RegistrationNumber: $tax2RegistrationNumber, ')
          ..write('subtotal: $subtotal, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('terms: $terms, ')
          ..write('poNumber: $poNumber, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedReasonCode: $deletedReasonCode, ')
          ..write('deletedDate: $deletedDate, ')
          ..write('deletedNotes: $deletedNotes, ')
          ..write('supersededByInvoiceId: $supersededByInvoiceId, ')
          ..write('notes: $notes, ')
          ..write('internalNotes: $internalNotes, ')
          ..write('workDescription: $workDescription, ')
          ..write('isSent: $isSent, ')
          ..write('invoiceType: $invoiceType')
          ..write(')'))
        .toString();
  }
}

class $InvoicePaymentsTable extends InvoicePayments
    with TableInfo<$InvoicePaymentsTable, DbInvoicePayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicePaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<String> paymentDate = GeneratedColumn<String>(
    'payment_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentReferenceMeta = const VerificationMeta(
    'paymentReference',
  );
  @override
  late final GeneratedColumn<String> paymentReference = GeneratedColumn<String>(
    'payment_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentNotesMeta = const VerificationMeta(
    'paymentNotes',
  );
  @override
  late final GeneratedColumn<String> paymentNotes = GeneratedColumn<String>(
    'payment_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isVoidMeta = const VerificationMeta('isVoid');
  @override
  late final GeneratedColumn<int> isVoid = GeneratedColumn<int>(
    'is_void',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _voidReasonCodeMeta = const VerificationMeta(
    'voidReasonCode',
  );
  @override
  late final GeneratedColumn<String> voidReasonCode = GeneratedColumn<String>(
    'void_reason_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voidDateMeta = const VerificationMeta(
    'voidDate',
  );
  @override
  late final GeneratedColumn<String> voidDate = GeneratedColumn<String>(
    'void_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voidNotesMeta = const VerificationMeta(
    'voidNotes',
  );
  @override
  late final GeneratedColumn<String> voidNotes = GeneratedColumn<String>(
    'void_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceId,
    amount,
    paymentDate,
    paymentMethod,
    paymentReference,
    paymentNotes,
    isVoid,
    voidReasonCode,
    voidDate,
    voidNotes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbInvoicePayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('payment_reference')) {
      context.handle(
        _paymentReferenceMeta,
        paymentReference.isAcceptableOrUnknown(
          data['payment_reference']!,
          _paymentReferenceMeta,
        ),
      );
    }
    if (data.containsKey('payment_notes')) {
      context.handle(
        _paymentNotesMeta,
        paymentNotes.isAcceptableOrUnknown(
          data['payment_notes']!,
          _paymentNotesMeta,
        ),
      );
    }
    if (data.containsKey('is_void')) {
      context.handle(
        _isVoidMeta,
        isVoid.isAcceptableOrUnknown(data['is_void']!, _isVoidMeta),
      );
    }
    if (data.containsKey('void_reason_code')) {
      context.handle(
        _voidReasonCodeMeta,
        voidReasonCode.isAcceptableOrUnknown(
          data['void_reason_code']!,
          _voidReasonCodeMeta,
        ),
      );
    }
    if (data.containsKey('void_date')) {
      context.handle(
        _voidDateMeta,
        voidDate.isAcceptableOrUnknown(data['void_date']!, _voidDateMeta),
      );
    }
    if (data.containsKey('void_notes')) {
      context.handle(
        _voidNotesMeta,
        voidNotes.isAcceptableOrUnknown(data['void_notes']!, _voidNotesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbInvoicePayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbInvoicePayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_date'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      ),
      paymentReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_reference'],
      ),
      paymentNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_notes'],
      ),
      isVoid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_void'],
      )!,
      voidReasonCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}void_reason_code'],
      ),
      voidDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}void_date'],
      ),
      voidNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}void_notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InvoicePaymentsTable createAlias(String alias) {
    return $InvoicePaymentsTable(attachedDatabase, alias);
  }
}

class DbInvoicePayment extends DataClass
    implements Insertable<DbInvoicePayment> {
  final int id;
  final int invoiceId;

  /// Payment amount in cents.
  final int amount;
  final String paymentDate;
  final String? paymentMethod;
  final String? paymentReference;
  final String? paymentNotes;
  final int isVoid;
  final String? voidReasonCode;
  final String? voidDate;
  final String? voidNotes;
  final String createdAt;
  const DbInvoicePayment({
    required this.id,
    required this.invoiceId,
    required this.amount,
    required this.paymentDate,
    this.paymentMethod,
    this.paymentReference,
    this.paymentNotes,
    required this.isVoid,
    this.voidReasonCode,
    this.voidDate,
    this.voidNotes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<int>(invoiceId);
    map['amount'] = Variable<int>(amount);
    map['payment_date'] = Variable<String>(paymentDate);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || paymentReference != null) {
      map['payment_reference'] = Variable<String>(paymentReference);
    }
    if (!nullToAbsent || paymentNotes != null) {
      map['payment_notes'] = Variable<String>(paymentNotes);
    }
    map['is_void'] = Variable<int>(isVoid);
    if (!nullToAbsent || voidReasonCode != null) {
      map['void_reason_code'] = Variable<String>(voidReasonCode);
    }
    if (!nullToAbsent || voidDate != null) {
      map['void_date'] = Variable<String>(voidDate);
    }
    if (!nullToAbsent || voidNotes != null) {
      map['void_notes'] = Variable<String>(voidNotes);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  InvoicePaymentsCompanion toCompanion(bool nullToAbsent) {
    return InvoicePaymentsCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      amount: Value(amount),
      paymentDate: Value(paymentDate),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      paymentReference: paymentReference == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentReference),
      paymentNotes: paymentNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentNotes),
      isVoid: Value(isVoid),
      voidReasonCode: voidReasonCode == null && nullToAbsent
          ? const Value.absent()
          : Value(voidReasonCode),
      voidDate: voidDate == null && nullToAbsent
          ? const Value.absent()
          : Value(voidDate),
      voidNotes: voidNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(voidNotes),
      createdAt: Value(createdAt),
    );
  }

  factory DbInvoicePayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbInvoicePayment(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      amount: serializer.fromJson<int>(json['amount']),
      paymentDate: serializer.fromJson<String>(json['paymentDate']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      paymentReference: serializer.fromJson<String?>(json['paymentReference']),
      paymentNotes: serializer.fromJson<String?>(json['paymentNotes']),
      isVoid: serializer.fromJson<int>(json['isVoid']),
      voidReasonCode: serializer.fromJson<String?>(json['voidReasonCode']),
      voidDate: serializer.fromJson<String?>(json['voidDate']),
      voidNotes: serializer.fromJson<String?>(json['voidNotes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'amount': serializer.toJson<int>(amount),
      'paymentDate': serializer.toJson<String>(paymentDate),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'paymentReference': serializer.toJson<String?>(paymentReference),
      'paymentNotes': serializer.toJson<String?>(paymentNotes),
      'isVoid': serializer.toJson<int>(isVoid),
      'voidReasonCode': serializer.toJson<String?>(voidReasonCode),
      'voidDate': serializer.toJson<String?>(voidDate),
      'voidNotes': serializer.toJson<String?>(voidNotes),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  DbInvoicePayment copyWith({
    int? id,
    int? invoiceId,
    int? amount,
    String? paymentDate,
    Value<String?> paymentMethod = const Value.absent(),
    Value<String?> paymentReference = const Value.absent(),
    Value<String?> paymentNotes = const Value.absent(),
    int? isVoid,
    Value<String?> voidReasonCode = const Value.absent(),
    Value<String?> voidDate = const Value.absent(),
    Value<String?> voidNotes = const Value.absent(),
    String? createdAt,
  }) => DbInvoicePayment(
    id: id ?? this.id,
    invoiceId: invoiceId ?? this.invoiceId,
    amount: amount ?? this.amount,
    paymentDate: paymentDate ?? this.paymentDate,
    paymentMethod: paymentMethod.present
        ? paymentMethod.value
        : this.paymentMethod,
    paymentReference: paymentReference.present
        ? paymentReference.value
        : this.paymentReference,
    paymentNotes: paymentNotes.present ? paymentNotes.value : this.paymentNotes,
    isVoid: isVoid ?? this.isVoid,
    voidReasonCode: voidReasonCode.present
        ? voidReasonCode.value
        : this.voidReasonCode,
    voidDate: voidDate.present ? voidDate.value : this.voidDate,
    voidNotes: voidNotes.present ? voidNotes.value : this.voidNotes,
    createdAt: createdAt ?? this.createdAt,
  );
  DbInvoicePayment copyWithCompanion(InvoicePaymentsCompanion data) {
    return DbInvoicePayment(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      paymentReference: data.paymentReference.present
          ? data.paymentReference.value
          : this.paymentReference,
      paymentNotes: data.paymentNotes.present
          ? data.paymentNotes.value
          : this.paymentNotes,
      isVoid: data.isVoid.present ? data.isVoid.value : this.isVoid,
      voidReasonCode: data.voidReasonCode.present
          ? data.voidReasonCode.value
          : this.voidReasonCode,
      voidDate: data.voidDate.present ? data.voidDate.value : this.voidDate,
      voidNotes: data.voidNotes.present ? data.voidNotes.value : this.voidNotes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbInvoicePayment(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('amount: $amount, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentReference: $paymentReference, ')
          ..write('paymentNotes: $paymentNotes, ')
          ..write('isVoid: $isVoid, ')
          ..write('voidReasonCode: $voidReasonCode, ')
          ..write('voidDate: $voidDate, ')
          ..write('voidNotes: $voidNotes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    invoiceId,
    amount,
    paymentDate,
    paymentMethod,
    paymentReference,
    paymentNotes,
    isVoid,
    voidReasonCode,
    voidDate,
    voidNotes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbInvoicePayment &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.amount == this.amount &&
          other.paymentDate == this.paymentDate &&
          other.paymentMethod == this.paymentMethod &&
          other.paymentReference == this.paymentReference &&
          other.paymentNotes == this.paymentNotes &&
          other.isVoid == this.isVoid &&
          other.voidReasonCode == this.voidReasonCode &&
          other.voidDate == this.voidDate &&
          other.voidNotes == this.voidNotes &&
          other.createdAt == this.createdAt);
}

class InvoicePaymentsCompanion extends UpdateCompanion<DbInvoicePayment> {
  final Value<int> id;
  final Value<int> invoiceId;
  final Value<int> amount;
  final Value<String> paymentDate;
  final Value<String?> paymentMethod;
  final Value<String?> paymentReference;
  final Value<String?> paymentNotes;
  final Value<int> isVoid;
  final Value<String?> voidReasonCode;
  final Value<String?> voidDate;
  final Value<String?> voidNotes;
  final Value<String> createdAt;
  const InvoicePaymentsCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.paymentReference = const Value.absent(),
    this.paymentNotes = const Value.absent(),
    this.isVoid = const Value.absent(),
    this.voidReasonCode = const Value.absent(),
    this.voidDate = const Value.absent(),
    this.voidNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InvoicePaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceId,
    required int amount,
    required String paymentDate,
    this.paymentMethod = const Value.absent(),
    this.paymentReference = const Value.absent(),
    this.paymentNotes = const Value.absent(),
    this.isVoid = const Value.absent(),
    this.voidReasonCode = const Value.absent(),
    this.voidDate = const Value.absent(),
    this.voidNotes = const Value.absent(),
    required String createdAt,
  }) : invoiceId = Value(invoiceId),
       amount = Value(amount),
       paymentDate = Value(paymentDate),
       createdAt = Value(createdAt);
  static Insertable<DbInvoicePayment> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<int>? amount,
    Expression<String>? paymentDate,
    Expression<String>? paymentMethod,
    Expression<String>? paymentReference,
    Expression<String>? paymentNotes,
    Expression<int>? isVoid,
    Expression<String>? voidReasonCode,
    Expression<String>? voidDate,
    Expression<String>? voidNotes,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (amount != null) 'amount': amount,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (paymentReference != null) 'payment_reference': paymentReference,
      if (paymentNotes != null) 'payment_notes': paymentNotes,
      if (isVoid != null) 'is_void': isVoid,
      if (voidReasonCode != null) 'void_reason_code': voidReasonCode,
      if (voidDate != null) 'void_date': voidDate,
      if (voidNotes != null) 'void_notes': voidNotes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InvoicePaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? invoiceId,
    Value<int>? amount,
    Value<String>? paymentDate,
    Value<String?>? paymentMethod,
    Value<String?>? paymentReference,
    Value<String?>? paymentNotes,
    Value<int>? isVoid,
    Value<String?>? voidReasonCode,
    Value<String?>? voidDate,
    Value<String?>? voidNotes,
    Value<String>? createdAt,
  }) {
    return InvoicePaymentsCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentReference: paymentReference ?? this.paymentReference,
      paymentNotes: paymentNotes ?? this.paymentNotes,
      isVoid: isVoid ?? this.isVoid,
      voidReasonCode: voidReasonCode ?? this.voidReasonCode,
      voidDate: voidDate ?? this.voidDate,
      voidNotes: voidNotes ?? this.voidNotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<String>(paymentDate.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (paymentReference.present) {
      map['payment_reference'] = Variable<String>(paymentReference.value);
    }
    if (paymentNotes.present) {
      map['payment_notes'] = Variable<String>(paymentNotes.value);
    }
    if (isVoid.present) {
      map['is_void'] = Variable<int>(isVoid.value);
    }
    if (voidReasonCode.present) {
      map['void_reason_code'] = Variable<String>(voidReasonCode.value);
    }
    if (voidDate.present) {
      map['void_date'] = Variable<String>(voidDate.value);
    }
    if (voidNotes.present) {
      map['void_notes'] = Variable<String>(voidNotes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicePaymentsCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('amount: $amount, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentReference: $paymentReference, ')
          ..write('paymentNotes: $paymentNotes, ')
          ..write('isVoid: $isVoid, ')
          ..write('voidReasonCode: $voidReasonCode, ')
          ..write('voidDate: $voidDate, ')
          ..write('voidNotes: $voidNotes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TimeEntriesTable extends TimeEntries
    with TableInfo<$TimeEntriesTable, DbTimeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pausedDurationMeta = const VerificationMeta(
    'pausedDuration',
  );
  @override
  late final GeneratedColumn<double> pausedDuration = GeneratedColumn<double>(
    'paused_duration',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _finalBilledDurationSecondsMeta =
      const VerificationMeta('finalBilledDurationSeconds');
  @override
  late final GeneratedColumn<double> finalBilledDurationSeconds =
      GeneratedColumn<double>(
        'final_billed_duration_seconds',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _hourlyRateMeta = const VerificationMeta(
    'hourlyRate',
  );
  @override
  late final GeneratedColumn<int> hourlyRate = GeneratedColumn<int>(
    'hourly_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPausedMeta = const VerificationMeta(
    'isPaused',
  );
  @override
  late final GeneratedColumn<int> isPaused = GeneratedColumn<int>(
    'is_paused',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pauseStartTimeMeta = const VerificationMeta(
    'pauseStartTime',
  );
  @override
  late final GeneratedColumn<String> pauseStartTime = GeneratedColumn<String>(
    'pause_start_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _workDetailsMeta = const VerificationMeta(
    'workDetails',
  );
  @override
  late final GeneratedColumn<String> workDetails = GeneratedColumn<String>(
    'work_details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costCodeIdMeta = const VerificationMeta(
    'costCodeId',
  );
  @override
  late final GeneratedColumn<int> costCodeId = GeneratedColumn<int>(
    'cost_code_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cost_codes (id)',
    ),
  );
  static const VerificationMeta _isBilledMeta = const VerificationMeta(
    'isBilled',
  );
  @override
  late final GeneratedColumn<int> isBilled = GeneratedColumn<int>(
    'is_billed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
    'invoice_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    employeeId,
    startTime,
    endTime,
    pausedDuration,
    finalBilledDurationSeconds,
    hourlyRate,
    isPaused,
    pauseStartTime,
    isDeleted,
    workDetails,
    costCodeId,
    isBilled,
    invoiceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbTimeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('paused_duration')) {
      context.handle(
        _pausedDurationMeta,
        pausedDuration.isAcceptableOrUnknown(
          data['paused_duration']!,
          _pausedDurationMeta,
        ),
      );
    }
    if (data.containsKey('final_billed_duration_seconds')) {
      context.handle(
        _finalBilledDurationSecondsMeta,
        finalBilledDurationSeconds.isAcceptableOrUnknown(
          data['final_billed_duration_seconds']!,
          _finalBilledDurationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('hourly_rate')) {
      context.handle(
        _hourlyRateMeta,
        hourlyRate.isAcceptableOrUnknown(data['hourly_rate']!, _hourlyRateMeta),
      );
    }
    if (data.containsKey('is_paused')) {
      context.handle(
        _isPausedMeta,
        isPaused.isAcceptableOrUnknown(data['is_paused']!, _isPausedMeta),
      );
    }
    if (data.containsKey('pause_start_time')) {
      context.handle(
        _pauseStartTimeMeta,
        pauseStartTime.isAcceptableOrUnknown(
          data['pause_start_time']!,
          _pauseStartTimeMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('work_details')) {
      context.handle(
        _workDetailsMeta,
        workDetails.isAcceptableOrUnknown(
          data['work_details']!,
          _workDetailsMeta,
        ),
      );
    }
    if (data.containsKey('cost_code_id')) {
      context.handle(
        _costCodeIdMeta,
        costCodeId.isAcceptableOrUnknown(
          data['cost_code_id']!,
          _costCodeIdMeta,
        ),
      );
    }
    if (data.containsKey('is_billed')) {
      context.handle(
        _isBilledMeta,
        isBilled.isAcceptableOrUnknown(data['is_billed']!, _isBilledMeta),
      );
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbTimeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbTimeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      ),
      pausedDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}paused_duration'],
      )!,
      finalBilledDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}final_billed_duration_seconds'],
      ),
      hourlyRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hourly_rate'],
      ),
      isPaused: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_paused'],
      )!,
      pauseStartTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pause_start_time'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_deleted'],
      )!,
      workDetails: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_details'],
      ),
      costCodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_code_id'],
      ),
      isBilled: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_billed'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_id'],
      ),
    );
  }

  @override
  $TimeEntriesTable createAlias(String alias) {
    return $TimeEntriesTable(attachedDatabase, alias);
  }
}

class DbTimeEntry extends DataClass implements Insertable<DbTimeEntry> {
  final int id;
  final int projectId;
  final int? employeeId;
  final String startTime;
  final String? endTime;
  final double pausedDuration;
  final double? finalBilledDurationSeconds;
  final int? hourlyRate;
  final int isPaused;
  final String? pauseStartTime;
  final int isDeleted;
  final String? workDetails;
  final int? costCodeId;
  final int isBilled;
  final int? invoiceId;
  const DbTimeEntry({
    required this.id,
    required this.projectId,
    this.employeeId,
    required this.startTime,
    this.endTime,
    required this.pausedDuration,
    this.finalBilledDurationSeconds,
    this.hourlyRate,
    required this.isPaused,
    this.pauseStartTime,
    required this.isDeleted,
    this.workDetails,
    this.costCodeId,
    required this.isBilled,
    this.invoiceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    if (!nullToAbsent || employeeId != null) {
      map['employee_id'] = Variable<int>(employeeId);
    }
    map['start_time'] = Variable<String>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<String>(endTime);
    }
    map['paused_duration'] = Variable<double>(pausedDuration);
    if (!nullToAbsent || finalBilledDurationSeconds != null) {
      map['final_billed_duration_seconds'] = Variable<double>(
        finalBilledDurationSeconds,
      );
    }
    if (!nullToAbsent || hourlyRate != null) {
      map['hourly_rate'] = Variable<int>(hourlyRate);
    }
    map['is_paused'] = Variable<int>(isPaused);
    if (!nullToAbsent || pauseStartTime != null) {
      map['pause_start_time'] = Variable<String>(pauseStartTime);
    }
    map['is_deleted'] = Variable<int>(isDeleted);
    if (!nullToAbsent || workDetails != null) {
      map['work_details'] = Variable<String>(workDetails);
    }
    if (!nullToAbsent || costCodeId != null) {
      map['cost_code_id'] = Variable<int>(costCodeId);
    }
    map['is_billed'] = Variable<int>(isBilled);
    if (!nullToAbsent || invoiceId != null) {
      map['invoice_id'] = Variable<int>(invoiceId);
    }
    return map;
  }

  TimeEntriesCompanion toCompanion(bool nullToAbsent) {
    return TimeEntriesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      employeeId: employeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeId),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      pausedDuration: Value(pausedDuration),
      finalBilledDurationSeconds:
          finalBilledDurationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(finalBilledDurationSeconds),
      hourlyRate: hourlyRate == null && nullToAbsent
          ? const Value.absent()
          : Value(hourlyRate),
      isPaused: Value(isPaused),
      pauseStartTime: pauseStartTime == null && nullToAbsent
          ? const Value.absent()
          : Value(pauseStartTime),
      isDeleted: Value(isDeleted),
      workDetails: workDetails == null && nullToAbsent
          ? const Value.absent()
          : Value(workDetails),
      costCodeId: costCodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(costCodeId),
      isBilled: Value(isBilled),
      invoiceId: invoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceId),
    );
  }

  factory DbTimeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbTimeEntry(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      employeeId: serializer.fromJson<int?>(json['employeeId']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String?>(json['endTime']),
      pausedDuration: serializer.fromJson<double>(json['pausedDuration']),
      finalBilledDurationSeconds: serializer.fromJson<double?>(
        json['finalBilledDurationSeconds'],
      ),
      hourlyRate: serializer.fromJson<int?>(json['hourlyRate']),
      isPaused: serializer.fromJson<int>(json['isPaused']),
      pauseStartTime: serializer.fromJson<String?>(json['pauseStartTime']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
      workDetails: serializer.fromJson<String?>(json['workDetails']),
      costCodeId: serializer.fromJson<int?>(json['costCodeId']),
      isBilled: serializer.fromJson<int>(json['isBilled']),
      invoiceId: serializer.fromJson<int?>(json['invoiceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'employeeId': serializer.toJson<int?>(employeeId),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String?>(endTime),
      'pausedDuration': serializer.toJson<double>(pausedDuration),
      'finalBilledDurationSeconds': serializer.toJson<double?>(
        finalBilledDurationSeconds,
      ),
      'hourlyRate': serializer.toJson<int?>(hourlyRate),
      'isPaused': serializer.toJson<int>(isPaused),
      'pauseStartTime': serializer.toJson<String?>(pauseStartTime),
      'isDeleted': serializer.toJson<int>(isDeleted),
      'workDetails': serializer.toJson<String?>(workDetails),
      'costCodeId': serializer.toJson<int?>(costCodeId),
      'isBilled': serializer.toJson<int>(isBilled),
      'invoiceId': serializer.toJson<int?>(invoiceId),
    };
  }

  DbTimeEntry copyWith({
    int? id,
    int? projectId,
    Value<int?> employeeId = const Value.absent(),
    String? startTime,
    Value<String?> endTime = const Value.absent(),
    double? pausedDuration,
    Value<double?> finalBilledDurationSeconds = const Value.absent(),
    Value<int?> hourlyRate = const Value.absent(),
    int? isPaused,
    Value<String?> pauseStartTime = const Value.absent(),
    int? isDeleted,
    Value<String?> workDetails = const Value.absent(),
    Value<int?> costCodeId = const Value.absent(),
    int? isBilled,
    Value<int?> invoiceId = const Value.absent(),
  }) => DbTimeEntry(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    employeeId: employeeId.present ? employeeId.value : this.employeeId,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    pausedDuration: pausedDuration ?? this.pausedDuration,
    finalBilledDurationSeconds: finalBilledDurationSeconds.present
        ? finalBilledDurationSeconds.value
        : this.finalBilledDurationSeconds,
    hourlyRate: hourlyRate.present ? hourlyRate.value : this.hourlyRate,
    isPaused: isPaused ?? this.isPaused,
    pauseStartTime: pauseStartTime.present
        ? pauseStartTime.value
        : this.pauseStartTime,
    isDeleted: isDeleted ?? this.isDeleted,
    workDetails: workDetails.present ? workDetails.value : this.workDetails,
    costCodeId: costCodeId.present ? costCodeId.value : this.costCodeId,
    isBilled: isBilled ?? this.isBilled,
    invoiceId: invoiceId.present ? invoiceId.value : this.invoiceId,
  );
  DbTimeEntry copyWithCompanion(TimeEntriesCompanion data) {
    return DbTimeEntry(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      pausedDuration: data.pausedDuration.present
          ? data.pausedDuration.value
          : this.pausedDuration,
      finalBilledDurationSeconds: data.finalBilledDurationSeconds.present
          ? data.finalBilledDurationSeconds.value
          : this.finalBilledDurationSeconds,
      hourlyRate: data.hourlyRate.present
          ? data.hourlyRate.value
          : this.hourlyRate,
      isPaused: data.isPaused.present ? data.isPaused.value : this.isPaused,
      pauseStartTime: data.pauseStartTime.present
          ? data.pauseStartTime.value
          : this.pauseStartTime,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      workDetails: data.workDetails.present
          ? data.workDetails.value
          : this.workDetails,
      costCodeId: data.costCodeId.present
          ? data.costCodeId.value
          : this.costCodeId,
      isBilled: data.isBilled.present ? data.isBilled.value : this.isBilled,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbTimeEntry(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('employeeId: $employeeId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('pausedDuration: $pausedDuration, ')
          ..write('finalBilledDurationSeconds: $finalBilledDurationSeconds, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('isPaused: $isPaused, ')
          ..write('pauseStartTime: $pauseStartTime, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('workDetails: $workDetails, ')
          ..write('costCodeId: $costCodeId, ')
          ..write('isBilled: $isBilled, ')
          ..write('invoiceId: $invoiceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    employeeId,
    startTime,
    endTime,
    pausedDuration,
    finalBilledDurationSeconds,
    hourlyRate,
    isPaused,
    pauseStartTime,
    isDeleted,
    workDetails,
    costCodeId,
    isBilled,
    invoiceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbTimeEntry &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.employeeId == this.employeeId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.pausedDuration == this.pausedDuration &&
          other.finalBilledDurationSeconds == this.finalBilledDurationSeconds &&
          other.hourlyRate == this.hourlyRate &&
          other.isPaused == this.isPaused &&
          other.pauseStartTime == this.pauseStartTime &&
          other.isDeleted == this.isDeleted &&
          other.workDetails == this.workDetails &&
          other.costCodeId == this.costCodeId &&
          other.isBilled == this.isBilled &&
          other.invoiceId == this.invoiceId);
}

class TimeEntriesCompanion extends UpdateCompanion<DbTimeEntry> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<int?> employeeId;
  final Value<String> startTime;
  final Value<String?> endTime;
  final Value<double> pausedDuration;
  final Value<double?> finalBilledDurationSeconds;
  final Value<int?> hourlyRate;
  final Value<int> isPaused;
  final Value<String?> pauseStartTime;
  final Value<int> isDeleted;
  final Value<String?> workDetails;
  final Value<int?> costCodeId;
  final Value<int> isBilled;
  final Value<int?> invoiceId;
  const TimeEntriesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.pausedDuration = const Value.absent(),
    this.finalBilledDurationSeconds = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.isPaused = const Value.absent(),
    this.pauseStartTime = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.workDetails = const Value.absent(),
    this.costCodeId = const Value.absent(),
    this.isBilled = const Value.absent(),
    this.invoiceId = const Value.absent(),
  });
  TimeEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    this.employeeId = const Value.absent(),
    required String startTime,
    this.endTime = const Value.absent(),
    this.pausedDuration = const Value.absent(),
    this.finalBilledDurationSeconds = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.isPaused = const Value.absent(),
    this.pauseStartTime = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.workDetails = const Value.absent(),
    this.costCodeId = const Value.absent(),
    this.isBilled = const Value.absent(),
    this.invoiceId = const Value.absent(),
  }) : projectId = Value(projectId),
       startTime = Value(startTime);
  static Insertable<DbTimeEntry> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<int>? employeeId,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<double>? pausedDuration,
    Expression<double>? finalBilledDurationSeconds,
    Expression<int>? hourlyRate,
    Expression<int>? isPaused,
    Expression<String>? pauseStartTime,
    Expression<int>? isDeleted,
    Expression<String>? workDetails,
    Expression<int>? costCodeId,
    Expression<int>? isBilled,
    Expression<int>? invoiceId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (employeeId != null) 'employee_id': employeeId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (pausedDuration != null) 'paused_duration': pausedDuration,
      if (finalBilledDurationSeconds != null)
        'final_billed_duration_seconds': finalBilledDurationSeconds,
      if (hourlyRate != null) 'hourly_rate': hourlyRate,
      if (isPaused != null) 'is_paused': isPaused,
      if (pauseStartTime != null) 'pause_start_time': pauseStartTime,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (workDetails != null) 'work_details': workDetails,
      if (costCodeId != null) 'cost_code_id': costCodeId,
      if (isBilled != null) 'is_billed': isBilled,
      if (invoiceId != null) 'invoice_id': invoiceId,
    });
  }

  TimeEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<int?>? employeeId,
    Value<String>? startTime,
    Value<String?>? endTime,
    Value<double>? pausedDuration,
    Value<double?>? finalBilledDurationSeconds,
    Value<int?>? hourlyRate,
    Value<int>? isPaused,
    Value<String?>? pauseStartTime,
    Value<int>? isDeleted,
    Value<String?>? workDetails,
    Value<int?>? costCodeId,
    Value<int>? isBilled,
    Value<int?>? invoiceId,
  }) {
    return TimeEntriesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      employeeId: employeeId ?? this.employeeId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      pausedDuration: pausedDuration ?? this.pausedDuration,
      finalBilledDurationSeconds:
          finalBilledDurationSeconds ?? this.finalBilledDurationSeconds,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      isPaused: isPaused ?? this.isPaused,
      pauseStartTime: pauseStartTime ?? this.pauseStartTime,
      isDeleted: isDeleted ?? this.isDeleted,
      workDetails: workDetails ?? this.workDetails,
      costCodeId: costCodeId ?? this.costCodeId,
      isBilled: isBilled ?? this.isBilled,
      invoiceId: invoiceId ?? this.invoiceId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (pausedDuration.present) {
      map['paused_duration'] = Variable<double>(pausedDuration.value);
    }
    if (finalBilledDurationSeconds.present) {
      map['final_billed_duration_seconds'] = Variable<double>(
        finalBilledDurationSeconds.value,
      );
    }
    if (hourlyRate.present) {
      map['hourly_rate'] = Variable<int>(hourlyRate.value);
    }
    if (isPaused.present) {
      map['is_paused'] = Variable<int>(isPaused.value);
    }
    if (pauseStartTime.present) {
      map['pause_start_time'] = Variable<String>(pauseStartTime.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    if (workDetails.present) {
      map['work_details'] = Variable<String>(workDetails.value);
    }
    if (costCodeId.present) {
      map['cost_code_id'] = Variable<int>(costCodeId.value);
    }
    if (isBilled.present) {
      map['is_billed'] = Variable<int>(isBilled.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimeEntriesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('employeeId: $employeeId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('pausedDuration: $pausedDuration, ')
          ..write('finalBilledDurationSeconds: $finalBilledDurationSeconds, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('isPaused: $isPaused, ')
          ..write('pauseStartTime: $pauseStartTime, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('workDetails: $workDetails, ')
          ..write('costCodeId: $costCodeId, ')
          ..write('isBilled: $isBilled, ')
          ..write('invoiceId: $invoiceId')
          ..write(')'))
        .toString();
  }
}

class $MaterialsTable extends Materials
    with TableInfo<$MaterialsTable, DbMaterial> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaterialsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _itemNameMeta = const VerificationMeta(
    'itemName',
  );
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
    'item_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<String> purchaseDate = GeneratedColumn<String>(
    'purchase_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _expenseCategoryMeta = const VerificationMeta(
    'expenseCategory',
  );
  @override
  late final GeneratedColumn<String> expenseCategory = GeneratedColumn<String>(
    'expense_category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baseQuantityMeta = const VerificationMeta(
    'baseQuantity',
  );
  @override
  late final GeneratedColumn<double> baseQuantity = GeneratedColumn<double>(
    'base_quantity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _odometerReadingMeta = const VerificationMeta(
    'odometerReading',
  );
  @override
  late final GeneratedColumn<double> odometerReading = GeneratedColumn<double>(
    'odometer_reading',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompanyExpenseMeta = const VerificationMeta(
    'isCompanyExpense',
  );
  @override
  late final GeneratedColumn<int> isCompanyExpense = GeneratedColumn<int>(
    'is_company_expense',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _vehicleDesignationMeta =
      const VerificationMeta('vehicleDesignation');
  @override
  late final GeneratedColumn<String> vehicleDesignation =
      GeneratedColumn<String>(
        'vehicle_designation',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _vendorOrSubtradeMeta = const VerificationMeta(
    'vendorOrSubtrade',
  );
  @override
  late final GeneratedColumn<String> vendorOrSubtrade = GeneratedColumn<String>(
    'vendor_or_subtrade',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costCodeIdMeta = const VerificationMeta(
    'costCodeId',
  );
  @override
  late final GeneratedColumn<int> costCodeId = GeneratedColumn<int>(
    'cost_code_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cost_codes (id)',
    ),
  );
  static const VerificationMeta _isBilledMeta = const VerificationMeta(
    'isBilled',
  );
  @override
  late final GeneratedColumn<int> isBilled = GeneratedColumn<int>(
    'is_billed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
    'invoice_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    itemName,
    cost,
    purchaseDate,
    description,
    isDeleted,
    expenseCategory,
    unit,
    quantity,
    baseQuantity,
    odometerReading,
    isCompanyExpense,
    vehicleDesignation,
    vendorOrSubtrade,
    costCodeId,
    isBilled,
    invoiceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'materials';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbMaterial> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(
        _itemNameMeta,
        itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta),
      );
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('expense_category')) {
      context.handle(
        _expenseCategoryMeta,
        expenseCategory.isAcceptableOrUnknown(
          data['expense_category']!,
          _expenseCategoryMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('base_quantity')) {
      context.handle(
        _baseQuantityMeta,
        baseQuantity.isAcceptableOrUnknown(
          data['base_quantity']!,
          _baseQuantityMeta,
        ),
      );
    }
    if (data.containsKey('odometer_reading')) {
      context.handle(
        _odometerReadingMeta,
        odometerReading.isAcceptableOrUnknown(
          data['odometer_reading']!,
          _odometerReadingMeta,
        ),
      );
    }
    if (data.containsKey('is_company_expense')) {
      context.handle(
        _isCompanyExpenseMeta,
        isCompanyExpense.isAcceptableOrUnknown(
          data['is_company_expense']!,
          _isCompanyExpenseMeta,
        ),
      );
    }
    if (data.containsKey('vehicle_designation')) {
      context.handle(
        _vehicleDesignationMeta,
        vehicleDesignation.isAcceptableOrUnknown(
          data['vehicle_designation']!,
          _vehicleDesignationMeta,
        ),
      );
    }
    if (data.containsKey('vendor_or_subtrade')) {
      context.handle(
        _vendorOrSubtradeMeta,
        vendorOrSubtrade.isAcceptableOrUnknown(
          data['vendor_or_subtrade']!,
          _vendorOrSubtradeMeta,
        ),
      );
    }
    if (data.containsKey('cost_code_id')) {
      context.handle(
        _costCodeIdMeta,
        costCodeId.isAcceptableOrUnknown(
          data['cost_code_id']!,
          _costCodeIdMeta,
        ),
      );
    }
    if (data.containsKey('is_billed')) {
      context.handle(
        _isBilledMeta,
        isBilled.isAcceptableOrUnknown(data['is_billed']!, _isBilledMeta),
      );
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbMaterial map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbMaterial(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      itemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_name'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost'],
      )!,
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_date'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_deleted'],
      )!,
      expenseCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expense_category'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      ),
      baseQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}base_quantity'],
      ),
      odometerReading: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}odometer_reading'],
      ),
      isCompanyExpense: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_company_expense'],
      )!,
      vehicleDesignation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_designation'],
      ),
      vendorOrSubtrade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor_or_subtrade'],
      ),
      costCodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_code_id'],
      ),
      isBilled: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_billed'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_id'],
      ),
    );
  }

  @override
  $MaterialsTable createAlias(String alias) {
    return $MaterialsTable(attachedDatabase, alias);
  }
}

class DbMaterial extends DataClass implements Insertable<DbMaterial> {
  final int id;
  final int projectId;
  final String itemName;
  final int cost;
  final String? purchaseDate;
  final String? description;
  final int isDeleted;
  final String? expenseCategory;
  final String? unit;
  final double? quantity;
  final double? baseQuantity;
  final double? odometerReading;
  final int isCompanyExpense;
  final String? vehicleDesignation;
  final String? vendorOrSubtrade;
  final int? costCodeId;
  final int isBilled;
  final int? invoiceId;
  const DbMaterial({
    required this.id,
    required this.projectId,
    required this.itemName,
    required this.cost,
    this.purchaseDate,
    this.description,
    required this.isDeleted,
    this.expenseCategory,
    this.unit,
    this.quantity,
    this.baseQuantity,
    this.odometerReading,
    required this.isCompanyExpense,
    this.vehicleDesignation,
    this.vendorOrSubtrade,
    this.costCodeId,
    required this.isBilled,
    this.invoiceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['item_name'] = Variable<String>(itemName);
    map['cost'] = Variable<int>(cost);
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<String>(purchaseDate);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_deleted'] = Variable<int>(isDeleted);
    if (!nullToAbsent || expenseCategory != null) {
      map['expense_category'] = Variable<String>(expenseCategory);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<double>(quantity);
    }
    if (!nullToAbsent || baseQuantity != null) {
      map['base_quantity'] = Variable<double>(baseQuantity);
    }
    if (!nullToAbsent || odometerReading != null) {
      map['odometer_reading'] = Variable<double>(odometerReading);
    }
    map['is_company_expense'] = Variable<int>(isCompanyExpense);
    if (!nullToAbsent || vehicleDesignation != null) {
      map['vehicle_designation'] = Variable<String>(vehicleDesignation);
    }
    if (!nullToAbsent || vendorOrSubtrade != null) {
      map['vendor_or_subtrade'] = Variable<String>(vendorOrSubtrade);
    }
    if (!nullToAbsent || costCodeId != null) {
      map['cost_code_id'] = Variable<int>(costCodeId);
    }
    map['is_billed'] = Variable<int>(isBilled);
    if (!nullToAbsent || invoiceId != null) {
      map['invoice_id'] = Variable<int>(invoiceId);
    }
    return map;
  }

  MaterialsCompanion toCompanion(bool nullToAbsent) {
    return MaterialsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      itemName: Value(itemName),
      cost: Value(cost),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isDeleted: Value(isDeleted),
      expenseCategory: expenseCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(expenseCategory),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      baseQuantity: baseQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(baseQuantity),
      odometerReading: odometerReading == null && nullToAbsent
          ? const Value.absent()
          : Value(odometerReading),
      isCompanyExpense: Value(isCompanyExpense),
      vehicleDesignation: vehicleDesignation == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleDesignation),
      vendorOrSubtrade: vendorOrSubtrade == null && nullToAbsent
          ? const Value.absent()
          : Value(vendorOrSubtrade),
      costCodeId: costCodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(costCodeId),
      isBilled: Value(isBilled),
      invoiceId: invoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceId),
    );
  }

  factory DbMaterial.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbMaterial(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      cost: serializer.fromJson<int>(json['cost']),
      purchaseDate: serializer.fromJson<String?>(json['purchaseDate']),
      description: serializer.fromJson<String?>(json['description']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
      expenseCategory: serializer.fromJson<String?>(json['expenseCategory']),
      unit: serializer.fromJson<String?>(json['unit']),
      quantity: serializer.fromJson<double?>(json['quantity']),
      baseQuantity: serializer.fromJson<double?>(json['baseQuantity']),
      odometerReading: serializer.fromJson<double?>(json['odometerReading']),
      isCompanyExpense: serializer.fromJson<int>(json['isCompanyExpense']),
      vehicleDesignation: serializer.fromJson<String?>(
        json['vehicleDesignation'],
      ),
      vendorOrSubtrade: serializer.fromJson<String?>(json['vendorOrSubtrade']),
      costCodeId: serializer.fromJson<int?>(json['costCodeId']),
      isBilled: serializer.fromJson<int>(json['isBilled']),
      invoiceId: serializer.fromJson<int?>(json['invoiceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'itemName': serializer.toJson<String>(itemName),
      'cost': serializer.toJson<int>(cost),
      'purchaseDate': serializer.toJson<String?>(purchaseDate),
      'description': serializer.toJson<String?>(description),
      'isDeleted': serializer.toJson<int>(isDeleted),
      'expenseCategory': serializer.toJson<String?>(expenseCategory),
      'unit': serializer.toJson<String?>(unit),
      'quantity': serializer.toJson<double?>(quantity),
      'baseQuantity': serializer.toJson<double?>(baseQuantity),
      'odometerReading': serializer.toJson<double?>(odometerReading),
      'isCompanyExpense': serializer.toJson<int>(isCompanyExpense),
      'vehicleDesignation': serializer.toJson<String?>(vehicleDesignation),
      'vendorOrSubtrade': serializer.toJson<String?>(vendorOrSubtrade),
      'costCodeId': serializer.toJson<int?>(costCodeId),
      'isBilled': serializer.toJson<int>(isBilled),
      'invoiceId': serializer.toJson<int?>(invoiceId),
    };
  }

  DbMaterial copyWith({
    int? id,
    int? projectId,
    String? itemName,
    int? cost,
    Value<String?> purchaseDate = const Value.absent(),
    Value<String?> description = const Value.absent(),
    int? isDeleted,
    Value<String?> expenseCategory = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<double?> quantity = const Value.absent(),
    Value<double?> baseQuantity = const Value.absent(),
    Value<double?> odometerReading = const Value.absent(),
    int? isCompanyExpense,
    Value<String?> vehicleDesignation = const Value.absent(),
    Value<String?> vendorOrSubtrade = const Value.absent(),
    Value<int?> costCodeId = const Value.absent(),
    int? isBilled,
    Value<int?> invoiceId = const Value.absent(),
  }) => DbMaterial(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    itemName: itemName ?? this.itemName,
    cost: cost ?? this.cost,
    purchaseDate: purchaseDate.present ? purchaseDate.value : this.purchaseDate,
    description: description.present ? description.value : this.description,
    isDeleted: isDeleted ?? this.isDeleted,
    expenseCategory: expenseCategory.present
        ? expenseCategory.value
        : this.expenseCategory,
    unit: unit.present ? unit.value : this.unit,
    quantity: quantity.present ? quantity.value : this.quantity,
    baseQuantity: baseQuantity.present ? baseQuantity.value : this.baseQuantity,
    odometerReading: odometerReading.present
        ? odometerReading.value
        : this.odometerReading,
    isCompanyExpense: isCompanyExpense ?? this.isCompanyExpense,
    vehicleDesignation: vehicleDesignation.present
        ? vehicleDesignation.value
        : this.vehicleDesignation,
    vendorOrSubtrade: vendorOrSubtrade.present
        ? vendorOrSubtrade.value
        : this.vendorOrSubtrade,
    costCodeId: costCodeId.present ? costCodeId.value : this.costCodeId,
    isBilled: isBilled ?? this.isBilled,
    invoiceId: invoiceId.present ? invoiceId.value : this.invoiceId,
  );
  DbMaterial copyWithCompanion(MaterialsCompanion data) {
    return DbMaterial(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      cost: data.cost.present ? data.cost.value : this.cost,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      description: data.description.present
          ? data.description.value
          : this.description,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      expenseCategory: data.expenseCategory.present
          ? data.expenseCategory.value
          : this.expenseCategory,
      unit: data.unit.present ? data.unit.value : this.unit,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      baseQuantity: data.baseQuantity.present
          ? data.baseQuantity.value
          : this.baseQuantity,
      odometerReading: data.odometerReading.present
          ? data.odometerReading.value
          : this.odometerReading,
      isCompanyExpense: data.isCompanyExpense.present
          ? data.isCompanyExpense.value
          : this.isCompanyExpense,
      vehicleDesignation: data.vehicleDesignation.present
          ? data.vehicleDesignation.value
          : this.vehicleDesignation,
      vendorOrSubtrade: data.vendorOrSubtrade.present
          ? data.vendorOrSubtrade.value
          : this.vendorOrSubtrade,
      costCodeId: data.costCodeId.present
          ? data.costCodeId.value
          : this.costCodeId,
      isBilled: data.isBilled.present ? data.isBilled.value : this.isBilled,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbMaterial(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('itemName: $itemName, ')
          ..write('cost: $cost, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('description: $description, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('expenseCategory: $expenseCategory, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('baseQuantity: $baseQuantity, ')
          ..write('odometerReading: $odometerReading, ')
          ..write('isCompanyExpense: $isCompanyExpense, ')
          ..write('vehicleDesignation: $vehicleDesignation, ')
          ..write('vendorOrSubtrade: $vendorOrSubtrade, ')
          ..write('costCodeId: $costCodeId, ')
          ..write('isBilled: $isBilled, ')
          ..write('invoiceId: $invoiceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    itemName,
    cost,
    purchaseDate,
    description,
    isDeleted,
    expenseCategory,
    unit,
    quantity,
    baseQuantity,
    odometerReading,
    isCompanyExpense,
    vehicleDesignation,
    vendorOrSubtrade,
    costCodeId,
    isBilled,
    invoiceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbMaterial &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.itemName == this.itemName &&
          other.cost == this.cost &&
          other.purchaseDate == this.purchaseDate &&
          other.description == this.description &&
          other.isDeleted == this.isDeleted &&
          other.expenseCategory == this.expenseCategory &&
          other.unit == this.unit &&
          other.quantity == this.quantity &&
          other.baseQuantity == this.baseQuantity &&
          other.odometerReading == this.odometerReading &&
          other.isCompanyExpense == this.isCompanyExpense &&
          other.vehicleDesignation == this.vehicleDesignation &&
          other.vendorOrSubtrade == this.vendorOrSubtrade &&
          other.costCodeId == this.costCodeId &&
          other.isBilled == this.isBilled &&
          other.invoiceId == this.invoiceId);
}

class MaterialsCompanion extends UpdateCompanion<DbMaterial> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<String> itemName;
  final Value<int> cost;
  final Value<String?> purchaseDate;
  final Value<String?> description;
  final Value<int> isDeleted;
  final Value<String?> expenseCategory;
  final Value<String?> unit;
  final Value<double?> quantity;
  final Value<double?> baseQuantity;
  final Value<double?> odometerReading;
  final Value<int> isCompanyExpense;
  final Value<String?> vehicleDesignation;
  final Value<String?> vendorOrSubtrade;
  final Value<int?> costCodeId;
  final Value<int> isBilled;
  final Value<int?> invoiceId;
  const MaterialsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.cost = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.description = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.expenseCategory = const Value.absent(),
    this.unit = const Value.absent(),
    this.quantity = const Value.absent(),
    this.baseQuantity = const Value.absent(),
    this.odometerReading = const Value.absent(),
    this.isCompanyExpense = const Value.absent(),
    this.vehicleDesignation = const Value.absent(),
    this.vendorOrSubtrade = const Value.absent(),
    this.costCodeId = const Value.absent(),
    this.isBilled = const Value.absent(),
    this.invoiceId = const Value.absent(),
  });
  MaterialsCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required String itemName,
    required int cost,
    this.purchaseDate = const Value.absent(),
    this.description = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.expenseCategory = const Value.absent(),
    this.unit = const Value.absent(),
    this.quantity = const Value.absent(),
    this.baseQuantity = const Value.absent(),
    this.odometerReading = const Value.absent(),
    this.isCompanyExpense = const Value.absent(),
    this.vehicleDesignation = const Value.absent(),
    this.vendorOrSubtrade = const Value.absent(),
    this.costCodeId = const Value.absent(),
    this.isBilled = const Value.absent(),
    this.invoiceId = const Value.absent(),
  }) : projectId = Value(projectId),
       itemName = Value(itemName),
       cost = Value(cost);
  static Insertable<DbMaterial> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<String>? itemName,
    Expression<int>? cost,
    Expression<String>? purchaseDate,
    Expression<String>? description,
    Expression<int>? isDeleted,
    Expression<String>? expenseCategory,
    Expression<String>? unit,
    Expression<double>? quantity,
    Expression<double>? baseQuantity,
    Expression<double>? odometerReading,
    Expression<int>? isCompanyExpense,
    Expression<String>? vehicleDesignation,
    Expression<String>? vendorOrSubtrade,
    Expression<int>? costCodeId,
    Expression<int>? isBilled,
    Expression<int>? invoiceId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (itemName != null) 'item_name': itemName,
      if (cost != null) 'cost': cost,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (description != null) 'description': description,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (expenseCategory != null) 'expense_category': expenseCategory,
      if (unit != null) 'unit': unit,
      if (quantity != null) 'quantity': quantity,
      if (baseQuantity != null) 'base_quantity': baseQuantity,
      if (odometerReading != null) 'odometer_reading': odometerReading,
      if (isCompanyExpense != null) 'is_company_expense': isCompanyExpense,
      if (vehicleDesignation != null) 'vehicle_designation': vehicleDesignation,
      if (vendorOrSubtrade != null) 'vendor_or_subtrade': vendorOrSubtrade,
      if (costCodeId != null) 'cost_code_id': costCodeId,
      if (isBilled != null) 'is_billed': isBilled,
      if (invoiceId != null) 'invoice_id': invoiceId,
    });
  }

  MaterialsCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<String>? itemName,
    Value<int>? cost,
    Value<String?>? purchaseDate,
    Value<String?>? description,
    Value<int>? isDeleted,
    Value<String?>? expenseCategory,
    Value<String?>? unit,
    Value<double?>? quantity,
    Value<double?>? baseQuantity,
    Value<double?>? odometerReading,
    Value<int>? isCompanyExpense,
    Value<String?>? vehicleDesignation,
    Value<String?>? vendorOrSubtrade,
    Value<int?>? costCodeId,
    Value<int>? isBilled,
    Value<int?>? invoiceId,
  }) {
    return MaterialsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      itemName: itemName ?? this.itemName,
      cost: cost ?? this.cost,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      description: description ?? this.description,
      isDeleted: isDeleted ?? this.isDeleted,
      expenseCategory: expenseCategory ?? this.expenseCategory,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      baseQuantity: baseQuantity ?? this.baseQuantity,
      odometerReading: odometerReading ?? this.odometerReading,
      isCompanyExpense: isCompanyExpense ?? this.isCompanyExpense,
      vehicleDesignation: vehicleDesignation ?? this.vehicleDesignation,
      vendorOrSubtrade: vendorOrSubtrade ?? this.vendorOrSubtrade,
      costCodeId: costCodeId ?? this.costCodeId,
      isBilled: isBilled ?? this.isBilled,
      invoiceId: invoiceId ?? this.invoiceId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<String>(purchaseDate.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    if (expenseCategory.present) {
      map['expense_category'] = Variable<String>(expenseCategory.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (baseQuantity.present) {
      map['base_quantity'] = Variable<double>(baseQuantity.value);
    }
    if (odometerReading.present) {
      map['odometer_reading'] = Variable<double>(odometerReading.value);
    }
    if (isCompanyExpense.present) {
      map['is_company_expense'] = Variable<int>(isCompanyExpense.value);
    }
    if (vehicleDesignation.present) {
      map['vehicle_designation'] = Variable<String>(vehicleDesignation.value);
    }
    if (vendorOrSubtrade.present) {
      map['vendor_or_subtrade'] = Variable<String>(vendorOrSubtrade.value);
    }
    if (costCodeId.present) {
      map['cost_code_id'] = Variable<int>(costCodeId.value);
    }
    if (isBilled.present) {
      map['is_billed'] = Variable<int>(isBilled.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaterialsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('itemName: $itemName, ')
          ..write('cost: $cost, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('description: $description, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('expenseCategory: $expenseCategory, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('baseQuantity: $baseQuantity, ')
          ..write('odometerReading: $odometerReading, ')
          ..write('isCompanyExpense: $isCompanyExpense, ')
          ..write('vehicleDesignation: $vehicleDesignation, ')
          ..write('vendorOrSubtrade: $vendorOrSubtrade, ')
          ..write('costCodeId: $costCodeId, ')
          ..write('isBilled: $isBilled, ')
          ..write('invoiceId: $invoiceId')
          ..write(')'))
        .toString();
  }
}

class $CompanySettingsTableTable extends CompanySettingsTable
    with TableInfo<$CompanySettingsTableTable, DbCompanySetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompanySettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyAddressMeta = const VerificationMeta(
    'companyAddress',
  );
  @override
  late final GeneratedColumn<String> companyAddress = GeneratedColumn<String>(
    'company_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyCityMeta = const VerificationMeta(
    'companyCity',
  );
  @override
  late final GeneratedColumn<String> companyCity = GeneratedColumn<String>(
    'company_city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyProvinceMeta = const VerificationMeta(
    'companyProvince',
  );
  @override
  late final GeneratedColumn<String> companyProvince = GeneratedColumn<String>(
    'company_province',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyPostalCodeMeta = const VerificationMeta(
    'companyPostalCode',
  );
  @override
  late final GeneratedColumn<String> companyPostalCode =
      GeneratedColumn<String>(
        'company_postal_code',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _companyPhoneMeta = const VerificationMeta(
    'companyPhone',
  );
  @override
  late final GeneratedColumn<String> companyPhone = GeneratedColumn<String>(
    'company_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyEmailMeta = const VerificationMeta(
    'companyEmail',
  );
  @override
  late final GeneratedColumn<String> companyEmail = GeneratedColumn<String>(
    'company_email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultTax1NameMeta = const VerificationMeta(
    'defaultTax1Name',
  );
  @override
  late final GeneratedColumn<String> defaultTax1Name = GeneratedColumn<String>(
    'default_tax1_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('GST'),
  );
  static const VerificationMeta _defaultTax1RateMeta = const VerificationMeta(
    'defaultTax1Rate',
  );
  @override
  late final GeneratedColumn<double> defaultTax1Rate = GeneratedColumn<double>(
    'default_tax1_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.05),
  );
  static const VerificationMeta _defaultTax1RegistrationNumberMeta =
      const VerificationMeta('defaultTax1RegistrationNumber');
  @override
  late final GeneratedColumn<String> defaultTax1RegistrationNumber =
      GeneratedColumn<String>(
        'default_tax1_registration_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _defaultTax2NameMeta = const VerificationMeta(
    'defaultTax2Name',
  );
  @override
  late final GeneratedColumn<String> defaultTax2Name = GeneratedColumn<String>(
    'default_tax2_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultTax2RateMeta = const VerificationMeta(
    'defaultTax2Rate',
  );
  @override
  late final GeneratedColumn<double> defaultTax2Rate = GeneratedColumn<double>(
    'default_tax2_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultTax2RegistrationNumberMeta =
      const VerificationMeta('defaultTax2RegistrationNumber');
  @override
  late final GeneratedColumn<String> defaultTax2RegistrationNumber =
      GeneratedColumn<String>(
        'default_tax2_registration_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _defaultTermsMeta = const VerificationMeta(
    'defaultTerms',
  );
  @override
  late final GeneratedColumn<String> defaultTerms = GeneratedColumn<String>(
    'default_terms',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Payable on Receipt'),
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(5.0),
  );
  static const VerificationMeta _postalCodeLabelMeta = const VerificationMeta(
    'postalCodeLabel',
  );
  @override
  late final GeneratedColumn<String> postalCodeLabel = GeneratedColumn<String>(
    'postal_code_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Postal Code'),
  );
  static const VerificationMeta _regionLabelMeta = const VerificationMeta(
    'regionLabel',
  );
  @override
  late final GeneratedColumn<String> regionLabel = GeneratedColumn<String>(
    'region_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Province'),
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Canada'),
  );
  static const VerificationMeta _invoicePrefixMeta = const VerificationMeta(
    'invoicePrefix',
  );
  @override
  late final GeneratedColumn<String> invoicePrefix = GeneratedColumn<String>(
    'invoice_prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INV'),
  );
  static const VerificationMeta _invoiceStartingNumberMeta =
      const VerificationMeta('invoiceStartingNumber');
  @override
  late final GeneratedColumn<int> invoiceStartingNumber = GeneratedColumn<int>(
    'invoice_starting_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _paymentEtransferEmailMeta =
      const VerificationMeta('paymentEtransferEmail');
  @override
  late final GeneratedColumn<String> paymentEtransferEmail =
      GeneratedColumn<String>(
        'payment_etransfer_email',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    companyName,
    companyAddress,
    companyCity,
    companyProvince,
    companyPostalCode,
    companyPhone,
    companyEmail,
    defaultTax1Name,
    defaultTax1Rate,
    defaultTax1RegistrationNumber,
    defaultTax2Name,
    defaultTax2Rate,
    defaultTax2RegistrationNumber,
    defaultTerms,
    taxRate,
    postalCodeLabel,
    regionLabel,
    country,
    invoicePrefix,
    invoiceStartingNumber,
    paymentEtransferEmail,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'company_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbCompanySetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    }
    if (data.containsKey('company_address')) {
      context.handle(
        _companyAddressMeta,
        companyAddress.isAcceptableOrUnknown(
          data['company_address']!,
          _companyAddressMeta,
        ),
      );
    }
    if (data.containsKey('company_city')) {
      context.handle(
        _companyCityMeta,
        companyCity.isAcceptableOrUnknown(
          data['company_city']!,
          _companyCityMeta,
        ),
      );
    }
    if (data.containsKey('company_province')) {
      context.handle(
        _companyProvinceMeta,
        companyProvince.isAcceptableOrUnknown(
          data['company_province']!,
          _companyProvinceMeta,
        ),
      );
    }
    if (data.containsKey('company_postal_code')) {
      context.handle(
        _companyPostalCodeMeta,
        companyPostalCode.isAcceptableOrUnknown(
          data['company_postal_code']!,
          _companyPostalCodeMeta,
        ),
      );
    }
    if (data.containsKey('company_phone')) {
      context.handle(
        _companyPhoneMeta,
        companyPhone.isAcceptableOrUnknown(
          data['company_phone']!,
          _companyPhoneMeta,
        ),
      );
    }
    if (data.containsKey('company_email')) {
      context.handle(
        _companyEmailMeta,
        companyEmail.isAcceptableOrUnknown(
          data['company_email']!,
          _companyEmailMeta,
        ),
      );
    }
    if (data.containsKey('default_tax1_name')) {
      context.handle(
        _defaultTax1NameMeta,
        defaultTax1Name.isAcceptableOrUnknown(
          data['default_tax1_name']!,
          _defaultTax1NameMeta,
        ),
      );
    }
    if (data.containsKey('default_tax1_rate')) {
      context.handle(
        _defaultTax1RateMeta,
        defaultTax1Rate.isAcceptableOrUnknown(
          data['default_tax1_rate']!,
          _defaultTax1RateMeta,
        ),
      );
    }
    if (data.containsKey('default_tax1_registration_number')) {
      context.handle(
        _defaultTax1RegistrationNumberMeta,
        defaultTax1RegistrationNumber.isAcceptableOrUnknown(
          data['default_tax1_registration_number']!,
          _defaultTax1RegistrationNumberMeta,
        ),
      );
    }
    if (data.containsKey('default_tax2_name')) {
      context.handle(
        _defaultTax2NameMeta,
        defaultTax2Name.isAcceptableOrUnknown(
          data['default_tax2_name']!,
          _defaultTax2NameMeta,
        ),
      );
    }
    if (data.containsKey('default_tax2_rate')) {
      context.handle(
        _defaultTax2RateMeta,
        defaultTax2Rate.isAcceptableOrUnknown(
          data['default_tax2_rate']!,
          _defaultTax2RateMeta,
        ),
      );
    }
    if (data.containsKey('default_tax2_registration_number')) {
      context.handle(
        _defaultTax2RegistrationNumberMeta,
        defaultTax2RegistrationNumber.isAcceptableOrUnknown(
          data['default_tax2_registration_number']!,
          _defaultTax2RegistrationNumberMeta,
        ),
      );
    }
    if (data.containsKey('default_terms')) {
      context.handle(
        _defaultTermsMeta,
        defaultTerms.isAcceptableOrUnknown(
          data['default_terms']!,
          _defaultTermsMeta,
        ),
      );
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    }
    if (data.containsKey('postal_code_label')) {
      context.handle(
        _postalCodeLabelMeta,
        postalCodeLabel.isAcceptableOrUnknown(
          data['postal_code_label']!,
          _postalCodeLabelMeta,
        ),
      );
    }
    if (data.containsKey('region_label')) {
      context.handle(
        _regionLabelMeta,
        regionLabel.isAcceptableOrUnknown(
          data['region_label']!,
          _regionLabelMeta,
        ),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('invoice_prefix')) {
      context.handle(
        _invoicePrefixMeta,
        invoicePrefix.isAcceptableOrUnknown(
          data['invoice_prefix']!,
          _invoicePrefixMeta,
        ),
      );
    }
    if (data.containsKey('invoice_starting_number')) {
      context.handle(
        _invoiceStartingNumberMeta,
        invoiceStartingNumber.isAcceptableOrUnknown(
          data['invoice_starting_number']!,
          _invoiceStartingNumberMeta,
        ),
      );
    }
    if (data.containsKey('payment_etransfer_email')) {
      context.handle(
        _paymentEtransferEmailMeta,
        paymentEtransferEmail.isAcceptableOrUnknown(
          data['payment_etransfer_email']!,
          _paymentEtransferEmailMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbCompanySetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbCompanySetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      ),
      companyAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_address'],
      ),
      companyCity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_city'],
      ),
      companyProvince: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_province'],
      ),
      companyPostalCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_postal_code'],
      ),
      companyPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_phone'],
      ),
      companyEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_email'],
      ),
      defaultTax1Name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_tax1_name'],
      )!,
      defaultTax1Rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_tax1_rate'],
      )!,
      defaultTax1RegistrationNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_tax1_registration_number'],
      ),
      defaultTax2Name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_tax2_name'],
      ),
      defaultTax2Rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_tax2_rate'],
      ),
      defaultTax2RegistrationNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_tax2_registration_number'],
      ),
      defaultTerms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_terms'],
      )!,
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      postalCodeLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}postal_code_label'],
      )!,
      regionLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_label'],
      )!,
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      )!,
      invoicePrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_prefix'],
      )!,
      invoiceStartingNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_starting_number'],
      )!,
      paymentEtransferEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_etransfer_email'],
      ),
    );
  }

  @override
  $CompanySettingsTableTable createAlias(String alias) {
    return $CompanySettingsTableTable(attachedDatabase, alias);
  }
}

class DbCompanySetting extends DataClass
    implements Insertable<DbCompanySetting> {
  final int id;
  final String? companyName;
  final String? companyAddress;
  final String? companyCity;
  final String? companyProvince;
  final String? companyPostalCode;
  final String? companyPhone;
  final String? companyEmail;
  final String defaultTax1Name;
  final double defaultTax1Rate;
  final String? defaultTax1RegistrationNumber;
  final String? defaultTax2Name;
  final double? defaultTax2Rate;
  final String? defaultTax2RegistrationNumber;
  final String defaultTerms;
  final double taxRate;
  final String postalCodeLabel;
  final String regionLabel;
  final String country;
  final String invoicePrefix;
  final int invoiceStartingNumber;
  final String? paymentEtransferEmail;
  const DbCompanySetting({
    required this.id,
    this.companyName,
    this.companyAddress,
    this.companyCity,
    this.companyProvince,
    this.companyPostalCode,
    this.companyPhone,
    this.companyEmail,
    required this.defaultTax1Name,
    required this.defaultTax1Rate,
    this.defaultTax1RegistrationNumber,
    this.defaultTax2Name,
    this.defaultTax2Rate,
    this.defaultTax2RegistrationNumber,
    required this.defaultTerms,
    required this.taxRate,
    required this.postalCodeLabel,
    required this.regionLabel,
    required this.country,
    required this.invoicePrefix,
    required this.invoiceStartingNumber,
    this.paymentEtransferEmail,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || companyName != null) {
      map['company_name'] = Variable<String>(companyName);
    }
    if (!nullToAbsent || companyAddress != null) {
      map['company_address'] = Variable<String>(companyAddress);
    }
    if (!nullToAbsent || companyCity != null) {
      map['company_city'] = Variable<String>(companyCity);
    }
    if (!nullToAbsent || companyProvince != null) {
      map['company_province'] = Variable<String>(companyProvince);
    }
    if (!nullToAbsent || companyPostalCode != null) {
      map['company_postal_code'] = Variable<String>(companyPostalCode);
    }
    if (!nullToAbsent || companyPhone != null) {
      map['company_phone'] = Variable<String>(companyPhone);
    }
    if (!nullToAbsent || companyEmail != null) {
      map['company_email'] = Variable<String>(companyEmail);
    }
    map['default_tax1_name'] = Variable<String>(defaultTax1Name);
    map['default_tax1_rate'] = Variable<double>(defaultTax1Rate);
    if (!nullToAbsent || defaultTax1RegistrationNumber != null) {
      map['default_tax1_registration_number'] = Variable<String>(
        defaultTax1RegistrationNumber,
      );
    }
    if (!nullToAbsent || defaultTax2Name != null) {
      map['default_tax2_name'] = Variable<String>(defaultTax2Name);
    }
    if (!nullToAbsent || defaultTax2Rate != null) {
      map['default_tax2_rate'] = Variable<double>(defaultTax2Rate);
    }
    if (!nullToAbsent || defaultTax2RegistrationNumber != null) {
      map['default_tax2_registration_number'] = Variable<String>(
        defaultTax2RegistrationNumber,
      );
    }
    map['default_terms'] = Variable<String>(defaultTerms);
    map['tax_rate'] = Variable<double>(taxRate);
    map['postal_code_label'] = Variable<String>(postalCodeLabel);
    map['region_label'] = Variable<String>(regionLabel);
    map['country'] = Variable<String>(country);
    map['invoice_prefix'] = Variable<String>(invoicePrefix);
    map['invoice_starting_number'] = Variable<int>(invoiceStartingNumber);
    if (!nullToAbsent || paymentEtransferEmail != null) {
      map['payment_etransfer_email'] = Variable<String>(paymentEtransferEmail);
    }
    return map;
  }

  CompanySettingsTableCompanion toCompanion(bool nullToAbsent) {
    return CompanySettingsTableCompanion(
      id: Value(id),
      companyName: companyName == null && nullToAbsent
          ? const Value.absent()
          : Value(companyName),
      companyAddress: companyAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(companyAddress),
      companyCity: companyCity == null && nullToAbsent
          ? const Value.absent()
          : Value(companyCity),
      companyProvince: companyProvince == null && nullToAbsent
          ? const Value.absent()
          : Value(companyProvince),
      companyPostalCode: companyPostalCode == null && nullToAbsent
          ? const Value.absent()
          : Value(companyPostalCode),
      companyPhone: companyPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(companyPhone),
      companyEmail: companyEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(companyEmail),
      defaultTax1Name: Value(defaultTax1Name),
      defaultTax1Rate: Value(defaultTax1Rate),
      defaultTax1RegistrationNumber:
          defaultTax1RegistrationNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultTax1RegistrationNumber),
      defaultTax2Name: defaultTax2Name == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultTax2Name),
      defaultTax2Rate: defaultTax2Rate == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultTax2Rate),
      defaultTax2RegistrationNumber:
          defaultTax2RegistrationNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultTax2RegistrationNumber),
      defaultTerms: Value(defaultTerms),
      taxRate: Value(taxRate),
      postalCodeLabel: Value(postalCodeLabel),
      regionLabel: Value(regionLabel),
      country: Value(country),
      invoicePrefix: Value(invoicePrefix),
      invoiceStartingNumber: Value(invoiceStartingNumber),
      paymentEtransferEmail: paymentEtransferEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentEtransferEmail),
    );
  }

  factory DbCompanySetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbCompanySetting(
      id: serializer.fromJson<int>(json['id']),
      companyName: serializer.fromJson<String?>(json['companyName']),
      companyAddress: serializer.fromJson<String?>(json['companyAddress']),
      companyCity: serializer.fromJson<String?>(json['companyCity']),
      companyProvince: serializer.fromJson<String?>(json['companyProvince']),
      companyPostalCode: serializer.fromJson<String?>(
        json['companyPostalCode'],
      ),
      companyPhone: serializer.fromJson<String?>(json['companyPhone']),
      companyEmail: serializer.fromJson<String?>(json['companyEmail']),
      defaultTax1Name: serializer.fromJson<String>(json['defaultTax1Name']),
      defaultTax1Rate: serializer.fromJson<double>(json['defaultTax1Rate']),
      defaultTax1RegistrationNumber: serializer.fromJson<String?>(
        json['defaultTax1RegistrationNumber'],
      ),
      defaultTax2Name: serializer.fromJson<String?>(json['defaultTax2Name']),
      defaultTax2Rate: serializer.fromJson<double?>(json['defaultTax2Rate']),
      defaultTax2RegistrationNumber: serializer.fromJson<String?>(
        json['defaultTax2RegistrationNumber'],
      ),
      defaultTerms: serializer.fromJson<String>(json['defaultTerms']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      postalCodeLabel: serializer.fromJson<String>(json['postalCodeLabel']),
      regionLabel: serializer.fromJson<String>(json['regionLabel']),
      country: serializer.fromJson<String>(json['country']),
      invoicePrefix: serializer.fromJson<String>(json['invoicePrefix']),
      invoiceStartingNumber: serializer.fromJson<int>(
        json['invoiceStartingNumber'],
      ),
      paymentEtransferEmail: serializer.fromJson<String?>(
        json['paymentEtransferEmail'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'companyName': serializer.toJson<String?>(companyName),
      'companyAddress': serializer.toJson<String?>(companyAddress),
      'companyCity': serializer.toJson<String?>(companyCity),
      'companyProvince': serializer.toJson<String?>(companyProvince),
      'companyPostalCode': serializer.toJson<String?>(companyPostalCode),
      'companyPhone': serializer.toJson<String?>(companyPhone),
      'companyEmail': serializer.toJson<String?>(companyEmail),
      'defaultTax1Name': serializer.toJson<String>(defaultTax1Name),
      'defaultTax1Rate': serializer.toJson<double>(defaultTax1Rate),
      'defaultTax1RegistrationNumber': serializer.toJson<String?>(
        defaultTax1RegistrationNumber,
      ),
      'defaultTax2Name': serializer.toJson<String?>(defaultTax2Name),
      'defaultTax2Rate': serializer.toJson<double?>(defaultTax2Rate),
      'defaultTax2RegistrationNumber': serializer.toJson<String?>(
        defaultTax2RegistrationNumber,
      ),
      'defaultTerms': serializer.toJson<String>(defaultTerms),
      'taxRate': serializer.toJson<double>(taxRate),
      'postalCodeLabel': serializer.toJson<String>(postalCodeLabel),
      'regionLabel': serializer.toJson<String>(regionLabel),
      'country': serializer.toJson<String>(country),
      'invoicePrefix': serializer.toJson<String>(invoicePrefix),
      'invoiceStartingNumber': serializer.toJson<int>(invoiceStartingNumber),
      'paymentEtransferEmail': serializer.toJson<String?>(
        paymentEtransferEmail,
      ),
    };
  }

  DbCompanySetting copyWith({
    int? id,
    Value<String?> companyName = const Value.absent(),
    Value<String?> companyAddress = const Value.absent(),
    Value<String?> companyCity = const Value.absent(),
    Value<String?> companyProvince = const Value.absent(),
    Value<String?> companyPostalCode = const Value.absent(),
    Value<String?> companyPhone = const Value.absent(),
    Value<String?> companyEmail = const Value.absent(),
    String? defaultTax1Name,
    double? defaultTax1Rate,
    Value<String?> defaultTax1RegistrationNumber = const Value.absent(),
    Value<String?> defaultTax2Name = const Value.absent(),
    Value<double?> defaultTax2Rate = const Value.absent(),
    Value<String?> defaultTax2RegistrationNumber = const Value.absent(),
    String? defaultTerms,
    double? taxRate,
    String? postalCodeLabel,
    String? regionLabel,
    String? country,
    String? invoicePrefix,
    int? invoiceStartingNumber,
    Value<String?> paymentEtransferEmail = const Value.absent(),
  }) => DbCompanySetting(
    id: id ?? this.id,
    companyName: companyName.present ? companyName.value : this.companyName,
    companyAddress: companyAddress.present
        ? companyAddress.value
        : this.companyAddress,
    companyCity: companyCity.present ? companyCity.value : this.companyCity,
    companyProvince: companyProvince.present
        ? companyProvince.value
        : this.companyProvince,
    companyPostalCode: companyPostalCode.present
        ? companyPostalCode.value
        : this.companyPostalCode,
    companyPhone: companyPhone.present ? companyPhone.value : this.companyPhone,
    companyEmail: companyEmail.present ? companyEmail.value : this.companyEmail,
    defaultTax1Name: defaultTax1Name ?? this.defaultTax1Name,
    defaultTax1Rate: defaultTax1Rate ?? this.defaultTax1Rate,
    defaultTax1RegistrationNumber: defaultTax1RegistrationNumber.present
        ? defaultTax1RegistrationNumber.value
        : this.defaultTax1RegistrationNumber,
    defaultTax2Name: defaultTax2Name.present
        ? defaultTax2Name.value
        : this.defaultTax2Name,
    defaultTax2Rate: defaultTax2Rate.present
        ? defaultTax2Rate.value
        : this.defaultTax2Rate,
    defaultTax2RegistrationNumber: defaultTax2RegistrationNumber.present
        ? defaultTax2RegistrationNumber.value
        : this.defaultTax2RegistrationNumber,
    defaultTerms: defaultTerms ?? this.defaultTerms,
    taxRate: taxRate ?? this.taxRate,
    postalCodeLabel: postalCodeLabel ?? this.postalCodeLabel,
    regionLabel: regionLabel ?? this.regionLabel,
    country: country ?? this.country,
    invoicePrefix: invoicePrefix ?? this.invoicePrefix,
    invoiceStartingNumber: invoiceStartingNumber ?? this.invoiceStartingNumber,
    paymentEtransferEmail: paymentEtransferEmail.present
        ? paymentEtransferEmail.value
        : this.paymentEtransferEmail,
  );
  DbCompanySetting copyWithCompanion(CompanySettingsTableCompanion data) {
    return DbCompanySetting(
      id: data.id.present ? data.id.value : this.id,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
      companyAddress: data.companyAddress.present
          ? data.companyAddress.value
          : this.companyAddress,
      companyCity: data.companyCity.present
          ? data.companyCity.value
          : this.companyCity,
      companyProvince: data.companyProvince.present
          ? data.companyProvince.value
          : this.companyProvince,
      companyPostalCode: data.companyPostalCode.present
          ? data.companyPostalCode.value
          : this.companyPostalCode,
      companyPhone: data.companyPhone.present
          ? data.companyPhone.value
          : this.companyPhone,
      companyEmail: data.companyEmail.present
          ? data.companyEmail.value
          : this.companyEmail,
      defaultTax1Name: data.defaultTax1Name.present
          ? data.defaultTax1Name.value
          : this.defaultTax1Name,
      defaultTax1Rate: data.defaultTax1Rate.present
          ? data.defaultTax1Rate.value
          : this.defaultTax1Rate,
      defaultTax1RegistrationNumber: data.defaultTax1RegistrationNumber.present
          ? data.defaultTax1RegistrationNumber.value
          : this.defaultTax1RegistrationNumber,
      defaultTax2Name: data.defaultTax2Name.present
          ? data.defaultTax2Name.value
          : this.defaultTax2Name,
      defaultTax2Rate: data.defaultTax2Rate.present
          ? data.defaultTax2Rate.value
          : this.defaultTax2Rate,
      defaultTax2RegistrationNumber: data.defaultTax2RegistrationNumber.present
          ? data.defaultTax2RegistrationNumber.value
          : this.defaultTax2RegistrationNumber,
      defaultTerms: data.defaultTerms.present
          ? data.defaultTerms.value
          : this.defaultTerms,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      postalCodeLabel: data.postalCodeLabel.present
          ? data.postalCodeLabel.value
          : this.postalCodeLabel,
      regionLabel: data.regionLabel.present
          ? data.regionLabel.value
          : this.regionLabel,
      country: data.country.present ? data.country.value : this.country,
      invoicePrefix: data.invoicePrefix.present
          ? data.invoicePrefix.value
          : this.invoicePrefix,
      invoiceStartingNumber: data.invoiceStartingNumber.present
          ? data.invoiceStartingNumber.value
          : this.invoiceStartingNumber,
      paymentEtransferEmail: data.paymentEtransferEmail.present
          ? data.paymentEtransferEmail.value
          : this.paymentEtransferEmail,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbCompanySetting(')
          ..write('id: $id, ')
          ..write('companyName: $companyName, ')
          ..write('companyAddress: $companyAddress, ')
          ..write('companyCity: $companyCity, ')
          ..write('companyProvince: $companyProvince, ')
          ..write('companyPostalCode: $companyPostalCode, ')
          ..write('companyPhone: $companyPhone, ')
          ..write('companyEmail: $companyEmail, ')
          ..write('defaultTax1Name: $defaultTax1Name, ')
          ..write('defaultTax1Rate: $defaultTax1Rate, ')
          ..write(
            'defaultTax1RegistrationNumber: $defaultTax1RegistrationNumber, ',
          )
          ..write('defaultTax2Name: $defaultTax2Name, ')
          ..write('defaultTax2Rate: $defaultTax2Rate, ')
          ..write(
            'defaultTax2RegistrationNumber: $defaultTax2RegistrationNumber, ',
          )
          ..write('defaultTerms: $defaultTerms, ')
          ..write('taxRate: $taxRate, ')
          ..write('postalCodeLabel: $postalCodeLabel, ')
          ..write('regionLabel: $regionLabel, ')
          ..write('country: $country, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('invoiceStartingNumber: $invoiceStartingNumber, ')
          ..write('paymentEtransferEmail: $paymentEtransferEmail')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    companyName,
    companyAddress,
    companyCity,
    companyProvince,
    companyPostalCode,
    companyPhone,
    companyEmail,
    defaultTax1Name,
    defaultTax1Rate,
    defaultTax1RegistrationNumber,
    defaultTax2Name,
    defaultTax2Rate,
    defaultTax2RegistrationNumber,
    defaultTerms,
    taxRate,
    postalCodeLabel,
    regionLabel,
    country,
    invoicePrefix,
    invoiceStartingNumber,
    paymentEtransferEmail,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbCompanySetting &&
          other.id == this.id &&
          other.companyName == this.companyName &&
          other.companyAddress == this.companyAddress &&
          other.companyCity == this.companyCity &&
          other.companyProvince == this.companyProvince &&
          other.companyPostalCode == this.companyPostalCode &&
          other.companyPhone == this.companyPhone &&
          other.companyEmail == this.companyEmail &&
          other.defaultTax1Name == this.defaultTax1Name &&
          other.defaultTax1Rate == this.defaultTax1Rate &&
          other.defaultTax1RegistrationNumber ==
              this.defaultTax1RegistrationNumber &&
          other.defaultTax2Name == this.defaultTax2Name &&
          other.defaultTax2Rate == this.defaultTax2Rate &&
          other.defaultTax2RegistrationNumber ==
              this.defaultTax2RegistrationNumber &&
          other.defaultTerms == this.defaultTerms &&
          other.taxRate == this.taxRate &&
          other.postalCodeLabel == this.postalCodeLabel &&
          other.regionLabel == this.regionLabel &&
          other.country == this.country &&
          other.invoicePrefix == this.invoicePrefix &&
          other.invoiceStartingNumber == this.invoiceStartingNumber &&
          other.paymentEtransferEmail == this.paymentEtransferEmail);
}

class CompanySettingsTableCompanion extends UpdateCompanion<DbCompanySetting> {
  final Value<int> id;
  final Value<String?> companyName;
  final Value<String?> companyAddress;
  final Value<String?> companyCity;
  final Value<String?> companyProvince;
  final Value<String?> companyPostalCode;
  final Value<String?> companyPhone;
  final Value<String?> companyEmail;
  final Value<String> defaultTax1Name;
  final Value<double> defaultTax1Rate;
  final Value<String?> defaultTax1RegistrationNumber;
  final Value<String?> defaultTax2Name;
  final Value<double?> defaultTax2Rate;
  final Value<String?> defaultTax2RegistrationNumber;
  final Value<String> defaultTerms;
  final Value<double> taxRate;
  final Value<String> postalCodeLabel;
  final Value<String> regionLabel;
  final Value<String> country;
  final Value<String> invoicePrefix;
  final Value<int> invoiceStartingNumber;
  final Value<String?> paymentEtransferEmail;
  const CompanySettingsTableCompanion({
    this.id = const Value.absent(),
    this.companyName = const Value.absent(),
    this.companyAddress = const Value.absent(),
    this.companyCity = const Value.absent(),
    this.companyProvince = const Value.absent(),
    this.companyPostalCode = const Value.absent(),
    this.companyPhone = const Value.absent(),
    this.companyEmail = const Value.absent(),
    this.defaultTax1Name = const Value.absent(),
    this.defaultTax1Rate = const Value.absent(),
    this.defaultTax1RegistrationNumber = const Value.absent(),
    this.defaultTax2Name = const Value.absent(),
    this.defaultTax2Rate = const Value.absent(),
    this.defaultTax2RegistrationNumber = const Value.absent(),
    this.defaultTerms = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.postalCodeLabel = const Value.absent(),
    this.regionLabel = const Value.absent(),
    this.country = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.invoiceStartingNumber = const Value.absent(),
    this.paymentEtransferEmail = const Value.absent(),
  });
  CompanySettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.companyName = const Value.absent(),
    this.companyAddress = const Value.absent(),
    this.companyCity = const Value.absent(),
    this.companyProvince = const Value.absent(),
    this.companyPostalCode = const Value.absent(),
    this.companyPhone = const Value.absent(),
    this.companyEmail = const Value.absent(),
    this.defaultTax1Name = const Value.absent(),
    this.defaultTax1Rate = const Value.absent(),
    this.defaultTax1RegistrationNumber = const Value.absent(),
    this.defaultTax2Name = const Value.absent(),
    this.defaultTax2Rate = const Value.absent(),
    this.defaultTax2RegistrationNumber = const Value.absent(),
    this.defaultTerms = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.postalCodeLabel = const Value.absent(),
    this.regionLabel = const Value.absent(),
    this.country = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.invoiceStartingNumber = const Value.absent(),
    this.paymentEtransferEmail = const Value.absent(),
  });
  static Insertable<DbCompanySetting> custom({
    Expression<int>? id,
    Expression<String>? companyName,
    Expression<String>? companyAddress,
    Expression<String>? companyCity,
    Expression<String>? companyProvince,
    Expression<String>? companyPostalCode,
    Expression<String>? companyPhone,
    Expression<String>? companyEmail,
    Expression<String>? defaultTax1Name,
    Expression<double>? defaultTax1Rate,
    Expression<String>? defaultTax1RegistrationNumber,
    Expression<String>? defaultTax2Name,
    Expression<double>? defaultTax2Rate,
    Expression<String>? defaultTax2RegistrationNumber,
    Expression<String>? defaultTerms,
    Expression<double>? taxRate,
    Expression<String>? postalCodeLabel,
    Expression<String>? regionLabel,
    Expression<String>? country,
    Expression<String>? invoicePrefix,
    Expression<int>? invoiceStartingNumber,
    Expression<String>? paymentEtransferEmail,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (companyName != null) 'company_name': companyName,
      if (companyAddress != null) 'company_address': companyAddress,
      if (companyCity != null) 'company_city': companyCity,
      if (companyProvince != null) 'company_province': companyProvince,
      if (companyPostalCode != null) 'company_postal_code': companyPostalCode,
      if (companyPhone != null) 'company_phone': companyPhone,
      if (companyEmail != null) 'company_email': companyEmail,
      if (defaultTax1Name != null) 'default_tax1_name': defaultTax1Name,
      if (defaultTax1Rate != null) 'default_tax1_rate': defaultTax1Rate,
      if (defaultTax1RegistrationNumber != null)
        'default_tax1_registration_number': defaultTax1RegistrationNumber,
      if (defaultTax2Name != null) 'default_tax2_name': defaultTax2Name,
      if (defaultTax2Rate != null) 'default_tax2_rate': defaultTax2Rate,
      if (defaultTax2RegistrationNumber != null)
        'default_tax2_registration_number': defaultTax2RegistrationNumber,
      if (defaultTerms != null) 'default_terms': defaultTerms,
      if (taxRate != null) 'tax_rate': taxRate,
      if (postalCodeLabel != null) 'postal_code_label': postalCodeLabel,
      if (regionLabel != null) 'region_label': regionLabel,
      if (country != null) 'country': country,
      if (invoicePrefix != null) 'invoice_prefix': invoicePrefix,
      if (invoiceStartingNumber != null)
        'invoice_starting_number': invoiceStartingNumber,
      if (paymentEtransferEmail != null)
        'payment_etransfer_email': paymentEtransferEmail,
    });
  }

  CompanySettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String?>? companyName,
    Value<String?>? companyAddress,
    Value<String?>? companyCity,
    Value<String?>? companyProvince,
    Value<String?>? companyPostalCode,
    Value<String?>? companyPhone,
    Value<String?>? companyEmail,
    Value<String>? defaultTax1Name,
    Value<double>? defaultTax1Rate,
    Value<String?>? defaultTax1RegistrationNumber,
    Value<String?>? defaultTax2Name,
    Value<double?>? defaultTax2Rate,
    Value<String?>? defaultTax2RegistrationNumber,
    Value<String>? defaultTerms,
    Value<double>? taxRate,
    Value<String>? postalCodeLabel,
    Value<String>? regionLabel,
    Value<String>? country,
    Value<String>? invoicePrefix,
    Value<int>? invoiceStartingNumber,
    Value<String?>? paymentEtransferEmail,
  }) {
    return CompanySettingsTableCompanion(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      companyAddress: companyAddress ?? this.companyAddress,
      companyCity: companyCity ?? this.companyCity,
      companyProvince: companyProvince ?? this.companyProvince,
      companyPostalCode: companyPostalCode ?? this.companyPostalCode,
      companyPhone: companyPhone ?? this.companyPhone,
      companyEmail: companyEmail ?? this.companyEmail,
      defaultTax1Name: defaultTax1Name ?? this.defaultTax1Name,
      defaultTax1Rate: defaultTax1Rate ?? this.defaultTax1Rate,
      defaultTax1RegistrationNumber:
          defaultTax1RegistrationNumber ?? this.defaultTax1RegistrationNumber,
      defaultTax2Name: defaultTax2Name ?? this.defaultTax2Name,
      defaultTax2Rate: defaultTax2Rate ?? this.defaultTax2Rate,
      defaultTax2RegistrationNumber:
          defaultTax2RegistrationNumber ?? this.defaultTax2RegistrationNumber,
      defaultTerms: defaultTerms ?? this.defaultTerms,
      taxRate: taxRate ?? this.taxRate,
      postalCodeLabel: postalCodeLabel ?? this.postalCodeLabel,
      regionLabel: regionLabel ?? this.regionLabel,
      country: country ?? this.country,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      invoiceStartingNumber:
          invoiceStartingNumber ?? this.invoiceStartingNumber,
      paymentEtransferEmail:
          paymentEtransferEmail ?? this.paymentEtransferEmail,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (companyAddress.present) {
      map['company_address'] = Variable<String>(companyAddress.value);
    }
    if (companyCity.present) {
      map['company_city'] = Variable<String>(companyCity.value);
    }
    if (companyProvince.present) {
      map['company_province'] = Variable<String>(companyProvince.value);
    }
    if (companyPostalCode.present) {
      map['company_postal_code'] = Variable<String>(companyPostalCode.value);
    }
    if (companyPhone.present) {
      map['company_phone'] = Variable<String>(companyPhone.value);
    }
    if (companyEmail.present) {
      map['company_email'] = Variable<String>(companyEmail.value);
    }
    if (defaultTax1Name.present) {
      map['default_tax1_name'] = Variable<String>(defaultTax1Name.value);
    }
    if (defaultTax1Rate.present) {
      map['default_tax1_rate'] = Variable<double>(defaultTax1Rate.value);
    }
    if (defaultTax1RegistrationNumber.present) {
      map['default_tax1_registration_number'] = Variable<String>(
        defaultTax1RegistrationNumber.value,
      );
    }
    if (defaultTax2Name.present) {
      map['default_tax2_name'] = Variable<String>(defaultTax2Name.value);
    }
    if (defaultTax2Rate.present) {
      map['default_tax2_rate'] = Variable<double>(defaultTax2Rate.value);
    }
    if (defaultTax2RegistrationNumber.present) {
      map['default_tax2_registration_number'] = Variable<String>(
        defaultTax2RegistrationNumber.value,
      );
    }
    if (defaultTerms.present) {
      map['default_terms'] = Variable<String>(defaultTerms.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (postalCodeLabel.present) {
      map['postal_code_label'] = Variable<String>(postalCodeLabel.value);
    }
    if (regionLabel.present) {
      map['region_label'] = Variable<String>(regionLabel.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (invoicePrefix.present) {
      map['invoice_prefix'] = Variable<String>(invoicePrefix.value);
    }
    if (invoiceStartingNumber.present) {
      map['invoice_starting_number'] = Variable<int>(
        invoiceStartingNumber.value,
      );
    }
    if (paymentEtransferEmail.present) {
      map['payment_etransfer_email'] = Variable<String>(
        paymentEtransferEmail.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompanySettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('companyName: $companyName, ')
          ..write('companyAddress: $companyAddress, ')
          ..write('companyCity: $companyCity, ')
          ..write('companyProvince: $companyProvince, ')
          ..write('companyPostalCode: $companyPostalCode, ')
          ..write('companyPhone: $companyPhone, ')
          ..write('companyEmail: $companyEmail, ')
          ..write('defaultTax1Name: $defaultTax1Name, ')
          ..write('defaultTax1Rate: $defaultTax1Rate, ')
          ..write(
            'defaultTax1RegistrationNumber: $defaultTax1RegistrationNumber, ',
          )
          ..write('defaultTax2Name: $defaultTax2Name, ')
          ..write('defaultTax2Rate: $defaultTax2Rate, ')
          ..write(
            'defaultTax2RegistrationNumber: $defaultTax2RegistrationNumber, ',
          )
          ..write('defaultTerms: $defaultTerms, ')
          ..write('taxRate: $taxRate, ')
          ..write('postalCodeLabel: $postalCodeLabel, ')
          ..write('regionLabel: $regionLabel, ')
          ..write('country: $country, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('invoiceStartingNumber: $invoiceStartingNumber, ')
          ..write('paymentEtransferEmail: $paymentEtransferEmail')
          ..write(')'))
        .toString();
  }
}

class $WorkerPaymentsTable extends WorkerPayments
    with TableInfo<$WorkerPaymentsTable, DbWorkerPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkerPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<String> paymentDate = GeneratedColumn<String>(
    'payment_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeId,
    paymentDate,
    amount,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'worker_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbWorkerPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbWorkerPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbWorkerPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_date'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WorkerPaymentsTable createAlias(String alias) {
    return $WorkerPaymentsTable(attachedDatabase, alias);
  }
}

class DbWorkerPayment extends DataClass implements Insertable<DbWorkerPayment> {
  final int id;
  final int employeeId;
  final String paymentDate;
  final int amount;
  final String? note;
  final String createdAt;
  const DbWorkerPayment({
    required this.id,
    required this.employeeId,
    required this.paymentDate,
    required this.amount,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['employee_id'] = Variable<int>(employeeId);
    map['payment_date'] = Variable<String>(paymentDate);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  WorkerPaymentsCompanion toCompanion(bool nullToAbsent) {
    return WorkerPaymentsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      paymentDate: Value(paymentDate),
      amount: Value(amount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory DbWorkerPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbWorkerPayment(
      id: serializer.fromJson<int>(json['id']),
      employeeId: serializer.fromJson<int>(json['employeeId']),
      paymentDate: serializer.fromJson<String>(json['paymentDate']),
      amount: serializer.fromJson<int>(json['amount']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'employeeId': serializer.toJson<int>(employeeId),
      'paymentDate': serializer.toJson<String>(paymentDate),
      'amount': serializer.toJson<int>(amount),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  DbWorkerPayment copyWith({
    int? id,
    int? employeeId,
    String? paymentDate,
    int? amount,
    Value<String?> note = const Value.absent(),
    String? createdAt,
  }) => DbWorkerPayment(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    paymentDate: paymentDate ?? this.paymentDate,
    amount: amount ?? this.amount,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  DbWorkerPayment copyWithCompanion(WorkerPaymentsCompanion data) {
    return DbWorkerPayment(
      id: data.id.present ? data.id.value : this.id,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbWorkerPayment(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, employeeId, paymentDate, amount, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbWorkerPayment &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.paymentDate == this.paymentDate &&
          other.amount == this.amount &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class WorkerPaymentsCompanion extends UpdateCompanion<DbWorkerPayment> {
  final Value<int> id;
  final Value<int> employeeId;
  final Value<String> paymentDate;
  final Value<int> amount;
  final Value<String?> note;
  final Value<String> createdAt;
  const WorkerPaymentsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WorkerPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int employeeId,
    required String paymentDate,
    required int amount,
    this.note = const Value.absent(),
    required String createdAt,
  }) : employeeId = Value(employeeId),
       paymentDate = Value(paymentDate),
       amount = Value(amount),
       createdAt = Value(createdAt);
  static Insertable<DbWorkerPayment> custom({
    Expression<int>? id,
    Expression<int>? employeeId,
    Expression<String>? paymentDate,
    Expression<int>? amount,
    Expression<String>? note,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WorkerPaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? employeeId,
    Value<String>? paymentDate,
    Value<int>? amount,
    Value<String?>? note,
    Value<String>? createdAt,
  }) {
    return WorkerPaymentsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      paymentDate: paymentDate ?? this.paymentDate,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<String>(paymentDate.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkerPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $RolesTable roles = $RolesTable(this);
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $CostCodesTable costCodes = $CostCodesTable(this);
  late final $ExpenseCategoriesTable expenseCategories =
      $ExpenseCategoriesTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $InvoicePaymentsTable invoicePayments = $InvoicePaymentsTable(
    this,
  );
  late final $TimeEntriesTable timeEntries = $TimeEntriesTable(this);
  late final $MaterialsTable materials = $MaterialsTable(this);
  late final $CompanySettingsTableTable companySettingsTable =
      $CompanySettingsTableTable(this);
  late final $WorkerPaymentsTable workerPayments = $WorkerPaymentsTable(this);
  late final Index idxInvoicePaymentsInvoice = Index(
    'idx_invoice_payments_invoice',
    'CREATE INDEX idx_invoice_payments_invoice ON invoice_payments (invoice_id)',
  );
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final ClientsDao clientsDao = ClientsDao(this as AppDatabase);
  late final ProjectsDao projectsDao = ProjectsDao(this as AppDatabase);
  late final RolesDao rolesDao = RolesDao(this as AppDatabase);
  late final EmployeesDao employeesDao = EmployeesDao(this as AppDatabase);
  late final CostCodesDao costCodesDao = CostCodesDao(this as AppDatabase);
  late final ExpenseCategoriesDao expenseCategoriesDao = ExpenseCategoriesDao(
    this as AppDatabase,
  );
  late final InvoicesDao invoicesDao = InvoicesDao(this as AppDatabase);
  late final InvoicePaymentsDao invoicePaymentsDao = InvoicePaymentsDao(
    this as AppDatabase,
  );
  late final TimeEntriesDao timeEntriesDao = TimeEntriesDao(
    this as AppDatabase,
  );
  late final MaterialsDao materialsDao = MaterialsDao(this as AppDatabase);
  late final CompanySettingsDao companySettingsDao = CompanySettingsDao(
    this as AppDatabase,
  );
  late final WorkerPaymentsDao workerPaymentsDao = WorkerPaymentsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settings,
    clients,
    projects,
    roles,
    employees,
    costCodes,
    expenseCategories,
    invoices,
    invoicePayments,
    timeEntries,
    materials,
    companySettingsTable,
    workerPayments,
    idxInvoicePaymentsInvoice,
  ];
}

typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<String?> employeeNumberPrefix,
      Value<int?> nextEmployeeNumber,
      Value<String?> vehicleDesignations,
      Value<String?> vendors,
      Value<int?> companyHourlyRate,
      Value<double?> burdenRate,
      Value<int?> timeRoundingInterval,
      Value<int?> autoBackupReminderFrequency,
      Value<int?> appRunsSinceBackup,
      Value<String?> measurementSystem,
      Value<int?> defaultReportMonths,
      Value<double?> expenseMarkupPercentage,
      Value<int> setupCompleted,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<String?> employeeNumberPrefix,
      Value<int?> nextEmployeeNumber,
      Value<String?> vehicleDesignations,
      Value<String?> vendors,
      Value<int?> companyHourlyRate,
      Value<double?> burdenRate,
      Value<int?> timeRoundingInterval,
      Value<int?> autoBackupReminderFrequency,
      Value<int?> appRunsSinceBackup,
      Value<String?> measurementSystem,
      Value<int?> defaultReportMonths,
      Value<double?> expenseMarkupPercentage,
      Value<int> setupCompleted,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeNumberPrefix => $composableBuilder(
    column: $table.employeeNumberPrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextEmployeeNumber => $composableBuilder(
    column: $table.nextEmployeeNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleDesignations => $composableBuilder(
    column: $table.vehicleDesignations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vendors => $composableBuilder(
    column: $table.vendors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get companyHourlyRate => $composableBuilder(
    column: $table.companyHourlyRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get burdenRate => $composableBuilder(
    column: $table.burdenRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeRoundingInterval => $composableBuilder(
    column: $table.timeRoundingInterval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get autoBackupReminderFrequency => $composableBuilder(
    column: $table.autoBackupReminderFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get appRunsSinceBackup => $composableBuilder(
    column: $table.appRunsSinceBackup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementSystem => $composableBuilder(
    column: $table.measurementSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultReportMonths => $composableBuilder(
    column: $table.defaultReportMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get expenseMarkupPercentage => $composableBuilder(
    column: $table.expenseMarkupPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setupCompleted => $composableBuilder(
    column: $table.setupCompleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeNumberPrefix => $composableBuilder(
    column: $table.employeeNumberPrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextEmployeeNumber => $composableBuilder(
    column: $table.nextEmployeeNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleDesignations => $composableBuilder(
    column: $table.vehicleDesignations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vendors => $composableBuilder(
    column: $table.vendors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get companyHourlyRate => $composableBuilder(
    column: $table.companyHourlyRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get burdenRate => $composableBuilder(
    column: $table.burdenRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeRoundingInterval => $composableBuilder(
    column: $table.timeRoundingInterval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get autoBackupReminderFrequency => $composableBuilder(
    column: $table.autoBackupReminderFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get appRunsSinceBackup => $composableBuilder(
    column: $table.appRunsSinceBackup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementSystem => $composableBuilder(
    column: $table.measurementSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultReportMonths => $composableBuilder(
    column: $table.defaultReportMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get expenseMarkupPercentage => $composableBuilder(
    column: $table.expenseMarkupPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setupCompleted => $composableBuilder(
    column: $table.setupCompleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeNumberPrefix => $composableBuilder(
    column: $table.employeeNumberPrefix,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nextEmployeeNumber => $composableBuilder(
    column: $table.nextEmployeeNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehicleDesignations => $composableBuilder(
    column: $table.vehicleDesignations,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vendors =>
      $composableBuilder(column: $table.vendors, builder: (column) => column);

  GeneratedColumn<int> get companyHourlyRate => $composableBuilder(
    column: $table.companyHourlyRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get burdenRate => $composableBuilder(
    column: $table.burdenRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeRoundingInterval => $composableBuilder(
    column: $table.timeRoundingInterval,
    builder: (column) => column,
  );

  GeneratedColumn<int> get autoBackupReminderFrequency => $composableBuilder(
    column: $table.autoBackupReminderFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<int> get appRunsSinceBackup => $composableBuilder(
    column: $table.appRunsSinceBackup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementSystem => $composableBuilder(
    column: $table.measurementSystem,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultReportMonths => $composableBuilder(
    column: $table.defaultReportMonths,
    builder: (column) => column,
  );

  GeneratedColumn<double> get expenseMarkupPercentage => $composableBuilder(
    column: $table.expenseMarkupPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get setupCompleted => $composableBuilder(
    column: $table.setupCompleted,
    builder: (column) => column,
  );
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          DbSetting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (DbSetting, BaseReferences<_$AppDatabase, $SettingsTable, DbSetting>),
          DbSetting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> employeeNumberPrefix = const Value.absent(),
                Value<int?> nextEmployeeNumber = const Value.absent(),
                Value<String?> vehicleDesignations = const Value.absent(),
                Value<String?> vendors = const Value.absent(),
                Value<int?> companyHourlyRate = const Value.absent(),
                Value<double?> burdenRate = const Value.absent(),
                Value<int?> timeRoundingInterval = const Value.absent(),
                Value<int?> autoBackupReminderFrequency = const Value.absent(),
                Value<int?> appRunsSinceBackup = const Value.absent(),
                Value<String?> measurementSystem = const Value.absent(),
                Value<int?> defaultReportMonths = const Value.absent(),
                Value<double?> expenseMarkupPercentage = const Value.absent(),
                Value<int> setupCompleted = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                employeeNumberPrefix: employeeNumberPrefix,
                nextEmployeeNumber: nextEmployeeNumber,
                vehicleDesignations: vehicleDesignations,
                vendors: vendors,
                companyHourlyRate: companyHourlyRate,
                burdenRate: burdenRate,
                timeRoundingInterval: timeRoundingInterval,
                autoBackupReminderFrequency: autoBackupReminderFrequency,
                appRunsSinceBackup: appRunsSinceBackup,
                measurementSystem: measurementSystem,
                defaultReportMonths: defaultReportMonths,
                expenseMarkupPercentage: expenseMarkupPercentage,
                setupCompleted: setupCompleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> employeeNumberPrefix = const Value.absent(),
                Value<int?> nextEmployeeNumber = const Value.absent(),
                Value<String?> vehicleDesignations = const Value.absent(),
                Value<String?> vendors = const Value.absent(),
                Value<int?> companyHourlyRate = const Value.absent(),
                Value<double?> burdenRate = const Value.absent(),
                Value<int?> timeRoundingInterval = const Value.absent(),
                Value<int?> autoBackupReminderFrequency = const Value.absent(),
                Value<int?> appRunsSinceBackup = const Value.absent(),
                Value<String?> measurementSystem = const Value.absent(),
                Value<int?> defaultReportMonths = const Value.absent(),
                Value<double?> expenseMarkupPercentage = const Value.absent(),
                Value<int> setupCompleted = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                employeeNumberPrefix: employeeNumberPrefix,
                nextEmployeeNumber: nextEmployeeNumber,
                vehicleDesignations: vehicleDesignations,
                vendors: vendors,
                companyHourlyRate: companyHourlyRate,
                burdenRate: burdenRate,
                timeRoundingInterval: timeRoundingInterval,
                autoBackupReminderFrequency: autoBackupReminderFrequency,
                appRunsSinceBackup: appRunsSinceBackup,
                measurementSystem: measurementSystem,
                defaultReportMonths: defaultReportMonths,
                expenseMarkupPercentage: expenseMarkupPercentage,
                setupCompleted: setupCompleted,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      DbSetting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (DbSetting, BaseReferences<_$AppDatabase, $SettingsTable, DbSetting>),
      DbSetting,
      PrefetchHooks Function()
    >;
typedef $$ClientsTableCreateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> id,
      required String name,
      Value<int> isActive,
      Value<String?> contactPerson,
      Value<String?> phoneNumber,
    });
typedef $$ClientsTableUpdateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> isActive,
      Value<String?> contactPerson,
      Value<String?> phoneNumber,
    });

final class $$ClientsTableReferences
    extends BaseReferences<_$AppDatabase, $ClientsTable, DbClient> {
  $$ClientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProjectsTable, List<DbProject>>
  _projectsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.projects,
    aliasName: $_aliasNameGenerator(db.clients.id, db.projects.clientId),
  );

  $$ProjectsTableProcessedTableManager get projectsRefs {
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InvoicesTable, List<DbInvoice>>
  _invoicesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoices,
    aliasName: $_aliasNameGenerator(db.clients.id, db.invoices.clientId),
  );

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> projectsRefs(
    Expression<bool> Function($$ProjectsTableFilterComposer f) f,
  ) {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> invoicesRefs(
    Expression<bool> Function($$InvoicesTableFilterComposer f) f,
  ) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  Expression<T> projectsRefs<T extends Object>(
    Expression<T> Function($$ProjectsTableAnnotationComposer a) f,
  ) {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> invoicesRefs<T extends Object>(
    Expression<T> Function($$InvoicesTableAnnotationComposer a) f,
  ) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientsTable,
          DbClient,
          $$ClientsTableFilterComposer,
          $$ClientsTableOrderingComposer,
          $$ClientsTableAnnotationComposer,
          $$ClientsTableCreateCompanionBuilder,
          $$ClientsTableUpdateCompanionBuilder,
          (DbClient, $$ClientsTableReferences),
          DbClient,
          PrefetchHooks Function({bool projectsRefs, bool invoicesRefs})
        > {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<String?> contactPerson = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
              }) => ClientsCompanion(
                id: id,
                name: name,
                isActive: isActive,
                contactPerson: contactPerson,
                phoneNumber: phoneNumber,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> isActive = const Value.absent(),
                Value<String?> contactPerson = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
              }) => ClientsCompanion.insert(
                id: id,
                name: name,
                isActive: isActive,
                contactPerson: contactPerson,
                phoneNumber: phoneNumber,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({projectsRefs = false, invoicesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (projectsRefs) db.projects,
                    if (invoicesRefs) db.invoices,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (projectsRefs)
                        await $_getPrefetchedData<
                          DbClient,
                          $ClientsTable,
                          DbProject
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._projectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (invoicesRefs)
                        await $_getPrefetchedData<
                          DbClient,
                          $ClientsTable,
                          DbInvoice
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._invoicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).invoicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clientId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientsTable,
      DbClient,
      $$ClientsTableFilterComposer,
      $$ClientsTableOrderingComposer,
      $$ClientsTableAnnotationComposer,
      $$ClientsTableCreateCompanionBuilder,
      $$ClientsTableUpdateCompanionBuilder,
      (DbClient, $$ClientsTableReferences),
      DbClient,
      PrefetchHooks Function({bool projectsRefs, bool invoicesRefs})
    >;
typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      required String projectName,
      required int clientId,
      Value<String?> city,
      Value<String?> streetAddress,
      Value<String?> region,
      Value<String?> postalCode,
      Value<String> pricingModel,
      Value<int> isCompleted,
      Value<String?> completionDate,
      Value<int> isInternal,
      Value<int?> billedHourlyRate,
      Value<int?> projectPrice,
      Value<double> expenseMarkupPercentage,
      Value<double> taxRate,
      Value<int?> parentProjectId,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      Value<String> projectName,
      Value<int> clientId,
      Value<String?> city,
      Value<String?> streetAddress,
      Value<String?> region,
      Value<String?> postalCode,
      Value<String> pricingModel,
      Value<int> isCompleted,
      Value<String?> completionDate,
      Value<int> isInternal,
      Value<int?> billedHourlyRate,
      Value<int?> projectPrice,
      Value<double> expenseMarkupPercentage,
      Value<double> taxRate,
      Value<int?> parentProjectId,
    });

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, DbProject> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) => db.clients
      .createAlias($_aliasNameGenerator(db.projects.clientId, db.clients.id));

  $$ClientsTableProcessedTableManager get clientId {
    final $_column = $_itemColumn<int>('client_id')!;

    final manager = $$ClientsTableTableManager(
      $_db,
      $_db.clients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _parentProjectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.projects.parentProjectId, db.projects.id),
      );

  $$ProjectsTableProcessedTableManager? get parentProjectId {
    final $_column = $_itemColumn<int>('parent_project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentProjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InvoicesTable, List<DbInvoice>>
  _invoicesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoices,
    aliasName: $_aliasNameGenerator(db.projects.id, db.invoices.projectId),
  );

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimeEntriesTable, List<DbTimeEntry>>
  _timeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: $_aliasNameGenerator(db.projects.id, db.timeEntries.projectId),
  );

  $$TimeEntriesTableProcessedTableManager get timeEntriesRefs {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MaterialsTable, List<DbMaterial>>
  _materialsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.materials,
    aliasName: $_aliasNameGenerator(db.projects.id, db.materials.projectId),
  );

  $$MaterialsTableProcessedTableManager get materialsRefs {
    final manager = $$MaterialsTableTableManager(
      $_db,
      $_db.materials,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_materialsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectName => $composableBuilder(
    column: $table.projectName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get streetAddress => $composableBuilder(
    column: $table.streetAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postalCode => $composableBuilder(
    column: $table.postalCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pricingModel => $composableBuilder(
    column: $table.pricingModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completionDate => $composableBuilder(
    column: $table.completionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isInternal => $composableBuilder(
    column: $table.isInternal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get billedHourlyRate => $composableBuilder(
    column: $table.billedHourlyRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get projectPrice => $composableBuilder(
    column: $table.projectPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get expenseMarkupPercentage => $composableBuilder(
    column: $table.expenseMarkupPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableFilterComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get parentProjectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> invoicesRefs(
    Expression<bool> Function($$InvoicesTableFilterComposer f) f,
  ) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> timeEntriesRefs(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> materialsRefs(
    Expression<bool> Function($$MaterialsTableFilterComposer f) f,
  ) {
    final $$MaterialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materials,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableFilterComposer(
            $db: $db,
            $table: $db.materials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectName => $composableBuilder(
    column: $table.projectName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get streetAddress => $composableBuilder(
    column: $table.streetAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postalCode => $composableBuilder(
    column: $table.postalCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pricingModel => $composableBuilder(
    column: $table.pricingModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completionDate => $composableBuilder(
    column: $table.completionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isInternal => $composableBuilder(
    column: $table.isInternal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get billedHourlyRate => $composableBuilder(
    column: $table.billedHourlyRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get projectPrice => $composableBuilder(
    column: $table.projectPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get expenseMarkupPercentage => $composableBuilder(
    column: $table.expenseMarkupPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableOrderingComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get parentProjectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectName => $composableBuilder(
    column: $table.projectName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get streetAddress => $composableBuilder(
    column: $table.streetAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get postalCode => $composableBuilder(
    column: $table.postalCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pricingModel => $composableBuilder(
    column: $table.pricingModel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completionDate => $composableBuilder(
    column: $table.completionDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isInternal => $composableBuilder(
    column: $table.isInternal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get billedHourlyRate => $composableBuilder(
    column: $table.billedHourlyRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get projectPrice => $composableBuilder(
    column: $table.projectPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get expenseMarkupPercentage => $composableBuilder(
    column: $table.expenseMarkupPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableAnnotationComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get parentProjectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> invoicesRefs<T extends Object>(
    Expression<T> Function($$InvoicesTableAnnotationComposer a) f,
  ) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> timeEntriesRefs<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> materialsRefs<T extends Object>(
    Expression<T> Function($$MaterialsTableAnnotationComposer a) f,
  ) {
    final $$MaterialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materials,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableAnnotationComposer(
            $db: $db,
            $table: $db.materials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          DbProject,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (DbProject, $$ProjectsTableReferences),
          DbProject,
          PrefetchHooks Function({
            bool clientId,
            bool parentProjectId,
            bool invoicesRefs,
            bool timeEntriesRefs,
            bool materialsRefs,
          })
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> projectName = const Value.absent(),
                Value<int> clientId = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> streetAddress = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String?> postalCode = const Value.absent(),
                Value<String> pricingModel = const Value.absent(),
                Value<int> isCompleted = const Value.absent(),
                Value<String?> completionDate = const Value.absent(),
                Value<int> isInternal = const Value.absent(),
                Value<int?> billedHourlyRate = const Value.absent(),
                Value<int?> projectPrice = const Value.absent(),
                Value<double> expenseMarkupPercentage = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<int?> parentProjectId = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                projectName: projectName,
                clientId: clientId,
                city: city,
                streetAddress: streetAddress,
                region: region,
                postalCode: postalCode,
                pricingModel: pricingModel,
                isCompleted: isCompleted,
                completionDate: completionDate,
                isInternal: isInternal,
                billedHourlyRate: billedHourlyRate,
                projectPrice: projectPrice,
                expenseMarkupPercentage: expenseMarkupPercentage,
                taxRate: taxRate,
                parentProjectId: parentProjectId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String projectName,
                required int clientId,
                Value<String?> city = const Value.absent(),
                Value<String?> streetAddress = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String?> postalCode = const Value.absent(),
                Value<String> pricingModel = const Value.absent(),
                Value<int> isCompleted = const Value.absent(),
                Value<String?> completionDate = const Value.absent(),
                Value<int> isInternal = const Value.absent(),
                Value<int?> billedHourlyRate = const Value.absent(),
                Value<int?> projectPrice = const Value.absent(),
                Value<double> expenseMarkupPercentage = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<int?> parentProjectId = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                projectName: projectName,
                clientId: clientId,
                city: city,
                streetAddress: streetAddress,
                region: region,
                postalCode: postalCode,
                pricingModel: pricingModel,
                isCompleted: isCompleted,
                completionDate: completionDate,
                isInternal: isInternal,
                billedHourlyRate: billedHourlyRate,
                projectPrice: projectPrice,
                expenseMarkupPercentage: expenseMarkupPercentage,
                taxRate: taxRate,
                parentProjectId: parentProjectId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clientId = false,
                parentProjectId = false,
                invoicesRefs = false,
                timeEntriesRefs = false,
                materialsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoicesRefs) db.invoices,
                    if (timeEntriesRefs) db.timeEntries,
                    if (materialsRefs) db.materials,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (clientId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.clientId,
                                    referencedTable: $$ProjectsTableReferences
                                        ._clientIdTable(db),
                                    referencedColumn: $$ProjectsTableReferences
                                        ._clientIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (parentProjectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.parentProjectId,
                                    referencedTable: $$ProjectsTableReferences
                                        ._parentProjectIdTable(db),
                                    referencedColumn: $$ProjectsTableReferences
                                        ._parentProjectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoicesRefs)
                        await $_getPrefetchedData<
                          DbProject,
                          $ProjectsTable,
                          DbInvoice
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._invoicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).invoicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (timeEntriesRefs)
                        await $_getPrefetchedData<
                          DbProject,
                          $ProjectsTable,
                          DbTimeEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._timeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).timeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (materialsRefs)
                        await $_getPrefetchedData<
                          DbProject,
                          $ProjectsTable,
                          DbMaterial
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._materialsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).materialsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      DbProject,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (DbProject, $$ProjectsTableReferences),
      DbProject,
      PrefetchHooks Function({
        bool clientId,
        bool parentProjectId,
        bool invoicesRefs,
        bool timeEntriesRefs,
        bool materialsRefs,
      })
    >;
typedef $$RolesTableCreateCompanionBuilder =
    RolesCompanion Function({
      Value<int> id,
      required String name,
      Value<int> standardRate,
    });
typedef $$RolesTableUpdateCompanionBuilder =
    RolesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> standardRate,
    });

final class $$RolesTableReferences
    extends BaseReferences<_$AppDatabase, $RolesTable, DbRole> {
  $$RolesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EmployeesTable, List<DbEmployee>>
  _employeesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.employees,
    aliasName: $_aliasNameGenerator(db.roles.id, db.employees.titleId),
  );

  $$EmployeesTableProcessedTableManager get employeesRefs {
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.titleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_employeesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RolesTableFilterComposer extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get standardRate => $composableBuilder(
    column: $table.standardRate,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> employeesRefs(
    Expression<bool> Function($$EmployeesTableFilterComposer f) f,
  ) {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.titleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RolesTableOrderingComposer
    extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get standardRate => $composableBuilder(
    column: $table.standardRate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RolesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get standardRate => $composableBuilder(
    column: $table.standardRate,
    builder: (column) => column,
  );

  Expression<T> employeesRefs<T extends Object>(
    Expression<T> Function($$EmployeesTableAnnotationComposer a) f,
  ) {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.titleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RolesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RolesTable,
          DbRole,
          $$RolesTableFilterComposer,
          $$RolesTableOrderingComposer,
          $$RolesTableAnnotationComposer,
          $$RolesTableCreateCompanionBuilder,
          $$RolesTableUpdateCompanionBuilder,
          (DbRole, $$RolesTableReferences),
          DbRole,
          PrefetchHooks Function({bool employeesRefs})
        > {
  $$RolesTableTableManager(_$AppDatabase db, $RolesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RolesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RolesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RolesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> standardRate = const Value.absent(),
              }) => RolesCompanion(
                id: id,
                name: name,
                standardRate: standardRate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> standardRate = const Value.absent(),
              }) => RolesCompanion.insert(
                id: id,
                name: name,
                standardRate: standardRate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$RolesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({employeesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (employeesRefs) db.employees],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (employeesRefs)
                    await $_getPrefetchedData<DbRole, $RolesTable, DbEmployee>(
                      currentTable: table,
                      referencedTable: $$RolesTableReferences
                          ._employeesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RolesTableReferences(db, table, p0).employeesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.titleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RolesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RolesTable,
      DbRole,
      $$RolesTableFilterComposer,
      $$RolesTableOrderingComposer,
      $$RolesTableAnnotationComposer,
      $$RolesTableCreateCompanionBuilder,
      $$RolesTableUpdateCompanionBuilder,
      (DbRole, $$RolesTableReferences),
      DbRole,
      PrefetchHooks Function({bool employeesRefs})
    >;
typedef $$EmployeesTableCreateCompanionBuilder =
    EmployeesCompanion Function({
      Value<int> id,
      Value<String?> employeeNumber,
      required String name,
      Value<int?> titleId,
      Value<int?> hourlyRate,
      Value<int> isDeleted,
    });
typedef $$EmployeesTableUpdateCompanionBuilder =
    EmployeesCompanion Function({
      Value<int> id,
      Value<String?> employeeNumber,
      Value<String> name,
      Value<int?> titleId,
      Value<int?> hourlyRate,
      Value<int> isDeleted,
    });

final class $$EmployeesTableReferences
    extends BaseReferences<_$AppDatabase, $EmployeesTable, DbEmployee> {
  $$EmployeesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RolesTable _titleIdTable(_$AppDatabase db) => db.roles.createAlias(
    $_aliasNameGenerator(db.employees.titleId, db.roles.id),
  );

  $$RolesTableProcessedTableManager? get titleId {
    final $_column = $_itemColumn<int>('title_id');
    if ($_column == null) return null;
    final manager = $$RolesTableTableManager(
      $_db,
      $_db.roles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_titleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TimeEntriesTable, List<DbTimeEntry>>
  _timeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: $_aliasNameGenerator(db.employees.id, db.timeEntries.employeeId),
  );

  $$TimeEntriesTableProcessedTableManager get timeEntriesRefs {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkerPaymentsTable, List<DbWorkerPayment>>
  _workerPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workerPayments,
    aliasName: $_aliasNameGenerator(
      db.employees.id,
      db.workerPayments.employeeId,
    ),
  );

  $$WorkerPaymentsTableProcessedTableManager get workerPaymentsRefs {
    final manager = $$WorkerPaymentsTableTableManager(
      $_db,
      $_db.workerPayments,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workerPaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmployeesTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeNumber => $composableBuilder(
    column: $table.employeeNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$RolesTableFilterComposer get titleId {
    final $$RolesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.titleId,
      referencedTable: $db.roles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RolesTableFilterComposer(
            $db: $db,
            $table: $db.roles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> timeEntriesRefs(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workerPaymentsRefs(
    Expression<bool> Function($$WorkerPaymentsTableFilterComposer f) f,
  ) {
    final $$WorkerPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workerPayments,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkerPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.workerPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmployeesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeNumber => $composableBuilder(
    column: $table.employeeNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$RolesTableOrderingComposer get titleId {
    final $$RolesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.titleId,
      referencedTable: $db.roles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RolesTableOrderingComposer(
            $db: $db,
            $table: $db.roles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmployeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeNumber => $composableBuilder(
    column: $table.employeeNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$RolesTableAnnotationComposer get titleId {
    final $$RolesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.titleId,
      referencedTable: $db.roles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RolesTableAnnotationComposer(
            $db: $db,
            $table: $db.roles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> timeEntriesRefs<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workerPaymentsRefs<T extends Object>(
    Expression<T> Function($$WorkerPaymentsTableAnnotationComposer a) f,
  ) {
    final $$WorkerPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workerPayments,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkerPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.workerPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmployeesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmployeesTable,
          DbEmployee,
          $$EmployeesTableFilterComposer,
          $$EmployeesTableOrderingComposer,
          $$EmployeesTableAnnotationComposer,
          $$EmployeesTableCreateCompanionBuilder,
          $$EmployeesTableUpdateCompanionBuilder,
          (DbEmployee, $$EmployeesTableReferences),
          DbEmployee,
          PrefetchHooks Function({
            bool titleId,
            bool timeEntriesRefs,
            bool workerPaymentsRefs,
          })
        > {
  $$EmployeesTableTableManager(_$AppDatabase db, $EmployeesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> employeeNumber = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> titleId = const Value.absent(),
                Value<int?> hourlyRate = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
              }) => EmployeesCompanion(
                id: id,
                employeeNumber: employeeNumber,
                name: name,
                titleId: titleId,
                hourlyRate: hourlyRate,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> employeeNumber = const Value.absent(),
                required String name,
                Value<int?> titleId = const Value.absent(),
                Value<int?> hourlyRate = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
              }) => EmployeesCompanion.insert(
                id: id,
                employeeNumber: employeeNumber,
                name: name,
                titleId: titleId,
                hourlyRate: hourlyRate,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmployeesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                titleId = false,
                timeEntriesRefs = false,
                workerPaymentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (timeEntriesRefs) db.timeEntries,
                    if (workerPaymentsRefs) db.workerPayments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (titleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.titleId,
                                    referencedTable: $$EmployeesTableReferences
                                        ._titleIdTable(db),
                                    referencedColumn: $$EmployeesTableReferences
                                        ._titleIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (timeEntriesRefs)
                        await $_getPrefetchedData<
                          DbEmployee,
                          $EmployeesTable,
                          DbTimeEntry
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._timeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).timeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (workerPaymentsRefs)
                        await $_getPrefetchedData<
                          DbEmployee,
                          $EmployeesTable,
                          DbWorkerPayment
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._workerPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).workerPaymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EmployeesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmployeesTable,
      DbEmployee,
      $$EmployeesTableFilterComposer,
      $$EmployeesTableOrderingComposer,
      $$EmployeesTableAnnotationComposer,
      $$EmployeesTableCreateCompanionBuilder,
      $$EmployeesTableUpdateCompanionBuilder,
      (DbEmployee, $$EmployeesTableReferences),
      DbEmployee,
      PrefetchHooks Function({
        bool titleId,
        bool timeEntriesRefs,
        bool workerPaymentsRefs,
      })
    >;
typedef $$CostCodesTableCreateCompanionBuilder =
    CostCodesCompanion Function({
      Value<int> id,
      required String name,
      Value<int> isBillable,
    });
typedef $$CostCodesTableUpdateCompanionBuilder =
    CostCodesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> isBillable,
    });

final class $$CostCodesTableReferences
    extends BaseReferences<_$AppDatabase, $CostCodesTable, DbCostCode> {
  $$CostCodesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TimeEntriesTable, List<DbTimeEntry>>
  _timeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: $_aliasNameGenerator(db.costCodes.id, db.timeEntries.costCodeId),
  );

  $$TimeEntriesTableProcessedTableManager get timeEntriesRefs {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.costCodeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MaterialsTable, List<DbMaterial>>
  _materialsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.materials,
    aliasName: $_aliasNameGenerator(db.costCodes.id, db.materials.costCodeId),
  );

  $$MaterialsTableProcessedTableManager get materialsRefs {
    final manager = $$MaterialsTableTableManager(
      $_db,
      $_db.materials,
    ).filter((f) => f.costCodeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_materialsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CostCodesTableFilterComposer
    extends Composer<_$AppDatabase, $CostCodesTable> {
  $$CostCodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isBillable => $composableBuilder(
    column: $table.isBillable,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> timeEntriesRefs(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.costCodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> materialsRefs(
    Expression<bool> Function($$MaterialsTableFilterComposer f) f,
  ) {
    final $$MaterialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materials,
      getReferencedColumn: (t) => t.costCodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableFilterComposer(
            $db: $db,
            $table: $db.materials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CostCodesTableOrderingComposer
    extends Composer<_$AppDatabase, $CostCodesTable> {
  $$CostCodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isBillable => $composableBuilder(
    column: $table.isBillable,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CostCodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CostCodesTable> {
  $$CostCodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get isBillable => $composableBuilder(
    column: $table.isBillable,
    builder: (column) => column,
  );

  Expression<T> timeEntriesRefs<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.costCodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> materialsRefs<T extends Object>(
    Expression<T> Function($$MaterialsTableAnnotationComposer a) f,
  ) {
    final $$MaterialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materials,
      getReferencedColumn: (t) => t.costCodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableAnnotationComposer(
            $db: $db,
            $table: $db.materials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CostCodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CostCodesTable,
          DbCostCode,
          $$CostCodesTableFilterComposer,
          $$CostCodesTableOrderingComposer,
          $$CostCodesTableAnnotationComposer,
          $$CostCodesTableCreateCompanionBuilder,
          $$CostCodesTableUpdateCompanionBuilder,
          (DbCostCode, $$CostCodesTableReferences),
          DbCostCode,
          PrefetchHooks Function({bool timeEntriesRefs, bool materialsRefs})
        > {
  $$CostCodesTableTableManager(_$AppDatabase db, $CostCodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CostCodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CostCodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CostCodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> isBillable = const Value.absent(),
              }) => CostCodesCompanion(
                id: id,
                name: name,
                isBillable: isBillable,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> isBillable = const Value.absent(),
              }) => CostCodesCompanion.insert(
                id: id,
                name: name,
                isBillable: isBillable,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CostCodesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({timeEntriesRefs = false, materialsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (timeEntriesRefs) db.timeEntries,
                    if (materialsRefs) db.materials,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (timeEntriesRefs)
                        await $_getPrefetchedData<
                          DbCostCode,
                          $CostCodesTable,
                          DbTimeEntry
                        >(
                          currentTable: table,
                          referencedTable: $$CostCodesTableReferences
                              ._timeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CostCodesTableReferences(
                                db,
                                table,
                                p0,
                              ).timeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.costCodeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (materialsRefs)
                        await $_getPrefetchedData<
                          DbCostCode,
                          $CostCodesTable,
                          DbMaterial
                        >(
                          currentTable: table,
                          referencedTable: $$CostCodesTableReferences
                              ._materialsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CostCodesTableReferences(
                                db,
                                table,
                                p0,
                              ).materialsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.costCodeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CostCodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CostCodesTable,
      DbCostCode,
      $$CostCodesTableFilterComposer,
      $$CostCodesTableOrderingComposer,
      $$CostCodesTableAnnotationComposer,
      $$CostCodesTableCreateCompanionBuilder,
      $$CostCodesTableUpdateCompanionBuilder,
      (DbCostCode, $$CostCodesTableReferences),
      DbCostCode,
      PrefetchHooks Function({bool timeEntriesRefs, bool materialsRefs})
    >;
typedef $$ExpenseCategoriesTableCreateCompanionBuilder =
    ExpenseCategoriesCompanion Function({Value<int> id, required String name});
typedef $$ExpenseCategoriesTableUpdateCompanionBuilder =
    ExpenseCategoriesCompanion Function({Value<int> id, Value<String> name});

class $$ExpenseCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpenseCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpenseCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$ExpenseCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpenseCategoriesTable,
          DbExpenseCategory,
          $$ExpenseCategoriesTableFilterComposer,
          $$ExpenseCategoriesTableOrderingComposer,
          $$ExpenseCategoriesTableAnnotationComposer,
          $$ExpenseCategoriesTableCreateCompanionBuilder,
          $$ExpenseCategoriesTableUpdateCompanionBuilder,
          (
            DbExpenseCategory,
            BaseReferences<
              _$AppDatabase,
              $ExpenseCategoriesTable,
              DbExpenseCategory
            >,
          ),
          DbExpenseCategory,
          PrefetchHooks Function()
        > {
  $$ExpenseCategoriesTableTableManager(
    _$AppDatabase db,
    $ExpenseCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => ExpenseCategoriesCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  ExpenseCategoriesCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpenseCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpenseCategoriesTable,
      DbExpenseCategory,
      $$ExpenseCategoriesTableFilterComposer,
      $$ExpenseCategoriesTableOrderingComposer,
      $$ExpenseCategoriesTableAnnotationComposer,
      $$ExpenseCategoriesTableCreateCompanionBuilder,
      $$ExpenseCategoriesTableUpdateCompanionBuilder,
      (
        DbExpenseCategory,
        BaseReferences<
          _$AppDatabase,
          $ExpenseCategoriesTable,
          DbExpenseCategory
        >,
      ),
      DbExpenseCategory,
      PrefetchHooks Function()
    >;
typedef $$InvoicesTableCreateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> id,
      required String invoiceNumber,
      required String invoiceDate,
      required int clientId,
      required int projectId,
      Value<String?> projectAddress,
      Value<int> labourSubtotal,
      Value<int> materialsSubtotal,
      Value<int> materialsPickupCost,
      Value<int> otherCosts,
      Value<String?> otherCostsDescription,
      Value<int> discountAmount,
      Value<String?> discountDescription,
      Value<double> discountPercent,
      Value<String?> tax1Name,
      Value<double?> tax1Rate,
      Value<int> tax1Amount,
      Value<String?> tax1RegistrationNumber,
      Value<String?> tax2Name,
      Value<double?> tax2Rate,
      Value<int> tax2Amount,
      Value<String?> tax2RegistrationNumber,
      Value<int> subtotal,
      Value<int> totalAmount,
      Value<String> terms,
      Value<String?> poNumber,
      Value<int> isDeleted,
      Value<String?> deletedReasonCode,
      Value<String?> deletedDate,
      Value<String?> deletedNotes,
      Value<int?> supersededByInvoiceId,
      Value<String?> notes,
      Value<String?> internalNotes,
      Value<String?> workDescription,
      Value<int> isSent,
      Value<String> invoiceType,
    });
typedef $$InvoicesTableUpdateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> id,
      Value<String> invoiceNumber,
      Value<String> invoiceDate,
      Value<int> clientId,
      Value<int> projectId,
      Value<String?> projectAddress,
      Value<int> labourSubtotal,
      Value<int> materialsSubtotal,
      Value<int> materialsPickupCost,
      Value<int> otherCosts,
      Value<String?> otherCostsDescription,
      Value<int> discountAmount,
      Value<String?> discountDescription,
      Value<double> discountPercent,
      Value<String?> tax1Name,
      Value<double?> tax1Rate,
      Value<int> tax1Amount,
      Value<String?> tax1RegistrationNumber,
      Value<String?> tax2Name,
      Value<double?> tax2Rate,
      Value<int> tax2Amount,
      Value<String?> tax2RegistrationNumber,
      Value<int> subtotal,
      Value<int> totalAmount,
      Value<String> terms,
      Value<String?> poNumber,
      Value<int> isDeleted,
      Value<String?> deletedReasonCode,
      Value<String?> deletedDate,
      Value<String?> deletedNotes,
      Value<int?> supersededByInvoiceId,
      Value<String?> notes,
      Value<String?> internalNotes,
      Value<String?> workDescription,
      Value<int> isSent,
      Value<String> invoiceType,
    });

final class $$InvoicesTableReferences
    extends BaseReferences<_$AppDatabase, $InvoicesTable, DbInvoice> {
  $$InvoicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) => db.clients
      .createAlias($_aliasNameGenerator(db.invoices.clientId, db.clients.id));

  $$ClientsTableProcessedTableManager get clientId {
    final $_column = $_itemColumn<int>('client_id')!;

    final manager = $$ClientsTableTableManager(
      $_db,
      $_db.clients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) => db.projects
      .createAlias($_aliasNameGenerator(db.invoices.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InvoicesTable _supersededByInvoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias(
        $_aliasNameGenerator(db.invoices.supersededByInvoiceId, db.invoices.id),
      );

  $$InvoicesTableProcessedTableManager? get supersededByInvoiceId {
    final $_column = $_itemColumn<int>('superseded_by_invoice_id');
    if ($_column == null) return null;
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _supersededByInvoiceIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InvoicePaymentsTable, List<DbInvoicePayment>>
  _invoicePaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoicePayments,
    aliasName: $_aliasNameGenerator(
      db.invoices.id,
      db.invoicePayments.invoiceId,
    ),
  );

  $$InvoicePaymentsTableProcessedTableManager get invoicePaymentsRefs {
    final manager = $$InvoicePaymentsTableTableManager(
      $_db,
      $_db.invoicePayments,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _invoicePaymentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimeEntriesTable, List<DbTimeEntry>>
  _timeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: $_aliasNameGenerator(db.invoices.id, db.timeEntries.invoiceId),
  );

  $$TimeEntriesTableProcessedTableManager get timeEntriesRefs {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MaterialsTable, List<DbMaterial>>
  _materialsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.materials,
    aliasName: $_aliasNameGenerator(db.invoices.id, db.materials.invoiceId),
  );

  $$MaterialsTableProcessedTableManager get materialsRefs {
    final manager = $$MaterialsTableTableManager(
      $_db,
      $_db.materials,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_materialsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectAddress => $composableBuilder(
    column: $table.projectAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get labourSubtotal => $composableBuilder(
    column: $table.labourSubtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get materialsSubtotal => $composableBuilder(
    column: $table.materialsSubtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get materialsPickupCost => $composableBuilder(
    column: $table.materialsPickupCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get otherCosts => $composableBuilder(
    column: $table.otherCosts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherCostsDescription => $composableBuilder(
    column: $table.otherCostsDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountDescription => $composableBuilder(
    column: $table.discountDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tax1Name => $composableBuilder(
    column: $table.tax1Name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tax1Rate => $composableBuilder(
    column: $table.tax1Rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tax1Amount => $composableBuilder(
    column: $table.tax1Amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tax1RegistrationNumber => $composableBuilder(
    column: $table.tax1RegistrationNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tax2Name => $composableBuilder(
    column: $table.tax2Name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tax2Rate => $composableBuilder(
    column: $table.tax2Rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tax2Amount => $composableBuilder(
    column: $table.tax2Amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tax2RegistrationNumber => $composableBuilder(
    column: $table.tax2RegistrationNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get terms => $composableBuilder(
    column: $table.terms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poNumber => $composableBuilder(
    column: $table.poNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedReasonCode => $composableBuilder(
    column: $table.deletedReasonCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedDate => $composableBuilder(
    column: $table.deletedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedNotes => $composableBuilder(
    column: $table.deletedNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get internalNotes => $composableBuilder(
    column: $table.internalNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workDescription => $composableBuilder(
    column: $table.workDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isSent => $composableBuilder(
    column: $table.isSent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceType => $composableBuilder(
    column: $table.invoiceType,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableFilterComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableFilterComposer get supersededByInvoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supersededByInvoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> invoicePaymentsRefs(
    Expression<bool> Function($$InvoicePaymentsTableFilterComposer f) f,
  ) {
    final $$InvoicePaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoicePayments,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicePaymentsTableFilterComposer(
            $db: $db,
            $table: $db.invoicePayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> timeEntriesRefs(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> materialsRefs(
    Expression<bool> Function($$MaterialsTableFilterComposer f) f,
  ) {
    final $$MaterialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materials,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableFilterComposer(
            $db: $db,
            $table: $db.materials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectAddress => $composableBuilder(
    column: $table.projectAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get labourSubtotal => $composableBuilder(
    column: $table.labourSubtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get materialsSubtotal => $composableBuilder(
    column: $table.materialsSubtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get materialsPickupCost => $composableBuilder(
    column: $table.materialsPickupCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get otherCosts => $composableBuilder(
    column: $table.otherCosts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherCostsDescription => $composableBuilder(
    column: $table.otherCostsDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountDescription => $composableBuilder(
    column: $table.discountDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tax1Name => $composableBuilder(
    column: $table.tax1Name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tax1Rate => $composableBuilder(
    column: $table.tax1Rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tax1Amount => $composableBuilder(
    column: $table.tax1Amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tax1RegistrationNumber => $composableBuilder(
    column: $table.tax1RegistrationNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tax2Name => $composableBuilder(
    column: $table.tax2Name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tax2Rate => $composableBuilder(
    column: $table.tax2Rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tax2Amount => $composableBuilder(
    column: $table.tax2Amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tax2RegistrationNumber => $composableBuilder(
    column: $table.tax2RegistrationNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get terms => $composableBuilder(
    column: $table.terms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poNumber => $composableBuilder(
    column: $table.poNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedReasonCode => $composableBuilder(
    column: $table.deletedReasonCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedDate => $composableBuilder(
    column: $table.deletedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedNotes => $composableBuilder(
    column: $table.deletedNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get internalNotes => $composableBuilder(
    column: $table.internalNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workDescription => $composableBuilder(
    column: $table.workDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isSent => $composableBuilder(
    column: $table.isSent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceType => $composableBuilder(
    column: $table.invoiceType,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableOrderingComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableOrderingComposer get supersededByInvoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supersededByInvoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get projectAddress => $composableBuilder(
    column: $table.projectAddress,
    builder: (column) => column,
  );

  GeneratedColumn<int> get labourSubtotal => $composableBuilder(
    column: $table.labourSubtotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get materialsSubtotal => $composableBuilder(
    column: $table.materialsSubtotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get materialsPickupCost => $composableBuilder(
    column: $table.materialsPickupCost,
    builder: (column) => column,
  );

  GeneratedColumn<int> get otherCosts => $composableBuilder(
    column: $table.otherCosts,
    builder: (column) => column,
  );

  GeneratedColumn<String> get otherCostsDescription => $composableBuilder(
    column: $table.otherCostsDescription,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discountDescription => $composableBuilder(
    column: $table.discountDescription,
    builder: (column) => column,
  );

  GeneratedColumn<double> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tax1Name =>
      $composableBuilder(column: $table.tax1Name, builder: (column) => column);

  GeneratedColumn<double> get tax1Rate =>
      $composableBuilder(column: $table.tax1Rate, builder: (column) => column);

  GeneratedColumn<int> get tax1Amount => $composableBuilder(
    column: $table.tax1Amount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tax1RegistrationNumber => $composableBuilder(
    column: $table.tax1RegistrationNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tax2Name =>
      $composableBuilder(column: $table.tax2Name, builder: (column) => column);

  GeneratedColumn<double> get tax2Rate =>
      $composableBuilder(column: $table.tax2Rate, builder: (column) => column);

  GeneratedColumn<int> get tax2Amount => $composableBuilder(
    column: $table.tax2Amount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tax2RegistrationNumber => $composableBuilder(
    column: $table.tax2RegistrationNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get terms =>
      $composableBuilder(column: $table.terms, builder: (column) => column);

  GeneratedColumn<String> get poNumber =>
      $composableBuilder(column: $table.poNumber, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get deletedReasonCode => $composableBuilder(
    column: $table.deletedReasonCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deletedDate => $composableBuilder(
    column: $table.deletedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deletedNotes => $composableBuilder(
    column: $table.deletedNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get internalNotes => $composableBuilder(
    column: $table.internalNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workDescription => $composableBuilder(
    column: $table.workDescription,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isSent =>
      $composableBuilder(column: $table.isSent, builder: (column) => column);

  GeneratedColumn<String> get invoiceType => $composableBuilder(
    column: $table.invoiceType,
    builder: (column) => column,
  );

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableAnnotationComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableAnnotationComposer get supersededByInvoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supersededByInvoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> invoicePaymentsRefs<T extends Object>(
    Expression<T> Function($$InvoicePaymentsTableAnnotationComposer a) f,
  ) {
    final $$InvoicePaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoicePayments,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicePaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.invoicePayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> timeEntriesRefs<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> materialsRefs<T extends Object>(
    Expression<T> Function($$MaterialsTableAnnotationComposer a) f,
  ) {
    final $$MaterialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materials,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableAnnotationComposer(
            $db: $db,
            $table: $db.materials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTable,
          DbInvoice,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (DbInvoice, $$InvoicesTableReferences),
          DbInvoice,
          PrefetchHooks Function({
            bool clientId,
            bool projectId,
            bool supersededByInvoiceId,
            bool invoicePaymentsRefs,
            bool timeEntriesRefs,
            bool materialsRefs,
          })
        > {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> invoiceNumber = const Value.absent(),
                Value<String> invoiceDate = const Value.absent(),
                Value<int> clientId = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<String?> projectAddress = const Value.absent(),
                Value<int> labourSubtotal = const Value.absent(),
                Value<int> materialsSubtotal = const Value.absent(),
                Value<int> materialsPickupCost = const Value.absent(),
                Value<int> otherCosts = const Value.absent(),
                Value<String?> otherCostsDescription = const Value.absent(),
                Value<int> discountAmount = const Value.absent(),
                Value<String?> discountDescription = const Value.absent(),
                Value<double> discountPercent = const Value.absent(),
                Value<String?> tax1Name = const Value.absent(),
                Value<double?> tax1Rate = const Value.absent(),
                Value<int> tax1Amount = const Value.absent(),
                Value<String?> tax1RegistrationNumber = const Value.absent(),
                Value<String?> tax2Name = const Value.absent(),
                Value<double?> tax2Rate = const Value.absent(),
                Value<int> tax2Amount = const Value.absent(),
                Value<String?> tax2RegistrationNumber = const Value.absent(),
                Value<int> subtotal = const Value.absent(),
                Value<int> totalAmount = const Value.absent(),
                Value<String> terms = const Value.absent(),
                Value<String?> poNumber = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<String?> deletedReasonCode = const Value.absent(),
                Value<String?> deletedDate = const Value.absent(),
                Value<String?> deletedNotes = const Value.absent(),
                Value<int?> supersededByInvoiceId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> internalNotes = const Value.absent(),
                Value<String?> workDescription = const Value.absent(),
                Value<int> isSent = const Value.absent(),
                Value<String> invoiceType = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                invoiceNumber: invoiceNumber,
                invoiceDate: invoiceDate,
                clientId: clientId,
                projectId: projectId,
                projectAddress: projectAddress,
                labourSubtotal: labourSubtotal,
                materialsSubtotal: materialsSubtotal,
                materialsPickupCost: materialsPickupCost,
                otherCosts: otherCosts,
                otherCostsDescription: otherCostsDescription,
                discountAmount: discountAmount,
                discountDescription: discountDescription,
                discountPercent: discountPercent,
                tax1Name: tax1Name,
                tax1Rate: tax1Rate,
                tax1Amount: tax1Amount,
                tax1RegistrationNumber: tax1RegistrationNumber,
                tax2Name: tax2Name,
                tax2Rate: tax2Rate,
                tax2Amount: tax2Amount,
                tax2RegistrationNumber: tax2RegistrationNumber,
                subtotal: subtotal,
                totalAmount: totalAmount,
                terms: terms,
                poNumber: poNumber,
                isDeleted: isDeleted,
                deletedReasonCode: deletedReasonCode,
                deletedDate: deletedDate,
                deletedNotes: deletedNotes,
                supersededByInvoiceId: supersededByInvoiceId,
                notes: notes,
                internalNotes: internalNotes,
                workDescription: workDescription,
                isSent: isSent,
                invoiceType: invoiceType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String invoiceNumber,
                required String invoiceDate,
                required int clientId,
                required int projectId,
                Value<String?> projectAddress = const Value.absent(),
                Value<int> labourSubtotal = const Value.absent(),
                Value<int> materialsSubtotal = const Value.absent(),
                Value<int> materialsPickupCost = const Value.absent(),
                Value<int> otherCosts = const Value.absent(),
                Value<String?> otherCostsDescription = const Value.absent(),
                Value<int> discountAmount = const Value.absent(),
                Value<String?> discountDescription = const Value.absent(),
                Value<double> discountPercent = const Value.absent(),
                Value<String?> tax1Name = const Value.absent(),
                Value<double?> tax1Rate = const Value.absent(),
                Value<int> tax1Amount = const Value.absent(),
                Value<String?> tax1RegistrationNumber = const Value.absent(),
                Value<String?> tax2Name = const Value.absent(),
                Value<double?> tax2Rate = const Value.absent(),
                Value<int> tax2Amount = const Value.absent(),
                Value<String?> tax2RegistrationNumber = const Value.absent(),
                Value<int> subtotal = const Value.absent(),
                Value<int> totalAmount = const Value.absent(),
                Value<String> terms = const Value.absent(),
                Value<String?> poNumber = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<String?> deletedReasonCode = const Value.absent(),
                Value<String?> deletedDate = const Value.absent(),
                Value<String?> deletedNotes = const Value.absent(),
                Value<int?> supersededByInvoiceId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> internalNotes = const Value.absent(),
                Value<String?> workDescription = const Value.absent(),
                Value<int> isSent = const Value.absent(),
                Value<String> invoiceType = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                invoiceNumber: invoiceNumber,
                invoiceDate: invoiceDate,
                clientId: clientId,
                projectId: projectId,
                projectAddress: projectAddress,
                labourSubtotal: labourSubtotal,
                materialsSubtotal: materialsSubtotal,
                materialsPickupCost: materialsPickupCost,
                otherCosts: otherCosts,
                otherCostsDescription: otherCostsDescription,
                discountAmount: discountAmount,
                discountDescription: discountDescription,
                discountPercent: discountPercent,
                tax1Name: tax1Name,
                tax1Rate: tax1Rate,
                tax1Amount: tax1Amount,
                tax1RegistrationNumber: tax1RegistrationNumber,
                tax2Name: tax2Name,
                tax2Rate: tax2Rate,
                tax2Amount: tax2Amount,
                tax2RegistrationNumber: tax2RegistrationNumber,
                subtotal: subtotal,
                totalAmount: totalAmount,
                terms: terms,
                poNumber: poNumber,
                isDeleted: isDeleted,
                deletedReasonCode: deletedReasonCode,
                deletedDate: deletedDate,
                deletedNotes: deletedNotes,
                supersededByInvoiceId: supersededByInvoiceId,
                notes: notes,
                internalNotes: internalNotes,
                workDescription: workDescription,
                isSent: isSent,
                invoiceType: invoiceType,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clientId = false,
                projectId = false,
                supersededByInvoiceId = false,
                invoicePaymentsRefs = false,
                timeEntriesRefs = false,
                materialsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoicePaymentsRefs) db.invoicePayments,
                    if (timeEntriesRefs) db.timeEntries,
                    if (materialsRefs) db.materials,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (clientId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.clientId,
                                    referencedTable: $$InvoicesTableReferences
                                        ._clientIdTable(db),
                                    referencedColumn: $$InvoicesTableReferences
                                        ._clientIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable: $$InvoicesTableReferences
                                        ._projectIdTable(db),
                                    referencedColumn: $$InvoicesTableReferences
                                        ._projectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (supersededByInvoiceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.supersededByInvoiceId,
                                    referencedTable: $$InvoicesTableReferences
                                        ._supersededByInvoiceIdTable(db),
                                    referencedColumn: $$InvoicesTableReferences
                                        ._supersededByInvoiceIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoicePaymentsRefs)
                        await $_getPrefetchedData<
                          DbInvoice,
                          $InvoicesTable,
                          DbInvoicePayment
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._invoicePaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).invoicePaymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (timeEntriesRefs)
                        await $_getPrefetchedData<
                          DbInvoice,
                          $InvoicesTable,
                          DbTimeEntry
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._timeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).timeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (materialsRefs)
                        await $_getPrefetchedData<
                          DbInvoice,
                          $InvoicesTable,
                          DbMaterial
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._materialsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).materialsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTable,
      DbInvoice,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (DbInvoice, $$InvoicesTableReferences),
      DbInvoice,
      PrefetchHooks Function({
        bool clientId,
        bool projectId,
        bool supersededByInvoiceId,
        bool invoicePaymentsRefs,
        bool timeEntriesRefs,
        bool materialsRefs,
      })
    >;
typedef $$InvoicePaymentsTableCreateCompanionBuilder =
    InvoicePaymentsCompanion Function({
      Value<int> id,
      required int invoiceId,
      required int amount,
      required String paymentDate,
      Value<String?> paymentMethod,
      Value<String?> paymentReference,
      Value<String?> paymentNotes,
      Value<int> isVoid,
      Value<String?> voidReasonCode,
      Value<String?> voidDate,
      Value<String?> voidNotes,
      required String createdAt,
    });
typedef $$InvoicePaymentsTableUpdateCompanionBuilder =
    InvoicePaymentsCompanion Function({
      Value<int> id,
      Value<int> invoiceId,
      Value<int> amount,
      Value<String> paymentDate,
      Value<String?> paymentMethod,
      Value<String?> paymentReference,
      Value<String?> paymentNotes,
      Value<int> isVoid,
      Value<String?> voidReasonCode,
      Value<String?> voidDate,
      Value<String?> voidNotes,
      Value<String> createdAt,
    });

final class $$InvoicePaymentsTableReferences
    extends
        BaseReferences<_$AppDatabase, $InvoicePaymentsTable, DbInvoicePayment> {
  $$InvoicePaymentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias(
        $_aliasNameGenerator(db.invoicePayments.invoiceId, db.invoices.id),
      );

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<int>('invoice_id')!;

    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InvoicePaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicePaymentsTable> {
  $$InvoicePaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentReference => $composableBuilder(
    column: $table.paymentReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentNotes => $composableBuilder(
    column: $table.paymentNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isVoid => $composableBuilder(
    column: $table.isVoid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voidReasonCode => $composableBuilder(
    column: $table.voidReasonCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voidDate => $composableBuilder(
    column: $table.voidDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voidNotes => $composableBuilder(
    column: $table.voidNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicePaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicePaymentsTable> {
  $$InvoicePaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentReference => $composableBuilder(
    column: $table.paymentReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentNotes => $composableBuilder(
    column: $table.paymentNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isVoid => $composableBuilder(
    column: $table.isVoid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voidReasonCode => $composableBuilder(
    column: $table.voidReasonCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voidDate => $composableBuilder(
    column: $table.voidDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voidNotes => $composableBuilder(
    column: $table.voidNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicePaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicePaymentsTable> {
  $$InvoicePaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentReference => $composableBuilder(
    column: $table.paymentReference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentNotes => $composableBuilder(
    column: $table.paymentNotes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isVoid =>
      $composableBuilder(column: $table.isVoid, builder: (column) => column);

  GeneratedColumn<String> get voidReasonCode => $composableBuilder(
    column: $table.voidReasonCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get voidDate =>
      $composableBuilder(column: $table.voidDate, builder: (column) => column);

  GeneratedColumn<String> get voidNotes =>
      $composableBuilder(column: $table.voidNotes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicePaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicePaymentsTable,
          DbInvoicePayment,
          $$InvoicePaymentsTableFilterComposer,
          $$InvoicePaymentsTableOrderingComposer,
          $$InvoicePaymentsTableAnnotationComposer,
          $$InvoicePaymentsTableCreateCompanionBuilder,
          $$InvoicePaymentsTableUpdateCompanionBuilder,
          (DbInvoicePayment, $$InvoicePaymentsTableReferences),
          DbInvoicePayment,
          PrefetchHooks Function({bool invoiceId})
        > {
  $$InvoicePaymentsTableTableManager(
    _$AppDatabase db,
    $InvoicePaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicePaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicePaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicePaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> invoiceId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> paymentDate = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> paymentReference = const Value.absent(),
                Value<String?> paymentNotes = const Value.absent(),
                Value<int> isVoid = const Value.absent(),
                Value<String?> voidReasonCode = const Value.absent(),
                Value<String?> voidDate = const Value.absent(),
                Value<String?> voidNotes = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => InvoicePaymentsCompanion(
                id: id,
                invoiceId: invoiceId,
                amount: amount,
                paymentDate: paymentDate,
                paymentMethod: paymentMethod,
                paymentReference: paymentReference,
                paymentNotes: paymentNotes,
                isVoid: isVoid,
                voidReasonCode: voidReasonCode,
                voidDate: voidDate,
                voidNotes: voidNotes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int invoiceId,
                required int amount,
                required String paymentDate,
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> paymentReference = const Value.absent(),
                Value<String?> paymentNotes = const Value.absent(),
                Value<int> isVoid = const Value.absent(),
                Value<String?> voidReasonCode = const Value.absent(),
                Value<String?> voidDate = const Value.absent(),
                Value<String?> voidNotes = const Value.absent(),
                required String createdAt,
              }) => InvoicePaymentsCompanion.insert(
                id: id,
                invoiceId: invoiceId,
                amount: amount,
                paymentDate: paymentDate,
                paymentMethod: paymentMethod,
                paymentReference: paymentReference,
                paymentNotes: paymentNotes,
                isVoid: isVoid,
                voidReasonCode: voidReasonCode,
                voidDate: voidDate,
                voidNotes: voidNotes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoicePaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({invoiceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (invoiceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.invoiceId,
                                referencedTable:
                                    $$InvoicePaymentsTableReferences
                                        ._invoiceIdTable(db),
                                referencedColumn:
                                    $$InvoicePaymentsTableReferences
                                        ._invoiceIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InvoicePaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicePaymentsTable,
      DbInvoicePayment,
      $$InvoicePaymentsTableFilterComposer,
      $$InvoicePaymentsTableOrderingComposer,
      $$InvoicePaymentsTableAnnotationComposer,
      $$InvoicePaymentsTableCreateCompanionBuilder,
      $$InvoicePaymentsTableUpdateCompanionBuilder,
      (DbInvoicePayment, $$InvoicePaymentsTableReferences),
      DbInvoicePayment,
      PrefetchHooks Function({bool invoiceId})
    >;
typedef $$TimeEntriesTableCreateCompanionBuilder =
    TimeEntriesCompanion Function({
      Value<int> id,
      required int projectId,
      Value<int?> employeeId,
      required String startTime,
      Value<String?> endTime,
      Value<double> pausedDuration,
      Value<double?> finalBilledDurationSeconds,
      Value<int?> hourlyRate,
      Value<int> isPaused,
      Value<String?> pauseStartTime,
      Value<int> isDeleted,
      Value<String?> workDetails,
      Value<int?> costCodeId,
      Value<int> isBilled,
      Value<int?> invoiceId,
    });
typedef $$TimeEntriesTableUpdateCompanionBuilder =
    TimeEntriesCompanion Function({
      Value<int> id,
      Value<int> projectId,
      Value<int?> employeeId,
      Value<String> startTime,
      Value<String?> endTime,
      Value<double> pausedDuration,
      Value<double?> finalBilledDurationSeconds,
      Value<int?> hourlyRate,
      Value<int> isPaused,
      Value<String?> pauseStartTime,
      Value<int> isDeleted,
      Value<String?> workDetails,
      Value<int?> costCodeId,
      Value<int> isBilled,
      Value<int?> invoiceId,
    });

final class $$TimeEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $TimeEntriesTable, DbTimeEntry> {
  $$TimeEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.timeEntries.projectId, db.projects.id),
      );

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.timeEntries.employeeId, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager? get employeeId {
    final $_column = $_itemColumn<int>('employee_id');
    if ($_column == null) return null;
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CostCodesTable _costCodeIdTable(_$AppDatabase db) =>
      db.costCodes.createAlias(
        $_aliasNameGenerator(db.timeEntries.costCodeId, db.costCodes.id),
      );

  $$CostCodesTableProcessedTableManager? get costCodeId {
    final $_column = $_itemColumn<int>('cost_code_id');
    if ($_column == null) return null;
    final manager = $$CostCodesTableTableManager(
      $_db,
      $_db.costCodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_costCodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias(
        $_aliasNameGenerator(db.timeEntries.invoiceId, db.invoices.id),
      );

  $$InvoicesTableProcessedTableManager? get invoiceId {
    final $_column = $_itemColumn<int>('invoice_id');
    if ($_column == null) return null;
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TimeEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pausedDuration => $composableBuilder(
    column: $table.pausedDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get finalBilledDurationSeconds => $composableBuilder(
    column: $table.finalBilledDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pauseStartTime => $composableBuilder(
    column: $table.pauseStartTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workDetails => $composableBuilder(
    column: $table.workDetails,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isBilled => $composableBuilder(
    column: $table.isBilled,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CostCodesTableFilterComposer get costCodeId {
    final $$CostCodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.costCodeId,
      referencedTable: $db.costCodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CostCodesTableFilterComposer(
            $db: $db,
            $table: $db.costCodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pausedDuration => $composableBuilder(
    column: $table.pausedDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get finalBilledDurationSeconds => $composableBuilder(
    column: $table.finalBilledDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pauseStartTime => $composableBuilder(
    column: $table.pauseStartTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workDetails => $composableBuilder(
    column: $table.workDetails,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isBilled => $composableBuilder(
    column: $table.isBilled,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CostCodesTableOrderingComposer get costCodeId {
    final $$CostCodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.costCodeId,
      referencedTable: $db.costCodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CostCodesTableOrderingComposer(
            $db: $db,
            $table: $db.costCodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<double> get pausedDuration => $composableBuilder(
    column: $table.pausedDuration,
    builder: (column) => column,
  );

  GeneratedColumn<double> get finalBilledDurationSeconds => $composableBuilder(
    column: $table.finalBilledDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isPaused =>
      $composableBuilder(column: $table.isPaused, builder: (column) => column);

  GeneratedColumn<String> get pauseStartTime => $composableBuilder(
    column: $table.pauseStartTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get workDetails => $composableBuilder(
    column: $table.workDetails,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isBilled =>
      $composableBuilder(column: $table.isBilled, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CostCodesTableAnnotationComposer get costCodeId {
    final $$CostCodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.costCodeId,
      referencedTable: $db.costCodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CostCodesTableAnnotationComposer(
            $db: $db,
            $table: $db.costCodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimeEntriesTable,
          DbTimeEntry,
          $$TimeEntriesTableFilterComposer,
          $$TimeEntriesTableOrderingComposer,
          $$TimeEntriesTableAnnotationComposer,
          $$TimeEntriesTableCreateCompanionBuilder,
          $$TimeEntriesTableUpdateCompanionBuilder,
          (DbTimeEntry, $$TimeEntriesTableReferences),
          DbTimeEntry,
          PrefetchHooks Function({
            bool projectId,
            bool employeeId,
            bool costCodeId,
            bool invoiceId,
          })
        > {
  $$TimeEntriesTableTableManager(_$AppDatabase db, $TimeEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimeEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimeEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimeEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<int?> employeeId = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<double> pausedDuration = const Value.absent(),
                Value<double?> finalBilledDurationSeconds =
                    const Value.absent(),
                Value<int?> hourlyRate = const Value.absent(),
                Value<int> isPaused = const Value.absent(),
                Value<String?> pauseStartTime = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<String?> workDetails = const Value.absent(),
                Value<int?> costCodeId = const Value.absent(),
                Value<int> isBilled = const Value.absent(),
                Value<int?> invoiceId = const Value.absent(),
              }) => TimeEntriesCompanion(
                id: id,
                projectId: projectId,
                employeeId: employeeId,
                startTime: startTime,
                endTime: endTime,
                pausedDuration: pausedDuration,
                finalBilledDurationSeconds: finalBilledDurationSeconds,
                hourlyRate: hourlyRate,
                isPaused: isPaused,
                pauseStartTime: pauseStartTime,
                isDeleted: isDeleted,
                workDetails: workDetails,
                costCodeId: costCodeId,
                isBilled: isBilled,
                invoiceId: invoiceId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                Value<int?> employeeId = const Value.absent(),
                required String startTime,
                Value<String?> endTime = const Value.absent(),
                Value<double> pausedDuration = const Value.absent(),
                Value<double?> finalBilledDurationSeconds =
                    const Value.absent(),
                Value<int?> hourlyRate = const Value.absent(),
                Value<int> isPaused = const Value.absent(),
                Value<String?> pauseStartTime = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<String?> workDetails = const Value.absent(),
                Value<int?> costCodeId = const Value.absent(),
                Value<int> isBilled = const Value.absent(),
                Value<int?> invoiceId = const Value.absent(),
              }) => TimeEntriesCompanion.insert(
                id: id,
                projectId: projectId,
                employeeId: employeeId,
                startTime: startTime,
                endTime: endTime,
                pausedDuration: pausedDuration,
                finalBilledDurationSeconds: finalBilledDurationSeconds,
                hourlyRate: hourlyRate,
                isPaused: isPaused,
                pauseStartTime: pauseStartTime,
                isDeleted: isDeleted,
                workDetails: workDetails,
                costCodeId: costCodeId,
                isBilled: isBilled,
                invoiceId: invoiceId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimeEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                projectId = false,
                employeeId = false,
                costCodeId = false,
                invoiceId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable:
                                        $$TimeEntriesTableReferences
                                            ._projectIdTable(db),
                                    referencedColumn:
                                        $$TimeEntriesTableReferences
                                            ._projectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (employeeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.employeeId,
                                    referencedTable:
                                        $$TimeEntriesTableReferences
                                            ._employeeIdTable(db),
                                    referencedColumn:
                                        $$TimeEntriesTableReferences
                                            ._employeeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (costCodeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.costCodeId,
                                    referencedTable:
                                        $$TimeEntriesTableReferences
                                            ._costCodeIdTable(db),
                                    referencedColumn:
                                        $$TimeEntriesTableReferences
                                            ._costCodeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (invoiceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.invoiceId,
                                    referencedTable:
                                        $$TimeEntriesTableReferences
                                            ._invoiceIdTable(db),
                                    referencedColumn:
                                        $$TimeEntriesTableReferences
                                            ._invoiceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TimeEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimeEntriesTable,
      DbTimeEntry,
      $$TimeEntriesTableFilterComposer,
      $$TimeEntriesTableOrderingComposer,
      $$TimeEntriesTableAnnotationComposer,
      $$TimeEntriesTableCreateCompanionBuilder,
      $$TimeEntriesTableUpdateCompanionBuilder,
      (DbTimeEntry, $$TimeEntriesTableReferences),
      DbTimeEntry,
      PrefetchHooks Function({
        bool projectId,
        bool employeeId,
        bool costCodeId,
        bool invoiceId,
      })
    >;
typedef $$MaterialsTableCreateCompanionBuilder =
    MaterialsCompanion Function({
      Value<int> id,
      required int projectId,
      required String itemName,
      required int cost,
      Value<String?> purchaseDate,
      Value<String?> description,
      Value<int> isDeleted,
      Value<String?> expenseCategory,
      Value<String?> unit,
      Value<double?> quantity,
      Value<double?> baseQuantity,
      Value<double?> odometerReading,
      Value<int> isCompanyExpense,
      Value<String?> vehicleDesignation,
      Value<String?> vendorOrSubtrade,
      Value<int?> costCodeId,
      Value<int> isBilled,
      Value<int?> invoiceId,
    });
typedef $$MaterialsTableUpdateCompanionBuilder =
    MaterialsCompanion Function({
      Value<int> id,
      Value<int> projectId,
      Value<String> itemName,
      Value<int> cost,
      Value<String?> purchaseDate,
      Value<String?> description,
      Value<int> isDeleted,
      Value<String?> expenseCategory,
      Value<String?> unit,
      Value<double?> quantity,
      Value<double?> baseQuantity,
      Value<double?> odometerReading,
      Value<int> isCompanyExpense,
      Value<String?> vehicleDesignation,
      Value<String?> vendorOrSubtrade,
      Value<int?> costCodeId,
      Value<int> isBilled,
      Value<int?> invoiceId,
    });

final class $$MaterialsTableReferences
    extends BaseReferences<_$AppDatabase, $MaterialsTable, DbMaterial> {
  $$MaterialsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.materials.projectId, db.projects.id),
      );

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CostCodesTable _costCodeIdTable(_$AppDatabase db) =>
      db.costCodes.createAlias(
        $_aliasNameGenerator(db.materials.costCodeId, db.costCodes.id),
      );

  $$CostCodesTableProcessedTableManager? get costCodeId {
    final $_column = $_itemColumn<int>('cost_code_id');
    if ($_column == null) return null;
    final manager = $$CostCodesTableTableManager(
      $_db,
      $_db.costCodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_costCodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias(
        $_aliasNameGenerator(db.materials.invoiceId, db.invoices.id),
      );

  $$InvoicesTableProcessedTableManager? get invoiceId {
    final $_column = $_itemColumn<int>('invoice_id');
    if ($_column == null) return null;
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MaterialsTableFilterComposer
    extends Composer<_$AppDatabase, $MaterialsTable> {
  $$MaterialsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expenseCategory => $composableBuilder(
    column: $table.expenseCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get baseQuantity => $composableBuilder(
    column: $table.baseQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get odometerReading => $composableBuilder(
    column: $table.odometerReading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isCompanyExpense => $composableBuilder(
    column: $table.isCompanyExpense,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleDesignation => $composableBuilder(
    column: $table.vehicleDesignation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vendorOrSubtrade => $composableBuilder(
    column: $table.vendorOrSubtrade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isBilled => $composableBuilder(
    column: $table.isBilled,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CostCodesTableFilterComposer get costCodeId {
    final $$CostCodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.costCodeId,
      referencedTable: $db.costCodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CostCodesTableFilterComposer(
            $db: $db,
            $table: $db.costCodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaterialsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaterialsTable> {
  $$MaterialsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expenseCategory => $composableBuilder(
    column: $table.expenseCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get baseQuantity => $composableBuilder(
    column: $table.baseQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get odometerReading => $composableBuilder(
    column: $table.odometerReading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isCompanyExpense => $composableBuilder(
    column: $table.isCompanyExpense,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleDesignation => $composableBuilder(
    column: $table.vehicleDesignation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vendorOrSubtrade => $composableBuilder(
    column: $table.vendorOrSubtrade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isBilled => $composableBuilder(
    column: $table.isBilled,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CostCodesTableOrderingComposer get costCodeId {
    final $$CostCodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.costCodeId,
      referencedTable: $db.costCodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CostCodesTableOrderingComposer(
            $db: $db,
            $table: $db.costCodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaterialsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaterialsTable> {
  $$MaterialsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<String> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get expenseCategory => $composableBuilder(
    column: $table.expenseCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get baseQuantity => $composableBuilder(
    column: $table.baseQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get odometerReading => $composableBuilder(
    column: $table.odometerReading,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isCompanyExpense => $composableBuilder(
    column: $table.isCompanyExpense,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehicleDesignation => $composableBuilder(
    column: $table.vehicleDesignation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vendorOrSubtrade => $composableBuilder(
    column: $table.vendorOrSubtrade,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isBilled =>
      $composableBuilder(column: $table.isBilled, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CostCodesTableAnnotationComposer get costCodeId {
    final $$CostCodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.costCodeId,
      referencedTable: $db.costCodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CostCodesTableAnnotationComposer(
            $db: $db,
            $table: $db.costCodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaterialsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaterialsTable,
          DbMaterial,
          $$MaterialsTableFilterComposer,
          $$MaterialsTableOrderingComposer,
          $$MaterialsTableAnnotationComposer,
          $$MaterialsTableCreateCompanionBuilder,
          $$MaterialsTableUpdateCompanionBuilder,
          (DbMaterial, $$MaterialsTableReferences),
          DbMaterial,
          PrefetchHooks Function({
            bool projectId,
            bool costCodeId,
            bool invoiceId,
          })
        > {
  $$MaterialsTableTableManager(_$AppDatabase db, $MaterialsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaterialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaterialsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaterialsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<String> itemName = const Value.absent(),
                Value<int> cost = const Value.absent(),
                Value<String?> purchaseDate = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<String?> expenseCategory = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<double?> quantity = const Value.absent(),
                Value<double?> baseQuantity = const Value.absent(),
                Value<double?> odometerReading = const Value.absent(),
                Value<int> isCompanyExpense = const Value.absent(),
                Value<String?> vehicleDesignation = const Value.absent(),
                Value<String?> vendorOrSubtrade = const Value.absent(),
                Value<int?> costCodeId = const Value.absent(),
                Value<int> isBilled = const Value.absent(),
                Value<int?> invoiceId = const Value.absent(),
              }) => MaterialsCompanion(
                id: id,
                projectId: projectId,
                itemName: itemName,
                cost: cost,
                purchaseDate: purchaseDate,
                description: description,
                isDeleted: isDeleted,
                expenseCategory: expenseCategory,
                unit: unit,
                quantity: quantity,
                baseQuantity: baseQuantity,
                odometerReading: odometerReading,
                isCompanyExpense: isCompanyExpense,
                vehicleDesignation: vehicleDesignation,
                vendorOrSubtrade: vendorOrSubtrade,
                costCodeId: costCodeId,
                isBilled: isBilled,
                invoiceId: invoiceId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                required String itemName,
                required int cost,
                Value<String?> purchaseDate = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<String?> expenseCategory = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<double?> quantity = const Value.absent(),
                Value<double?> baseQuantity = const Value.absent(),
                Value<double?> odometerReading = const Value.absent(),
                Value<int> isCompanyExpense = const Value.absent(),
                Value<String?> vehicleDesignation = const Value.absent(),
                Value<String?> vendorOrSubtrade = const Value.absent(),
                Value<int?> costCodeId = const Value.absent(),
                Value<int> isBilled = const Value.absent(),
                Value<int?> invoiceId = const Value.absent(),
              }) => MaterialsCompanion.insert(
                id: id,
                projectId: projectId,
                itemName: itemName,
                cost: cost,
                purchaseDate: purchaseDate,
                description: description,
                isDeleted: isDeleted,
                expenseCategory: expenseCategory,
                unit: unit,
                quantity: quantity,
                baseQuantity: baseQuantity,
                odometerReading: odometerReading,
                isCompanyExpense: isCompanyExpense,
                vehicleDesignation: vehicleDesignation,
                vendorOrSubtrade: vendorOrSubtrade,
                costCodeId: costCodeId,
                isBilled: isBilled,
                invoiceId: invoiceId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MaterialsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({projectId = false, costCodeId = false, invoiceId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable: $$MaterialsTableReferences
                                        ._projectIdTable(db),
                                    referencedColumn: $$MaterialsTableReferences
                                        ._projectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (costCodeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.costCodeId,
                                    referencedTable: $$MaterialsTableReferences
                                        ._costCodeIdTable(db),
                                    referencedColumn: $$MaterialsTableReferences
                                        ._costCodeIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (invoiceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.invoiceId,
                                    referencedTable: $$MaterialsTableReferences
                                        ._invoiceIdTable(db),
                                    referencedColumn: $$MaterialsTableReferences
                                        ._invoiceIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$MaterialsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaterialsTable,
      DbMaterial,
      $$MaterialsTableFilterComposer,
      $$MaterialsTableOrderingComposer,
      $$MaterialsTableAnnotationComposer,
      $$MaterialsTableCreateCompanionBuilder,
      $$MaterialsTableUpdateCompanionBuilder,
      (DbMaterial, $$MaterialsTableReferences),
      DbMaterial,
      PrefetchHooks Function({bool projectId, bool costCodeId, bool invoiceId})
    >;
typedef $$CompanySettingsTableTableCreateCompanionBuilder =
    CompanySettingsTableCompanion Function({
      Value<int> id,
      Value<String?> companyName,
      Value<String?> companyAddress,
      Value<String?> companyCity,
      Value<String?> companyProvince,
      Value<String?> companyPostalCode,
      Value<String?> companyPhone,
      Value<String?> companyEmail,
      Value<String> defaultTax1Name,
      Value<double> defaultTax1Rate,
      Value<String?> defaultTax1RegistrationNumber,
      Value<String?> defaultTax2Name,
      Value<double?> defaultTax2Rate,
      Value<String?> defaultTax2RegistrationNumber,
      Value<String> defaultTerms,
      Value<double> taxRate,
      Value<String> postalCodeLabel,
      Value<String> regionLabel,
      Value<String> country,
      Value<String> invoicePrefix,
      Value<int> invoiceStartingNumber,
      Value<String?> paymentEtransferEmail,
    });
typedef $$CompanySettingsTableTableUpdateCompanionBuilder =
    CompanySettingsTableCompanion Function({
      Value<int> id,
      Value<String?> companyName,
      Value<String?> companyAddress,
      Value<String?> companyCity,
      Value<String?> companyProvince,
      Value<String?> companyPostalCode,
      Value<String?> companyPhone,
      Value<String?> companyEmail,
      Value<String> defaultTax1Name,
      Value<double> defaultTax1Rate,
      Value<String?> defaultTax1RegistrationNumber,
      Value<String?> defaultTax2Name,
      Value<double?> defaultTax2Rate,
      Value<String?> defaultTax2RegistrationNumber,
      Value<String> defaultTerms,
      Value<double> taxRate,
      Value<String> postalCodeLabel,
      Value<String> regionLabel,
      Value<String> country,
      Value<String> invoicePrefix,
      Value<int> invoiceStartingNumber,
      Value<String?> paymentEtransferEmail,
    });

class $$CompanySettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CompanySettingsTableTable> {
  $$CompanySettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyAddress => $composableBuilder(
    column: $table.companyAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyCity => $composableBuilder(
    column: $table.companyCity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyProvince => $composableBuilder(
    column: $table.companyProvince,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyPostalCode => $composableBuilder(
    column: $table.companyPostalCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyPhone => $composableBuilder(
    column: $table.companyPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyEmail => $composableBuilder(
    column: $table.companyEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultTax1Name => $composableBuilder(
    column: $table.defaultTax1Name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultTax1Rate => $composableBuilder(
    column: $table.defaultTax1Rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultTax1RegistrationNumber => $composableBuilder(
    column: $table.defaultTax1RegistrationNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultTax2Name => $composableBuilder(
    column: $table.defaultTax2Name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultTax2Rate => $composableBuilder(
    column: $table.defaultTax2Rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultTax2RegistrationNumber => $composableBuilder(
    column: $table.defaultTax2RegistrationNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultTerms => $composableBuilder(
    column: $table.defaultTerms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postalCodeLabel => $composableBuilder(
    column: $table.postalCodeLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regionLabel => $composableBuilder(
    column: $table.regionLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get invoiceStartingNumber => $composableBuilder(
    column: $table.invoiceStartingNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentEtransferEmail => $composableBuilder(
    column: $table.paymentEtransferEmail,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CompanySettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CompanySettingsTableTable> {
  $$CompanySettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyAddress => $composableBuilder(
    column: $table.companyAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyCity => $composableBuilder(
    column: $table.companyCity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyProvince => $composableBuilder(
    column: $table.companyProvince,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyPostalCode => $composableBuilder(
    column: $table.companyPostalCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyPhone => $composableBuilder(
    column: $table.companyPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyEmail => $composableBuilder(
    column: $table.companyEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultTax1Name => $composableBuilder(
    column: $table.defaultTax1Name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultTax1Rate => $composableBuilder(
    column: $table.defaultTax1Rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultTax1RegistrationNumber =>
      $composableBuilder(
        column: $table.defaultTax1RegistrationNumber,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get defaultTax2Name => $composableBuilder(
    column: $table.defaultTax2Name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultTax2Rate => $composableBuilder(
    column: $table.defaultTax2Rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultTax2RegistrationNumber =>
      $composableBuilder(
        column: $table.defaultTax2RegistrationNumber,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get defaultTerms => $composableBuilder(
    column: $table.defaultTerms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postalCodeLabel => $composableBuilder(
    column: $table.postalCodeLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regionLabel => $composableBuilder(
    column: $table.regionLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get invoiceStartingNumber => $composableBuilder(
    column: $table.invoiceStartingNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentEtransferEmail => $composableBuilder(
    column: $table.paymentEtransferEmail,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompanySettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompanySettingsTableTable> {
  $$CompanySettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyAddress => $composableBuilder(
    column: $table.companyAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyCity => $composableBuilder(
    column: $table.companyCity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyProvince => $composableBuilder(
    column: $table.companyProvince,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyPostalCode => $composableBuilder(
    column: $table.companyPostalCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyPhone => $composableBuilder(
    column: $table.companyPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyEmail => $composableBuilder(
    column: $table.companyEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultTax1Name => $composableBuilder(
    column: $table.defaultTax1Name,
    builder: (column) => column,
  );

  GeneratedColumn<double> get defaultTax1Rate => $composableBuilder(
    column: $table.defaultTax1Rate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultTax1RegistrationNumber =>
      $composableBuilder(
        column: $table.defaultTax1RegistrationNumber,
        builder: (column) => column,
      );

  GeneratedColumn<String> get defaultTax2Name => $composableBuilder(
    column: $table.defaultTax2Name,
    builder: (column) => column,
  );

  GeneratedColumn<double> get defaultTax2Rate => $composableBuilder(
    column: $table.defaultTax2Rate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultTax2RegistrationNumber =>
      $composableBuilder(
        column: $table.defaultTax2RegistrationNumber,
        builder: (column) => column,
      );

  GeneratedColumn<String> get defaultTerms => $composableBuilder(
    column: $table.defaultTerms,
    builder: (column) => column,
  );

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<String> get postalCodeLabel => $composableBuilder(
    column: $table.postalCodeLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get regionLabel => $composableBuilder(
    column: $table.regionLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => column,
  );

  GeneratedColumn<int> get invoiceStartingNumber => $composableBuilder(
    column: $table.invoiceStartingNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentEtransferEmail => $composableBuilder(
    column: $table.paymentEtransferEmail,
    builder: (column) => column,
  );
}

class $$CompanySettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompanySettingsTableTable,
          DbCompanySetting,
          $$CompanySettingsTableTableFilterComposer,
          $$CompanySettingsTableTableOrderingComposer,
          $$CompanySettingsTableTableAnnotationComposer,
          $$CompanySettingsTableTableCreateCompanionBuilder,
          $$CompanySettingsTableTableUpdateCompanionBuilder,
          (
            DbCompanySetting,
            BaseReferences<
              _$AppDatabase,
              $CompanySettingsTableTable,
              DbCompanySetting
            >,
          ),
          DbCompanySetting,
          PrefetchHooks Function()
        > {
  $$CompanySettingsTableTableTableManager(
    _$AppDatabase db,
    $CompanySettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompanySettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompanySettingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CompanySettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> companyName = const Value.absent(),
                Value<String?> companyAddress = const Value.absent(),
                Value<String?> companyCity = const Value.absent(),
                Value<String?> companyProvince = const Value.absent(),
                Value<String?> companyPostalCode = const Value.absent(),
                Value<String?> companyPhone = const Value.absent(),
                Value<String?> companyEmail = const Value.absent(),
                Value<String> defaultTax1Name = const Value.absent(),
                Value<double> defaultTax1Rate = const Value.absent(),
                Value<String?> defaultTax1RegistrationNumber =
                    const Value.absent(),
                Value<String?> defaultTax2Name = const Value.absent(),
                Value<double?> defaultTax2Rate = const Value.absent(),
                Value<String?> defaultTax2RegistrationNumber =
                    const Value.absent(),
                Value<String> defaultTerms = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<String> postalCodeLabel = const Value.absent(),
                Value<String> regionLabel = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String> invoicePrefix = const Value.absent(),
                Value<int> invoiceStartingNumber = const Value.absent(),
                Value<String?> paymentEtransferEmail = const Value.absent(),
              }) => CompanySettingsTableCompanion(
                id: id,
                companyName: companyName,
                companyAddress: companyAddress,
                companyCity: companyCity,
                companyProvince: companyProvince,
                companyPostalCode: companyPostalCode,
                companyPhone: companyPhone,
                companyEmail: companyEmail,
                defaultTax1Name: defaultTax1Name,
                defaultTax1Rate: defaultTax1Rate,
                defaultTax1RegistrationNumber: defaultTax1RegistrationNumber,
                defaultTax2Name: defaultTax2Name,
                defaultTax2Rate: defaultTax2Rate,
                defaultTax2RegistrationNumber: defaultTax2RegistrationNumber,
                defaultTerms: defaultTerms,
                taxRate: taxRate,
                postalCodeLabel: postalCodeLabel,
                regionLabel: regionLabel,
                country: country,
                invoicePrefix: invoicePrefix,
                invoiceStartingNumber: invoiceStartingNumber,
                paymentEtransferEmail: paymentEtransferEmail,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> companyName = const Value.absent(),
                Value<String?> companyAddress = const Value.absent(),
                Value<String?> companyCity = const Value.absent(),
                Value<String?> companyProvince = const Value.absent(),
                Value<String?> companyPostalCode = const Value.absent(),
                Value<String?> companyPhone = const Value.absent(),
                Value<String?> companyEmail = const Value.absent(),
                Value<String> defaultTax1Name = const Value.absent(),
                Value<double> defaultTax1Rate = const Value.absent(),
                Value<String?> defaultTax1RegistrationNumber =
                    const Value.absent(),
                Value<String?> defaultTax2Name = const Value.absent(),
                Value<double?> defaultTax2Rate = const Value.absent(),
                Value<String?> defaultTax2RegistrationNumber =
                    const Value.absent(),
                Value<String> defaultTerms = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<String> postalCodeLabel = const Value.absent(),
                Value<String> regionLabel = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String> invoicePrefix = const Value.absent(),
                Value<int> invoiceStartingNumber = const Value.absent(),
                Value<String?> paymentEtransferEmail = const Value.absent(),
              }) => CompanySettingsTableCompanion.insert(
                id: id,
                companyName: companyName,
                companyAddress: companyAddress,
                companyCity: companyCity,
                companyProvince: companyProvince,
                companyPostalCode: companyPostalCode,
                companyPhone: companyPhone,
                companyEmail: companyEmail,
                defaultTax1Name: defaultTax1Name,
                defaultTax1Rate: defaultTax1Rate,
                defaultTax1RegistrationNumber: defaultTax1RegistrationNumber,
                defaultTax2Name: defaultTax2Name,
                defaultTax2Rate: defaultTax2Rate,
                defaultTax2RegistrationNumber: defaultTax2RegistrationNumber,
                defaultTerms: defaultTerms,
                taxRate: taxRate,
                postalCodeLabel: postalCodeLabel,
                regionLabel: regionLabel,
                country: country,
                invoicePrefix: invoicePrefix,
                invoiceStartingNumber: invoiceStartingNumber,
                paymentEtransferEmail: paymentEtransferEmail,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompanySettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompanySettingsTableTable,
      DbCompanySetting,
      $$CompanySettingsTableTableFilterComposer,
      $$CompanySettingsTableTableOrderingComposer,
      $$CompanySettingsTableTableAnnotationComposer,
      $$CompanySettingsTableTableCreateCompanionBuilder,
      $$CompanySettingsTableTableUpdateCompanionBuilder,
      (
        DbCompanySetting,
        BaseReferences<
          _$AppDatabase,
          $CompanySettingsTableTable,
          DbCompanySetting
        >,
      ),
      DbCompanySetting,
      PrefetchHooks Function()
    >;
typedef $$WorkerPaymentsTableCreateCompanionBuilder =
    WorkerPaymentsCompanion Function({
      Value<int> id,
      required int employeeId,
      required String paymentDate,
      required int amount,
      Value<String?> note,
      required String createdAt,
    });
typedef $$WorkerPaymentsTableUpdateCompanionBuilder =
    WorkerPaymentsCompanion Function({
      Value<int> id,
      Value<int> employeeId,
      Value<String> paymentDate,
      Value<int> amount,
      Value<String?> note,
      Value<String> createdAt,
    });

final class $$WorkerPaymentsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkerPaymentsTable, DbWorkerPayment> {
  $$WorkerPaymentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.workerPayments.employeeId, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkerPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkerPaymentsTable> {
  $$WorkerPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkerPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkerPaymentsTable> {
  $$WorkerPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkerPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkerPaymentsTable> {
  $$WorkerPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkerPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkerPaymentsTable,
          DbWorkerPayment,
          $$WorkerPaymentsTableFilterComposer,
          $$WorkerPaymentsTableOrderingComposer,
          $$WorkerPaymentsTableAnnotationComposer,
          $$WorkerPaymentsTableCreateCompanionBuilder,
          $$WorkerPaymentsTableUpdateCompanionBuilder,
          (DbWorkerPayment, $$WorkerPaymentsTableReferences),
          DbWorkerPayment,
          PrefetchHooks Function({bool employeeId})
        > {
  $$WorkerPaymentsTableTableManager(
    _$AppDatabase db,
    $WorkerPaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkerPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkerPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkerPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> employeeId = const Value.absent(),
                Value<String> paymentDate = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => WorkerPaymentsCompanion(
                id: id,
                employeeId: employeeId,
                paymentDate: paymentDate,
                amount: amount,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int employeeId,
                required String paymentDate,
                required int amount,
                Value<String?> note = const Value.absent(),
                required String createdAt,
              }) => WorkerPaymentsCompanion.insert(
                id: id,
                employeeId: employeeId,
                paymentDate: paymentDate,
                amount: amount,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkerPaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable: $$WorkerPaymentsTableReferences
                                    ._employeeIdTable(db),
                                referencedColumn:
                                    $$WorkerPaymentsTableReferences
                                        ._employeeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkerPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkerPaymentsTable,
      DbWorkerPayment,
      $$WorkerPaymentsTableFilterComposer,
      $$WorkerPaymentsTableOrderingComposer,
      $$WorkerPaymentsTableAnnotationComposer,
      $$WorkerPaymentsTableCreateCompanionBuilder,
      $$WorkerPaymentsTableUpdateCompanionBuilder,
      (DbWorkerPayment, $$WorkerPaymentsTableReferences),
      DbWorkerPayment,
      PrefetchHooks Function({bool employeeId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$RolesTableTableManager get roles =>
      $$RolesTableTableManager(_db, _db.roles);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db, _db.employees);
  $$CostCodesTableTableManager get costCodes =>
      $$CostCodesTableTableManager(_db, _db.costCodes);
  $$ExpenseCategoriesTableTableManager get expenseCategories =>
      $$ExpenseCategoriesTableTableManager(_db, _db.expenseCategories);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$InvoicePaymentsTableTableManager get invoicePayments =>
      $$InvoicePaymentsTableTableManager(_db, _db.invoicePayments);
  $$TimeEntriesTableTableManager get timeEntries =>
      $$TimeEntriesTableTableManager(_db, _db.timeEntries);
  $$MaterialsTableTableManager get materials =>
      $$MaterialsTableTableManager(_db, _db.materials);
  $$CompanySettingsTableTableTableManager get companySettingsTable =>
      $$CompanySettingsTableTableTableManager(_db, _db.companySettingsTable);
  $$WorkerPaymentsTableTableManager get workerPayments =>
      $$WorkerPaymentsTableTableManager(_db, _db.workerPayments);
}
