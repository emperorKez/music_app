part of 'search_bloc.dart';

@immutable
class SearchState {
  final String keyword;
  final List<SongModel>? songs;
  final bool isSearching;
  //final List<ProductItem> products;

  bool get isValidKeyword =>
      SearchFormValidator(keyword: keyword).validateKeyword();
  const SearchState({this.keyword = '', this.songs, this.isSearching = false});

  // SearchState copyWith({String? keyword, List<ProductItem>? products}) {
  //   return SearchState(
  //       keyword: keyword ??  this.keyword, products: products ?? this.products); 
  // }

  // @override
  // List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  const SearchLoaded({required super.songs, super.isSearching});
}

class SearchError extends SearchState {
  final String error;
  const SearchError({this.error = 'Something went wrong'});
}
