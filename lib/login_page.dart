// A widget's Key is passed to Widget.key by {super.key}; Flutter uses it to
// identify that widget among siblings and preserve the right element/state.
// GlobalKey<FormState> is different: it gives this form's State a stable handle
// so validators can be run imperatively with currentState!.validate().
// const widgets can be reused across rebuilds, reducing short-lived object
// creation and allowing Flutter to skip rebuilding unchanged widget configs.
// Dart's leading underscore makes a name library-private. Keeping State classes
// private hides implementation details and prevents callers from depending on them.
// Navigation experiment answers:
// 1) Login -> push('/signup') -> Signup -> pop(): push adds Signup above Login
//    on the Navigator stack; pop removes Signup and reveals the existing Login.
// 2) Login -> go('/signup') -> Signup -> pop(): go selects the Signup route
//    configuration instead of pushing above Login. Login is no longer a page
//    to reveal, so pop cannot be relied on to return there (it may do nothing or
//    leave the app, depending on the platform/router stack).
// 3) Login -> go('/signup') -> Signup -> go('/login'): this explicitly selects
//    Login and works regardless of whether Login remains in the stack.
// 4) Login -> push('/signup') -> system/AppBar back: back pops Signup and shows
//    the Login page underneath.
// Lifecycle answer: with push, Login stays mounted, so its initState does not
// run again when Signup is popped, and dispose waits until Login is removed.
// With go, Login is disposed when it leaves the route configuration; navigating
// to /login later creates Login again, so initState runs for that new State.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'test.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _keyForm = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _inputCheck() {
    if (!_keyForm.currentState!.validate()) return;

    if (_usernameController.text.trim() == Database.username &&
        _passwordController.text == Database.password) {
      Database.isLoggedIn = true;
      context.go('/home');
    } else {
      _usernameController.clear();
      _passwordController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Wrong info')));
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('start Login');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    debugPrint('finish Login');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _keyForm,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 56,
                      color: colors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue shopping',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Please enter your username'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => (value?.length ?? 0) < 6
                          ? 'Please enter a valid password'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _inputCheck,
                        child: const Text('Sign in'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => context.push('/signup'),
                      child: const Text("Don't have an account? Sign up"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
