import 'package:flutter/material.dart';

/// Modelos para el sistema de productos (Products) de LifeVibes
/// Escalera de Valor: DBY → DWY → DFY

/// Tipo de producto
enum ProductType {
  dby,   // Done-By-You (Curso, Ebook, Template)
  dwy,   // Done-With-You (Mentoría, Coaching, Mastermind)
  dfy,   // Done-For-You (Servicio Premium, Consultoría)
}

/// Nivel de producto
enum ProductLevel {
  level1, // DBY: $7-$77
  level2, // DWY: $97-$497
  level3, // DFY: $1,000-$10,000+
}

/// Estado del producto
enum ProductStatus {
  draft,      // Borrador
  published,  // Publicado
  archived,   // Archivado
  sold,       // Vendido (para productos únicos)
}

/// Modelo de Producto
class ProductModel {
  final String productId;
  final String userId;
  final String title;
  final String description;
  final ProductType type;
  final ProductLevel level;
  final ProductStatus status;
  final double price; // Precio en USD
  final double? discountPrice; // Precio con descuento (opcional)
  final String? discountExpires; // Fecha de expiración del descuento
  final String imageUrl; // URL de imagen del producto
  final List<String> tags; // Tags para categorización
  final int? stock; // Stock disponible (null = ilimitado)
  final int sales; // Número de ventas
  final double revenue; // Ingresos generados
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt; // Fecha de publicación
  final String? stripePriceId; // ID del precio en Stripe

  ProductModel({
    required this.productId,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    required this.level,
    required this.status,
    required this.price,
    this.discountPrice,
    this.discountExpires,
    this.imageUrl = '',
    this.tags = const [],
    this.stock,
    this.sales = 0,
    this.revenue = 0.0,
    required this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.stripePriceId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: _parseProductType(json['type'] as String? ?? 'dby'),
      level: _parseProductLevel(json['level'] as String? ?? 'level1'),
      status: _parseProductStatus(json['status'] as String? ?? 'draft'),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      discountExpires: json['discountExpires'] as String?,
      imageUrl: json['imageUrl'] as String? ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      stock: json['stock'] as int?,
      sales: json['sales'] as int? ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'] as String)
          : null,
      stripePriceId: json['stripePriceId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'userId': userId,
      'title': title,
      'description': description,
      'type': type.name,
      'level': level.name,
      'status': status.name,
      'price': price,
      'discountPrice': discountPrice,
      'discountExpires': discountExpires,
      'imageUrl': imageUrl,
      'tags': tags,
      'stock': stock,
      'sales': sales,
      'revenue': revenue,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'publishedAt': publishedAt?.toIso8601String(),
      'stripePriceId': stripePriceId,
    };
  }

  ProductModel copyWith({
    String? productId,
    String? userId,
    String? title,
    String? description,
    ProductType? type,
    ProductLevel? level,
    ProductStatus? status,
    double? price,
    double? discountPrice,
    String? discountExpires,
    String? imageUrl,
    List<String>? tags,
    int? stock,
    int? sales,
    double? revenue,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
    String? stripePriceId,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      level: level ?? this.level,
      status: status ?? this.status,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      discountExpires: discountExpires ?? this.discountExpires,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      stock: stock ?? this.stock,
      sales: sales ?? this.sales,
      revenue: revenue ?? this.revenue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedAt: publishedAt ?? this.publishedAt,
      stripePriceId: stripePriceId ?? this.stripePriceId,
    );
  }

  // Getters útiles
  bool get isDraft => status == ProductStatus.draft;
  bool get isPublished => status == ProductStatus.published;
  bool get isArchived => status == ProductStatus.archived;
  bool get isSold => status == ProductStatus.sold;

  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  bool get isOutOfStock => stock != null && stock! <= 0;
  bool get hasStock => stock == null || stock! > 0;

  String get typeLabel => _getTypeLabel(type);
  String get levelLabel => _getLevelLabel(level);
  String get statusLabel => _getStatusLabel(status);

  Color get levelColor => _getLevelColor(level);
  Color get statusColor => _getStatusColor(status);

  static ProductType _parseProductType(String type) {
    return ProductType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => ProductType.dby,
    );
  }

  static ProductLevel _parseProductLevel(String level) {
    return ProductLevel.values.firstWhere(
      (e) => e.name == level,
      orElse: () => ProductLevel.level1,
    );
  }

