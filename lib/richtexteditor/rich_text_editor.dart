// // Automatic FlutterFlow imports
// // import '/flutter_flow/flutter_flow_theme.dart';
// // import '/flutter_flow/flutter_flow_util.dart';
// // import 'index.dart'; // Imports other custom widgets
// import 'package:flutter/material.dart';
// // Begin custom widget code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// // import 'package:flutter/foundation.dart';

// // import 'dart:collection';
// import 'package:html_editor_enhanced/html_editor.dart';

// class RichTextEditor extends StatefulWidget {
//   const RichTextEditor({
//     super.key,
//     this.width,
//     this.height,
//     this.darkMode,
//     this.spellCheck,
//     this.dropdownBackgroundColor,
//     this.dropdownButtonColor,
//     this.dropdownTextColor,
//     this.editorBackgroundColor,
//     this.editorTextColor,
//     this.hint, this.defaultContent,
//   });
//   final  String? defaultContent ;
//   final double? width;
//   final double? height;
//   final bool? darkMode;
//   final bool? spellCheck;
//   final Color? dropdownBackgroundColor;
//   final Color? dropdownButtonColor;
//   final Color? dropdownTextColor;
//   final Color? editorBackgroundColor;
//   final Color? editorTextColor;
//   final String? hint;

//   @override
//   State<RichTextEditor> createState() => _RichTextEditorState();
// }

// class _RichTextEditorState extends State<RichTextEditor> {
//   late HtmlEditorController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = HtmlEditorController(
//       processNewLineAsBr: true,
//     );
//     setDefaultContent();
//   }

//   void setDefaultContent() {
//     // String defaultContent = FFAppState().HTMLMessage ?? '';
  
//     controller.setText(widget.defaultContent??""); // Corrected controller reference
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: widget.width,
//       height: widget.height,
//       child: HtmlEditor(
//         controller: controller,
//         htmlEditorOptions: HtmlEditorOptions(
//           hint: widget.hint ?? "Type here...",
//           initialText: widget.defaultContent,
//           // FFAppState().HTMLMessage ?? '',
//           //     webInitialScripts: UnmodifiableListView([
//           //       WebScript(name: 'setThemeStyle', script: """
//           //            document.getElementsByClassName('note-editable')[0].style.color = '${widget.editorTextColor?.value.toRadixString(16).padLeft(8, '0').substring(2)}' ?? 'white';
//           //   document.getElementsByClassName('note-editable')[0].style.background = '${widget.editorBackgroundColor?.value.toRadixString(16).padLeft(8, '0').substring(2)}' ?? '##00FFFFFF';
//           // """),
//           //     ]),
//           // webInitialScripts:
//           //     kIsWeb // Conditionally execute script for web platform
//           //         ? UnmodifiableListView([
//           //             WebScript(name: 'setThemeStyle', script: """
//           //            document.getElementsByClassName('note-editable')[0].style.color = '${widget.editorTextColor?.value.toRadixString(16).padLeft(8, '0').substring(2)}' ?? 'white';
//           //            document.getElementsByClassName('note-editable')[0].style.background = '${widget.editorBackgroundColor?.value.toRadixString(16).padLeft(8, '0').substring(2)}' ?? '##00FFFFFF';
//           //         """),
//           //           ])
//           //         : null,
//           darkMode: widget.darkMode ?? false,
//           spellCheck: widget.spellCheck ?? true,
//         ),
//         callbacks: Callbacks(onChangeContent: (String? htmlContent) {
//           // FFAppState().HTMLMessage = htmlContent ?? '';
//         }, onInit: () {
//           // controller.evaluateJavascriptWeb('setThemeStyle');
//         }),
//         htmlToolbarOptions: HtmlToolbarOptions(
//           // Customize the appearance of the toolbar
//           // defaultToolbarButtons: [
//           //   StyleButtons(),
//           //   ParagraphButtons(),
//           //   InsertButtons(),
//           // ],
//           // customToolbarButtons: [
//           //   // Add your custom buttons here if needed
//           // ],
//           // customToolbarInsertionIndices: [
//           //   // Specify indices for custom buttons if needed
//           // ],

//           textStyle: TextStyle(
//             fontSize: 12,
//             color: widget.dropdownTextColor ?? Colors.black,
//           ),
//           dropdownBackgroundColor:
//               widget.dropdownBackgroundColor ?? Colors.white,
//           buttonColor: widget.dropdownButtonColor ?? Colors.black,
//           gridViewHorizontalSpacing: 3,
//           toolbarType: ToolbarType
//               .nativeGrid, // Specify if toolbar is full or expandable e.g ToolbarType.nativeExpandable,
//           gridViewVerticalSpacing: 2,
//           // toolbarItemHeight: 30,
//           toolbarPosition: ToolbarPosition.aboveEditor,
//           renderSeparatorWidget: false,
//           // You can adjust other styling options based on your preference
//         ),
//         otherOptions: OtherOptions(
//           height: 1000.0,
//         ),
//       ),
//     );
//   }
// }
