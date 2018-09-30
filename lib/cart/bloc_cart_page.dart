import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern_example/models/cart_item.dart';
import 'package:flutter_bloc_pattern_example/widgets/cart_page.dart';
import 'package:flutter_bloc_pattern_example/cart/cart_provider.dart';

class BlocCartPage extends StatelessWidget {
  BlocCartPage();

  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: StreamBuilder<List<CartItem>>(
          stream: cart.items,
          builder: (context, snapshot) {
            if (snapshot.data?.isEmpty ?? true) {
              return Center(
                  child: Text('Empty',
                      style: Theme.of(context).textTheme.display1));
            }

            return ListView(
                children:
                    snapshot.data.map((item) => ItemTile(item: item)).toList());
          }),
    );
  }
}
