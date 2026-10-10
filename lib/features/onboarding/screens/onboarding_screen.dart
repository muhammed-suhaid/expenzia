import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/app_button.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback? onGetStarted;

  const OnboardingScreen({super.key, this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFEDF7F6),
                ),
              ),
              //TODO: Add illustator
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPadding,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: AppDimensions.spacingLG),
                      Text(
                        AppStrings.onboardingTitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading.copyWith(
                          color: AppColors.primary,
                          fontSize: 46,
                          height: 1.15,
                        ),
                      ),
                      const Spacer(),
                      AppButton(
                        label: AppStrings.getStarted,
                        onPressed: onGetStarted,
                      ),
                      const SizedBox(height: AppDimensions.spacingXL),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
