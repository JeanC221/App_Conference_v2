import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';

class ConferenceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final double elevation;
  final Widget? leading;
  
  const ConferenceAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.elevation = 0,
    this.leading,
  }) : super(key: key);
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: elevation,
      actions: actions,
      leading: showBackButton && Get.previousRoute.isNotEmpty
          ? leading ?? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Get.back(),
            )
          : leading,
      backgroundColor: AppTheme.cardColor,
      foregroundColor: AppTheme.textPrimaryColor,
    );
  }
}
