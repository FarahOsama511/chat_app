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
import '../../groups/cubit/rooms_cubit.dart';
import '../../groups/cubit/rooms_state.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  late final RoomsCubit _roomsCubit;

  @override
  void initState() {
    super.initState();
    _roomsCubit = RoomsCubit(getIt<GroupRepo>())..emitGetRooms();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocProvider.value(
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
                            context.read<RoomsCubit>().emitGetRooms();
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
                return ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: _buildEmptyState(context),
                    ),
                  ],
                );
              }

              return RefreshIndicator(
                onRefresh: () => context.read<RoomsCubit>().emitGetRooms(),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: rooms.length,
                  separatorBuilder: (context, index) => const AppDivider(),
                  itemBuilder: (context, index) {
                    final room = context.read<RoomsCubit>().chats[index];
                    return ConversationTile(
                      room: room,
                      onTap: () async {
                        await context.push(Routes.chat, extra: room);
                        _roomsCubit.emitGetRooms(showLoading: false);
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
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
                Icons.chat_bubble_outline_rounded,
                size: 32.sp,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 16.h),
            Text('No conversations found', style: textTheme.titleMedium),
            SizedBox(height: 6.h),
            Text(
              'Start a new chat to connect with friends',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
