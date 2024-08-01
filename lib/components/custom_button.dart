import 'package:flutter/material.dart';

enum CustomButtonVariants { primary, secondary, terciary }

// TODO: Поправить центирование текста и расположение иконок
// и внести изменения в проект с виджетами.
class CustomButton extends StatelessWidget {
  final String text;
  final CustomButtonVariants variant;
  final String? leftImage;
  final String? rightImage;
  final bool showText;
  final bool showLeftImage;
  final bool showRightImage;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.variant,
    required this.onPressed,
    this.text = '',
    this.leftImage,
    this.rightImage,
    this.showText = true,
    this.showLeftImage = false,
    this.showRightImage = false,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color backgroundColor;
    Color textColor;

    switch (variant) {
      case CustomButtonVariants.primary:
        borderColor = Colors.transparent;
        backgroundColor = const Color(0xFF006FFD);
        textColor = Colors.white;
        break;
      case CustomButtonVariants.secondary:
        borderColor = const Color(0xFF006FFD);
        backgroundColor = Colors.transparent;
        textColor = const Color(0xFF006FFD);
        break;
      case CustomButtonVariants.terciary:
        borderColor = Colors.transparent;
        backgroundColor = Colors.transparent;
        textColor = const Color(0xFF006FFD);
        break;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        constraints: const BoxConstraints(minHeight: 40),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showLeftImage && leftImage != null)
              Image.asset(
                leftImage!,
                height: 16,
                width: 16,
                color: textColor,
              ),
            if (showLeftImage) const SizedBox(width: 8),
            if (showText)
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            if (showRightImage) const SizedBox(width: 8),
            if (showRightImage && rightImage != null)
              Image.asset(
                rightImage!,
                height: 16,
                width: 16,
                color: textColor,
              ),
          ],
        ),
      ),
    );
  }
}
