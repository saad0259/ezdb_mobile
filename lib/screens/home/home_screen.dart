import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../constants/enums.dart';
import '../../models/member.dart';
import '../../state/auth_state.dart';
import '../../state/home_state.dart';
import '../../utils/snippet.dart';
import 'search_results.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PagingController<int, MemberModel> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    log('pageKey: $pageKey');
    try {
      final AuthState authState =
          Provider.of<AuthState>(context, listen: false);

      final HomeState homeState =
          Provider.of<HomeState>(context, listen: false);
      homeState.currentPage = pageKey;
      final List<MemberModel> newItems = await homeState.searchMembers(
        authState.user!.id,
      );

      final isLastPage = newItems.length < homeState.currentPage;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // height: screenHeight * 0.5,
              child: Column(
                children: [
                  SearchForm(controller: _pagingController),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Search Result:',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                      ),
                      Consumer<HomeState>(
                        builder: (context, homeState, child) {
                          return Text(
                            '${homeState.dataCount} records found',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchForm extends StatelessWidget {
  SearchForm({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final PagingController<int, MemberModel> controller;
  @override
  Widget build(BuildContext context) {
    final HomeState homeState = Provider.of<HomeState>(context);
    searchController.text = homeState.searchValue;
    postcodeController.text = homeState.postcode;

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
                if (homeState.searchType == SearchType.address)
                  TextFormField(
                    controller: postcodeController,
                    validator: mandatoryValidator,
                    onChanged: (value) {
                      homeState.postcode = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Postcode',
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
                  onPressed: () async {
                    //close keypad
                    FocusScope.of(context).unfocus();
                    final AuthState authState =
                        Provider.of<AuthState>(context, listen: false);

                    if (authState.user?.isExpired ?? false) {
                      return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Expired'),
                          content: const Text(
                              'Your membership has expired. Please See offers and renew your membership'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final AuthState authState =
                                    Provider.of<AuthState>(context,
                                        listen: false);
                                getStickyLoader(context);
                                try {
                                  String userId =
                                      (authState.user?.id ?? '').toString();
                                  log('userId: $userId');
                                  authState.updateUser(userId);
                                } catch (e) {}
                                pop(context);
                                pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }

                    log('helooooooo : ${authState.user?.isExpired}');

                    if (formKey.currentState?.validate() ?? false) {
                      homeState.isLoading = true;
                      push(context, SearchResultsScreen());
                      // try {
                      //   final HomeState homeState =
                      //       Provider.of<HomeState>(context, listen: false);
                      //   homeState.currentPage = 0;
                      //   final List<MemberModel> newItems =
                      //       await homeState.searchMembers();

                      //   final isLastPage =
                      //       newItems.length < homeState.currentPage;
                      //   if (isLastPage) {
                      //     controller.appendLastPage(newItems);
                      //   } else {
                      //     final nextPageKey = 1;
                      //     controller.appendPage(newItems, nextPageKey);
                      //   }
                      // } catch (error) {
                      //   controller.error = error;
                      // }
                      homeState.isLoading = false;
                    }
                    //   homeState.searchValue = searchController.text;
                    //   homeState.currentPage = 0;
                    //   homeState.searchMembers();
                    //   // await controller.navigateToPage(0);
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
