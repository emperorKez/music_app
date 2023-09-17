class SearchFormValidator {
  final String? keyword;
  SearchFormValidator({
    this.keyword,
  });

  bool validateKeyword() {
    return keyword!.length > 3 ? true : false;
  }
}
