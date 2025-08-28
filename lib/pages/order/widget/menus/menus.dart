import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_simple_v2/pages/order/bloc/bloc_order.dart';
import 'package:pos_simple_v2/widgets/molecules/modal/modal_delete.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';

class Menus extends StatelessWidget {
  const Menus({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    BlocOrder blocOrder = context.read<BlocOrder>();
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
        if (value == 'hapus') {
          ModalDelete.instance.show(
            context,
            title: "Riwayat pembayaran ini akan dihapus?",
            description:
                "Jika riwayat ini dihapus tidak dapat dikembalikan, tekan tombol hapus untuk konfirmasi hapus riwayat pembayaran",
            onSubmit: () => blocOrder.onDeleteOrder(id: id),
          );
        }
      },
      itemBuilder: (context) => [
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
