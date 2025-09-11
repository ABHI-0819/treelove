import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MultiSelectSearchableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String hintText;
  final String searchHintText;
  final String Function(T) itemAsString;
  final List<String> Function(T) searchableAttributes;
  final Function(List<T>)? onChanged;
  final List<T> initialSelection;

  const MultiSelectSearchableDropdown({
    Key? key,
    required this.items,
    required this.itemAsString,
    required this.searchableAttributes,
    this.hintText = 'Select Items',
    this.searchHintText = 'Search...',
    this.onChanged,
    this.initialSelection = const [],
  }) : super(key: key);

  @override
  State<MultiSelectSearchableDropdown<T>> createState() =>
      _MultiSelectSearchableDropdownState<T>();
}

class _MultiSelectSearchableDropdownState<T>
    extends State<MultiSelectSearchableDropdown<T>> {
  late List<T> _selectedItems;
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _selectedItems = [...widget.initialSelection];
    _filteredItems = [...widget.items];
  }

  void _onSearch(String query) {
    setState(() {
      _filteredItems = widget.items.where((item) {
        final searchStrings = widget.searchableAttributes(item);
        return searchStrings
            .any((str) => str.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<T>.multiSelectSearch(
      key: UniqueKey(),
      items: _filteredItems,
      initialItems: _selectedItems,
      hintText: widget.hintText,
      searchHintText: widget.searchHintText,
      maxlines: 3,
      overlayHeight: 300.h,
      listItemPadding: EdgeInsets.zero,
      onListChanged: (selected) {
        _selectedItems = selected;
        widget.onChanged?.call(selected);
      },
      listItemBuilder: (BuildContext context, T item, bool isSelected,
          void Function() onTap) {
        return CheckboxListTile(
          title: Text(widget.itemAsString(item)),
          value: isSelected,
          onChanged: (_) => onTap(),
        );
      },
      noResultFoundText: "No results found",
      decoration: const CustomDropdownDecoration(

      ),
      // Optional: Hook into internal search text if CustomDropdown provides it
      // If not, add a controller or handle from outside
    );
  }
}
