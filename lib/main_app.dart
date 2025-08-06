import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:test_task/core/global_state/global_state.dart';
import 'package:toastification/toastification.dart';

import 'core/router/app_router.dart';
import 'core/storage/sqlite_storage.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.router});

  final AppRouter router;

  @override
  State<StatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final GlobalState _globalState = GlobalState();

  late final ReactionDisposer errorToastViewer;
  late final SqliteStorage storage;

  @override
  void initState() {
    storage = SqliteStorage();
    GetIt.instance.registerSingleton(storage);
    errorToastViewer = reaction((_) => _globalState.error?.isNotEmpty ?? false, (_) {
      if (_globalState.error == null) return;
      toastification.show(
        type: ToastificationType.warning,
        style: ToastificationStyle.flat,
        title: Text(_globalState.error!),
        autoCloseDuration: const Duration(seconds: GlobalState.errorViewPeriod),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    storage.close();
    errorToastViewer.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Product List',
        theme: ThemeData(primarySwatch: Colors.blue),
        routerConfig: widget.router.router,
      ),
    );
  }
}
