import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc_pattern_example/models/cart.dart';
import 'package:flutter_bloc_pattern_example/widgets/cart_button.dart';
import 'package:flutter_bloc_pattern_example/cart/cart_bloc.dart';
import 'package:flutter_bloc_pattern_example/catalog/catalog_bloc.dart';
import 'package:flutter_bloc_pattern_example/main.dart'
    as bloc_complex;
import 'package:flutter_bloc_pattern_example/services/catalog.dart';

void main() {
  testWidgets('bloc_complex', (WidgetTester tester) async {
    // We need runAsync here because CatalogBloc uses a Timer
    // (via RX bufferTime). For more info:
    // https://github.com/flutter/flutter/issues/17738
    await tester.runAsync(() async {
      final catalogService = CatalogService();
      final catalog = CatalogBloc(catalogService);
      final cart = CartBloc();
      final app = bloc_complex.MyApp(catalog, cart);

      // The product name is generated in bloc_complex, so no "Socks" here.
      final productName = "Product 43740 (#0)";

      await tester.pumpWidget(app);

      expect(find.text("0"), findsOneWidget);

      await tester.tap(find.byType(CartButton));
      await tester.pumpAndSettle();

      expect(find.text("Empty"), findsOneWidget);

      await tester.pageBack();
      // We need this piece of real asynchrony here so that the bloc can
      // do its thing.
      await Future.delayed(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      await tester.tap(find.text(productName));
      await tester.pumpAndSettle();

      expect(find.text("1"), findsOneWidget);

      await tester.tap(find.byType(CartButton));
      await tester.pumpAndSettle();

      expect(find.text("Empty"), findsNothing);
      expect(find.text(productName), findsOneWidget);
    });
  });
}

/// Verifies that the app compiles and runs, and that tapping products
/// adds them to cart.
///
/// This test exists to ensure that the sample works with future versions
/// of Flutter.
Future _performSmokeTest(WidgetTester tester, Widget app) async {
  await tester.pumpWidget(app);

  expect(find.text("0"), findsOneWidget);

  await tester.tap(find.byType(CartButton));
  await tester.pumpAndSettle();

  expect(find.text("Empty"), findsOneWidget);

  await tester.pageBack();
  await tester.pumpAndSettle();

  await tester.tap(find.text("Socks"));
  await tester.pumpAndSettle();

  expect(find.text("1"), findsOneWidget);

  await tester.tap(find.byType(CartButton));
  await tester.pumpAndSettle();

  expect(find.text("Empty"), findsNothing);
  expect(find.text("Socks"), findsOneWidget);
}
