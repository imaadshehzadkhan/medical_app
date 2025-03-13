class Laboratory {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> facilities;
  final bool isOpen;
  final String openingHours;
  final double distance;

  Laboratory({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.facilities,
    required this.isOpen,
    required this.openingHours,
    required this.distance,
  });

  // Sample data updated for Kashmir, India.
  static List<Laboratory> getSampleLabs() {
    return [
      Laboratory(
        id: '1',
        name: 'HealthCore Diagnostics',
        address: '123 Medical Avenue, Srinagar, Kashmir, India',
        imageUrl:
            'https://images.unsplash.com/photo-1504439468489-c8920d796a29?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.8,
        reviewCount: 354,
        description:
            'HealthCore Diagnostics is a state-of-the-art laboratory offering a wide range of medical tests with precision and care.',
        facilities: ['Parking', 'Wheelchair Access', 'Home Collection', 'Online Reports'],
        isOpen: true,
        openingHours: '7:00 AM - 9:00 PM',
        distance: 0.0, // will be updated based on actual location
      ),
      Laboratory(
        id: '2',
        name: 'MediLife Labs',
        address: '456 Health Street, Jammu, Kashmir, India',
        imageUrl:
            'https://images.unsplash.com/photo-1579154204601-01588f351e67?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.5,
        reviewCount: 289,
        description:
            'MediLife Labs provides trusted diagnostic services with the latest technology and experienced professionals.',
        facilities: ['Wi-Fi', 'Cafeteria', 'Wheelchair Access', 'Online Reports'],
        isOpen: true,
        openingHours: '8:00 AM - 8:00 PM',
        distance: 0.0,
      ),
      Laboratory(
        id: '3',
        name: 'Precision Diagnostics',
        address: '789 Care Lane, Kupwara, Kashmir, India',
        imageUrl:
            'https://images.unsplash.com/photo-1666214280391-8ff5bd3c0bf0?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.9,
        reviewCount: 412,
        description:
            'Precision Diagnostics delivers accurate results with cutting-edge equipment and a compassionate approach.',
        facilities: ['Parking', 'Waiting Lounge', 'Home Collection', 'Express Testing'],
        isOpen: false,
        openingHours: '7:30 AM - 9:30 PM',
        distance: 0.0,
      ),
      Laboratory(
        id: '4',
        name: 'VitaCheck Labs',
        address: '321 Wellness Road, Baramulla, Kashmir, India',
        imageUrl:
            'https://images.unsplash.com/photo-1556740738-b6a63e27c4df?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.7,
        reviewCount: 326,
        description:
            'VitaCheck Labs focuses on delivering fast and accurate diagnostic services in a comfortable environment.',
        facilities: ['Parking', 'Child Care', 'Home Collection', 'Online Reports'],
        isOpen: true,
        openingHours: '7:00 AM - 10:00 PM',
        distance: 0.0,
      ),
      Laboratory(
        id: '5',
        name: 'NextGen Diagnostics',
        address: '555 Health Center Drive, Anantnag, Kashmir, India',
        imageUrl:
            'https://images.unsplash.com/photo-1612277632421-a823aca777fd?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.6,
        reviewCount: 298,
        description:
            'NextGen Diagnostics combines innovative technology with expert medical professionals for comprehensive health testing.',
        facilities: ['Parking', 'Waiting Lounge', 'Home Collection', '24/7 Service'],
        isOpen: true,
        openingHours: '24 Hours',
        distance: 0.0,
      ),
    ];
  }
}
