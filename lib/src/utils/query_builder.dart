part of backendless_sdk;

class PagedQueryBuilder {
  static const int DEFAULT_PAGE_SIZE = 10;
  static const int DEFAULT_OFFSET = 0;
  int _pageSize;
  int _offset;

  PagedQueryBuilder([this._pageSize = DEFAULT_PAGE_SIZE, this._offset = DEFAULT_OFFSET]);

  set pageSize(int pageSize) {
    _validatePageSize(pageSize);
    if (pageSize != null)
      _pageSize = pageSize;
    else
      _pageSize = DEFAULT_PAGE_SIZE;
  }

  get pageSize => _pageSize;

  set offset(int offset) {
    _validateOffset(offset);
    if (offset != null)
      _offset = offset;
    else
      _offset = DEFAULT_OFFSET;
  }

  get offset => _offset;

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
}

void _validateOffset(int offset) {
  if (offset != null && offset < 0)
    throw new ArgumentError("Offset cannot have a negative value.");
}

void _validatePageSize(int pageSize) {
  if (pageSize != null && pageSize <= 0)
    throw new ArgumentError("Page size cannot have a negative value.");
}

enum Units { METERS, MILES, YARDS, KILOMETERS, FEET }
