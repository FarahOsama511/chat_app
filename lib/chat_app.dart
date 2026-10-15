import 'package:chatapp/core/di/service_locator.dart';
import 'package:chatapp/core/utils/cubit/theme/app_theme_state.dart';
import 'package:chatapp/core/utils/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/flavor/flavor_config.dart';
import 'core/utils/cubit/theme/app_theme_cubit.dart' hide AppTheme;
import 'core/utils/theme/app_theme.dart';

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});
  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => getIt<ThemeAppCubit>(),
          child: Builder(
            builder: (context) {
              return BlocBuilder<ThemeAppCubit, ThemeAppState>(
                builder: (context, theme) {
                  return MaterialApp.router(
                    title: FlavorConfig.instance.appName,
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.getLightTheme(),
                    darkTheme: AppTheme.getDarkTheme(),
                    themeMode: context.read<ThemeAppCubit>().getCurrentTheme,
                    routerConfig: AppRouter.router,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
