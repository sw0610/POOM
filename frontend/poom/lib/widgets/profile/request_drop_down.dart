import 'package:flutter/material.dart';

class RequestDropDown extends StatefulWidget {
  const RequestDropDown({super.key});

  @override
  State<RequestDropDown> createState() => _RequestDropDownState();
}

class _RequestDropDownState extends State<RequestDropDown> {
  final List<String> dropdownMenuList = ["모집중", "모집완료"];
  String selectedDropDown = "모집중";
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedDropDown,
      elevation: 1,
      items: dropdownMenuList.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedDropDown = value!;
        });
      },
    );
  }
}
