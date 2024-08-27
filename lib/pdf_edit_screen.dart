// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:pdf_render/pdf_render.dart';
// // import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// // import 'package:path_provider/path_provider.dart';

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf_render/pdf_render.dart';

// class PdfEditScreen extends StatefulWidget {
//   final String filePath;

//   PdfEditScreen({required this.filePath});

//   @override
//   _PdfEditScreenState createState() => _PdfEditScreenState();
// }

// class _PdfEditScreenState extends State<PdfEditScreen> {
//   late PdfDocument pdfDocument;
//   late List<PdfPageImage?> pdfPages;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadPdf();
//   }

//   Future<void> _loadPdf() async {
//     pdfDocument = await PdfDocument.openFile(widget.filePath);
//     pdfPages = List<PdfPageImage?>.filled(pdfDocument.pageCount, null);
    
//     setState(() {
//          isLoading = false;
//     });
 
//   }

//   Future<void> _savePdf() async {
//     final pw.Document pdf = pw.Document();

//     for (int i = 0; i < pdfDocument.pageCount; i++) {
//       final pageImage = pdfPages[i];
//       if (pageImage != null) {
//         pdf.addPage(
//           pw.Page(
//             build: (pw.Context context) {
//               return pw.Image(pw.MemoryImage(pageImage.pixels));
//             },
//           ),
//         );
//       }
//     }

//     final outputDir = await getApplicationDocumentsDirectory();
//     final outputFile = File("${outputDir.path}/edited_output.pdf");
//     await outputFile.writeAsBytes(await pdf.save());

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('PDF saved to ${outputFile.path}')),
//     );
//   }

//   Future<void> _renderPage(int pageIndex) async {
//     final page = await pdfDocument.getPage(pageIndex + 1);
//     final pageImage = await page.render(
//       // width: page.width,
//       // height: page.height,
//       // format: PdfPageImageFormat.png,
//     );
//     pdfPages[pageIndex] = pageImage;
//     // await page.close();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit PDF'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: _savePdf,
//           ),
//         ],
//       ),
//       body: isLoading?CircularProgressIndicator(color: Colors.amber,):
//       pdfDocument == null
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: pdfDocument.pageCount,
//               itemBuilder: (context, index) {
//                 if (pdfPages[index] == null) {
//                   _renderPage(index);
//                   return Center(child: CircularProgressIndicator());
//                 } else {
//                   return Stack(
//                     children: [
//                       Image.memory(pdfPages[index]!.pixels),
//                       Positioned(
//                         bottom: 10,
//                         right: 10,
//                         child: IconButton(
//                           icon: Icon(Icons.edit, color: Colors.red),
//                           onPressed: () {
//                             // TODO: Add annotation or editing logic here
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             ),
//     );
//   }
// }
