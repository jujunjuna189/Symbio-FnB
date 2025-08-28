import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class GetImage extends StatefulWidget {
  final String path;

  const GetImage({super.key, required this.path});

  @override
  State<GetImage> createState() => _GetImageState();
}

class _GetImageState extends State<GetImage> {
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _decodeBase64();
  }

  @override
  void didUpdateWidget(covariant GetImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _decodeBase64();
    }
  }

  void _decodeBase64() {
    try {
      _imageBytes = base64Decode(widget.path);
    } catch (_) {
      _imageBytes = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_imageBytes == null) {
      return Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }

    return Image.memory(
      _imageBytes!,
      fit: BoxFit.cover,
      gaplessPlayback: true, // **Penting: cegah gambar flicker**
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
    );
  }
}
