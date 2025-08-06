import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:go_router/go_router.dart';
import 'package:test_task/core/router/app_router.dart';

import '../core/model/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return GFCard(
      boxFit: BoxFit.cover,
      title: GFListTile(
        avatar: const GFAvatar(backgroundImage: AssetImage('assets/placeholder.png')),
        titleText: product.name,
        subTitleText: "\$${product.price.toStringAsFixed(2)}",
      ),
      content: Text(product.description, overflow: TextOverflow.ellipsis, maxLines: 2),
      buttonBar: GFButtonBar(
        children: <Widget>[
          GFButton(
            onPressed: () {
              GoRouter.of(context).go(AppRouter.productPath, extra: {'product': product});
            },
            text: 'View Details',
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            color: Colors.blue,
            type: GFButtonType.solid,
          ),
        ],
      ),
    );
  }
}
