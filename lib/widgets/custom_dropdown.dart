import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String? value; 
  final String hint;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint = "Seçiniz",
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool isOpen = false;
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.value; 
  }

  @override
  void didUpdateWidget(covariant CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        selectedItem = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isOpen = !isOpen;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedItem ?? widget.hint,
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedItem == null ? Colors.grey : Colors.black,
                  ),
                ),
                Icon(isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (isOpen)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: widget.items.map((item) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedItem = item;
                      isOpen = false;
                    });
                    widget.onChanged(item);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    alignment: Alignment.centerLeft,
                    child: Text(item, style: const TextStyle(fontSize: 16)),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
