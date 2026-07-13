import 'package:flutter_test/flutter_test.dart';

import 'package:financeflow/main.dart';

void main() {
  testWidgets('launches the FinanceFlow home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FinanceFlowApp());
    await tester.pumpAndSettle();

    expect(find.text('FinanceFlow'), findsWidgets);
    expect(find.text('Track money with less friction.'), findsOneWidget);
    expect(find.text('View Entries'), findsOneWidget);
  });

  testWidgets('navigates to the entries screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FinanceFlowApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('View Entries'));
    await tester.pumpAndSettle();

    expect(find.text('Entries'), findsWidgets);
    expect(find.text('Add a finance entry'), findsOneWidget);
  });

  testWidgets('navigates to the entry detail route', (WidgetTester tester) async {
    await tester.pumpWidget(const FinanceFlowApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Entry details'));
    await tester.pumpAndSettle();

    expect(find.text('Entry Details'), findsOneWidget);
    expect(find.text('Entry id: preview-1'), findsOneWidget);
  });
}
