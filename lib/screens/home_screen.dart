import 'package:adtsmed/models/booking.dart';
import 'package:adtsmed/models/laboratory.dart';
import 'package:adtsmed/models/medical_test.dart';
import 'package:adtsmed/screens/bookings_screen.dart';
import 'package:adtsmed/screens/confirmation_screen.dart';
import 'package:adtsmed/theme/app_theme.dart';
import 'package:adtsmed/widgets/lab_card.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  // Page index for bottom navigation bar
  int _selectedIndex = 0;

  // Controllers and data for Home tab:
  final TextEditingController _searchController = TextEditingController();
  List<Laboratory> _labs = [];
  List<Laboratory> _filteredLabs = [];
  bool _isNearbySelected = true;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Open Now', 'Highest Rated', 'Nearest'];
  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Blood Tests',
      'icon': Icons.opacity_rounded,
      'color': const Color(0xFF3366FF)
    },
    {
      'title': 'Cardiac',
      'icon': Icons.favorite,
      'color': const Color(0xFFF6575F)
    },
    {'title': 'Imaging', 'icon': Icons.image, 'color': const Color(0xFF00C6B3)},
    {
      'title': 'Covid-19',
      'icon': Icons.coronavirus_rounded,
      'color': const Color(0xFFFFB950)
    },
    {
      'title': 'Diabetes',
      'icon': Icons.bloodtype_outlined,
      'color': const Color(0xFF7D40FF)
    },
    {'title': 'Allergy', 'icon': Icons.air, 'color': const Color(0xFF3DC256)},
  ];

  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _labs = Laboratory.getSampleLabs();
    _filteredLabs = _labs;
    _tabController = TabController(length: 2, vsync: this);
  }

  void _filterLabs(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredLabs = _labs;
      });
    } else {
      setState(() {
        _filteredLabs = _labs.where((lab) {
          final lowerQuery = query.toLowerCase();
          return lab.name.toLowerCase().contains(lowerQuery) ||
              lab.address.toLowerCase().contains(lowerQuery);
        }).toList();
      });
    }
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      switch (filter) {
        case 'Open Now':
          _filteredLabs = _labs.where((lab) => lab.isOpen).toList();
          break;
        case 'Highest Rated':
          _filteredLabs = List.from(_labs)
            ..sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'Nearest':
          _filteredLabs = List.from(_labs)
            ..sort((a, b) => a.distance.compareTo(b.distance));
          break;
        default:
          _filteredLabs = _labs;
      }
    });
  }

  // Home content widget – includes app bar, hero, search, categories,
  // and, if a booking exists, the upcoming appointment banner.
  Widget _buildHomeContent() {
    // Retrieve the latest booking (if any) from your global bookings list.
    final latestBooking =
        Booking.getBookings().isNotEmpty ? Booking.getBookings().last : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAppBar(),
        // Show upcoming appointment banner if booking exists.
        if (latestBooking != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                // Create a dummy MedicalTest from the booking details.
                final dummyTest = MedicalTest(
                  id: latestBooking.testId,
                  name: latestBooking.testName,
                  category: '',
                  description: '',
                  price: latestBooking.amount,
                  isPopular: false,
                  reportTime: '',
                  preparationInstructions: [],
                  includedTests: [],
                  labId: latestBooking.labId,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmationScreen(
                      booking: latestBooking,
                      test: dummyTest,
                    ),
                  ),
                );
              },
              child: _buildUpcomingAppointmentCard(latestBooking),
            ),
          )
        else
          const SizedBox(height: 16),
        // Add extra spacing between banner and scroll view content.
        const SizedBox(height: 16),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroSection(),
                    const SizedBox(height: 24),
                    // Updated Search Box using our new SearchBox widget.
                    SearchBox(
                      controller: _searchController,
                      onChanged: _filterLabs,
                      onFilterTap: _showFilterBottomSheet,
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildCategoriesSection(),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildLabsHeader(),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: _buildLabsList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'MED',
                    textStyle: AppTheme.titleLarge.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
                displayFullTextOnTap: true,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  // Updated location icon using Iconly
                  const Icon(
                    IconlyBold.location,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'New York, USA',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: AppTheme.textSecondaryColor,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLightColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Badge(
                    label: const Text('3'),
                    child: const Icon(
                      // Updated notification icon using Iconly
                      IconlyBold.notification,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLightColor,
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: NetworkImage(
                          'https://randomuser.me/api/portraits/men/32.jpg'),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 210,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.secondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -40,
            top: -40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        child: Text(
                          'Premium Health Checkups',
                          style: AppTheme.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          'Get 20% off on all diagnostic tests this week',
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Book Now',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.health_and_safety_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ).animate().fadeIn(duration: 800.ms).scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                      curve: Curves.elasticOut,
                      duration: 1200.ms,
                    ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(
          begin: 0.2,
          end: 0,
          curve: Curves.easeOutQuad,
          duration: 800.ms,
        );
  }

  Widget _buildUpcomingAppointmentCard(Booking booking) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 100,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.primaryColor.withOpacity(0.8),
          AppTheme.secondaryColor.withOpacity(0.8),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.4),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: AppTheme.primaryColor,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Upcoming Appointment',
                    style: AppTheme.labelSmall.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.testName,
                    style: AppTheme.titleMedium.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${booking.appointmentDate.day}/${booking.appointmentDate.month}/${booking.appointmentDate.year} | ${booking.timeSlot}',
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(
          begin: 0.2,
          end: 0,
          curve: Curves.easeOutQuad,
          duration: 800.ms,
        );
  }

  Widget _buildCategoriesSection() {
    final List<Map<String, dynamic>> _enhancedCategories = [
      {
        'title': 'Blood Tests',
        'icon': Icons.opacity_rounded,
        'color': const Color(0xFF3366FF),
        'gradient': const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3366FF), Color(0xFF00CCFF)],
        ),
      },
      {
        'title': 'Cardiac',
        'icon': Icons.favorite,
        'color': const Color(0xFFF6575F),
        'gradient': const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF6575F), Color(0xFFFF9CAA)],
        ),
      },
      {
        'title': 'Imaging',
        'icon': Icons.image,
        'color': const Color(0xFF00C6B3),
        'gradient': const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00C6B3), Color(0xFF00E6D4)],
        ),
      },
      {
        'title': 'Covid-19',
        'icon': Icons.coronavirus_rounded,
        'color': const Color(0xFFFFB950),
        'gradient': const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFB950), Color(0xFFFFD68A)],
        ),
      },
      {
        'title': 'Diabetes',
        'icon': Icons.bloodtype_outlined,
        'color': const Color(0xFF7D40FF),
        'gradient': const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7D40FF), Color(0xFFA980FF)],
        ),
      },
      {
        'title': 'Allergy',
        'icon': Icons.air,
        'color': const Color(0xFF3DC256),
        'gradient': const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3DC256), Color(0xFF7AE28E)],
        ),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: AppTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 95,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _enhancedCategories.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: _enhancedCategories[index]['gradient'],
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: _enhancedCategories[index]['color']
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                _enhancedCategories[index]['icon'],
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _enhancedCategories[index]['title'],
                            style: AppTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
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

  Widget _buildLabsHeader() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Nearby Labs'),
                  Tab(text: 'Popular Labs'),
                ],
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: AppTheme.primaryColor,
                labelColor: AppTheme.primaryColor,
                labelStyle: AppTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                unselectedLabelColor: AppTheme.textSecondaryColor,
                unselectedLabelStyle: AppTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                onTap: (index) {
                  setState(() {
                    _isNearbySelected = index == 0;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final isSelected = _selectedFilter == filter;
              return GestureDetector(
                onTap: () {
                  _applyFilter(filter);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.primaryLightColor,
                    borderRadius: BorderRadius.circular(8), // More square look
                  ),
                  child: Center(
                    child: Text(
                      filter,
                      style: AppTheme.labelMedium.copyWith(
                        color:
                            isSelected ? Colors.white : AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLabsList() {
    if (_filteredLabs.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: AppTheme.textSecondaryColor.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No labs found',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try changing your search or filter criteria',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: LabCard(lab: _filteredLabs[index]),
              ),
            ),
          );
        },
        childCount: _filteredLabs.length,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(0, 'Home', IconlyBold.home, IconlyLight.home),
            _buildNavItem(1, 'Search', IconlyBold.search, IconlyLight.search),
            _buildNavItem(
                2, 'Bookings', IconlyBold.calendar, IconlyLight.calendar),
            _buildNavItem(
                3, 'Profile', IconlyBold.profile, IconlyLight.profile),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, String label, IconData selectedIcon, IconData unselectedIcon) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isSelected ? selectedIcon : unselectedIcon,
                key: ValueKey<bool>(isSelected),
                size: 28,
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: isSelected ? 14 : 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondaryColor,
              ),
              child: Text(label),
            ),
          ],
        ),
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
        return AnimationConfiguration.synchronized(
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter Labs',
                          style: AppTheme.headlineSmall,
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLightColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Lab Status',
                      style: AppTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildFilterChip('All Labs', _selectedFilter == 'All'),
                        const SizedBox(width: 12),
                        _buildFilterChip(
                            'Open Now', _selectedFilter == 'Open Now'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Sort By',
                      style: AppTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildFilterChip('Highest Rated',
                            _selectedFilter == 'Highest Rated'),
                        const SizedBox(width: 12),
                        _buildFilterChip(
                            'Nearest', _selectedFilter == 'Nearest'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      height: 56,
                      width: double.infinity,
                      decoration: AppTheme.gradientDecoration,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: AppTheme.gradientButtonStyle,
                        child: Text(
                          'Apply Filters',
                          style: AppTheme.titleMedium.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        _applyFilter(label);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(8), // More square look
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
            width: isSelected ? 1.5 : 1,
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
          label,
          style: AppTheme.labelMedium.copyWith(
            color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Build the main body using an IndexedStack so the nav bar remains visible.
  Widget _buildBody() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        _buildHomeContent(),
        // Placeholder for Tests screen
        Center(child: Text('Tests Screen', style: AppTheme.titleLarge)),
        // BookingsScreen is embedded here.
        const BookingsScreen(),
        // Placeholder for Profile screen
        Center(child: Text('Profile Screen', style: AppTheme.titleLarge)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}

// Updated SearchBox widget with modern styling and Iconly icons.
class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const SearchBox({
    Key? key,
    required this.controller,
    this.hintText = 'Search for labs or tests',
    this.onChanged,
    this.onFilterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            IconlyLight.search,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Search for labs or tests',
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryLightColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                IconlyBold.filter,
                color: AppTheme.primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
