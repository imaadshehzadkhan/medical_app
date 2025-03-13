class Booking {
  final String id;
  final String testId;
  final String labId;
  final String testName; // Added field for the test's name
  final String labName;  // Added field for the lab's name
  final DateTime appointmentDate;
  final String timeSlot;
  final String patientName;
  final String patientAge;
  final String patientGender;
  final String patientEmail;
  final String patientPhone;
  final String bookingStatus;
  final DateTime bookingDate;
  final double amount;
  final String paymentMethod;
  final String paymentStatus;

  Booking({
    required this.id,
    required this.testId,
    required this.labId,
    required this.testName,
    required this.labName,
    required this.appointmentDate,
    required this.timeSlot,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.patientEmail,
    required this.patientPhone,
    required this.bookingStatus,
    required this.bookingDate,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  // Internal list to store bookings
  static final List<Booking> _bookings = [];

  /// Creates a new booking and adds it to the internal list.
  static Booking createBooking({
    required String testId,
    required String labId,
    required String testName,
    required String labName,
    required DateTime appointmentDate,
    required String timeSlot,
    required String patientName,
    required String patientAge,
    required String patientGender,
    required String patientEmail,
    required String patientPhone,
    required double amount,
    required String paymentMethod,
  }) {
    final booking = Booking(
      id: 'BK${DateTime.now().millisecondsSinceEpoch}',
      testId: testId,
      labId: labId,
      testName: testName,
      labName: labName,
      appointmentDate: appointmentDate,
      timeSlot: timeSlot,
      patientName: patientName,
      patientAge: patientAge,
      patientGender: patientGender,
      patientEmail: patientEmail,
      patientPhone: patientPhone,
      bookingStatus: 'Confirmed',
      bookingDate: DateTime.now(),
      amount: amount,
      paymentMethod: paymentMethod,
      paymentStatus: 'Paid',
    );
    _bookings.add(booking);
    return booking;
  }

  /// Returns all stored bookings.
  static List<Booking> getBookings() => _bookings;
}
