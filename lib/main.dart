// import 'dart:developer';
// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:pfdeditor/quillEditor.dart';
// // import 'package:pdf_text/pdf_text.dart' as pdft;
// import 'package:pfdeditor/richtexteditor/rich_text_editor.dart';
// import 'package:pfdeditor/testedit.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// void main() {
//   runApp( MaterialApp(
//     title: 'Syncfusion PDF Viewer Demo',
//     home: PdfViewerPage(),
//   )); 
// }


// class PdfViewerPage extends StatefulWidget {
//   @override
//   _PdfViewerPageState createState() => _PdfViewerPageState();
// }

// class _PdfViewerPageState extends State<PdfViewerPage> {
//   PdfViewerController? _pdfViewerController;

//   @override
//   void initState() {
//     super.initState();
//     _pdfViewerController = PdfViewerController();
//   }

//   Future<void> _pickAndDisplayPdf() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null && result.files.single.path != null) {
//       String filePath = result.files.single.path!;

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => QuillEditorScreen(pdfPath: filePath)
//           // PdfEditorScreen(pdfPath: filePath),
//         ),
//       );
//     } else {
//       // User canceled the picker
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No file selected')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PDF Viewer'),
//       ),
//       body: Center(
//         child:
//         // RichTextEditor()
//          ElevatedButton(
//           onPressed: _pickAndDisplayPdf,
//           child: const Text('Pick PDF and Open'),
//         ),
//       ),
//     );
//   }
// }











// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// class PdfEditor extends StatefulWidget {
//   final String filePath;

//   PdfEditor({required this.filePath});

//   @override
//   _PdfEditorState createState() => _PdfEditorState();
// }

// class _PdfEditorState extends State<PdfEditor> {
//     String extractedText = '';

//   @override
//   void initState() {
//     super.initState();
//     // _loadPdfAndExtractText();
//   }

//   Future<void> _loadPdfAndExtractText() async {
//  //Load an existing PDF document.
// PdfDocument document =
//    PdfDocument(inputBytes:  File(widget.filePath).readAsBytesSync());
// //Extract the text from page 1.
// String text = PdfTextExtractor(document).extractText(startPageIndex: 0);
// //Dispose the document.
// log(text);
//     setState(() {
//       extractedText = text;
//     });
//     document.dispose();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Editor'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: () {
//               // Handle saving of the edited PDF here
//             },
//           ),
//         ],
//       ),
//       body:PdfEditor(filePath: widget.filePath)
//       // RichTextEditor(
//       //   defaultContent: extractedText,
//       // )
//       //  Stack(
//       //   children: [
//       //     SfPdfViewer.file(
//       //       File(widget.filePath),
//       //     ),
//       //     ...annotations,
//       //   ],
//       // ),
//     );
//   }
// }













import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_image_renderer/pdf_image_renderer.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int pageIndex = 0;
  Uint8List? image;

  bool open = false;

  PdfImageRendererPdf? pdf;
  int? count;
  PdfImageRendererPageSize? size;

  bool cropped = false;

  int asyncTasks = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> renderPage() async {
    size = await pdf!.getPageSize(pageIndex: pageIndex);
    final i = await pdf!.renderPage(
      pageIndex: pageIndex,
      x: cropped ? 100 : 0,
      y: cropped ? 100 : 0,
      width: cropped ? 100 : size!.width,
      height: cropped ? 100 : size!.height,
      scale: 3,
      background: Colors.white,
    );

    setState(() {
      image = i;
    });
  }

  Future<void> renderPageMultipleTimes() async {
    const count = 50;

    await pdf!.openPage(pageIndex: pageIndex);

    size = await pdf!.getPageSize(pageIndex: pageIndex);

    asyncTasks = count;

    final renderFutures = <Future<Uint8List?>>[];
    for (var i = 0; i < count; i++) {
      final future = pdf!.renderPage(
        pageIndex: pageIndex,
        x: (size!.width / count * i).round(),
        y: (size!.height / count * i).round(),
        width: (size!.width / count).round(),
        height: (size!.height / count).round(),
        scale: 3,
        background: Colors.white,
      );

      renderFutures.add(future);

      future.then((value) {
        setState(() {
          asyncTasks--;
        });
      });
    }

    await Future.wait(renderFutures);

    await pdf!.closePage(pageIndex: pageIndex);
  }

  Future<void> openPdf({required String path}) async {
    // if (pdf != null) {
      // await pdf!.close();
    // }
    pdf = PdfImageRendererPdf(path: path);
    await pdf!.open();
    setState(() {
      open = true;
    });
  }

  Future<void> closePdf() async {
    if (pdf != null) {
      await pdf!.close();
      setState(() {
        pdf = null;
        open = false;
      });
    }
  }

  Future<void> openPdfPage({required int pageIndex}) async {
    await pdf!.openPage(pageIndex: pageIndex);
  }

  Future<void> closePdfPage({required int pageIndex}) async {
    await pdf!.closePage(pageIndex: pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            if (open == true)
              IconButton(
                icon: const Icon(Icons.crop),
                onPressed: () async {
                  cropped = !cropped;
                  await renderPage();
                },
              )
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Select PDF'),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom, allowedExtensions: ['pdf']);

                    if (result != null) {
                      await openPdf(path: result.paths[0]!);
                      pageIndex = 0;
                      count = await pdf!.getPageCount();
                      await renderPage();
                    }
                  },
                ),
                if (count != null) Text('The selected PDF has $count pages.'),
                if (image != null)
                  Text('It is ${size!.width} wide and ${size!.height} high.'),
                if (open == true)
                  ElevatedButton(
                    child: const Text('Close PDF'),
                    onPressed: () async {
                      await closePdf();
                    },
                  ),
                if (image != null) ...[
                  const Text('Rendered image area:'),
                  Image(image: MemoryImage(image!)),
                ],
                if (open == true) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton.icon(
                        onPressed: pageIndex > 0
                            ? () async {
                                pageIndex -= 1;
                                await renderPage();
                              }
                            : null,
                        icon: const Icon(Icons.chevron_left),
                        label: const Text('Previous'),
                      ),
                      TextButton.icon(
                        onPressed: pageIndex < (count! - 1)
                            ? () async {
                                pageIndex += 1;
                                await renderPage();
                              }
                            : null,
                        icon: const Icon(Icons.chevron_right),
                        label: const Text('Next'),
                      ),
                    ],
                  ),
                  if (asyncTasks <= 0)
                    TextButton(
                      onPressed: () {
                        renderPageMultipleTimes();
                      },
                      child: const Text('Async rendering test'),
                    ),
                  if (asyncTasks > 0) Text('$asyncTasks remaining tasks'),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}