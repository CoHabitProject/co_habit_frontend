import 'package:co_habit_frontend/presentation/screens/taches/utils/tache_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TachesCard extends StatelessWidget {
  final String title;
  final FontWeight? titleWeight;
  final double? titleSize;
  final String text;
  final double? textSize;
  final FontWeight? textWeight;
  final DateTime date;
  final TacheStatus status;
  final String initials;
  final double width;
  final double height;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color avatarColor;
  final Color? textColor;

  const TachesCard({
    super.key,
    required this.title,
    this.titleWeight,
    this.titleSize,
    required this.text,
    this.textSize,
    this.textWeight,
    required this.date,
    required this.status,
    required this.initials,
    required this.width,
    required this.height,
    required this.borderRadius,
    this.onTap,
    required this.avatarColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(2),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                _buildCircleAvatar(context),
                const SizedBox(width: 15),
                Expanded(child: _buildCenterContent(context)),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: _buildEndContent(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleAvatar(BuildContext context) {
    return CircleAvatar(
      backgroundColor: avatarColor, // Using the provided avatarColor
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCenterContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleSize ?? 16,
            fontWeight: titleWeight ?? FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: textSize ?? 14,
            fontWeight: textWeight,
            color: textColor ?? Colors.grey[600],
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildEndContent(BuildContext context) {
    return Column(
      children: [
        Text(
          DateFormat('dd/MM/yyyy').format(date),
          style: TextStyle(
            fontSize: (titleSize ?? 16) * 0.8,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: status.color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status.label.toString(),
            style: TextStyle(
              fontSize: (titleSize ?? 16) * 0.7,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
