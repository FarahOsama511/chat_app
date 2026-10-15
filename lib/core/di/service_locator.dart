import 'package:chatapp/core/helpers/security_sharedpref.dart';
import 'package:chatapp/core/utils/cubit/theme/app_theme_cubit.dart';
import 'package:get_it/get_it.dart';
import '../../data/repositories/group_repo.dart';
import '../../ui/features/auth/data/repos/login_repo.dart';
import '../../data/repositories/messages_repo.dart';
import '../../data/repositories/users_repo.dart';
import '../networking/api_service.dart';
import '../networking/pusher_config.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Networking
  getIt.registerLazySingleton<DioHelper>(() => DioHelper());
  getIt.registerSingleton<PusherConfig>(PusherConfig());
  getIt.registerLazySingleton<SecuritySharedpref>(() => SecuritySharedpref());
  getIt.registerSingleton<ThemeAppCubit>(ThemeAppCubit());

  // Repositories
  getIt.registerLazySingleton<LoginRepo>(
    () => LoginRepoImpl(getIt<DioHelper>()),
  );
  getIt.registerLazySingleton<UsersRepo>(
    () => UsersRepoImpl(getIt<DioHelper>()),
  );
  getIt.registerLazySingleton<GroupRepo>(
    () => GroupRepoImpl(getIt<DioHelper>()),
  );
  getIt.registerLazySingleton<MessagesRepo>(
    () => MessagesRepoImpl(getIt<DioHelper>()),
  );
}
