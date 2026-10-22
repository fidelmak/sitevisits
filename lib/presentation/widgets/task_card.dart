import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:sitevisits/presentation/theme/app_colors.dart';
import 'package:sitevisits/presentation/theme/app_test.dart';

class TaskCard extends StatefulWidget {
bool isChecked ;
  final String title;
  final String updateTime;
  final String? status;
 TaskCard({super.key, this.isChecked= false, required this.title, required this.updateTime,this.status});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
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

          Row(
            children: [
              // check box ,
              Transform.scale(
                scale: 1.3,
                child: Checkbox(
                  checkColor: AppColors.white,
                  activeColor: AppColors.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),

                  ),
                  side:BorderSide(
                      color:AppColors.black,

                  ),
                  value: widget.isChecked,
                  onChanged: (bool? newValue) {
                    setState(() {
                      widget.isChecked = newValue ?? false;
                    });
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(title: widget.title),
                  AppText(title: widget.updateTime),
                ],
              ),
            ],
          ),
          if (widget.status != null) AppText(title: widget.status!),
        ],
      ),
    );
  }
}
