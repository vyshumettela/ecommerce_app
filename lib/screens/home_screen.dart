import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';
import '../widgets/product_search_delegate.dart';
import 'package:shared_preferences/shared_preferences.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  late ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.fetchProducts();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_productProvider.isLoading && _productProvider.hasMore) {
        _productProvider.fetchProducts(loadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    if (productProvider.isLoading && productProvider.products.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('E-commerce App'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              productProvider.sortProducts(value); // Sort products
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'price',
                child: Text('Sort by Price'),
              ),
              PopupMenuItem(
                value: 'popularity',
                child: Text('Sort by Popularity'),
              ),
              PopupMenuItem(
                value: 'rating',
                child: Text('Sort by Rating'),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(productProvider.products),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLoggedIn', false);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          controller: _scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 products per row
            crossAxisSpacing: 8, // Spacing between columns
            mainAxisSpacing: 8, // Spacing between rows
            childAspectRatio: 0.5, // Adjust the aspect ratio for 5 rows
          ),
          itemCount: productProvider.products.length + (productProvider.hasMore ? 1 : 0),
          itemBuilder: (ctx, index) {
            if (index < productProvider.products.length) {
              return ProductItem(product: productProvider.products[index]);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}