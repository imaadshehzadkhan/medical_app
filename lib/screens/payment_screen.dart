import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late ConfettiController _confettiController;
  late Razorpay _razorpay;

  // Reordered payment methods: Google Pay, Cash on Delivery, Credit Card, Razorpay.
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'Google Pay',
      'icon': ImageIcon(AssetImage('assets/google_pay.png')),
      'selected': true,
    },
    {
      'name': 'Cash on Delivery',
      'icon': Icons.attach_money,
      'selected': false,
    },
    {
      'name': 'Credit Card',
      'icon': Icons.credit_card,
      'selected': false,
    },
    {
      'name': 'Razorpay',
      'icon': ImageIcon(AssetImage('assets/razorpay.png')),
      'selected': false,
    },
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
        title: Text('Payment',
            style: GoogleFonts.lato(textStyle: AppTheme.titleLarge)),
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
                  // Credit card form (visible for demonstration if needed)
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
                  // Order summary using a beautiful table
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: _buildOrderSummaryTable(),
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
                                style: GoogleFonts.lato(
                                  textStyle: AppTheme.titleMedium.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
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
          style: GoogleFonts.lato(textStyle: AppTheme.titleLarge),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
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
                    padding: const EdgeInsets.all(12),
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
                          child: method['icon'] is IconData
                              ? Icon(
                                  method['icon'],
                                  color: method['selected']
                                      ? AppTheme.primaryColor
                                      : AppTheme.textSecondaryColor,
                                  size: 24,
                                )
                              : method['icon'],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          method['name'],
                          style: GoogleFonts.lato(
                            textStyle: AppTheme.bodySmall.copyWith(
                              color: method['selected']
                                  ? AppTheme.primaryColor
                                  : AppTheme.textSecondaryColor,
                              fontWeight: method['selected']
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
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

  Widget _buildOrderSummaryTable() {
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
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1),
        },
        children: [
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Order Summary',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              const SizedBox(),
            ],
          ),
          _buildTableRow('Test', widget.test.name),
          _buildTableRow('Lab', 'HealthCore Diagnostics'),
          _buildTableRow('Patient', widget.patientDetails['name'] ?? 'N/A'),
          _buildTableRow('Date & Time',
              '${widget.appointmentDate.day}/${widget.appointmentDate.month}/${widget.appointmentDate.year} | ${widget.timeSlot}'),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: AppTheme.dividerColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: AppTheme.dividerColor),
              ),
            ],
          ),
          _buildTableRow(
              'Test Fee', '\$${widget.test.price.toStringAsFixed(2)}'),
          _buildTableRow('Processing Fee', '\$5.00'),
          _buildTableRow(
              'Tax', '\$${(widget.test.price * 0.08).toStringAsFixed(2)}'),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: AppTheme.dividerColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: AppTheme.dividerColor),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Total',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '\$${widget.totalAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
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
    _confettiController.play();

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
      var options = {
        'key': 'rzp_test_1DP5mmOlF5G5ag', // Replace with your test key
        'amount': (widget.totalAmount * 100).toInt(),
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
    } else if (selectedMethod == 'Credit Card') {
      if (formKey.currentState!.validate()) {
        await Future.delayed(const Duration(seconds: 2));

        _confettiController.play();
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
          paymentMethod: 'Credit Card',
        );
        setState(() {
          isLoading = false;
        });
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
    } else {
      // For Google Pay and Cash on Delivery, simulate payment processing.
      await Future.delayed(const Duration(seconds: 2));

      _confettiController.play();
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
    }
  }
}
