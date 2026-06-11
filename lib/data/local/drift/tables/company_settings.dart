import 'package:drift/drift.dart';

/// Company / tax / invoice profile (singleton row, id always == 1). The
/// explicit [tableName] keeps the table named `company_settings` (matching
/// v23) rather than the class-derived `company_settings_table`.
/// Row class: `DbCompanySetting`.
@DataClassName('DbCompanySetting')
class CompanySettingsTable extends Table {
  @override
  String get tableName => 'company_settings';

  IntColumn get id => integer()();
  TextColumn get companyName => text().nullable()();
  TextColumn get companyAddress => text().nullable()();
  TextColumn get companyCity => text().nullable()();
  TextColumn get companyProvince => text().nullable()();
  TextColumn get companyPostalCode => text().nullable()();
  TextColumn get companyPhone => text().nullable()();
  TextColumn get companyEmail => text().nullable()();
  TextColumn get defaultTax1Name =>
      text().withDefault(const Constant('GST'))();
  RealColumn get defaultTax1Rate =>
      real().withDefault(const Constant(0.05))();
  TextColumn get defaultTax1RegistrationNumber => text().nullable()();
  TextColumn get defaultTax2Name => text().nullable()();
  RealColumn get defaultTax2Rate => real().nullable()();
  TextColumn get defaultTax2RegistrationNumber => text().nullable()();
  TextColumn get defaultTerms =>
      text().withDefault(const Constant('Payable on Receipt'))();
  RealColumn get taxRate => real().withDefault(const Constant(5.0))();
  TextColumn get postalCodeLabel =>
      text().withDefault(const Constant('Postal Code'))();
  TextColumn get regionLabel =>
      text().withDefault(const Constant('Province'))();
  TextColumn get country => text().withDefault(const Constant('Canada'))();
  TextColumn get invoicePrefix =>
      text().withDefault(const Constant('INV'))();
  IntColumn get invoiceStartingNumber =>
      integer().withDefault(const Constant(1))();
  TextColumn get paymentEtransferEmail => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
