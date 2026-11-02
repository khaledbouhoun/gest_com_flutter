/// Pagination metadata model for API responses
///
/// Handles pagination information returned from paginated API endpoints.
/// Example API response:
/// {
///   "data": [...],
///   "totalRows": 10532,
///   "page": 1,
///   "pageSize": 50,
///   "hasMore": true
/// }
class PaginationMeta {
  final int totalRows;
  final int pageSize;
  bool hasMore;

  PaginationMeta({
    required this.totalRows,
    required this.pageSize,
    required this.hasMore,
  });

  /// Create from JSON response (null-safe)
  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      totalRows: json['totalRows'] as int? ?? 0,
      pageSize: json['pageSize'] as int? ?? 50,
      hasMore: json['hasMore'] == 1 ? true : false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'totalRows': totalRows,
        'pageSize': pageSize,
        'hasMore': hasMore,
      };

  /// Create a copy with updated values
  PaginationMeta copyWith({
    int? totalRows,
    int? pageSize,
    bool? hasMore,
  }) {
    return PaginationMeta(
      totalRows: totalRows ?? this.totalRows,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  String toString() => 'PaginationMeta(totalRows: $totalRows, pageSize: $pageSize, hasMore: $hasMore)';
}
