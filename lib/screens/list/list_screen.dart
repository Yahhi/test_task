import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:test_task/screens/list/list_screen_state.dart';

import '../../widgets/product_card.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({required this.state, super.key});

  final ListScreenState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text("Products"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [IconButton(onPressed: state.changeOrder, icon: Icon(Icons.sort))],
      ),
      body: Observer(
        builder: (_) {
          if (state.isLoading) {
            return const Center(child: GFLoader(type: GFLoaderType.circle));
          } else {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: state.products[index]);
              },
            );
          }
        },
      ),
    );
  }
}
