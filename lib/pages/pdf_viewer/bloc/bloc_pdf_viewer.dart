import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pos_simple_v2/pages/pdf_viewer/state/state_pdf_viewer.dart';

class BlocPdfViewer extends Cubit<StatePdfViewer> {
  BlocPdfViewer({this.arguments}) : super(PdfViewerInitial());

  final String? arguments;

  void initialPage() {
    emit(PdfViewerLoaded(path: (jsonDecode(arguments ?? ''))['path']));
  }

  void onShare() async {
    final currentState = state as PdfViewerLoaded;
    final params = ShareParams(text: 'Great picture', files: [XFile(currentState.path ?? '')]);
    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing the file!');
    }
  }

  @override
  void onChange(Change<StatePdfViewer> change) {
    super.onChange(change);
  }
}
