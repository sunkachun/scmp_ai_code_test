import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../bloc/staff_bloc.dart';
import '../bloc/staff_event.dart';
import '../bloc/staff_state.dart';
import '../widgets/staff_list_shimmer.dart';
import '../widgets/user_avatar.dart';

class StaffDirectoryPage extends StatefulWidget {
  const StaffDirectoryPage({super.key});

  @override
  State<StaffDirectoryPage> createState() => _StaffDirectoryPageState();
}

class _StaffDirectoryPageState extends State<StaffDirectoryPage> {
  static const int _pageSize = 6;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<StaffBloc>().add(const FetchStaffList());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bloc = context.read<StaffBloc>();
    final state = bloc.state;
    if (state is! StaffLoaded) return;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50 &&
        state.hasMore &&
        !state.isLoadingMore) {
      bloc.add(const FetchNextPage());
    }
  }

  void _scheduleOverflowCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<StaffBloc>();
      final state = bloc.state;
      if (state is! StaffLoaded || !state.hasMore || state.isLoadingMore) {
        return;
      }

      final double maxScrollExtent = _scrollController.hasClients
          ? _scrollController.position.maxScrollExtent
          : -1;

      debugPrint(
        'StaffDirectoryPage auto-load check: users=${state.users.length}, '
        'hasMore=${state.hasMore}, isLoadingMore=${state.isLoadingMore}, '
        'maxScrollExtent=$maxScrollExtent',
      );

      if (state.users.length <= _pageSize) {
        bloc.add(const FetchNextPage());
        return;
      }

      if (_scrollController.hasClients && maxScrollExtent < 20) {
        bloc.add(const FetchNextPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Staff List'),
      ),
      body: BlocBuilder<StaffBloc, StaffState>(
        builder: (context, state) {
          if (state is StaffLoading) {
            return const StaffListShimmer();
          }
          if (state is StaffFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<StaffBloc>().add(const FetchStaffList()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is StaffLoaded) {
            _scheduleOverflowCheck();
            return Column(
              children: [
                _TokenBanner(token: state.token),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: state.users.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.users.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }
                      final user = state.users[index];
                      return ListTile(
                        leading: UserAvatar(
                          avatarUrl: user.avatar,
                          index: index,
                        ),
                        title: Text('${user.firstName} ${user.lastName}'),
                        subtitle: Text(user.email),
                        onTap: () => context.push(
                          AppRoutes.staffDetail,
                          extra: user,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _TokenBanner extends StatelessWidget {
  const _TokenBanner({required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        'Token: $token',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
