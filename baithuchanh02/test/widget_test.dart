// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baithuchanh02/main.dart';

void main() {
  testWidgets('Smart Note app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('Smart Note - Ngoc Luong - 12345'), findsOneWidget);

    // Verify that the search field is present
    expect(find.text('Tìm kiếm ghi chú...'), findsOneWidget);

    // Verify that the FAB is present
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Verify empty state message
    expect(
      find.text('Bạn chưa có ghi chú nào, hãy tạo mới nhé!'),
      findsOneWidget,
    );
  });
}
