import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';

import '../../constants/enums.dart';
import '../../state/home_state.dart';
import '../../utils/snippet.dart';
import 'member_list.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchForm(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Search Result:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                ),
                Consumer<HomeState>(
                  builder: (context, homeState, child) {
                    return Text(
                      '${homeState.dataCount} records found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Consumer<HomeState>(
              builder: (context, homeState, child) {
                return homeState.members.isNotEmpty
                    ? NumberPaginator(
                        numberPages: homeState.dataCount ~/ homeState.pageSize,
                        initialPage: homeState.currentPage,
                        config: NumberPaginatorUIConfig(
                          mode: ContentDisplayMode.dropdown,
                        ),
                        onPageChange: (value) {
                          homeState.currentPage = value;
                          homeState.searchMembers();
                        },
                      )
                    : SizedBox();
              },
            ),
            const SizedBox(height: 10),
            Consumer<HomeState>(
              builder: (context, homeState, child) {
                if (homeState.isLoading) {
                  return shimmerTableEffect();
                } else if (homeState.members.isEmpty) {
                  return const Center(
                    child: Text('No data found'),
                  );
                } else {
                  return MembersList(homeState: homeState);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class SearchForm extends StatelessWidget {
  SearchForm({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final HomeState homeState = Provider.of<HomeState>(context);
    searchController.text = homeState.searchValue;

    return Card(
      color: Colors.grey.shade300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButton<SearchType>(
                    style: Theme.of(context).textTheme.bodyLarge,
                    value: homeState.searchType,
                    underline: Container(),
                    icon: const Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    onChanged: (value) {
                      homeState.setSearchType(value ?? SearchType.ic);
                    },
                    items: SearchType.values
                        .map((e) => DropdownMenuItem<SearchType>(
                              value: e,
                              child: Text(e.toString().split('.').last),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: searchController,
                  validator: mandatoryValidator,
                  onChanged: (value) {
                    homeState.searchValue = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Type here',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    //close keypad
                    FocusScope.of(context).unfocus();

                    if (formKey.currentState?.validate() ?? false) {
                      homeState.searchValue = searchController.text;
                      homeState.currentPage = 0;
                      homeState.searchMembers();
                    }
                  },
                  child: const Text('Search'),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
