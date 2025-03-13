import 'package:adtsmed/models/booking.dart';
import 'package:adtsmed/models/medical_test.dart';
import 'package:adtsmed/theme/app_theme.dart';
import 'package:adtsmed/screens/confirmation_screen.dart';
import 'package:adtsmed/screens/home_screen.dart';
import 'package:flutter/material.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Booking> _allBookings = [];
  List<Booking> _filteredBookings = [];

  @override
  void initState() {
    super.initState();
    // Retrieve all bookings (ensure your Booking model stores bookings globally)
    _allBookings = Booking.getBookings();
    _filteredBookings = List.from(_allBookings);
  }

  void _filterBookings(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredBookings = List.from(_allBookings);
      });
    } else {
      setState(() {
        _filteredBookings = _allBookings.where((booking) {
          final lowerQuery = query.toLowerCase();
          // Search by test name or lab name
          return booking.testName.toLowerCase().contains(lowerQuery) ||
              booking.labName.toLowerCase().contains(lowerQuery);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Bookings', style: AppTheme.titleLarge),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search field at the top
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterBookings,
              decoration: InputDecoration(
                hintText: 'Search bookings',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.cardColor,
              ),
            ),
          ),
          // Display list of bookings
          Expanded(
            child: _filteredBookings.isEmpty
                ? Center(
                    child: Text(
                      'No bookings found',
                      style: AppTheme.titleMedium,
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = _filteredBookings[index];
                      return InkWell(
                        onTap: () {
                          // Create a dummy MedicalTest from the booking details.
                          final dummyTest = MedicalTest(
                            id: booking.testId,
                            name: booking.testName,
                            category: '',
                            description: '',
                            price: booking.amount,
                            isPopular: false,
                            reportTime: '',
                            preparationInstructions: [],
                            includedTests: [],
                            labId: booking.labId,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmationScreen(
                                booking: booking,
                                test: dummyTest,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.medical_services_rounded,
                                color: AppTheme.primaryColor,
                                size: 28,
                              ),
                            ),
                            title: Text(
                              booking.testName,
                              style: AppTheme.titleMedium,
                            ),
                            subtitle: Text(
                              '${booking.labName}\n${booking.appointmentDate.day}/${booking.appointmentDate.month}/${booking.appointmentDate.year} | ${booking.timeSlot}',
                              style: AppTheme.bodySmall,
                            ),
                            isThreeLine: true,
                            trailing: Text(
                              '\$${booking.amount.toStringAsFixed(2)}',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
