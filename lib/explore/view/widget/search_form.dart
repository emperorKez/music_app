import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/explore/bloc/search_bloc/search_bloc.dart';
import 'package:music_app/library/bloc/library_fetch_bloc/library_fetch_bloc.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LibraryLoaded) {
          return Form(
            key: formKey,
            child: TextFormField(
              keyboardType: TextInputType.text,
              autofocus: false,
              onChanged: (value) {
                context.read<SearchBloc>().add(SearchKeywordChanged(
                    keyword: value, songLibrary: state.songs));
              },
              decoration: const InputDecoration(
                  isDense: true,
                  filled: true,
                  hintText: 'Search Songs, Playlists, artistes ...',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              validator: (value) {
                //  return context.read<SearchBloc>().state.isValidKeyword == false
                //     ? 'enter product name to search'
                //     : null;
              },
              onEditingComplete: () =>
                  context.read<SearchBloc>().add(SearchCanceled()),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
