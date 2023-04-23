import 'package:flutter/material.dart';

class SelectionBoxItem<T> {
  final IconData icon;
  final String label;
  final T value;

  SelectionBoxItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class SelectionBox<T> extends StatelessWidget {
  final String label;
  final T? selectedItem;
  final Function(T?) onChanged;
  final List<SelectionBoxItem<T>> items;

  const SelectionBox({
    super.key,
    required this.label,
    required this.selectedItem,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      isExpanded: true,
      elevation: 2, // decrease elevation shadow
      value: selectedItem,
      onChanged: onChanged,
      items: [
        for (final item in items)
          DropdownMenuItem(
            value: item.value,
            child: Row(
              children: [
                Icon(item.icon),
                const SizedBox(width: 5),
                Text(item.label),
              ],
            ),
          )
      ],
    );
  }
}
