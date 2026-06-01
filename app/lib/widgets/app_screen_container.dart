import 'package:flutter/material.dart';

class AppScreenContainer extends StatelessWidget {
  final Widget child;

  const AppScreenContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final isTabletOrDesktop = screenWidth >= 700;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTabletOrDesktop ? 520 : double.infinity,
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.symmetric(
              horizontal: isTabletOrDesktop ? 24 : 0,
              vertical: isTabletOrDesktop ? 24 : 0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                isTabletOrDesktop ? 28 : 0,
              ),
              boxShadow: isTabletOrDesktop
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.14),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                isTabletOrDesktop ? 28 : 0,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}