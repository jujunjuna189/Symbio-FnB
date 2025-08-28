import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pos_simple_v2/helpers/formatter/price_formatter.dart';
import 'package:pos_simple_v2/pages/product/bloc/bloc_product.dart';
import 'package:pos_simple_v2/pages/product/state/state_product.dart';
import 'package:pos_simple_v2/pages/product/widget/menus/menus.dart';
import 'package:pos_simple_v2/pages/product/widget/modal/modal_product_order.dart';
import 'package:pos_simple_v2/routes/route_name.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';
import 'package:pos_simple_v2/widgets/molecules/empty/empty_no_data.dart';
import 'package:pos_simple_v2/widgets/molecules/image/get_image.dart';
import 'package:pos_simple_v2/widgets/molecules/navigation/navigation_floating.dart';

class PageProduct extends StatelessWidget {
  const PageProduct({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProduct blocProduct = context.read<BlocProduct>();
    return Scaffold(
      backgroundColor: ThemeApp.color.grey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: BlocBuilder<BlocProduct, StateProduct>(
            bloc: blocProduct,
            builder: (context, state) {
              if (state is ProductLoading) {
                return Container();
              } else if (state is ProductLoaded && state.products.isNotEmpty) {
                return SingleChildScrollView(
                  child: StaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: state.products.asMap().entries.map((item) {
                      return GestureDetector(
                        onTap: () =>
                            ModalProductOrder.instance.show(context, blocProduct: blocProduct, product: item.value),
                        child: Container(
                          height: 235,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image placeholder
                              Container(
                                height: 150, // Adjust height as needed
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: ThemeApp.color.primary.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: item.value.image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: GetImage(path: item.value.image ?? ''),
                                      )
                                    : Container(),
                              ),
                              const SizedBox(height: 8.0),
                              // First text line placeholder
                              Text(item.value.name, style: ThemeApp.font.bold, overflow: TextOverflow.ellipsis),
                              Expanded(child: Container()),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${PriceFormatter.instance.decimal(double.parse(item.value.price.toString()), decimalDigits: 0)}/${item.value.unit}",
                                          style: ThemeApp.font.regular.copyWith(fontSize: 11, color: Colors.grey),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        // Second text line placeholder
                                        Text(
                                          PriceFormatter.instance.price(
                                            double.parse(item.value.price.toString()),
                                            decimalDigits: 0,
                                          ),
                                          style: ThemeApp.font.bold.copyWith(color: Colors.blueGrey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Menus(id: item.value.id ?? 0),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: const EmptyNoData(
                        title: "Produk belum ditambahkan",
                        description: "Klik menu berwarna dan tekan tombol menu '+' untuk menambah produk",
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [ThemeApp.color.white, ThemeApp.color.white]),
              boxShadow: [
                BoxShadow(color: ThemeApp.color.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                BlocBuilder<BlocProduct, StateProduct>(
                  bloc: blocProduct,
                  builder: (context, state) {
                    final currentState = state as ProductLoaded;
                    if (currentState.carts.isNotEmpty) {
                      return Positioned(
                        top: -6,
                        right: -6,
                        child: Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              currentState.carts.length.toString(),
                              style: ThemeApp.font.medium.copyWith(color: ThemeApp.color.white, fontSize: 12),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart, color: ThemeApp.color.secondary, size: 20),
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteName.CART).then((res) {
                      blocProduct.onGetCart();
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [ThemeApp.color.yellow, ThemeApp.color.primary]),
              boxShadow: [
                BoxShadow(color: ThemeApp.color.primary.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.menu_open, color: ThemeApp.color.secondary, size: 30),
              onPressed: () {
                NavigationFloating.instance.showFloatingMenu(context, blocProduct);
              },
            ),
          ),
        ],
      ),
    );
  }
}
