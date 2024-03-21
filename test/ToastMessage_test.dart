import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workshop/constants/trip.constants.dart';
import 'package:flutter_workshop/features/trips/view/widgets/ToastMessage.widget.dart';

void main() {
  testWidgets('ToastMessage displays correctly for success status',
      (WidgetTester tester) async {
    const String text = 'Success Message';
    const ToastStatus status = ToastStatus.success;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ToastMessage(
            status: status,
            message: text,
          ),
        ),
      ),
    );

    expect(find.text(text), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
  });

  testWidgets('ToastMessage displays correctly for error status',
      (WidgetTester tester) async {
    const String text = 'Error Message';
    const ToastStatus status = ToastStatus.error;

    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ToastMessage(status: status, message: text),
      ),
    ));

    expect(find.text(text), findsOneWidget);
    expect(find.byIcon(Icons.error), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
  });

  testWidgets('ToastMessage displays correctly for info status',
      (WidgetTester tester) async {
    const String text = 'Info Message';
    const ToastStatus status = ToastStatus.info;

    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ToastMessage(status: status, message: text),
      ),
    ));

    expect(find.text(text), findsOneWidget);
    expect(find.byIcon(Icons.info), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
  });
}
