part of backendless_sdk;

class PagedQueryBuilder {
  static const int defaultPageSize = 10;
  static const int defaultOffset = 0;
  int _pageSize;
  int _offset;

  PagedQueryBuilder(
      [this._pageSize = defaultPageSize, this._offset = defaultOffset]);

  int get pageSize => _pageSize;

  set pageSize(int pageSize) {
    _validatePageSize(pageSize);
    _pageSize = pageSize;
  }

  int get offset => _offset;

  set offset(int offset) {
    _validateOffset(offset);
    _offset = offset;
  }

  void prepareNextPage() {
    int newOffset = _offset + _pageSize;
    _validateOffset(newOffset);
    _offset = newOffset;
  }

  void preparePreviousPage() {
    int newOffset = _offset - _pageSize;
    _validateOffset(newOffset);
    _offset = newOffset;
  }

  void _validateOffset(int offset) {
    if (offset < 0) {
      throw ArgumentError("Offset cannot have a negative value.");
    }
  }

  void _validatePageSize(int pageSize) {
    if (pageSize <= 0) {
      throw ArgumentError("Page size cannot have a negative value.");
    }
  }
}
