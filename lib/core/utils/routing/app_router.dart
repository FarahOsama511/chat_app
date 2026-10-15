import 'package:chatapp/data/repositories/group_repo.dart';
import 'package:chatapp/ui/features/auth/data/repos/login_repo.dart';
import 'package:chatapp/data/repositories/users_repo.dart';
import 'package:chatapp/ui/features/create_group/cubit/create_group_cubit.dart';
import 'package:chatapp/ui/features/create_group/cubit/users_cubit.dart';
import 'package:chatapp/ui/features/create_group/views/create_group_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../di/service_locator.dart';
import '../../../data/models/group_model.dart';
import '../../../data/repositories/messages_repo.dart';
import '../../../ui/features/auth/bussiness logic/login_cubit.dart';
import '../../../ui/features/auth/presentation/views/login_screen.dart';
import '../../../ui/features/chat/bussiness logic/chat_cubit.dart';
import '../../../ui/features/chat/bussiness logic/send_message_cubit.dart';
import '../../../ui/features/chat/presentation/views/chat_screen.dart';
import '../../../ui/features/home/views/home_screen.dart';
import 'routes.dart';

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.login,
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) => BlocProvider(
          create: (_) => LoginCubit(getIt<LoginRepo>()),
          child: LoginScreen(),
        ),
      ),
      GoRoute(path: Routes.home, builder: (context, state) => HomeScreen()),
      GoRoute(
        path: Routes.createGroup,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => UsersCubit(getIt<UsersRepo>())),
            BlocProvider(create: (_) => CreateGroupCubit(getIt<GroupRepo>())),
          ],
          child: const CreateGroupScreen(),
        ),
      ),
      GoRoute(
        path: Routes.chat,
        builder: (context, state) {
          final group = state.extra is GroupModel
              ? state.extra as GroupModel
              : const GroupModel(name: 'Chat');
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    ChatCubit(getIt<MessagesRepo>())
                      ..emitGetRoomMessages(group.id ?? 0),
              ),
              BlocProvider(
                create: (_) => SendMessageCubit(getIt<MessagesRepo>()),
              ),
            ],
            child: ChatScreen(group: group),
          );
        },
      ),
    ],
  );
}
