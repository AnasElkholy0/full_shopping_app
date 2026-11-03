import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    debugPrint('start Products');
  }

  @override
  void dispose() {
    debugPrint('finish Products');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Products')),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Welcome to Products Page'),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => context.pop(),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    ),
  );
}
