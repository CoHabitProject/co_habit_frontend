import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum IconPosition { left, right, bottom }

class FlexibleCard extends StatelessWidget {
  final String title;
  final String text;
  final IconData? icon;
  final IconPosition? iconPosition;
  final Color? cardColor;
  final Color? titleColor;
  final double titleSize;
  final FontWeight? titleWeight;
  final Color? textColor;
  final double textSize;
  final FontWeight? textWeight;
  final Color? iconColor;
  final double width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;

  const FlexibleCard(
      {super.key,
      required this.title,
      required this.text,
      this.icon,
      this.iconPosition = IconPosition.left,
      this.cardColor,
      this.titleColor,
      this.textColor,
      this.iconColor,
      required this.width,
      required this.height,
      this.padding,
      this.margin,
      required this.borderRadius,
      this.onTap,
      required this.textSize,
      this.textWeight,
      required this.titleSize,
      this.titleWeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.all(0.0),
      child: Card(
        color: cardColor ?? AppTheme.darkPrimaryColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16.0),
            child: _buildCardContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: titleWeight,
            color: titleColor ?? Colors.black,
          ),
        ),
        Expanded(child: _buildContentArea(context))
      ],
    );
  }

  Widget _buildContentArea(BuildContext context) {
    final iconWidget = Icon(
      icon,
      color: iconColor ?? Colors.white,
      size: 24,
    );

    final textWidget = Text(
      text,
      style: TextStyle(
          fontSize: textSize,
          color: textColor ?? Colors.black,
          fontWeight: textWeight ?? FontWeight.normal),
    );

    switch (iconPosition) {
      case IconPosition.left:
        return Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              const SizedBox(
                width: 8,
              ),
              Flexible(child: textWidget)
            ],
          ),
        );
      case IconPosition.right:
        return Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: textWidget),
              const SizedBox(
                width: 8,
              ),
              iconWidget,
            ],
          ),
        );
      case IconPosition.bottom:
        return Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              textWidget,
              const SizedBox(
                width: 8,
              ),
              iconWidget,
            ],
          ),
        );
      case null:
        return Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              textWidget,
            ],
          ),
        );
    }
  }
}
