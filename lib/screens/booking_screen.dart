import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/medical_test.dart';
import '../models/booking.dart';
import '../theme/app_theme.dart';
import '../screens/payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final MedicalTest test;
  final String labId;

  const BookingScreen({
    Key? key,
    required this.test,
    required this.labId,
  }) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String _selectedGender = 'Male';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  CalendarFormat _calendarFormat = CalendarFormat.week;
  String _selectedTimeSlot = '';
  String _selectedPaymentMethod = 'Credit Card';
  
  final List<String> _timeSlots = [
    '08:00 AM',
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];
  
  final List<String> _genders = ['Male', 'Female', 'Other'];
  
  int _currentStep = 0;
  
  bool isDateBeforeToday(DateTime date) {
    final today = DateTime.now();
    return date.year < today.year ||
        (date.year == today.year && date.month < today.month) ||
        (date.year == today.year && date.month == today.month && date.day < today.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Book Appointment', style: AppTheme.titleLarge),
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
              Icons.arrow_back,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Stepper Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                _buildStepIndicator(0, 'Date & Time'),
                _buildStepConnector(_currentStep > 0),
                _buildStepIndicator(1, 'Patient Details'),
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _currentStep == 0
                  ? _buildDateTimeStep()
                  : _buildPatientDetailsStep(),
            ),
          ),
          
          // Bottom Navigation Buttons
          Container(
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
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _currentStep--;
                        });
                      },
                      style: AppTheme.secondaryButtonStyle,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('Previous'),
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: _currentStep < 1 
                      ? null 
                      : AppTheme.gradientDecoration,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentStep < 1) {
                          if (_selectedTimeSlot.isEmpty) {
                            _showSnackBar('Please select a time slot');
                            return;
                          }
                          setState(() {
                            _currentStep++;
                          });
                        } else {
                          // Final step - proceed to payment
                          if (_formKey.currentState!.validate()) {
                            _proceedToPayment();
                          }
                        }
                      },
                      style: _currentStep < 1 
                        ? AppTheme.primaryButtonStyle 
                        : AppTheme.gradientButtonStyle,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(_currentStep < 1 ? 'Next' : 'Proceed to Payment'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primaryColor : AppTheme.dividerColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isActive
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : Text(
                      '${step + 1}',
                      style: TextStyle(
                        color: isActive
                            ? Colors.white
                            : AppTheme.textSecondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.labelSmall.copyWith(
              color: isActive
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Container(
      width: 30,
      height: 2,
      color: isActive ? AppTheme.primaryColor : AppTheme.dividerColor,
    );
  }

  Widget _buildDateTimeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Booking info card
        Container(
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.test.name,
                      style: AppTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Report in ${widget.test.reportTime}',
                          style: AppTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${widget.test.price.toStringAsFixed(2)}',
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(
              begin: 0.2,
              end: 0,
              curve: Curves.easeOutQuad,
              duration: 800.ms,
            ),
        const SizedBox(height: 24),
        
        // Calendar Section
        Text(
          'Select Date',
          style: AppTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Container(
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
          child: TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 60)),
            focusedDay: _selectedDate,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                _selectedTimeSlot = '';
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              selectedDecoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              markersMaxCount: 3,
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: AppTheme.primaryLightColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
        const SizedBox(height: 24),
        
        // Time Slots Section
        Text(
          'Select Time Slot',
          style: AppTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _timeSlots.asMap().entries.map((entry) {
            final index = entry.key;
            final time = entry.value;
            final isSelected = _selectedTimeSlot == time;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTimeSlot = time;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.dividerColor,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  time,
                  style: AppTheme.bodyMedium.copyWith(
                    color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ).animate().fadeIn(
                  duration: 400.ms,
                  delay: Duration(milliseconds: 300 + (index * 50)),
                );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPatientDetailsStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Details',
            style: AppTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          
          // Full Name
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
          const SizedBox(height: 16),
          
          // Age and Gender in a row
          Row(
            children: [
              // Age Field
              Expanded(
                child: TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Invalid age';
                    }
                    return null;
                  },
                ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
              ),
              const SizedBox(width: 16),
              
              // Gender Dropdown
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.people),
                  ),
                  items: _genders.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select gender';
                    }
                    return null;
                  },
                ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Email
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
          const SizedBox(height: 16),
          
          // Phone
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
          const SizedBox(height: 30),
          
          // Appointment Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.dividerColor),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appointment Summary',
                  style: AppTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _buildSummaryRow('Test', widget.test.name),
                _buildSummaryRow(
                  'Date',
                  DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
                ),
                _buildSummaryRow('Time', _selectedTimeSlot),
                const Divider(height: 24),
                _buildSummaryRow(
                  'Test Fee',
                  '\$${widget.test.price.toStringAsFixed(2)}',
                ),
                _buildSummaryRow(
                  'Processing Fee',
                  '\$5.00',
                ),
                _buildSummaryRow(
                  'Tax',
                  '\$${(widget.test.price * 0.08).toStringAsFixed(2)}',
                ),
                const Divider(height: 24),
                _buildSummaryRow(
                  'Total',
                  '\$${_calculateTotalAmount().toStringAsFixed(2)}',
                  isHighlighted: true,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 600.ms).slideY(
                begin: 0.3,
                end: 0,
                curve: Curves.easeOutQuad,
                duration: 800.ms,
              ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isHighlighted
                ? AppTheme.titleMedium
                : AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
          ),
          Text(
            value,
            style: isHighlighted
                ? AppTheme.titleMedium.copyWith(
                    color: AppTheme.primaryColor,
                  )
                : AppTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  double _calculateTotalAmount() {
    final testFee = widget.test.price;
    final processingFee = 5.0;
    final tax = testFee * 0.08; // 8% tax
    return testFee + processingFee + tax;
  }

  void _proceedToPayment() {
    final patientDetails = {
      'name': _nameController.text,
      'age': _ageController.text,
      'gender': _selectedGender,
      'email': _emailController.text,
      'phone': _phoneController.text,
    };
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          test: widget.test,
          labId: widget.labId,
          appointmentDate: _selectedDate,
          timeSlot: _selectedTimeSlot,
          patientDetails: patientDetails,
          totalAmount: _calculateTotalAmount(),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
} 