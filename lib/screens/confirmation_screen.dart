import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import '../models/medical_test.dart';
import '../theme/app_theme.dart';
import '../screens/home_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  final Booking booking;
  final MedicalTest test;

  const ConfirmationScreen({
    Key? key,
    required this.booking,
    required this.test,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 5),
                // Success animation/icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppTheme.successColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Success message
                Text(
                  'Booking Confirmed!',
                  style: GoogleFonts.nunito(
                    textStyle: AppTheme.headlineLarge.copyWith(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Your appointment has been scheduled successfully.',
                  style: GoogleFonts.openSans(
                    textStyle: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Booking details card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.shadowColor.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Booking ID
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Booking ID: ',
                            style: GoogleFonts.poppins(
                              textStyle: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Text(
                            booking.id,
                            style: GoogleFonts.poppins(
                              textStyle: AppTheme.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Test name
                      _buildDetailRow(
                        'Test',
                        test.name,
                        IconlyLight.ticket_star,
                      ),
                      const Divider(height: 16),
                      // Patient name
                      _buildDetailRow(
                        'Patient',
                        booking.patientName,
                        IconlyLight.profile,
                      ),
                      const Divider(height: 16),
                      // Date and time
                      _buildDetailRow(
                        'Date & Time',
                        '${DateFormat('EEE, MMM d, yyyy').format(booking.appointmentDate)} | ${booking.timeSlot}',
                        IconlyLight.calendar,
                      ),
                      const Divider(height: 16),
                      // Amount paid
                      _buildDetailRow(
                        'Amount Paid',
                        '\$${booking.amount.toStringAsFixed(2)}',
                        IconlyLight.send,
                        valueColor: AppTheme.successColor,
                      ),
                      const Divider(height: 16),
                      // Payment method
                      _buildDetailRow(
                        'Payment Method',
                        booking.paymentMethod,
                        IconlyLight.wallet,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Home button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()),
                        (route) => false,
                      );
                    },
                    style: AppTheme.primaryButtonStyle.copyWith(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 19)),
                    ),
                    child: Text(
                      'Back to Home',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Download button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking details downloaded'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppTheme.successColor,
                        ),
                      );
                    },
                    style: AppTheme.secondaryButtonStyle.copyWith(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.download, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          'Download Booking Details',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryLightColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.nunitoSans(
                  textStyle: AppTheme.labelSmall.copyWith(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.nunito(
                  textStyle: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: valueColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
