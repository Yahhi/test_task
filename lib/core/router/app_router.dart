import 'package:go_router/go_router.dart';
import 'package:test_task/core/model/product.dart';
import 'package:test_task/screens/error/error_screen.dart';
import 'package:test_task/screens/item/product_screen.dart';
import 'package:test_task/screens/list/list_screen.dart';
import 'package:test_task/screens/list/list_screen_state.dart';

class AppRouter {
  static const home = '/home';
  static const product = '/product';
  static const productPath = '$home$product';

  ListScreenState? listState;

  late final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) {
          listState ??= ListScreenState();
          return ListScreen(state: listState!);
        },
        routes: [
          GoRoute(
            path: product,
            builder: (context, state) {
              final extra = (state.extra as Map);
              final product = extra['product'] as Product?;
              if (product == null) {
                return ErrorScreen();
              } else {
                return ProductScreen(listState: listState!, product: product);
              }
            },
          ),
        ],
      ),
    ],
  );
}
