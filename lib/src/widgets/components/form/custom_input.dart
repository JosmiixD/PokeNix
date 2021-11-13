import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {

  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final int maxLines;
  final IconData prefixIcon;
  final TextStyle textStyle;
  
  const CustomInput({
    Key key,
    @required this.hintText,
    @required this.controller,
    @required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.done,
    this.textStyle = const TextStyle( fontSize: 16 ),
    this.maxLines = 1,
  }) : super(key: key);

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only( top: 27),
      child: TextFormField(
        maxLines: this.widget.maxLines,
        style: this.widget.textStyle,
        controller: this.widget.controller,
        cursorColor: Colors.black,
        autocorrect: false,
        keyboardType: this.widget.keyboardType,
        textCapitalization: this.widget.textCapitalization,
        textInputAction: this.widget.textInputAction,
        decoration: InputDecoration(
          prefixIcon: Icon( this.widget.prefixIcon, size: 16,),
          hintText: this.widget.hintText,
          focusColor: Colors.black,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide( color: Colors.black)
          ),
          errorStyle: TextStyle(
            color: Colors.black
          ),
        ),
      ),
    );
  }
}