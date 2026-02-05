import 'package:equatable/equatable.dart';
import 'package:lifevibes/features/product/models/product_model.dart';

class ProductState extends Equatable {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final String? message;
  final List<ProductModel> products;
  final List<ProductModel> publishedProducts;
  final List<ProductModel> draftProducts;
  final double totalRevenue;
  final int totalSales;

  const ProductState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.message,
    this.products = const [],
    this.publishedProducts = const [],
    this.draftProducts = const [],
    this.totalRevenue = 0.0,
    this.totalSales = 0,
  });

  ProductState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    String? message,
    List<ProductModel>? products,
    List<ProductModel>? publishedProducts,
    List<ProductModel>? draftProducts,
    double? totalRevenue,
    int? totalSales,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      message: message,
      products: products ?? this.products,
      publishedProducts: publishedProducts ?? this.publishedProducts,
      draftProducts: draftProducts ?? this.draftProducts,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalSales: totalSales ?? this.totalSales,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        hasError,
        errorMessage,
        message,
        products,
        publishedProducts,
        draftProducts,
        totalRevenue,
        totalSales,
      ];
}
