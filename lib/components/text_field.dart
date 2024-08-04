import 'package:flutter/material.dart';

class TextFieldComponents extends StatefulWidget {
  const TextFieldComponents({super.key});

  @override
  State<TextFieldComponents> createState() =>
      _TextFieldComponentsState(emptyPasswordFocusNode: FocusNode());
}

class _TextFieldComponentsState extends State<TextFieldComponents> {
  bool emptyShowPussword = true;

  late FocusNode emptyPasswordFocusNode;

  String errorText = '';

  final typingStateColor = const Color(0xFF006FFD);
  final emptyStateColor = const Color(0xFFC5C6CC);

  _TextFieldComponentsState({
    required this.emptyPasswordFocusNode,
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emptyPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emptyPasswordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _emptyTextField();
  }

  Widget _emptyTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            if (value.length > 11) {
              errorText = 'Error';
            } else {
              errorText = '';
            }
          });
        },
        focusNode: emptyPasswordFocusNode,
        enabled: true, //если установить false , то будет состояние inactive
        onTap: () {
          setState(() {
            FocusScope.of(context).unfocus();
            FocusScope.of(context).requestFocus(emptyPasswordFocusNode);
          });
        },
        obscureText: emptyShowPussword,
        decoration: InputDecoration(
          errorText: errorText.isEmpty ? null : errorText,
          //labelText: 'Title',                   //title
          border: OutlineInputBorder(
            //борт для Error состояния
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
              //борт в typing состоянии
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: typingStateColor, width: 2)),
          enabledBorder: OutlineInputBorder(
              //борт в empty состоянии
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: emptyStateColor, width: 1)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.remove_red_eye),
            onPressed: () {
              setState(() {
                emptyShowPussword = !emptyShowPussword;
              });
            },
          ),
          hintText: 'Введите текст',
        ),
      ),
    );
  }
}
