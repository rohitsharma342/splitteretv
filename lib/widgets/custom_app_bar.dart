import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  
  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
      iconTheme: const IconThemeData(
        color: AppColors.textDark,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.border,
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}