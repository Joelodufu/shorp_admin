// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:oltron_admin/app.dart';
import 'package:oltron_admin/core/di/injection_container.dart';

void main() {
  setUp(() {
    InjectionContainer.init();
  });

  testWidgets('Admin panel loads dashboard screen', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the dashboard screen is shown.
    expect(find.text('Dashboard'), findsOneWidget);
    // You can also check for other widgets that should be present on load.
  });
}
