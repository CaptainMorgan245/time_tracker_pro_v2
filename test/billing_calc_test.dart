import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_pro/core/billing_calc.dart';
import 'package:time_tracker_pro/data/local/drift/app_database.dart';

/// Rate-resolution tests for [hourlyRateCents].
///
/// These exist because the same bug shipped three times: a project created
/// without an hourly rate fell through to the employee's role `standardRate` —
/// an internal COST rate — and quietly billed the client at it. Each time it
/// was fixed by correcting that one project's rate, so the next new project
/// reproduced it. [blankRateDoesNotFallThroughToRoleRate] is the guard: it
/// fails if that fall-through ever comes back.
///
/// Pure functions over row objects, so no database and no Riverpod container.
void main() {
  // Rates in cents.
  const companyDefault = 7492; // $74.92/hour — the Default Billing Rate
  const roleRate = 4200; // $42.00/hour — an employee cost rate
  const projectRate = 9500; // $95.00/hour — a project's own negotiated rate

  DbProject project({String pricingModel = 'hourly', int? billedHourlyRate}) =>
      DbProject(
        id: 1,
        projectName: 'Test Project',
        clientId: 1,
        pricingModel: pricingModel,
        isCompleted: 0,
        isInternal: 0,
        billedHourlyRate: billedHourlyRate,
        expenseMarkupPercentage: 15.0,
        taxRate: 5.0,
      );

  const employeeId = 7;
  const titleId = 3;

  final employeeById = {
    employeeId: DbEmployee(
      id: employeeId,
      name: 'Test Employee',
      titleId: titleId,
      isDeleted: 0,
    ),
  };
  final roleById = {
    titleId: DbRole(id: titleId, name: 'Technician', standardRate: roleRate),
  };

  group('hourlyRateCents', () {
    test('a project with its own rate bills at that rate', () {
      expect(
        hourlyRateCents(
          project(billedHourlyRate: projectRate),
          employeeId,
          employeeById,
          roleById,
          companyDefaultRateCents: companyDefault,
        ),
        projectRate,
      );
    });

    test('the project rate wins over the company default', () {
      expect(
        hourlyRateCents(
          project(billedHourlyRate: projectRate),
          employeeId,
          employeeById,
          roleById,
          companyDefaultRateCents: companyDefault,
        ),
        isNot(companyDefault),
      );
    });

    test('a blank project rate falls back to the company default', () {
      expect(
        hourlyRateCents(
          project(billedHourlyRate: null),
          employeeId,
          employeeById,
          roleById,
          companyDefaultRateCents: companyDefault,
        ),
        companyDefault,
      );
    });

    // THE REGRESSION GUARD — the three-times-shipped bug.
    test(
      'a blank project rate does NOT fall through to the role rate when a '
      'company default exists',
      () {
        final rate = hourlyRateCents(
          project(billedHourlyRate: null),
          employeeId,
          employeeById,
          roleById,
          companyDefaultRateCents: companyDefault,
        );
        expect(
          rate,
          isNot(roleRate),
          reason: 'A project with no rate must never bill the client at an '
              'employee cost rate. This is the bug that regressed three times.',
        );
        expect(rate, companyDefault);
      },
    );

    test('the role rate still applies when no company default is configured',
        () {
      expect(
        hourlyRateCents(
          project(billedHourlyRate: null),
          employeeId,
          employeeById,
          roleById,
          companyDefaultRateCents: null,
        ),
        roleRate,
        reason: 'Unconfigured default must preserve the pre-existing behaviour '
            'rather than silently billing zero.',
      );
    });

    test('a zero company default is treated as unconfigured', () {
      expect(
        hourlyRateCents(
          project(billedHourlyRate: null),
          employeeId,
          employeeById,
          roleById,
          companyDefaultRateCents: 0,
        ),
        roleRate,
      );
    });

    test('a fixed-price project uses the company default over the role rate',
        () {
      expect(
        hourlyRateCents(
          project(pricingModel: 'fixed', billedHourlyRate: projectRate),
          employeeId,
          employeeById,
          roleById,
          companyDefaultRateCents: companyDefault,
        ),
        companyDefault,
        reason: 'billedHourlyRate only applies to hourly-model projects, so a '
            'fixed-price project falls to the next step in the chain.',
      );
    });

    test('resolves to 0 when nothing is configured', () {
      expect(
        hourlyRateCents(
          project(billedHourlyRate: null),
          null,
          employeeById,
          roleById,
          companyDefaultRateCents: null,
        ),
        0,
      );
    });
  });

  group('labourCostCents', () {
    test('costs labour at the burden rate, in dollars', () {
      // 10 hours at $50.00/hour burden = $500.00 = 50000 cents.
      expect(labourCostCents(10, 50.0), 50000);
    });

    test('an unconfigured burden rate yields 0, not a billed rate', () {
      expect(labourCostCents(10, null), 0);
      expect(labourCostCents(10, 0), 0);
    });
  });
}
