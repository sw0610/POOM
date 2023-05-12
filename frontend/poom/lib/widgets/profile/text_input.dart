import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  static const Color _textColor = Color(0xFF333333);
  static const Color _inputBackgroundColor = Color(0xFFFAFAFA);
  const TextInput({
    super.key,
    required this.initValue,
    required this.title,
    required this.placeholder,
    required this.onSaved,
    required this.onChanged,
    required this.validator,
  });

  final String initValue, title, placeholder;
  final FormFieldSetter onSaved, onChanged;
  final FormFieldValidator validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const Text(
            "*",
            style: TextStyle(
              color: Color(
                0xFFFF4040,
              ),
            ),
          )
        ]),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          initialValue: initValue,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: _inputBackgroundColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 0, color: _inputBackgroundColor),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 0, color: _inputBackgroundColor),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          onSaved: onSaved,
          validator: validator,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
