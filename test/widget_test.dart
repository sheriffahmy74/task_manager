import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/app.dart';

void main() {
  testWidgets('App boots and renders without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
