import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PdfViewerPopup extends StatelessWidget {
  final String pdfBase64;

  const PdfViewerPopup({Key? key, required this.pdfBase64}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Uint8List pdfData = base64Decode(pdfBase64);

    return Dialog(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: SfPdfViewer.memory(
          pdfData,
          controller: PdfViewerController(),
        ),
      ),
    );
  }
}
