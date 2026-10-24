import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:sitevisits/presentation/theme/app_colors.dart';
import 'package:sitevisits/presentation/theme/app_test.dart';

import '../../core/utils/date_formatter.dart';

class TaskCard extends StatefulWidget {
  final bool isChecked;
  final VoidCallback update;
  final String title;
  final DateTime updateTime;
  final String? status;

  const TaskCard({
    super.key,
    this.isChecked = false,
    required this.title,
    required this.updateTime,
    this.status,
    required this.update,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  void didUpdateWidget(covariant TaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChecked != widget.isChecked) {
      _isChecked = widget.isChecked;
    }
  }

  Widget _buildStatusBadge(String statusText) {
    Color bgColor;
    Color textColor;

    final lowerStatus = statusText.toLowerCase().trim();

    if (lowerStatus == 'pending') {
      bgColor = AppColors.pendingBackground;
      textColor = AppColors.pendingText;
    } else if (lowerStatus.contains('not saved') || lowerStatus.contains('retry')) {
      bgColor = AppColors.errorBackground;
      textColor = AppColors.errorText;
    } else {
      bgColor = AppColors.headerBackground;
      textColor = AppColors.textSecondary;
    }

    return GestureDetector(
      onTap: widget.update,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: AppText(
          title: statusText,
          size: 11.sp,
          color: textColor,
          weight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 80.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 4.sp),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                // check box
                Transform.scale(
                  scale: 1.1,
                  child: Checkbox(
                    checkColor: AppColors.white,
                    activeColor: AppColors.success,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    side: const BorderSide(
                      color: AppColors.black,
                    ),
                    value: _isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isChecked = newValue ?? false;
                      });
                      widget.update();
                    },
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        title: widget.title,
                        size: 16.sp,
                        weight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 2.h),
                      AppText(
                        title: 'Updated ${DateFormatter.visitUpdated(widget.updateTime)}',
                        size: 12.sp,
                        weight: FontWeight.normal,
                        color: AppColors.textSecondary,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.status != null && widget.status!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: _buildStatusBadge(widget.status!),
            ),
        ],
      ),
    );
  }
}