  static ProductStatus _parseProductStatus(String status) {
    return ProductStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => ProductStatus.draft,
    );
  }

  static String _getTypeLabel(ProductType type) {
    switch (type) {
      case ProductType.dby:
        return 'DBY';
      case ProductType.dwy:
        return 'DWY';
      case ProductType.dfy:
        return 'DFY';
    }
  }

  static String _getLevelLabel(ProductLevel level) {
    switch (level) {
      case ProductLevel.level1:
        return 'Nivel 1 ($7-$77)';
      case ProductLevel.level2:
        return 'Nivel 2 ($97-$497)';
      case ProductLevel.level3:
        return 'Nivel 3 ($1,000-$10,000+)';
    }
  }

  static String _getStatusLabel(ProductStatus status) {
    switch (status) {
      case ProductStatus.draft:
        return 'Borrador';
      case ProductStatus.published:
        return 'Publicado';
      case ProductStatus.archived:
        return 'Archivado';
      case ProductStatus.sold:
        return 'Vendido';
    }
  }

  static Color _getLevelColor(ProductLevel level) {
    switch (level) {
      case ProductLevel.level1:
        return Colors.green;
      case ProductLevel.level2:
        return Colors.blue;
      case ProductLevel.level3:
        return Colors.purple;
    }
  }

  static Color _getStatusColor(ProductStatus status) {
    switch (status) {
      case ProductStatus.draft:
        return Colors.grey;
      case ProductStatus.published:
        return Colors.green;
      case ProductStatus.archived:
        return Colors.orange;
      case ProductStatus.sold:
        return Colors.blue;
    }
  }
}

/// Productos de ejemplo/templates
class ProductTemplates {
  /// Template de producto DBY
  static ProductModel get dbyTemplate {
    return ProductModel(
      productId: 'template_dby',
      userId: '',
      title: 'Plantilla de Landing Page',
      description: 'Plantilla profesional de landing page con todos los componentes necesarios para vender tu producto.',
      type: ProductType.dby,
      level: ProductLevel.level1,
      status: ProductStatus.published,
      price: 27.0,
      imageUrl: '',
      tags: ['Plantilla', 'Marketing', 'Web'],
      createdAt: DateTime.now(),
    );
  }

  /// Template de producto DWY
  static ProductModel get dwyTemplate {
    return ProductModel(
      productId: 'template_dwy',
      userId: '',
      title: 'Mentoría Grupal 4 Semanas',
      description: 'Programa de mentoría grupal de 4 semanas para transformar tu negocio. Incluye sesiones semanales, material exclusivo y comunidad privada.',
      type: ProductType.dwy,
      level: ProductLevel.level2,
      status: ProductStatus.published,
      price: 297.0,
      imageUrl: '',
      tags: ['Mentoría', 'Coaching', 'Comunidad'],
      createdAt: DateTime.now(),
    );
  }

  /// Template de producto DFY
  static ProductModel get dfyTemplate {
    return ProductModel(
      productId: 'template_dfy',
      userId: '',
      title: 'Servicio de Lanzamiento Completo',
      description: 'Servicio premium que incluye desarrollo de landing page, configuración de email marketing, setup de pagos y estrategia de lanzamiento.',
      type: ProductType.dfy,
      level: ProductLevel.level3,
      status: ProductStatus.published,
      price: 5000.0,
      imageUrl: '',
      tags: ['Servicio', 'Lanzamiento', 'Consultoría'],
      createdAt: DateTime.now(),
    );
  }

  /// Generar producto aleatorio basado en nivel
  static ProductModel generateForLevel(ProductLevel level) {
    switch (level) {
      case ProductLevel.level1:
        return dbyTemplate.copyWith(
          productId: '',
          userId: '',
          createdAt: DateTime.now(),
        );
      case ProductLevel.level2:
        return dwyTemplate.copyWith(
          productId: '',
          userId: '',
          createdAt: DateTime.now(),
        );
      case ProductLevel.level3:
        return dfyTemplate.copyWith(
          productId: '',
          userId: '',
          createdAt: DateTime.now(),
        );
    }
  }
}

/// Categorías de productos
class ProductCategories {
  static const List<String> all = [
    'Marketing',
    'Web',
    'Ecommerce',
    'Coaching',
    'Consultoría',
    'Plantilla',
    'Curso',
    'Ebook',
    'Software',
    'Herramienta',
  ];
}
