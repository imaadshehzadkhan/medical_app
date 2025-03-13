import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final Function() onFilterTap;

  const SearchBox({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onFilterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(
            Icons.search,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              style: AppTheme.bodyMedium,
              cursorColor: AppTheme.primaryColor,
            ),
          ),
          // Divider
          Container(
            height: 30,
            width: 1,
            color: AppTheme.dividerColor,
          ),
          // Filter button
          InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 60,
              child: Center(
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_list,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Filter',
                      style: AppTheme.labelMedium.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 