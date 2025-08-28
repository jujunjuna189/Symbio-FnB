abstract class StatePdfViewer {}

class PdfViewerInitial extends StatePdfViewer {}

class PdfViewerLoading extends StatePdfViewer {}

class PdfViewerLoaded extends StatePdfViewer {
  final String? path;

  PdfViewerLoaded({this.path});

  PdfViewerLoaded copyWith({String? path}) {
    return PdfViewerLoaded(path: path ?? this.path);
  }
}

class PdfViewerAdded extends StatePdfViewer {
  PdfViewerAdded();
}

class PdfViewerError extends StatePdfViewer {
  final String message;

  PdfViewerError(this.message);
}
