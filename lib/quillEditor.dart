import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pfdeditor/quillEditor.dart';
// import 'package:pdf_text/pdf_text.dart' as pdft;
import 'package:pfdeditor/richtexteditor/rich_text_editor.dart';
import 'package:pfdeditor/testedit.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class QuillEditorScreen extends StatefulWidget {
  final String pdfPath;

  const QuillEditorScreen({super.key, required this.pdfPath});

  @override
  State<QuillEditorScreen> createState() => _QuillEditorScreenState();
}

class _QuillEditorScreenState extends State<QuillEditorScreen> {
  bool isPdfLoading = true;
  String extractedText = '';

  final _toolbarColor = Colors.grey.shade200;
  late QuillEditorController quillController;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle = const TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontFamily: 'Roboto');
  final _hintTextStyle = const TextStyle(
      fontSize: 18, color: Colors.black38, fontWeight: FontWeight.normal);
  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.underline,
    ToolBarStyle.headerOne,
    ToolBarStyle.headerTwo,
    ToolBarStyle.strike,
    ToolBarStyle.align,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.directionLtr,
    ToolBarStyle.directionRtl,
    ToolBarStyle.blockQuote,
    ToolBarStyle.link,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
    ToolBarStyle.undo,
    ToolBarStyle.redo,
    ToolBarStyle.color
  ];
  Future<void> loadPdfAndExtractText() async {
    PdfDocument document =
        PdfDocument(inputBytes: File(widget.pdfPath).readAsBytesSync());
//Extract the text from page 1.
    String text = PdfTextExtractor(document).extractText(startPageIndex: 0);
    setState(() {
      isPdfLoading = false;
      extractedText = text;
    });
    document.dispose();
  }

  @override
  void initState() {
    quillController = QuillEditorController();
    quillController.getSelectedHtmlText();
    loadPdfAndExtractText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: isPdfLoading
          ? CircularProgressIndicator()
          : Column(
              children: [
                ToolBar(
                  toolBarColor: _toolbarColor,
                  padding: const EdgeInsets.all(8),
                  iconSize: 19,
                  iconColor: _toolbarIconColor,
                  activeIconColor: Colors.greenAccent.shade400,
                  controller: quillController,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  direction: Axis.horizontal,
                  // toolBarConfig: customToolBarList,
                ),
                Expanded(
                  child: QuillHtmlEditor(
                    text: extractedText,
                    // text: "<h1>Hello</h1>This is a quill html editor example 😊",
                    hintText: 'Hint text goes here',
                    controller: quillController,
                    isEnabled: true,
                    ensureVisible: false,
                    minHeight: 500,
                    autoFocus: false,
                    textStyle: _editorTextStyle,
                    hintTextStyle: _hintTextStyle,
                    hintTextAlign: TextAlign.start,
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    hintTextPadding: const EdgeInsets.only(left: 20),
                    // backgroundColor: ,
                    inputAction: InputAction.newline,
                    onEditingComplete: (s) =>
                        debugPrint('Editing completed $s'),
                    loadingBuilder: (context) {
                      return const Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 1,
                        color: Colors.red,
                      ));
                    },

                    onEditorResized: (height) =>
                        debugPrint('Editor resized $height'),
                    onSelectionChanged: (sel) =>
                        debugPrint('index ${sel.index}, range ${sel.length}'),
                  ),
                ),

              ],
            ),
    ));
  }
}
