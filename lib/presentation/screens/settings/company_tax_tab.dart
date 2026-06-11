import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/drift/app_database.dart';
import '../../providers/database_provider.dart';

/// "Company & Tax" tab. Owns the entire `company_settings` table: company
/// profile, regional labels, primary/secondary tax, invoice terms & settings.
///
/// Tax rates are stored as fractions (e.g. 0.05) but edited as percentages
/// (5.0), matching the original app — converted on load and save.
class CompanyTaxTab extends ConsumerStatefulWidget {
  const CompanyTaxTab({super.key});

  @override
  ConsumerState<CompanyTaxTab> createState() => _CompanyTaxTabState();
}

class _CompanyTaxTabState extends ConsumerState<CompanyTaxTab> {
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  final companyCityController = TextEditingController();
  final companyProvinceController = TextEditingController();
  final companyPostalCodeController = TextEditingController();
  final companyPhoneController = TextEditingController();
  final companyEmailController = TextEditingController();
  final tax1NameController = TextEditingController();
  final tax1RateController = TextEditingController();
  final tax1RegController = TextEditingController();
  final tax2NameController = TextEditingController();
  final tax2RateController = TextEditingController();
  final tax2RegController = TextEditingController();
  final termsController = TextEditingController();
  final countryController = TextEditingController();
  final regionLabelController = TextEditingController();
  final postalCodeLabelController = TextEditingController();
  final invoicePrefixController = TextEditingController();
  final invoiceStartingNumberController = TextEditingController();
  final paymentEtransferEmailController = TextEditingController();

  bool _loading = true;

  AppDatabase get _db => ref.read(databaseProvider);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    companyNameController.dispose();
    companyAddressController.dispose();
    companyCityController.dispose();
    companyProvinceController.dispose();
    companyPostalCodeController.dispose();
    companyPhoneController.dispose();
    companyEmailController.dispose();
    tax1NameController.dispose();
    tax1RateController.dispose();
    tax1RegController.dispose();
    tax2NameController.dispose();
    tax2RateController.dispose();
    tax2RegController.dispose();
    termsController.dispose();
    countryController.dispose();
    regionLabelController.dispose();
    postalCodeLabelController.dispose();
    invoicePrefixController.dispose();
    invoiceStartingNumberController.dispose();
    paymentEtransferEmailController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final c = await _db.companySettingsDao.getSettings();
    companyNameController.text = c.companyName ?? '';
    companyAddressController.text = c.companyAddress ?? '';
    companyCityController.text = c.companyCity ?? '';
    companyProvinceController.text = c.companyProvince ?? '';
    companyPostalCodeController.text = c.companyPostalCode ?? '';
    companyPhoneController.text = c.companyPhone ?? '';
    companyEmailController.text = c.companyEmail ?? '';
    tax1NameController.text = c.defaultTax1Name;
    tax1RateController.text = (c.defaultTax1Rate * 100).toStringAsFixed(2);
    tax1RegController.text = c.defaultTax1RegistrationNumber ?? '';
    tax2NameController.text = c.defaultTax2Name ?? '';
    tax2RateController.text = c.defaultTax2Rate != null
        ? (c.defaultTax2Rate! * 100).toStringAsFixed(2)
        : '';
    tax2RegController.text = c.defaultTax2RegistrationNumber ?? '';
    termsController.text = c.defaultTerms;
    countryController.text = c.country;
    regionLabelController.text = c.regionLabel;
    postalCodeLabelController.text = c.postalCodeLabel;
    invoicePrefixController.text = c.invoicePrefix;
    invoiceStartingNumberController.text = c.invoiceStartingNumber.toString();
    paymentEtransferEmailController.text = c.paymentEtransferEmail ?? '';
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    final tax1Rate = (double.tryParse(tax1RateController.text) ?? 0.0) / 100.0;
    final tax2RateInput = double.tryParse(tax2RateController.text);
    final tax2Rate = tax2RateInput != null ? tax2RateInput / 100.0 : null;

