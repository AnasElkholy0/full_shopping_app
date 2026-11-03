import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_shopping_app_4/main.dart';
import 'package:full_shopping_app_4/test.dart';

void main() {
  testWidgets('signup credentials can log in and log out', (tester) async {
    Database.isLoggedIn = false;
    Database.username = 'Atef';
    Database.password = 'Atef12345';
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text("Don't have an account? Sign up"));
    await tester.pumpAndSettle();
    expect(find.text('Create account'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'newuser');
    await tester.enterText(find.byType(TextFormField).at(1), 'new@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'secret123');
    await tester.enterText(find.byType(TextFormField).at(3), 'secret123');
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(Database.username, 'newuser');
    expect(Database.password, 'secret123');
    expect(find.text('Welcome back'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'newuser');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(Database.isLoggedIn, isTrue);
    expect(find.text('Welcome to Home Page'), findsOneWidget);

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(Database.isLoggedIn, isFalse);
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('signup shows validation errors for invalid input', (
    tester,
  ) async {
    Database.isLoggedIn = false;
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text("Don't have an account? Sign up"));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(2), 'abc');
    await tester.enterText(find.byType(TextFormField).at(3), 'different');
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(find.text('Username must be at least 3 characters'), findsOneWidget);
    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}
