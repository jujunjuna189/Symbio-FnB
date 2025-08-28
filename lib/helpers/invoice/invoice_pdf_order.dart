import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_simple_v2/databases/order/model/model_order.dart';
import 'package:pos_simple_v2/databases/order/model/model_order_product.dart';
import 'package:pos_simple_v2/helpers/formatter/price_formatter.dart';

class InvoicePdfOrder {
  InvoicePdfOrder._privateConstructor();
  static final InvoicePdfOrder instance = InvoicePdfOrder._privateConstructor();

  Future<String> generate(BuildContext context, {ModelOrder? order, List<ModelOrderProduct>? products}) async {
    // Create a PDF document
    final pdf = pw.Document();

    final fontData = await rootBundle.load('lib/assets/font/AlumniSans-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    // Define the receipt layout
    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(70 * PdfPageFormat.mm, double.infinity, marginAll: 5),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "POTONG AYAM HEGAR",
                    style: pw.TextStyle(font: ttf, fontSize: 20, fontWeight: pw.FontWeight.bold),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                "Jl. Raya Ciakar, Kawali, Kec. Cipaku, Kabupaten Ciamis, Jawa Barat 46253",
                style: pw.TextStyle(font: ttf, fontSize: 11),
                textAlign: pw.TextAlign.center,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Telepon: 0812-2221-5665",
                    style: pw.TextStyle(font: ttf, fontSize: 11),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Divider(height: 0.2, borderStyle: pw.BorderStyle.dashed),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(
                    width: 50,
                    child: pw.Text(
                      "Nomor",
                      style: pw.TextStyle(font: ttf, fontSize: 11, fontWeight: pw.FontWeight.normal),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      ": ${order?.number ?? ''}",
                      style: pw.TextStyle(font: ttf, fontSize: 11, fontWeight: pw.FontWeight.normal),
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(
                    width: 50,
                    child: pw.Text(
                      "Tanggal",
                      style: pw.TextStyle(font: ttf, fontSize: 11, fontWeight: pw.FontWeight.normal),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      ": ${order?.createdAt ?? ''} WIB",
                      style: pw.TextStyle(font: ttf, fontSize: 11, fontWeight: pw.FontWeight.normal),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Divider(height: 0.2, borderStyle: pw.BorderStyle.dashed),
              pw.SizedBox(height: 10),
              // Contoh item belanjaan
              pw.Column(
                children: (products ?? []).asMap().entries.map((item) {
                  return pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        child: pw.Text(item.value.name, style: pw.TextStyle(font: ttf, fontSize: 12)),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Text(
                        "${item.value.quantity.toString()}/${item.value.unit}",
                        style: pw.TextStyle(font: ttf, fontSize: 12),
                      ),
                      pw.SizedBox(width: 5),
                      pw.SizedBox(
                        child: pw.Text(
                          PriceFormatter.instance.decimal(item.value.price, decimalDigits: 0),
                          style: pw.TextStyle(font: ttf, fontSize: 12),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                      pw.SizedBox(width: 7),
                      pw.SizedBox(
                        width: 35,
                        child: pw.Text(
                          PriceFormatter.instance.decimal(item.value.subTotal, decimalDigits: 0),
                          style: pw.TextStyle(font: ttf, fontSize: 12),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),

              pw.SizedBox(height: 10),
              pw.Divider(height: 0.2, borderStyle: pw.BorderStyle.dashed),
              pw.SizedBox(height: 5),
              // Total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      "Subtotal :",
                      style: pw.TextStyle(font: ttf, fontSize: 12, fontWeight: pw.FontWeight.normal),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                  pw.SizedBox(
                    width: 50,
                    child: pw.Text(
                      PriceFormatter.instance.decimal((order?.total ?? 0), decimalDigits: 0),
                      style: pw.TextStyle(font: ttf, fontSize: 12, fontWeight: pw.FontWeight.normal),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      "Ppn :",
                      style: pw.TextStyle(font: ttf, fontSize: 12, fontWeight: pw.FontWeight.normal),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                  pw.SizedBox(
                    width: 50,
                    child: pw.Text(
                      "-",
                      style: pw.TextStyle(font: ttf, fontSize: 12, fontWeight: pw.FontWeight.normal),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [pw.SizedBox(width: 100, child: pw.Divider(height: 0.2, borderStyle: pw.BorderStyle.dashed))],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      "Total :",
                      style: pw.TextStyle(font: ttf, fontSize: 12, fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                  pw.SizedBox(
                    width: 50,
                    child: pw.Text(
                      PriceFormatter.instance.decimal((order?.total ?? 0), decimalDigits: 0),
                      style: pw.TextStyle(font: ttf, fontSize: 12, fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [pw.SizedBox(width: 100, child: pw.Divider(height: 0.2, borderStyle: pw.BorderStyle.dashed))],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      "Tunai :",
                      style: pw.TextStyle(font: ttf, fontSize: 12, fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                  pw.SizedBox(
                    width: 50,
                    child: pw.Text(
                      PriceFormatter.instance.decimal((order?.paid ?? 0), decimalDigits: 0),
                      style: pw.TextStyle(font: ttf, fontSize: 12, fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      "Kembali :",
                      style: pw.TextStyle(font: ttf, fontSize: 12, fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                  pw.SizedBox(
                    width: 50,
                    child: pw.Text(
                      PriceFormatter.instance.decimal((order?.change ?? 0), decimalDigits: 0),
                      style: pw.TextStyle(font: ttf, fontSize: 12, fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Divider(height: 0.2, borderStyle: pw.BorderStyle.dashed),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Terima Kasih sudah berbelanja!",
                    style: pw.TextStyle(font: ttf, fontSize: 14),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
            ],
          );
        },
      ),
    );

    // Save Pdf
    final directory = await getExternalStorageDirectory();

    String filePath = '${directory!.path}/example.pdf';
    File file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return filePath;
  }
}
