import 'package:clean_architecture_posts_app/core/app_theme.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: SizedBox(
          height: 32,
          width: 32,
          child: CircularProgressIndicator(
            color: secondaryColor,
          ),
        ),
      ),
    );
  }
}
