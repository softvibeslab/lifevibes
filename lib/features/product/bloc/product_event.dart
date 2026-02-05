import 'package:equatable/equatable.dart';
import 'package:lifevibes/features/product/models/product_model.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class ProductsLoadRequested extends ProductEvent {
  final String userId;

  const ProductsLoadRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ProductCreateRequested extends ProductEvent {
  final ProductModel product;

  const ProductCreateRequested(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductUpdateRequested extends ProductEvent {
  final String productId;
  final Map<String, dynamic> updates;

  const ProductUpdateRequested({
    required this.productId,
    required this.updates,
  });

  @override
  List<Object?> get props => [productId, updates];
}

class ProductDeleteRequested extends ProductEvent {
  final String productId;

  const ProductDeleteRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ProductPublishRequested extends ProductEvent {
  final String productId;

  const ProductPublishRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ProductArchiveRequested extends ProductEvent {
  final String productId;

  const ProductArchiveRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ProductsRefreshRequested extends ProductEvent {
  const ProductsRefreshRequested();
}
