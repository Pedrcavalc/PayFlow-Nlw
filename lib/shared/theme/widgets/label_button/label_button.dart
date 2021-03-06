import 'package:flutter/material.dart';
import 'package:payflow/shared/theme/app_text_styles.dart';

class LabelButton extends StatelessWidget {
  final String label;
  final TextStyle? style;
  final VoidCallback onPressed;
  const LabelButton(
      {Key? key, required this.label, required this.onPressed, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: style ?? TextStyles.buttonBoldHeading,
        ),
      ),
    );
  }
}
