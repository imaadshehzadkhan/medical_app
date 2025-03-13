import 'package:flutter/material.dart';
import '../models/medical_test.dart';
import '../theme/app_theme.dart';
import '../screens/test_detail_screen.dart';

class TestCard extends StatelessWidget {
  final MedicalTest test;
  final String labId;

  const TestCard({
    Key? key,
    required this.test,
    required this.labId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestDetailScreen(test: test, labId: labId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowColor,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Test icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLightColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.science_outlined,
                        color: AppTheme.primaryColor,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Test info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          test.name,
                          style: AppTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLightColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            test.category,
                            style: AppTheme.labelSmall.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${test.price.toStringAsFixed(2)}',
                        style: AppTheme.titleMedium.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      if (test.isPopular)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Popular',
                            style: AppTheme.labelSmall.copyWith(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Report time
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Report: ${test.reportTime}',
                        style: AppTheme.bodySmall,
                      ),
                    ],
                  ),
                  // Included tests count
                  Row(
                    children: [
                      const Icon(
                        Icons.checklist,
                        size: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${test.includedTests.length} included tests',
                        style: AppTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TestDetailScreen(test: test, labId: labId),
                    ),
                  );
                },
                style: AppTheme.primaryButtonStyle,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Book Now'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 