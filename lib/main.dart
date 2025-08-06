import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:test_task/core/router/app_router.dart';
import 'package:test_task/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final logger = Logger();
  GetIt.instance.registerSingleton(logger);

  final AppRouter router = AppRouter();
  runApp(MainApp(router: router));
}
