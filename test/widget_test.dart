import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatapp/core/di/service_locator.dart';
import 'package:chatapp/core/networking/api_service.dart';
import 'package:chatapp/chat_app.dart';

void main() {
  setUp(() {
    if (!getIt.isRegistered<DioHelper>()) {
      setupServiceLocator();
    }
  });

  testWidgets('ChatApp login screen smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1125, 2436);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChatApp());
    await tester.pumpAndSettle();

    // 1. Verify Login Screen elements
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