    await _db.companySettingsDao.saveSettings(
      CompanySettingsTableCompanion(
        companyName: Value(companyNameController.text),
        companyAddress: Value(companyAddressController.text),
        companyCity: Value(companyCityController.text),
        companyProvince: Value(companyProvinceController.text),
        companyPostalCode: Value(companyPostalCodeController.text),
        companyPhone: Value(companyPhoneController.text),
        companyEmail: Value(companyEmailController.text),
        defaultTax1Name: Value(tax1NameController.text),
        defaultTax1Rate: Value(tax1Rate),
        defaultTax1RegistrationNumber: Value(tax1RegController.text),
        defaultTax2Name: Value(tax2NameController.text),
        defaultTax2Rate: Value(tax2Rate),
        defaultTax2RegistrationNumber: Value(tax2RegController.text),
        defaultTerms: Value(termsController.text),
        country: Value(countryController.text),
        regionLabel: Value(regionLabelController.text),
        postalCodeLabel: Value(postalCodeLabelController.text),
        invoicePrefix: Value(invoicePrefixController.text.trim()),
        invoiceStartingNumber:
            Value(int.tryParse(invoiceStartingNumberController.text) ?? 1),
        paymentEtransferEmail: Value(
          paymentEtransferEmailController.text.trim().isEmpty
              ? null
              : paymentEtransferEmailController.text.trim(),
        ),
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Company settings saved!')),
    );
  }

  /// Compact, outlined field style matching the General & Reports tab.
  InputDecoration _dec(String label, {String? hint}) => InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      );

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    const gap = SizedBox(height: 12);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Company Information'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: companyNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _dec('Company Name'),
                  ),
                  gap,
                  TextField(
                    controller: companyAddressController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _dec('Street Address'),
                  ),
                  gap,
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: companyCityController,
                          textCapitalization: TextCapitalization.words,
                          decoration: _dec('City'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: companyProvinceController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: _dec('Province'),
                        ),
                      ),
                    ],
                  ),
                  gap,
                  TextField(
                    controller: companyPostalCodeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: _dec('Postal Code'),
                  ),
                  gap,
                  TextField(
                    controller: countryController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _dec('Country'),
                  ),
                  gap,
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: companyPhoneController,
                          decoration: _dec('Phone'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: companyEmailController,
                          decoration: _dec('Email'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle('Regional Settings'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: regionLabelController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _dec('Province/State Field Label',
                        hint: 'e.g. Province, State, County'),
                  ),
                  gap,
                  TextField(
                    controller: postalCodeLabelController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _dec('Postal/ZIP Field Label',
                        hint: 'e.g. Postal Code, ZIP Code, Postcode'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle('Tax Settings (e.g., GST)'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: tax1NameController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: _dec('Tax 1 Name (e.g. GST)'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: tax1RateController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: _dec('Rate %', hint: '5.0'),
                        ),
                      ),
                    ],
                  ),
                  gap,
                  TextField(
                    controller: tax1RegController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: _dec('Tax 1 Registration #'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle('Secondary Tax (Optional, e.g. PST)'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: tax2NameController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: _dec('Tax 2 Name'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: tax2RateController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: _dec('Rate %'),
                        ),
                      ),
                    ],
                  ),
                  gap,
                  TextField(
                    controller: tax2RegController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: _dec('Tax 2 Registration #'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle('Invoice Terms'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: termsController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                decoration:
                    _dec('Default Terms', hint: 'Payable on Receipt'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle('Invoice Settings'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: invoicePrefixController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: _dec('Invoice Prefix',
                              hint: 'e.g. INV or DPS, leave blank to omit'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: invoiceStartingNumberController,
                          keyboardType: TextInputType.number,
                          decoration: _dec('Starting Invoice Number',
                              hint: 'e.g. 1001'),
                        ),
                      ),
                    ],
                  ),
                  gap,
                  TextField(
                    controller: paymentEtransferEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _dec('Payment E-Transfer Email',
                        hint: 'shown on invoices, leave blank to omit'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Company Settings'),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
    );
  }
}
