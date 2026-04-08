// lib/widgets/section_label.dart
import 'package:flutter/material.dart';

class SectionLabel extends StatelessWidget {
  final String title;
  final bool mandatory;
  final String? subtitle;
  final bool hasError;

  const SectionLabel({
    super.key,
    required this.title,
    this.mandatory = false,
    this.subtitle,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: hasError ? Colors.red.shade700 : const Color(0xFF1A1A1A),
              ),
            ),
            if (mandatory) ...[
              const SizedBox(width: 2),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: hasError ? Colors.red.shade700 : Colors.red,
                  height: 1.1,
                ),
              ),
            ] else ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  'Optional',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 3),
          Text(
            subtitle!,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
        if (hasError) ...[
          const SizedBox(height: 3),
          Row(
            children: [
              Icon(Icons.error_outline, size: 12, color: Colors.red.shade500),
              const SizedBox(width: 4),
              Text(
                'This field is required',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}