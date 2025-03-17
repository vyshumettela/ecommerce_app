import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  ProductDetailScreen({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: FutureBuilder<Product>(
        future: ApiService().fetchProductDetails(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No product found'));
          }

          final product = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.image,
                      height: 400, // Reduced image size
                      width: 350, // Reduced image size
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Product Title
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),

                // Product Price
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.green.shade800,
                  ),
                ),
                SizedBox(height: 16),

                // Product Description
                Text(
                  product.description,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 16),

                // Product Rating
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text(
                      '${product.rating.rate} (${product.rating.count} reviews)',
                      style: TextStyle(fontSize: 23),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}