import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:sitevisits/presentation/theme/app_colors.dart';
import 'package:sitevisits/presentation/widgets/app_icon_button.dart';

class AppSearch extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onSearch;
  final VoidCallback? onClear;
  final Duration debounceDuration;

  const AppSearch({
    super.key,
    this.hintText = 'Search here...',
    required this.onSearch,
    this.onClear,
    this.debounceDuration = const Duration(milliseconds: 400),
  });

  @override
  State<AppSearch> createState() => _AppSearchState();
}

class _AppSearchState extends State<AppSearch> {
  late final TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _textController.dispose();

    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && _hasSearched) {
      _textController.clear();

      widget.onClear?.call();

      setState(() {
        _hasSearched = false;
      });
    }
  }

  void _handleSearch(String value) {
    final query = value.trim();

    setState(() {
      _hasSearched = query.isNotEmpty;
    });

    widget.onSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
        child: SizedBox(
          height: 50.sp,
          child: TextField(
            controller: _textController,
            focusNode: _focusNode,
            cursorColor: AppColors.textPrimary,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.sp,
                horizontal: 12.sp,
              ),
              labelText: widget.hintText,
              labelStyle: TextStyle(color: AppColors.searchHint, fontSize: 24.sp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: AppColors.searchHint),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: AppColors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: AppColors.searchHint),
              ),
              prefixIcon: Container(
                margin: EdgeInsets.all(4.r),

                child: AppIconButton(
                  icon: CupertinoIcons.search,
                  size: 24.sp,
                  color:  AppColors.searchHint,
                  onPressed: () {
                    _handleSearch(_textController.text);
                  },
                ),
              ),
            ),
            onChanged: _handleSearch,
            onSubmitted: _handleSearch,
          ),
        ),
      ),
    );
  }
}
