import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'test.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    debugPrint('start Home');
  }

  @override
  void dispose() {
    debugPrint('finish Home');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Home'),
      actions: [
        TextButton.icon(
          onPressed: () {
            Database.isLoggedIn = false;
            // Logout answer: clear authentication, then go('/login') to select
            // the public login route. pop() is wrong here because it only
            // removes the current stack entry; it does not clear auth and could
            // reveal a protected Home route or another unrelated page.
            context.go('/login');
          },
          icon: const Icon(Icons.logout),
          label: const Text('Log out'),
        ),
      ],
    ),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Welcome to Home Page'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/home/products'),
            child: const Text('Browse products'),
          ),
        ],
      ),
    ),
  );
}
