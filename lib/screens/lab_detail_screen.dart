import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import '../models/laboratory.dart';
import '../models/medical_test.dart';
import '../theme/app_theme.dart';
import '../widgets/test_card.dart';
import '../widgets/search_box.dart';

class LabDetailScreen extends StatefulWidget {
  final Laboratory lab;

  const LabDetailScreen({
    Key? key,
    required this.lab,
  }) : super(key: key);

  @override
  State<LabDetailScreen> createState() => _LabDetailScreenState();
}

class _LabDetailScreenState extends State<LabDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<MedicalTest> _tests = [];
  List<MedicalTest> _filteredTests = [];
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load tests for this lab
    _tests = MedicalTest.getTestsByLabId(widget.lab.id);
    _filteredTests = _tests;

    // Get all unique categories
    final categories = MedicalTest.getCategories();
    _categories = ['All', ...categories];
  }

  void _filterTests(String query) {
    if (query.isEmpty) {
      if (_selectedCategory == 'All') {
        setState(() {
          _filteredTests = _tests;
        });
      } else {
        setState(() {
          _filteredTests = _tests
              .where((test) => test.category == _selectedCategory)
              .toList();
        });
      }
    } else {
      setState(() {
        _filteredTests = _tests
            .where((test) =>
                test.name.toLowerCase().contains(query.toLowerCase()) &&
                (_selectedCategory == 'All' ||
                    test.category == _selectedCategory))
            .toList();
      });
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All') {
        _filteredTests = _tests;
      } else {
        _filteredTests =
            _tests.where((test) => test.category == category).toList();
      }
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with Lab Image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
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
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Lab Image
                  CachedNetworkImage(
                    imageUrl: widget.lab.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
                  // Overlay gradient
                  Container(
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
                  // Lab name and rating at the bottom
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.lab.name,
                          style: GoogleFonts.lato(
                            textStyle: AppTheme.headlineMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: widget.lab.rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 18,
                              ignoreGestures: true,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.lab.rating.toStringAsFixed(1)} (${widget.lab.reviewCount} reviews)',
                              style: GoogleFonts.lato(
                                textStyle: AppTheme.bodyMedium.copyWith(
                                  color: Colors.white,
                                ),
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
          ),

          // Lab Info and Tests
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address and Open status
                  Row(
                    children: [
                      const Icon(
                        IconlyLight.location,
                        size: 20,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.lab.address,
                          style: GoogleFonts.lato(
                            textStyle: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: widget.lab.isOpen
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.lab.isOpen ? 'Open Now' : 'Closed',
                          style: GoogleFonts.lato(
                            textStyle: AppTheme.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Opening hours
                  Row(
                    children: [
                      const Icon(
                        IconlyLight.time_circle,
                        size: 20,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Opening Hours: ${widget.lab.openingHours}',
                        style: GoogleFonts.lato(
                          textStyle: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Distance with formatted value
                  Row(
                    children: [
                      const Icon(
                        IconlyLight.location,
                        size: 20,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Distance: ${widget.lab.distance.toStringAsFixed(2)} km',
                        style: GoogleFonts.lato(
                          textStyle: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Updated Search Box (uses the modern SearchBox widget)
                  SearchBox(
                    controller: _searchController,
                    hintText: 'Search for tests',
                    onChanged: _filterTests,
                    onFilterTap: _showFilterBottomSheet,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // Test Results
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: _filteredTests.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            IconlyLight.info_square,
                            size: 64,
                            color: AppTheme.textSecondaryColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tests found',
                            style: GoogleFonts.lato(
                              textStyle: AppTheme.titleMedium.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try changing your search or filter criteria',
                            style: GoogleFonts.lato(
                              textStyle: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return TestCard(
                          test: _filteredTests[index],
                          labId: widget.lab.id,
                        );
                      },
                      childCount: _filteredTests.length,
                    ),
                  ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 20),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row with title and close icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Tests',
                      style: GoogleFonts.lato(
                        textStyle: AppTheme.headlineSmall,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(IconlyLight.close_square),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Test Categories (with squared chips)
                Text(
                  'Test Categories',
                  style: GoogleFonts.lato(
                    textStyle: AppTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return GestureDetector(
                      onTap: () {
                        _filterByCategory(category);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : AppTheme.dividerColor,
                          ),
                        ),
                        child: Text(
                          category,
                          style: GoogleFonts.lato(
                            textStyle: AppTheme.labelMedium.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                // Apply Filters Button (ensured not to overflow)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      textStyle: GoogleFonts.lato(
                        textStyle: AppTheme.titleMedium.copyWith(fontSize: 16),
                      ),
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
