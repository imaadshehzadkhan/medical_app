import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import '../models/medical_test.dart';
import '../theme/app_theme.dart';
import '../screens/booking_screen.dart';

class TestDetailScreen extends StatelessWidget {
  final MedicalTest test;
  final String labId;

  const TestDetailScreen({
    Key? key,
    required this.test,
    required this.labId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Test Details',
          style: GoogleFonts.lato(textStyle: AppTheme.titleLarge),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowColor,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              IconlyLight.arrow_left,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Test header card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.shadowColor,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Test icon
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLightColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Icon(
                                IconlyLight
                                    .activity, // Using Iconly for a scientific look
                                color: AppTheme.primaryColor,
                                size: 36,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Test name and category
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  test.name,
                                  style: GoogleFonts.lato(
                                    textStyle: AppTheme.headlineSmall,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryLightColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    test.category,
                                    style: GoogleFonts.lato(
                                      textStyle: AppTheme.labelSmall.copyWith(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Price and report time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price',
                                style: GoogleFonts.lato(
                                  textStyle: AppTheme.labelMedium.copyWith(
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${test.price.toStringAsFixed(2)}',
                                style: GoogleFonts.lato(
                                  textStyle: AppTheme.titleLarge.copyWith(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Report Time',
                                style: GoogleFonts.lato(
                                  textStyle: AppTheme.labelMedium.copyWith(
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    IconlyLight.time_circle,
                                    size: 18,
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    test.reportTime,
                                    style: GoogleFonts.lato(
                                      textStyle: AppTheme.titleMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Test description
                Text(
                  'About This Test',
                  style: GoogleFonts.lato(
                    textStyle: AppTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  test.description,
                  style: GoogleFonts.lato(
                    textStyle: AppTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 24),
                // Preparation instructions
                Text(
                  'Preparation Instructions',
                  style: GoogleFonts.lato(
                    textStyle: AppTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 12),
                ...test.preparationInstructions.map((instruction) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          IconlyLight.tick_square,
                          color: AppTheme.successColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            instruction,
                            style: GoogleFonts.lato(
                              textStyle: AppTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 24),
                // Included tests
                Text(
                  'Included Tests',
                  style: GoogleFonts.lato(
                    textStyle: AppTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.dividerColor),
                  ),
                  child: Column(
                    children: test.includedTests.map((includedTest) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                includedTest,
                                style: GoogleFonts.lato(
                                  textStyle: AppTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Bottom padding for the floating action button
                const SizedBox(height: 100),
              ],
            ),
          ),
          // Bottom booking bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowColor,
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Price',
                        style: GoogleFonts.lato(
                          textStyle: AppTheme.labelMedium.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ),
                      Text(
                        '\$${test.price.toStringAsFixed(2)}',
                        style: GoogleFonts.lato(
                          textStyle: AppTheme.titleLarge.copyWith(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingScreen(
                              test: test,
                              labId: labId,
                            ),
                          ),
                        );
                      },
                      style: AppTheme.primaryButtonStyle,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Book Now',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
