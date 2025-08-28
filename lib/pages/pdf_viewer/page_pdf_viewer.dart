import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pos_simple_v2/pages/pdf_viewer/bloc/bloc_pdf_viewer.dart';
import 'package:pos_simple_v2/pages/pdf_viewer/state/state_pdf_viewer.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';

class PagePdfViewer extends StatelessWidget {
  const PagePdfViewer({super.key});

  @override
  Widget build(BuildContext context) {
    BlocPdfViewer blocPdfViewer = context.read<BlocPdfViewer>();

    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<BlocPdfViewer, StatePdfViewer>(
                bloc: blocPdfViewer,
                builder: (context, state) {
                  final currentState = state as PdfViewerLoaded;
                  return PDFView(
                    filePath: currentState.path,
                    fitPolicy: FitPolicy.BOTH, // Sesuaikan dengan lebar & tinggi layar
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: true,
                    pageFling: true,
                    backgroundColor: Colors.grey,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GestureDetector(
                onTap: () => blocPdfViewer.onShare(),
                child: Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: ThemeApp.color.primary),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.share_rounded, color: Colors.black, size: 18),
                      const SizedBox(width: 10),
                      Text("Bagikan", style: ThemeApp.font.semiBold.copyWith(color: ThemeApp.color.black)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
