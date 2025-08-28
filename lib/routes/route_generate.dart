import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_simple_v2/pages/cart/bloc/bloc_cart.dart';
import 'package:pos_simple_v2/pages/cart/page_cart.dart';
import 'package:pos_simple_v2/pages/order/bloc/bloc_order.dart';
import 'package:pos_simple_v2/pages/order/page_order.dart';
import 'package:pos_simple_v2/pages/order_detail/bloc/bloc_order_detail.dart';
import 'package:pos_simple_v2/pages/order_detail/page_order_detail.dart';
import 'package:pos_simple_v2/pages/pdf_viewer/bloc/bloc_pdf_viewer.dart';
import 'package:pos_simple_v2/pages/pdf_viewer/page_pdf_viewer.dart';
import 'package:pos_simple_v2/pages/product/bloc/bloc_product.dart';
import 'package:pos_simple_v2/pages/product/page_product.dart';
import 'package:pos_simple_v2/routes/route_name.dart';

class RouteGenerate {
  static Route onRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments;
    switch (settings.name) {
      case RouteName.INITIAL:
        return MaterialPageRoute(
          builder: (context) =>
              BlocProvider(create: (context) => BlocProduct()..initialPage(), child: const PageProduct()),
        );
      case RouteName.CART:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(create: (context) => BlocCart()..initialPage(), child: const PageCart()),
        );
      case RouteName.ORDER:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(create: (context) => BlocOrder()..initialPage(), child: const PageOrder()),
        );
      case RouteName.ORDER_DETAIL:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => BlocOrderDetail(arguments: args is String ? args : '')..initialPage(),
            child: const PageOrderDetail(),
          ),
        );
      case RouteName.PDF_VIEWER:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => BlocPdfViewer(arguments: args is String ? args : '')..initialPage(),
            child: const PagePdfViewer(),
          ),
        );
      default:
        return MaterialPageRoute(builder: (context) => _errorRoute());
    }
  }

  static List<dynamic> pageProvider(BuildContext context) {
    List<dynamic> providers = [BlocProvider(create: (context) => BlocProduct())];

    return providers;
  }

  static Widget _errorRoute() {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('ERROR')),
    );
  }
}
