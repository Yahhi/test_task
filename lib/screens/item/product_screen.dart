import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:test_task/core/model/product.dart';
import 'package:test_task/screens/item/product_screen_state.dart';

class ProductScreen extends StatelessWidget {
  final ProductScreenState state;

  ProductScreen({required Product product, super.key}) : state = ProductScreenState(product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(state.product.name)),
      body: Observer(
        builder: (_) {
          final product = state.product;
          final details = state.details;
          return SingleChildScrollView(
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
                  if (details != null) ...[
                    GFAccordion(
                      title: "Specifications",
                      content:
                          "Weight: ${details.weight} kg\n"
                          "Height: ${details.dimensions.height} m\n"
                          "Width: ${details.dimensions.width} m\n"
                          "Depth: ${details.dimensions.depth} m",
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
