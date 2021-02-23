import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes/main.dart';

void main(){
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MyNotes());
    final AddIcon = find.byIcon(Icons.add);
    expect(AddIcon,findsOneWidget);
    final galleryIcon = find.byIcon(Icons.camera_alt_outlined);
    expect(galleryIcon,findsOneWidget);
    final InsertIcon = find.byIcon(Icons.insert_photo);
    expect(InsertIcon,findsOneWidget);
  });
}