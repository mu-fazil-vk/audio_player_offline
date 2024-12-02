import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final List<DropdownMenuItem<String>> items;
  final String hint;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.hint,
    this.selectedItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: DropdownButton<String>(
        value: selectedItem,
        hint: Text(hint),
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(fontSize: 16),
        underline: Container(),
        onChanged: onChanged,
        items: items,
        dropdownColor: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }
}
