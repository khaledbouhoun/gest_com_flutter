import 'pagination_meta.dart';

/// Generic pagination response wrapper
/// 
/// Wraps paginated API responses with metadata.
/// Keeps existing models unchanged while adding pagination support.
/// 
/// Usage:
/// ```dart
/// PaginatedResponse<Product> response = PaginatedResponse.fromJson(
///   data,
///   (item) => Product.fromJson(item),
/// );
/// ```
class PaginatedResponse<T> {
  final List<T> data;
  final PaginationMeta meta;

  PaginatedResponse({
    required this.data,
    required this.meta,
  });

  /// Create from JSON with custom item parser
  /// 
  /// [json] - Raw API response JSON
  /// [itemParser] - Function to parse individual items
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemParser,
  ) {
    try {
      final dataList = json['data'] as List? ?? [];
      final items = dataList
          .map((item) {
            try {
              return itemParser(item as Map<String, dynamic>);
            } catch (e) {
              print('Error parsing item: $e');
              return null;
            }
          })
          .whereType<T>()
          .toList();

      final meta = PaginationMeta.fromJson(json);

      return PaginatedResponse(
        data: items,
        meta: meta,
      );
    } catch (e) {
      print('Error creating PaginatedResponse: $e');
      rethrow;
    }
  }

  /// Fallback for old API format (non-paginated)
  /// 
  /// Converts old format {data: [...]} to paginated format
  factory PaginatedResponse.fromLegacyJson(
    List<dynamic> items,
    T Function(Map<String, dynamic>) itemParser,
  ) {
    try {
      final parsed = items
          .map((item) {
            try {
              return itemParser(item as Map<String, dynamic>);
            } catch (e) {
              print('Error parsing item: $e');
              return null;
            }
          })
          .whereType<T>()
          .toList();

      final meta = PaginationMeta(
        totalRows: parsed.length,
        pageSize: parsed.length,
        hasMore: false,
      );

      return PaginatedResponse(
        data: parsed,
        meta: meta,
      );
    } catch (e) {
      print('Error creating PaginatedResponse from legacy data: $e');
      rethrow;
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'data': data,
    ...meta.toJson(),
  };

  @override
  String toString() =>
      'PaginatedResponse(items: ${data.length}, meta: $meta)';
}
