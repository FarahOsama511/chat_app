import 'package:chatapp/chat_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/service_locator.dart';
import 'core/flavor/flavor_config.dart';
import 'core/helpers/sharedpref_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.init(
    flavor: FlavorType.production,
    appName: 'Chat App',
    baseUrl: 'https://0684-156-197-118-136.ngrok-free.app/api',
  );

  await ScreenUtil.ensureScreenSize();
  await SharedprefHelper.cacheInitialization();
  setupServiceLocator();
  runApp(const ChatApp());
}
