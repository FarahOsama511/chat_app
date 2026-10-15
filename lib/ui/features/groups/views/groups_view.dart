import 'package:chatapp/core/di/service_locator.dart';
import 'package:chatapp/data/repositories/group_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/routing/routes.dart';
import '../../../../data/models/group_model.dart';
import '../../../core/widgets/app_divider.dart';
import '../../../core/widgets/conversation_tile.dart';
import '../cubit/rooms_cubit.dart';
import '../cubit/rooms_state.dart';

class GroupsView extends StatefulWidget {
  final VoidCallback? onCreateGroupTap;
  const GroupsView({super.key, this.onCreateGroupTap});

  @override
  State<GroupsView> createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {
  late final RoomsCubit _roomsCubit;

  @override
  void initState() {
    super.initState();
    _roomsCubit = RoomsCubit(getIt<GroupRepo>());
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    await _roomsCubit.emitGetRooms(type: "group");
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        BlocProvider.value(
          value: _roomsCubit,
          child: Builder(
            builder: (context) {
              return BlocBuilder<RoomsCubit, RoomsState>(
                builder: (context, state) {
                  if (state is RoomsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is RoomsError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 48.sp,
                              color: colorScheme.error,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              state.error,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<RoomsCubit>().emitGetRooms(
                                  type: "group",
                                );
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  final List<GroupModel> rooms = state is RoomsSuccess
                      ? state.rooms
                      : [];
                  if (rooms.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () => context.read<RoomsCubit>().emitGetRooms(
                        type: "group",
                      ),
                      child: ListView(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: _buildEmptyState(context),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<RoomsCubit>().emitGetRooms(type: "group"),
                    child: ListView.separated(
                      padding: EdgeInsets.only(top: 8.h, bottom: 88.h),
                      itemCount: rooms.length,
                      separatorBuilder: (context, index) => const AppDivider(),
                      itemBuilder: (context, index) {
                        final room = context.read<RoomsCubit>().chats[index];
                        return ConversationTile(
                          room: room,
                          onTap: () async {
                            await context.push(Routes.chat, extra: room);
                            _roomsCubit.emitGetRooms(
                              type: "group",
                              showLoading: false,
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (widget.onCreateGroupTap != null)
          Positioned(
            right: 20.w,
            bottom: 20.h,
            child: FloatingActionButton(
              onPressed: widget.onCreateGroupTap,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(Icons.add_rounded, size: 28.sp),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72.w,
              height: 72.h,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.groups_outlined,
                size: 32.sp,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 16.h),
            Text('No groups yet', style: textTheme.titleMedium),
            SizedBox(height: 6.h),
            Text(
              'Create a group to start collaborating',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
