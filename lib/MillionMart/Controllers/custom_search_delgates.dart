import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/SearchProducts.dart';

import 'VoiceSearchController.dart';

typedef OnSearchChanged = Future<List<String>> Function(String);

class SearchWithSuggestionDelegate extends SearchDelegate<String> {
  final OnSearchChanged? onSearchChanged;

  List<String> _oldFilters = const [];

  SearchWithSuggestionDelegate({String? searchFieldLabel, this.onSearchChanged})
      : super(searchFieldLabel: searchFieldLabel);

  ///
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      ),
    ];
  }

  ///OnSubmit in the keyboard, returns the [query]
  @override
  void showResults(BuildContext context) {
    close(context, query);
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: onSearchChanged != null ? onSearchChanged!(query) : null,
      builder: (context, snapshot) {
        if (snapshot.hasData) _oldFilters = snapshot.data!;
        return ListView.builder(
          itemCount: _oldFilters.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.restore),
              title: Text("${_oldFilters[index]}"),
              onTap: () {
                close(context, _oldFilters[index]);
                if (_oldFilters[index].isNotEmpty) {
                  final VoiceSearchController voiceSearchController =
                      Get.put(VoiceSearchController());
                  voiceSearchController
                      .fetchProducts(_oldFilters[index].trim());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchProducts()));
                }
              },
            );
          },
        );
      },
    );
  }
}
