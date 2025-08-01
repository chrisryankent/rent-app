import 'package:rental_connect/tenant_screens/models/user.dart';

// models/room.dart
class Room {
  final String id;
  final String title;
  final String description;
  final double price;
  final String location;
  final String imageUrl;
  final int bedrooms;
  final int bathrooms;
  final double size;
  final bool furnished;
  final bool petFriendly;
  final bool parking;
  final double rating;
  final int reviews;
  final double distance;
  final DateTime postedDate;
  final List<String> images;
  final User landlord;

  Room({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.imageUrl,
    this.bedrooms = 1,
    this.bathrooms = 1,
    this.size = 500,
    this.furnished = false,
    this.petFriendly = false,
    this.parking = false,
    this.rating = 4.5,
    this.reviews = 12,
    this.distance = 0.5,
    required this.postedDate,
    required this.images,
    required this.landlord,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(postedDate);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'Just now';
    }
  }

  static List<Room> get sampleData => [
    Room(
      id: '1',
      title: 'property1.jpg',
      description:
          'Beautiful studio apartment with city views and modern amenities. Close to public transport and shopping centers. Pets are allowed with additional deposit.',
      price: 1250,
      location: 'Downtown, New York',
      imageUrl: 'lib/assets/property1.jpg',
      bedrooms: 1,
      bathrooms: 1,
      size: 650,
      furnished: true,
      petFriendly: true,
      parking: true,
      rating: 4.7,
      reviews: 24,
      distance: 0.3,
      postedDate: DateTime.now().subtract(const Duration(days: 1)),
      images: ['lib/assets/property1.jpg'],
      landlord: User(
        id: '1',
        name: 'Alex Morgan',
        email: 'alex@example.com',
        phone: '1234567890',
        type: UserType.landlord,
        isVerified: true,
      ),
    ),
    Room(
      id: '2',
      title: 'property1.jpg',
      description:
          'Spacious shared apartment with friendly roommates. Perfect for students or young professionals. Utilities included in the rent.',
      price: 750,
      location: 'University District, Boston',
      imageUrl: 'lib/assets/property1.jpg',
      bedrooms: 2,
      bathrooms: 2,
      size: 1200,
      furnished: true,
      petFriendly: false,
      parking: false,
      rating: 4.3,
      reviews: 18,
      distance: 0.8,
      postedDate: DateTime.now().subtract(const Duration(days: 3)),
      images: ['lib/assets/property1.jpg'],
      landlord: User(
        id: '2',
        name: 'Sarah Johnson',
        email: 'sarah@example.com',
        phone: '2345678901',
        type: UserType.landlord,
        isVerified: false,
      ),
    ),
    Room(
      id: '3',
      title: 'property1.jpg',
      description:
          'Stunning waterfront property with panoramic views. High-end finishes and premium amenities including gym, pool, and concierge service.',
      price: 3200,
      location: 'Harbor Front, Miami',
      imageUrl: 'lib/assets/property1.jpg',
      bedrooms: 2,
      bathrooms: 2,
      size: 1400,
      furnished: true,
      petFriendly: true,
      parking: true,
      rating: 4.9,
      reviews: 36,
      distance: 1.2,
      postedDate: DateTime.now().subtract(const Duration(hours: 5)),
      images: ['lib/assets/property1.jpg'],
      landlord: User(
        id: '3',
        name: 'Property Management',
        email: 'pm@example.com',
        phone: '3456789012',
        type: UserType.landlord,
        isVerified: true,
      ),
    ),
  ];

  String get name => title;
}
