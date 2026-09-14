import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.thumbnail, width: double.infinity, height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: Theme.of(context).textTheme.headlineMedium),
                  Text('\$${product.price}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.green)),
                  const SizedBox(height: 10),
                  Text(product.category.toUpperCase(), style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 20),
                  Text(product.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
