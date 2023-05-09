import 'package:flutter/material.dart';

class RegistInputForm extends StatelessWidget {
  final FormFieldSetter onSaved;
  final FormFieldValidator validator;

  final String title;
  final String? description;
  final String placeholder;
  final bool? isOnlyNum;
  final bool? isPositionedRight;
  final bool? isTextarea;
  final bool? isHasSuffix;

  static final Color _inputBackground =
      const Color(0xFFD9D9D9).withOpacity(0.15);

  const RegistInputForm({
    super.key,
    required this.title,
    this.description,
    this.isOnlyNum = false,
    required this.onSaved,
    required this.validator,
    this.isPositionedRight = false,
    required this.placeholder,
    this.isTextarea = false,
    this.isHasSuffix = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Title(
          title: title,
        ),
        if (description != null) Description(description: description!),
        const SizedBox(height: 10),
        TextFormField(
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            suffixIcon: isHasSuffix!
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'eth',
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  )
                : const Text(''),
            hintText: placeholder,
            hintStyle: const TextStyle(
                color: Color(0xFF999999),
                fontSize: 14,
                fontWeight: FontWeight.w300),
            filled: true,
            fillColor: _inputBackground,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: _inputBackground),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: _inputBackground),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          maxLines: isTextarea! ? 5 : 1, // 여러 줄의 텍스트 입력 가능
          keyboardType: isTextarea!
              ? TextInputType.multiline
              : isOnlyNum!
                  ? TextInputType.number
                  : TextInputType.text, // 키보드 타입 지정
          textAlign: isPositionedRight! ? TextAlign.end : TextAlign.start,
        ),
      ],
    );
  }
}

class Title extends StatelessWidget {
  static const Color textColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF666666);

  final String title;
  const Title({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, right: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

class Description extends StatelessWidget {
  static const Color textSecondaryColor = Color(0xFF666666);

  final String description;

  const Description({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        description,
        style: const TextStyle(
          color: textSecondaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
