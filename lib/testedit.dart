import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PdfEditorPage extends StatefulWidget {
  final String pdfPath;

  PdfEditorPage({required this.pdfPath});

  @override
  _PdfEditorPageState createState() => _PdfEditorPageState();
}

class _PdfEditorPageState extends State<PdfEditorPage> {
  late ui.Image pdfImage;
  final List<Widget> _overlays = [];

  @override
  void initState() {
    super.initState();
    _renderPdfToImage(widget.pdfPath);
  }

  Future<void> _renderPdfToImage(String pdfPath) async {
    final document = PdfDocument(inputBytes: File(pdfPath).readAsBytesSync());
    final page = document.pages[0];

    // // Convert the page to an image
    // final pageImage = await page.render(
    //   width: page.getClientSize().width.toInt(),
    //   height: page.getClientSize().height.toInt(),
    //   format: PdfRenderFormat.png,
    // );

    // final decodedImage = await decodeImageFromList(pageImage!);

    // setState(() {
    //   pdfImage = decodedImage;
    // });

    document.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Editor')),
      body: pdfImage == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CustomPaint(
                  size: Size(pdfImage.width.toDouble(), pdfImage.height.toDouble()),
                  painter: PdfPainter(pdfImage),
                ),
                ..._overlays,
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTextOverlay();
        },
        child: const Icon(Icons.text_fields),
      ),
    );
  }

  void _addTextOverlay() {
    setState(() {
      _overlays.add(
        Positioned(
          top: 100,
          left: 50,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                final overlay = _overlays.last as Positioned;
                _overlays[_overlays.length - 1] = Positioned(
                  top: overlay.top! + details.delta.dy,
                  left: overlay.left! + details.delta.dx,
                  child: overlay.child!,
                );
              });
            },
            child: Container(
              width: 200,
              height: 50,
              color: Colors.white.withOpacity(0.8),
              child: const TextField(
                decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Edit text...'),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class PdfPainter extends CustomPainter {
  final ui.Image pdfImage;

  PdfPainter(this.pdfImage);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the PDF image onto the canvas
    canvas.drawImage(pdfImage, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
