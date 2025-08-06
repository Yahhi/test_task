import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:go_router/go_router.dart';
import 'package:test_task/core/model/product.dart';
import 'package:test_task/screens/item/product_screen_state.dart';
import 'package:test_task/screens/list/list_screen_state.dart';

class ProductScreen extends StatelessWidget {
  final ProductScreenState state;
  final ListScreenState listState;

  ProductScreen({required this.listState, required Product product, super.key}) : state = ProductScreenState(product);

  @override
  Widget build(BuildContext context) {
    final product = state.product;
    return Scaffold(
      appBar: GFAppBar(
        title: Text(state.product.name),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          GFIconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              if (await listState.remove(state.product)) {
                GoRouter.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GFCard(
          title: GFListTile(
            avatar: const GFAvatar(backgroundImage: AssetImage('assets/placeholder.png'), size: GFSize.LARGE),
            titleText: product.name,
            subTitleText: "\$${product.price.toStringAsFixed(2)}",
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.description, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              // Basic Info
              GFAccordion(
                title: "Basic Info",
                content:
                    "ID: ${product.id}\n"
                    "Material: ${product.material}\n"
                    "Category ID: ${product.category.id}",
              ),
              // Price Info
              GFAccordion(title: "Price", content: "\$${product.price.toStringAsFixed(2)}"),
              // Specs (if available)
              Observer(
                builder: (_) => GFAccordion(
                  title: "Specifications",
                  content: (state.details != null)
                      ? "Weight: ${state.details!.weight} kg\n"
                            "Height: ${state.details!.dimensions.height} m\n"
                            "Width: ${state.details!.dimensions.width} m\n"
                            "Depth: ${state.details!.dimensions.depth} m"
                      : "No connection",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
