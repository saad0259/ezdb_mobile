import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/member.dart';
import '../../state/auth_state.dart';
import '../../state/home_state.dart';
import '../../utils/snippet.dart';
import 'member_list.dart';

class SearchResultsScreen extends StatefulWidget {
  SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final ScrollController _scrollController = ScrollController();

  final PagingController<int, MemberModel> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      await _fetchPage(pageKey);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => getFirstPage());
  }

  Future<void> getFirstPage() async {
    final HomeState homeState = Provider.of<HomeState>(context, listen: false);
    homeState.isLoading = true;
    // push(context, SearchResultsScreen());
    try {
      final AuthState authState =
          Provider.of<AuthState>(context, listen: false);

      final HomeState homeState =
          Provider.of<HomeState>(context, listen: false);
      homeState.currentPage = 0;
      final List<MemberModel> newItems =
          await homeState.searchMembers(authState.user!.id);

      final isLastPage = newItems.length < homeState.currentPage;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
    homeState.isLoading = false;
    return null;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final AuthState authState =
          Provider.of<AuthState>(context, listen: false);

      final HomeState homeState =
          Provider.of<HomeState>(context, listen: false);
      homeState.currentPage = pageKey;
      final List<MemberModel> newItems =
          await homeState.searchMembers(authState.user!.id);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records'),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
          child: Consumer<HomeState>(
            builder: (context, homeState, child) {
              return homeState.isLoading
                  ? shimmerTableEffect()
                  : homeState.members.isEmpty
                      ? const Center(
                          child: Text('No data found'),
                        )
                      : PagedListView<int, MemberModel>.separated(
                          scrollController: _scrollController,
                          pagingController: _pagingController,
                          shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          // scrollController: _scrollController,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          // physics: const NeverScrollableScrollPhysics(),
                          builderDelegate:
                              PagedChildBuilderDelegate<MemberModel>(
                            itemBuilder: (context, item, index) => MemberWidget(
                              member: item,
                            ),
                          ),
                        );
            },
          ),
        ),
      ),
    );
  }
}
