// widgets/common_refresh_indicator.dart

import 'package:flutter/material.dart';

class CommonRefreshIndicator extends StatelessWidget {
  final Widget child;
  final RefreshCallback onRefresh;
  final bool isLoading; // To show loading state during API call

  const CommonRefreshIndicator({
    Key? key,
    required this.child,
    required this.onRefresh,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Pull-to-refresh
        RefreshIndicator(
          onRefresh: onRefresh,
          child: child,
        ),

        // Global loading overlay (shown when isLoading == true)
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
              child: Center(
                child: CommonLoadingIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}


class CommonLoadingIndicator extends StatelessWidget {
  const CommonLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ),
    );
  }
}