import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final Color hintTextColor;
  final TextEditingController? controller; // Added TextEditingController
  final TextInputType keyboardType;
  final void Function(String)? onChanged;

  const CustomTextFormField({
    Key? key,
    required this.keyboardType,
    this.labelText,
    required this.hintText,
    this.validator,
    this.hintTextColor = Colors.white,
    this.controller, // Added controller
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Assigning controller
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintTextColor,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white, // Default border color
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white, // Default border color
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white, // Border color when focused
          ),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}

class CustomPasswordFormField extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final Color hintTextColor;
  final TextEditingController? controller; // Added TextEditingController
  final void Function(String)? onChanged;

  const CustomPasswordFormField({
    Key? key,
    this.labelText,
    required this.hintText,
    this.validator,
    this.hintTextColor = Colors.white,
    this.controller, // Added controller
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomPasswordFormFieldState createState() => _CustomPasswordFormFieldState();
}

class _CustomPasswordFormFieldState extends State<CustomPasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller, // Assigning controller
      validator: widget.validator,
      onChanged: widget.onChanged,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.hintTextColor,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white, // Default border color
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white, // Default border color
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white, // Border color when focused
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
