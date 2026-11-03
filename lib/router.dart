import 'package:go_router/go_router.dart';

import 'login_page.dart';
import 'home_page.dart';
import 'products_page.dart';
import 'signup_page.dart';
import 'test.dart';

final router = GoRouter(
  initialLocation: "/login",
  redirect: (context, state) {
    var path = state.matchedLocation;
    // Answer: /signup is a top-level route, not nested under /home, so an
    // unauthenticated visitor can open it directly. The redirect checks the
    // requested matched location and sends only /home (including products)
    // to /login while Database.isLoggedIn is false; /login and /signup pass.
    if (path.startsWith("/home") && !Database.isLoggedIn) {
      return "/login";
    }
    return null;
  },
  routes: [
    GoRoute(path: "/login", builder: (context, state) => const LoginPage()),
    GoRoute(path: "/signup", builder: (context, state) => const SignupPage()),
    GoRoute(
      path: "/home",
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'products',
          builder: (context, state) => const ProductsPage(),
        ),
      ],
    ),
  ],
);
