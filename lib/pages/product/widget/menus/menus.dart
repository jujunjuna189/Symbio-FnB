import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_simple_v2/pages/product/bloc/bloc_product.dart';
import 'package:pos_simple_v2/pages/product/widget/form/form_product_update.dart';
import 'package:pos_simple_v2/widgets/molecules/modal/modal_delete.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';

class Menus extends StatelessWidget {
  const Menus({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    BlocProduct blocProduct = context.read<BlocProduct>();
    return PopupMenuButton<String>(
      color: ThemeApp.color.white,
      padding: EdgeInsets.zero,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // sudut melengkung
        side: BorderSide(
          // border di sekeliling popup menu
          color: Colors.grey.shade300, // warna border
          width: 1, // ketebalan border
        ),
      ),
      onSelected: (value) {
        if (value == 'ubah') {
          Future.delayed(const Duration(milliseconds: 400), () {
            if (context.mounted) FormProductUpdate.instance.show(context, blocProduct, id: id);
          });
        } else if (value == 'hapus') {
          ModalDelete.instance.show(
            context,
            title: "Produk ini akan dihapus?",
            description:
                "Jika produk di hapus tidak dapat dikembalikan tekan tombol hapus untuk konfirmasi hapus produk",
            onSubmit: () => blocProduct.onDeleteProduct(id: id),
          );
        }
      },
      itemBuilder: (context) => [
        // Item pertama dengan divider di bawahnya
        PopupMenuItem(
          value: 'ubah',
          height: 35,
          child: Row(
            children: [
              Icon(Icons.update, color: Colors.amber, size: 20),
              SizedBox(width: 3),
              const Text('Ubah'),
            ],
          ),
        ),
        // Item terakhir tanpa divider
        PopupMenuItem(
          value: 'hapus',
          height: 35,
          child: Row(
            children: [
              Icon(Icons.delete_outlined, color: Colors.red[900], size: 20),
              SizedBox(width: 3),
              const Text('Hapus'),
            ],
          ),
        ),
      ],
      child: const Icon(Icons.more_vert),
    );
  }
}
