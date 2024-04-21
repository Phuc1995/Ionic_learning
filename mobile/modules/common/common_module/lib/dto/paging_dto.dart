
class PagingDto<T, S>{
  List<T>? items;
  S? summary;
  PageData? page;

  PagingDto({this.items, this.page, this.summary});

  void setItems(List<T>? items) => this.items = items;
  List<T>? getItems() => this.items;

  void setSummary(S? summary) => this.summary = summary;
  S? getSummary() => this.summary;

  void setPage(PageData? page) => this.page = page;
  PageData? getPageData() => this.page;
}

class PageData {
  int totalItems;
  int itemCount;
  int itemsPerPage;
  int totalPages;
  int currentPage;

  PageData(
      {required this.totalItems,
        required this.itemCount,
        required this.itemsPerPage,
        required this.totalPages,
        required this.currentPage,
      });

  factory PageData.fromMap(Map<String, dynamic> json) => PageData(
    totalItems: json['totalItems'],
    itemCount: json['itemCount'],
    itemsPerPage: json['itemsPerPage'],
    totalPages: json['totalPages'],
    currentPage: json['currentPage'],
  );

}
