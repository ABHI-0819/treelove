import 'package:flutter/material.dart';

/// A production-ready customizable FAQ widget that expands and collapses to show an answer.
/// It integrates deeply with the Material Design theme for consistent styling.
final class EasyFaq extends StatefulWidget {
  /// The question text to display. This field is required.
  final String question;

  /// The answer text to display when the FAQ is expanded. This field is required.
  final String answer;

  /// Optional text style for the question. If null, defaults to
  /// Theme.of(context).textTheme.titleMedium with specific customizations.
  final TextStyle? questionTextStyle;

  /// Optional text style for the answer. If null, defaults to
  /// Theme.of(context).textTheme.titleSmall with specific customizations.
  final TextStyle? answerTextStyle;

  /// The icon to display when the FAQ is expanded. Defaults to [Icons.remove].
  final IconData expandedIcon;

  /// The icon to display when the FAQ is collapsed. Defaults to [Icons.add].
  final IconData collapsedIcon;

  /// The color of the expand/collapse icons. Defaults to a specific grey.
  final Color iconColor;

  /// The duration of the expansion/collapse animation. Defaults to 200 milliseconds.
  final Duration animationDuration;

  /// The animation curve for the expansion/collapse. Defaults to [Curves.easeInOut].
  final Curve animationCurve;

  /// The background color of the FAQ card. If null, defaults to
  /// Theme.of(context).cardTheme.color.
  final Color? backgroundColor;

  /// The border radius of the FAQ card. If null, defaults to
  /// Theme.of(context).cardTheme.shape's borderRadius, or [BorderRadius.circular(10)].
  final BorderRadiusGeometry? borderRadius;

  /// The padding inside the FAQ card. Defaults to 16 horizontal and 10 vertical.
  final EdgeInsetsGeometry padding;

  /// The number of turns the icon should rotate when expanded.
  /// A value of 0.5 means a 180-degree rotation. Defaults to 0.5.
  final double rotationTurns;

  const EasyFaq({
    super.key,
    required this.question,
    required this.answer,
    this.questionTextStyle,
    this.answerTextStyle,
    this.expandedIcon = Icons.remove,
    this.collapsedIcon = Icons.add,
    this.iconColor = const Color.fromRGBO(101, 101, 105, 1),
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.backgroundColor,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.rotationTurns = 0.5,
  });

  @override
  State<EasyFaq> createState() => _EasyFaqState();
}

class _EasyFaqState extends State<EasyFaq> {
  bool _isExpanded = false; // Private state for expansion status

  @override
  Widget build(BuildContext context) {
    // Determine default text styles from the current theme, with specific fallbacks.
    final TextStyle defaultQuestionStyle =
        Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ) ??
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 14);

    final TextStyle defaultAnswerStyle =
        Theme.of(context).textTheme.titleSmall?.copyWith(
          fontSize: 13,
        ) ??
            const TextStyle(fontSize: 13);

    // Safely extract BorderRadius from the theme's CardTheme shape.
    // CardTheme.shape can be any ShapeBorder, so we cast if it's RoundedRectangleBorder.
    final BorderRadiusGeometry? themeBorderRadiusFromShape =
    (Theme.of(context).cardTheme.shape is RoundedRectangleBorder)
        ? (Theme.of(context).cardTheme.shape as RoundedRectangleBorder).borderRadius
        : null;

    // Determine the effective BorderRadiusGeometry for the Card's `shape` property.
    // Prioritizes widget.borderRadius, then theme's shape, then a default circular radius.
    final BorderRadiusGeometry effectiveCardBorderRadius =
        widget.borderRadius ?? themeBorderRadiusFromShape ?? BorderRadius.circular(10);

    // Determine the effective BorderRadius for InkWell's `borderRadius` property.
    // InkWell specifically requires `BorderRadius`, not the more general `BorderRadiusGeometry`.
    final BorderRadius inkWellTapRadius =
    (widget.borderRadius is BorderRadius)
        ? (widget.borderRadius as BorderRadius)
        : (themeBorderRadiusFromShape is BorderRadius)
        ? themeBorderRadiusFromShape
        : BorderRadius.circular(10); // Fallback to a concrete BorderRadius


    return Card(
      // Ensure no extra margin is applied by default from the Card widget itself
      margin: EdgeInsets.zero,
      // Use the provided background color or fall back to the theme's card color
      color: widget.backgroundColor ?? Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveCardBorderRadius,
      ),
      // InkWell provides Material Design ripple feedback on tap
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        // Apply the specific BorderRadius for InkWell's tap animation
        borderRadius: inkWellTapRadius,
        child: AnimatedSize(
          duration: widget.animationDuration,
          curve: widget.animationCurve,
          child: Padding( // Use Padding directly instead of Container for padding
            padding: widget.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // Align icon vertically
                  children: [
                    Expanded(
                      child: Text(
                        widget.question,
                        // Merge custom style provided to the widget with the default theme style.
                        // widget.questionTextStyle will override properties in defaultQuestionStyle.
                        style: defaultQuestionStyle.merge(widget.questionTextStyle),
                      ),
                    ),
                    // AnimatedRotation provides a smooth visual cue for expansion/collapse
                    AnimatedRotation(
                      turns: _isExpanded ? widget.rotationTurns : 0,
                      duration: widget.animationDuration,
                      curve: widget.animationCurve,
                      child: Icon(
                        _isExpanded ? widget.expandedIcon : widget.collapsedIcon,
                        color: widget.iconColor,
                      ),
                    ),
                  ],
                ),
                // Conditionally display the answer and a SizedBox for spacing
                if (_isExpanded) ...[
                  const SizedBox(height: 10),
                  Text(
                    widget.answer,
                    // Merge custom style provided to the widget with the default theme style.
                    style: defaultAnswerStyle.merge(widget.answerTextStyle),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}