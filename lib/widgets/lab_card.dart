import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/laboratory.dart';
import '../theme/app_theme.dart';
import '../screens/lab_detail_screen.dart';

class LabCard extends StatelessWidget {
  final Laboratory lab;

  const LabCard({
    Key? key,
    required this.lab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LabDetailScreen(lab: lab),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowColor.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lab Image with Open/Closed Label
            Stack(
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: lab.imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 160,
                      color: AppTheme.shimmerBaseColor,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 160,
                      color: AppTheme.shimmerBaseColor,
                      child: Center(
                        child: Icon(
                          Icons.error_outline_rounded,
                          color: AppTheme.errorColor.withOpacity(0.7),
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Gradient overlay for better text visibility
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Lab Name and Rating at the bottom of the image
                Positioned(
                  bottom: 12,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lab.name,
                              style: AppTheme.titleMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                RatingBar.builder(
                                  initialRating: lab.rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 16,
                                  ignoreGestures: true,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  lab.rating.toStringAsFixed(1),
                                  style: AppTheme.labelMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '(${lab.reviewCount})',
                                  style: AppTheme.bodySmall.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Status Badge (Open/Closed)
                Positioned(
                  top: 16,
                  right: 16,
                  child: GlassmorphicContainer(
                    width: 80,
                    height: 36,
                    borderRadius: 18,
                    blur: 20,
                    alignment: Alignment.center,
                    border: 0,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        lab.isOpen
                            ? AppTheme.successColor.withOpacity(0.7)
                            : AppTheme.errorColor.withOpacity(0.7),
                        lab.isOpen
                            ? AppTheme.successColor.withOpacity(0.4)
                            : AppTheme.errorColor.withOpacity(0.4),
                      ],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        lab.isOpen ? 'Open' : 'Closed',
                        style: AppTheme.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Distance Badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: GlassmorphicContainer(
                    width: 82,
                    height: 36,
                    borderRadius: 18,
                    blur: 20,
                    alignment: Alignment.center,
                    border: 0,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.5),
                      ],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: AppTheme.primaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${lab.distance} km',
                          style: AppTheme.labelMedium.copyWith(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Premium Badge (if rating > 4.5)
                if (lab.rating > 4.5)
                  Positioned(
                    top: 60,
                    left: 16,
                    child: GlassmorphicContainer(
                      width: 100,
                      height: 36,
                      borderRadius: 18,
                      blur: 20,
                      alignment: Alignment.center,
                      border: 0,
                      linearGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFFFD700).withOpacity(0.7),
                          const Color(0xFFFFA500).withOpacity(0.7),
                        ],
                      ),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.2),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Premium',
                            style: AppTheme.labelMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            
            // Lab Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          lab.address,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Opening hours
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 18,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        lab.openingHours,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Facilities badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: lab.facilities
                        .take(3)
                        .map((facility) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.primaryColor.withOpacity(0.1),
                                    AppTheme.secondaryColor.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                facility,
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  
                  // Book Now button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.secondaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LabDetailScreen(lab: lab),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'View Tests',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 