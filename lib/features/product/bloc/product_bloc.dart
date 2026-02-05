import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifevibes/features/product/models/product_model.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ProductBloc(this._firestore, this._auth) : super(const ProductState()) {
    on<ProductsLoadRequested>(_onProductsLoadRequested);
    on<ProductCreateRequested>(_onProductCreateRequested);
    on<ProductUpdateRequested>(_onProductUpdateRequested);
    on<ProductDeleteRequested>(_onProductDeleteRequested);
    on<ProductPublishRequested>(_onProductPublishRequested);
    on<ProductArchiveRequested>(_onProductArchiveRequested);
    on<ProductsRefreshRequested>(_onProductsRefreshRequested);
  }

  Future<void> _onProductsLoadRequested(
    ProductsLoadRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, hasError: false));

    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: 'Usuario no autenticado',
        ));
        return;
      }

      // Load user's products
      final productsSnapshot = await _firestore
          .collection('products')
          .where('userId', isEqualTo: currentUserId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      // Parse products
      final products = productsSnapshot.docs.map((doc) {
        final data = doc.data();
        return ProductModel.fromJson({
          ...data,
          'productId': doc.id,
        });
      }).toList();

      // Categorize products
      final published = products.where((p) => p.isPublished).toList();
      final drafts = products.where((p) => p.isDraft).toList();

      // Calculate totals
      final totalRevenue = products.fold<double>(
        0,
        (sum, p) => sum + p.revenue,
      );

      final totalSales = products.fold<int>(
        0,
        (sum, p) => sum + p.sales,
      );

      emit(state.copyWith(
        isLoading: false,
        products: products,
        publishedProducts: published,
        draftProducts: drafts,
        totalRevenue: totalRevenue,
        totalSales: totalSales,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Error cargando productos: ${e.toString()}',
      ));
    }
  }

  Future<void> _onProductCreateRequested(
    ProductCreateRequested event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) return;

      final newProductRef = await _firestore.collection('products').add({
        'userId': currentUserId,
        'title': event.product.title,
        'description': event.product.description,
        'type': event.product.type.name,
        'level': event.product.level.name,
        'status': event.product.status.name,
        'price': event.product.price,
        'discountPrice': event.product.discountPrice,
        'discountExpires': event.product.discountExpires,
        'imageUrl': event.product.imageUrl,
        'tags': event.product.tags,
        'stock': event.product.stock,
        'sales': 0,
        'revenue': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Get the created product
      final newProductDoc = await newProductRef.get();
      final newProduct = ProductModel.fromJson({
        ...newProductDoc.data() as Map<String, dynamic>,
        'productId': newProductDoc.id,
      });

      final updatedProducts = [newProduct, ...state.products];
      final updatedDrafts = [newProduct, ...state.draftProducts];

      emit(state.copyWith(
        products: updatedProducts,
        draftProducts: updatedDrafts,
        message: '✨ Producto creado exitosamente',
      ));
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error creando producto: ${e.toString()}',
      ));
    }
  }

  Future<void> _onProductUpdateRequested(
    ProductUpdateRequested event,
    Emitter<ProductState> emit,
  ) async {
    try {
      await _firestore
          .collection('products')
          .doc(event.productId)
          .update({
        ...event.updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local state
      final updatedProducts = state.products.map((p) {
        if (p.productId == event.productId) {
          return p.copyWith(
            event.updates,
            updatedAt: DateTime.now(),
          );
        }
        return p;
      }).toList();

      // Re-categorize
      final published = updatedProducts.where((p) => p.isPublished).toList();
      final drafts = updatedProducts.where((p) => p.isDraft).toList();

      emit(state.copyWith(
        products: updatedProducts,
        publishedProducts: published,
        draftProducts: drafts,
      ));
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error actualizando producto: ${e.toString()}',
      ));
    }
  }

  Future<void> _onProductDeleteRequested(
    ProductDeleteRequested event,
    Emitter<ProductState> emit,
  ) async {
    try {
      await _firestore.collection('products').doc(event.productId).delete();

      // Remove from local state
      final updatedProducts = state.products
          .where((p) => p.productId != event.productId)
          .toList();

      final updatedPublished = state.publishedProducts
          .where((p) => p.productId != event.productId)
          .toList();

      final updatedDrafts = state.draftProducts
          .where((p) => p.productId != event.productId)
          .toList();

      emit(state.copyWith(
        products: updatedProducts,
        publishedProducts: updatedPublished,
        draftProducts: updatedDrafts,
        message: '🗑️ Producto eliminado',
      ));
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error eliminando producto: ${e.toString()}',
      ));
    }
  }

  Future<void> _onProductPublishRequested(
    ProductPublishRequested event,
    Emitter<ProductState> emit,
  ) async {
    try {
      await _firestore
          .collection('products')
          .doc(event.productId)
          .update({
        'status': 'published',
        'publishedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local state
      final updatedProducts = state.products.map((p) {
        if (p.productId == event.productId) {
          return p.copyWith(
            status: ProductStatus.published,
            publishedAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
        return p;
      }).toList();

      final published = updatedProducts.where((p) => p.isPublished).toList();
      final drafts = updatedProducts.where((p) => p.isDraft).toList();

      emit(state.copyWith(
        products: updatedProducts,
        publishedProducts: published,
        draftProducts: drafts,
        message: '✅ Producto publicado',
      ));
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error publicando producto: ${e.toString()}',
      ));
    }
  }

  Future<void> _onProductArchiveRequested(
    ProductArchiveRequested event,
    Emitter<ProductState> emit,
  ) async {
    try {
      await _firestore
          .collection('products')
          .doc(event.productId)
          .update({
        'status': 'archived',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local state
      final updatedProducts = state.products.map((p) {
        if (p.productId == event.productId) {
          return p.copyWith(
            status: ProductStatus.archived,
            updatedAt: DateTime.now(),
          );
        }
        return p;
      }).toList();

      final published = updatedProducts.where((p) => p.isPublished).toList();
      final drafts = updatedProducts.where((p) => p.isDraft).toList();

      emit(state.copyWith(
        products: updatedProducts,
        publishedProducts: published,
        draftProducts: drafts,
      ));
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error archivando producto: ${e.toString()}',
      ));
    }
  }

  Future<void> _onProductsRefreshRequested(
    ProductsRefreshRequested event,
    Emitter<ProductState> emit,
  ) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      add(ProductsLoadRequested(userId));
    }
  }
}

