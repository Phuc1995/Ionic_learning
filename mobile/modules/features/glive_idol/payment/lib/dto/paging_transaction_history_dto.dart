class PagingTransactionHistoryDto {
  int totalItems;
  int itemCount;
  int itemsPerPage;
  int totalPages;
  int currentPage;

  PagingTransactionHistoryDto({
    required this.totalItems,
    required this.itemCount,
    required this.itemsPerPage,
    required this.totalPages,
    required this.currentPage,
  });

  factory PagingTransactionHistoryDto.fromMap(Map<String, dynamic> json) => PagingTransactionHistoryDto(
    totalItems: json['totalItems'],
    itemCount: json['itemCount'],
    itemsPerPage: json['itemsPerPage'],
    totalPages: json['totalPages'],
    currentPage: json['currentPage'],
  );
}
