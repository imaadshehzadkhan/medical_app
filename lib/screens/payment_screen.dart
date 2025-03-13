import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/medical_test.dart';
import '../theme/app_theme.dart';
import '../screens/confirmation_screen.dart';
import '../models/booking.dart';

class PaymentScreen extends StatefulWidget {
  final MedicalTest test;
  final String labId;
  final DateTime appointmentDate;
  final String timeSlot;
  final Map<String, String> patientDetails;
  final double totalAmount;

  const PaymentScreen({
    Key? key,
    required this.test,
    required this.labId,
    required this.appointmentDate,
    required this.timeSlot,
    required this.patientDetails,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = true;
  bool useBackgroundImage = false;
  bool isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late ConfettiController _confettiController;
  late Razorpay _razorpay;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Credit Card', 'icon': Icons.credit_card, 'selected': true},
    {'name': 'PayPal', 'icon': Icons.paypal, 'selected': false},
    {'name': 'Apple Pay', 'icon': Icons.apple, 'selected': false},
    {'name': 'Google Pay', 'icon': Icons.g_mobiledata, 'selected': false},
    {'name': 'Razorpay', 'icon': Icons.currency_rupee, 'selected': false},
  ];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    // Initialize Razorpay
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Payment', style: AppTheme.titleLarge),
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
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Confetti effect
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 30,
            gravity: 0.1,
            colors: const [
              AppTheme.primaryColor,
              AppTheme.secondaryColor,
              AppTheme.accentColor,
              Colors.white,
            ],
          ),

          // Main content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment methods
                  _buildPaymentMethods(),
                  const SizedBox(height: 30),

                  // Credit card form
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Order summary
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: _buildOrderSummary(),
                  ),
                  const SizedBox(height: 40),

                  // Pay button
                  FadeInUp(
                    duration: const Duration(milliseconds: 700),
                    child: Container(
                      height: 56,
                      width: double.infinity,
                      decoration: AppTheme.gradientDecoration,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _processPayment,
                        style: AppTheme.gradientButtonStyle,
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Pay \$${widget.totalAmount.toStringAsFixed(2)}',
                                style: AppTheme.titleMedium.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: AppTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _paymentMethods.length,
            itemBuilder: (context, index) {
              final method = _paymentMethods[index];
              return FadeInRight(
                duration: Duration(milliseconds: 400 + (index * 100)),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      for (var m in _paymentMethods) {
                        m['selected'] = false;
                      }
                      _paymentMethods[index]['selected'] = true;
                    });
                  },
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: method['selected']
                          ? AppTheme.primaryColor.withOpacity(0.1)
                          : AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: method['selected']
                            ? AppTheme.primaryColor
                            : AppTheme.dividerColor,
                        width: method['selected'] ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: method['selected']
                                ? AppTheme.primaryColor.withOpacity(0.15)
                                : AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            method['icon'],
                            color: method['selected']
                                ? AppTheme.primaryColor
                                : AppTheme.textSecondaryColor,
                            size: method['name'] == 'Google Pay' ? 32 : 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          method['name'],
                          style: AppTheme.bodySmall.copyWith(
                            color: method['selected']
                                ? AppTheme.primaryColor
                                : AppTheme.textSecondaryColor,
                            fontWeight: method['selected']
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: AppTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Test', widget.test.name),
          // Lab name is hard-coded for now. Update it as needed.
          _buildSummaryRow('Lab', 'HealthCore Diagnostics'),
          _buildSummaryRow('Patient', widget.patientDetails['name'] ?? 'N/A'),
          _buildSummaryRow(
            'Date & Time',
            '${widget.appointmentDate.day}/${widget.appointmentDate.month}/${widget.appointmentDate.year} | ${widget.timeSlot}',
          ),
          const Divider(height: 24),
          _buildSummaryRow('Test Fee', '\$${widget.test.price.toStringAsFixed(2)}'),
          _buildSummaryRow('Processing Fee', '\$5.00'),
          _buildSummaryRow('Tax', '\$${(widget.test.price * 0.08).toStringAsFixed(2)}'),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${widget.totalAmount.toStringAsFixed(2)}',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          Text(
            value,
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  // Razorpay event handlers
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Show confetti effect
    _confettiController.play();

    // Create booking with testName and labName values.
    final booking = Booking.createBooking(
      testId: widget.test.id,
      labId: widget.labId,
      testName: widget.test.name,
      labName: 'HealthCore Diagnostics',
      appointmentDate: widget.appointmentDate,
      timeSlot: widget.timeSlot,
      patientName: widget.patientDetails['name'] ?? '',
      patientAge: widget.patientDetails['age'] ?? '',
      patientGender: widget.patientDetails['gender'] ?? '',
      patientEmail: widget.patientDetails['email'] ?? '',
      patientPhone: widget.patientDetails['phone'] ?? '',
      amount: widget.totalAmount,
      paymentMethod: 'Razorpay',
    );

    setState(() {
      isLoading = false;
    });

    // Navigate to confirmation screen after a brief delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationScreen(
              booking: booking,
              test: widget.test,
            ),
          ),
          (route) => false,
        );
      }
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      isLoading = false;
    });

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment failed: ${response.message}'),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External wallet selected: ${response.walletName}'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _processPayment() async {
    // Get the selected payment method
    final selectedMethod =
        _paymentMethods.firstWhere((m) => m['selected'])['name'];

    setState(() {
      isLoading = true;
    });

    if (selectedMethod == 'Razorpay') {
      // Open Razorpay checkout
      var options = {
        'key': 'rzp_test_1DP5mmOlF5G5ag', // Replace with your actual test key
        'amount': (widget.totalAmount * 100).toInt(), // Amount in smallest currency unit
        'name': 'ADTSMED',
        'description': widget.test.name,
        'prefill': {
          'contact': widget.patientDetails['phone'] ?? '',
          'email': widget.patientDetails['email'] ?? '',
          'name': widget.patientDetails['name'] ?? '',
        },
        'external': {
          'wallets': ['paytm', 'gpay']
        }
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } else if (formKey.currentState!.validate() || selectedMethod != 'Credit Card') {
      // Simulate payment processing for other methods
      await Future.delayed(const Duration(seconds: 2));

      // Play confetti
      _confettiController.play();

      // Create booking with the additional fields
      final booking = Booking.createBooking(
        testId: widget.test.id,
        labId: widget.labId,
        testName: widget.test.name,
        labName: 'HealthCore Diagnostics',
        appointmentDate: widget.appointmentDate,
        timeSlot: widget.timeSlot,
        patientName: widget.patientDetails['name'] ?? '',
        patientAge: widget.patientDetails['age'] ?? '',
        patientGender: widget.patientDetails['gender'] ?? '',
        patientEmail: widget.patientDetails['email'] ?? '',
        patientPhone: widget.patientDetails['phone'] ?? '',
        amount: widget.totalAmount,
        paymentMethod: selectedMethod,
      );

      setState(() {
        isLoading = false;
      });

      // Show success message and navigate to confirmation screen after a brief delay
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationScreen(
              booking: booking,
              test: widget.test,
            ),
          ),
          (route) => false,
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
