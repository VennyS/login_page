import 'package:flutter/material.dart';

class TextFieldComponents extends StatefulWidget {
  const TextFieldComponents({super.key});

  @override
  State<TextFieldComponents> createState() => _TextFieldComponentsState();
}

class _TextFieldComponentsState extends State<TextFieldComponents> {
  bool emptyShowPussword = true;
  bool typingShowPussword = true;
  bool filledShowPussword = true;
  bool errorShowPussword = true;

  late FocusNode emptyPasswordFocusNode;
  late FocusNode typingPasswordFocusNode;
  late FocusNode filledPasswordFocusNode;
  late FocusNode errorPasswordFocusNode;

  @override
  void initState() {
    super.initState();
    emptyPasswordFocusNode = FocusNode();
    typingPasswordFocusNode = FocusNode();
    filledPasswordFocusNode = FocusNode();
    errorPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    emptyPasswordFocusNode.dispose();
    typingPasswordFocusNode.dispose();
    filledPasswordFocusNode.dispose();
    errorPasswordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _emptyTextField();
  }

  Widget _emptyTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (String emptyTyping) {},
        focusNode: emptyPasswordFocusNode,
        onTap: () {
          setState(() {
            FocusScope.of(context).unfocus();
            FocusScope.of(context).requestFocus(emptyPasswordFocusNode);
          });
        },
        obscureText: emptyShowPussword,
        decoration: InputDecoration(
          labelText: 'Title',
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade700)),
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

  Widget _typingTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (String typing) {},
        focusNode: typingPasswordFocusNode,
        onTap: () {
          setState(() {
            FocusScope.of(context).unfocus();
            FocusScope.of(context).requestFocus(typingPasswordFocusNode);
          });
        },
        obscureText: typingShowPussword,
        decoration: InputDecoration(
          labelText: 'Title',
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2)),
          hintText: 'Введите текст',
          suffixIcon: IconButton(
            icon: const Icon(Icons.remove_red_eye),
            onPressed: () {
              setState(() {
                typingShowPussword = !typingShowPussword;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _filledTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (String filledTyping) {}, //filled
        focusNode: filledPasswordFocusNode,
        onTap: () {
          setState(() {
            FocusScope.of(context).unfocus();
            FocusScope.of(context).requestFocus(filledPasswordFocusNode);
          });
        },
        obscureText: filledShowPussword,
        decoration: InputDecoration(
          labelText: 'Title',
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade700)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade700)),
          hintText: 'Введите текст',
          suffixIcon: IconButton(
            icon: const Icon(Icons.remove_red_eye),
            onPressed: () {
              setState(() {
                filledShowPussword = !filledShowPussword;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _errorTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (String errorTyping) {}, //error
        focusNode: errorPasswordFocusNode,
        onTap: () {
          setState(() {
            FocusScope.of(context).unfocus();
            FocusScope.of(context).requestFocus(errorPasswordFocusNode);
          });
        },
        obscureText: errorShowPussword,
        decoration: InputDecoration(
          labelText: 'Title',
          errorText: 'Error',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: 'Введите текст',
          suffixIcon: IconButton(
            icon: const Icon(Icons.remove_red_eye),
            color: Colors.red,
            onPressed: () {
              setState(() {
                errorShowPussword = !errorShowPussword;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _inactiveTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (String inactiveTyping) {}, //inactive
        decoration: InputDecoration(
            labelText: 'Title',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.grey)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.grey)),
            hintText: 'Введите текст',
            filled: true,
            fillColor: Colors.grey.shade50),
      ),
    );
  }
}
