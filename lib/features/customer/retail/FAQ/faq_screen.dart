import 'package:flutter/material.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/config/themes/app_color.dart';

import '../../../../core/widgets/faq.dart';

class FaqScreen extends StatelessWidget {
  static const route = "/faq-section";
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEF7),
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          EasyFaq(
            question: 'How do I get started with Dart?',
            answer: 'Dart is the programming language optimized for UI. You can start learning Dart through its official documentation and interactive tours on dart.dev.',
            collapsedIcon: Icons.keyboard_arrow_down,
            expandedIcon: Icons.keyboard_arrow_down,
            iconColor: Colors.green.shade700,
            animationCurve: Curves.fastOutSlowIn,
          ),
        ],
      ),
    );
  }
}