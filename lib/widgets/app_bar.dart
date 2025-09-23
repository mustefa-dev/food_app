import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  const AppTopBar({super.key, required this.title, this.actions, this.showBack = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      centerTitle: false,
      backgroundColor: kPrimary,
      elevation: 0,
      leading: showBack
        ? IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).maybePop()
          )
        : null,
      actions: actions?.map((action) {
        if (action is IconButton) {
          return IconButton(
            icon: Icon(
              (action.icon as Icon).icon,
              color: Colors.white,
            ),
            onPressed: action.onPressed,
          );
        }
        return action;
      }).toList(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}