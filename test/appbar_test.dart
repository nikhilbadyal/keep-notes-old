import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes/widget/AppBar.dart';

void main() {
  testWidgets("App Bar widget test", (WidgetTester widgetTest) async {
    await widgetTest.pumpWidget(MaterialApp(
        home: MyAppBar(
      callback: () {},
      title: "test",
      imagePath: 'assets/images/img3.jpg',
    )));
    final findTitle = find.byType(CircleAvatar);
   expect(findTitle, findsOneWidget);
  });
}
