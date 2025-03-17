import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  int _page = 1;
  bool _hasMore = true;
  String _sortBy = 'default'; // Default sorting
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  final ApiService _apiService = ApiService();

  Future<void> fetchProducts({bool loadMore = false}) async {
    if (loadMore) {
      _page++;
    } else {
      _products = [];
      _page = 1;
      _hasMore = true;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final newProducts = await _apiService.fetchProducts(page: _page);
      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(newProducts);
      }
    } catch (e) {
      print('Error fetching products: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
    
    void sortProducts(String sortBy) {
    _sortBy = sortBy;
    _sortProducts();
    notifyListeners();
  }
    void _sortProducts() {
    switch (_sortBy) {
      case 'price':
        _products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'popularity':
        _products.sort((a, b) => b.rating.count.compareTo(a.rating.count));
        break;
      case 'rating':
        _products.sort((a, b) => b.rating.rate.compareTo(a.rating.rate));
        break;
      default:
        // No sorting
        break;
    }
    }
  }
