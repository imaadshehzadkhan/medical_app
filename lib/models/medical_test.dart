class MedicalTest {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final bool isPopular;
  final String reportTime;
  final List<String> preparationInstructions;
  final List<String> includedTests;
  final String labId;

  MedicalTest({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.isPopular,
    required this.reportTime,
    required this.preparationInstructions,
    required this.includedTests,
    required this.labId,
  });

  // Sample data
  static List<MedicalTest> getSampleTests() {
    return [
      MedicalTest(
        id: '1',
        name: 'Complete Blood Count (CBC)',
        category: 'Hematology',
        description: 'A complete blood count is a blood test used to evaluate your overall health and detect a wide range of disorders, including anemia, infection and leukemia.',
        price: 40.0,
        isPopular: true,
        reportTime: '24 hours',
        preparationInstructions: [
          'No special preparation is needed',
          'You may be asked to fast for 8-12 hours before the test',
          'Inform your doctor about any medications you are taking',
        ],
        includedTests: [
          'Red Blood Cell (RBC) count',
          'White Blood Cell (WBC) count',
          'Hemoglobin',
          'Hematocrit',
          'Platelet count',
        ],
        labId: '1',
      ),
      MedicalTest(
        id: '2',
        name: 'Comprehensive Metabolic Panel',
        category: 'Blood Chemistry',
        description: 'A comprehensive metabolic panel is a blood test that measures your sugar (glucose) level, electrolyte and fluid balance, kidney function, and liver function.',
        price: 65.0,
        isPopular: true,
        reportTime: '24 hours',
        preparationInstructions: [
          'Fast for 8-12 hours before the test',
          'You may drink water',
          'Take your medications as prescribed unless otherwise directed',
        ],
        includedTests: [
          'Glucose',
          'Calcium',
          'Albumin',
          'Total Protein',
          'Sodium, Potassium, CO2, Chloride',
          'BUN and Creatinine',
          'ALP, ALT, AST, Bilirubin',
        ],
        labId: '1',
      ),
      MedicalTest(
        id: '3',
        name: 'Lipid Profile',
        category: 'Cardiovascular',
        description: 'A lipid profile measures the amount of specific fat molecules called lipids in your blood. It helps assess your risk of developing cardiovascular diseases.',
        price: 55.0,
        isPopular: true,
        reportTime: '24 hours',
        preparationInstructions: [
          'Fast for 9-12 hours before the test',
          'Avoid alcohol for 24 hours before the test',
          'Continue taking your medications unless directed otherwise by your healthcare provider',
        ],
        includedTests: [
          'Total Cholesterol',
          'High-density Lipoprotein (HDL)',
          'Low-density Lipoprotein (LDL)',
          'Triglycerides',
          'Total Cholesterol/HDL Ratio',
        ],
        labId: '2',
      ),
      MedicalTest(
        id: '4',
        name: 'Thyroid Function Test',
        category: 'Endocrinology',
        description: 'This test measures how well your thyroid gland is working, by checking the levels of thyroid hormones in your blood.',
        price: 75.0,
        isPopular: false,
        reportTime: '48 hours',
        preparationInstructions: [
          'No fasting required',
          'Inform your doctor about any medications you are taking',
          'Certain medications might need to be temporarily stopped',
        ],
        includedTests: [
          'Thyroid Stimulating Hormone (TSH)',
          'Thyroxine (T4)',
          'Triiodothyronine (T3)',
        ],
        labId: '2',
      ),
      MedicalTest(
        id: '5',
        name: 'Vitamin D Test',
        category: 'Nutritional',
        description: 'This blood test measures the level of vitamin D in your body, which is important for bone health and immune function.',
        price: 60.0,
        isPopular: false,
        reportTime: '24 hours',
        preparationInstructions: [
          'No special preparation is needed',
          'You may be asked to fast for 8 hours before the test',
        ],
        includedTests: [
          'Vitamin D, 25-Hydroxy',
        ],
        labId: '3',
      ),
      MedicalTest(
        id: '6',
        name: 'COVID-19 PCR Test',
        category: 'Infectious Disease',
        description: 'A molecular test that detects genetic material from the virus and can tell if you have an active COVID-19 infection.',
        price: 120.0,
        isPopular: true,
        reportTime: '24-48 hours',
        preparationInstructions: [
          'No eating, drinking, or smoking for 30 minutes before the test',
          'Bring identification and insurance information',
        ],
        includedTests: [
          'SARS-CoV-2 RNA (COVID-19), Qualitative PCR',
        ],
        labId: '3',
      ),
      MedicalTest(
        id: '7',
        name: 'Complete Health Checkup',
        category: 'Preventive Care',
        description: 'A comprehensive health screening that includes multiple tests to assess your overall health status.',
        price: 250.0,
        isPopular: true,
        reportTime: '72 hours',
        preparationInstructions: [
          'Fast for 12 hours before the test',
          'Avoid alcohol for 24 hours before the test',
          'Avoid strenuous exercise for 24 hours before the test',
          'Bring any previous medical records if available',
        ],
        includedTests: [
          'Complete Blood Count',
          'Comprehensive Metabolic Panel',
          'Lipid Profile',
          'Thyroid Function Test',
          'Vitamin B12 and Folate',
          'Urinalysis',
          'Chest X-ray',
          'ECG',
        ],
        labId: '4',
      ),
    ];
  }

  static List<MedicalTest> getTestsByLabId(String labId) {
    return getSampleTests().where((test) => test.labId == labId).toList();
  }

  static List<String> getCategories() {
    final Set<String> categories = {};
    for (var test in getSampleTests()) {
      categories.add(test.category);
    }
    return categories.toList();
  }
} 