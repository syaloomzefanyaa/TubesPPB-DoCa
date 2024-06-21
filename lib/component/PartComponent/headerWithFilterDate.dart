import 'package:flutter/material.dart';
import 'package:doca_project/component/ColorGlobal.dart';

class HeaderWithFilter extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function(DateTime) onFilterDateSelected;

  HeaderWithFilter({required this.title, required this.onFilterDateSelected});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: AppColors.primaryColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2025),
            );
            if (pickedDate != null) {
              onFilterDateSelected(pickedDate);
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
