// File: HeatmapPage.dart
import 'package:flutter/material.dart';
import 'package:sih/main.dart';
import 'package:sih/models.dart';

class HeatmapPage extends StatefulWidget {
  const HeatmapPage({super.key});

  @override
  State<HeatmapPage> createState() => _HeatmapPageState();
}

class _HeatmapPageState extends State<HeatmapPage> {
  String _selectedFilter = 'All';

  final List<Report> _mockReports = [
    // Existing reports
    Report(
      id: '1',
      author: User(id: 'user_1', username: 'Sarah Chen', joinDate: DateTime(2023, 10, 26), profileImageUrl: 'https://i.pravatar.cc/300?img=15'),
      title: 'Dangerous Pothole on Main Street',
      description: '',
      dateTime: DateTime.now(),
      status: 'open',
      tags: ['Pothole', 'Infrastructure'],
      upvotes: 15,
      downvotes: 1,
      latitude: 13.0827,
      longitude: 80.2707,
    ),
    Report(
      id: '2',
      author: User(id: 'user_2', username: 'Michael Rodriguez', joinDate: DateTime(2023, 11, 10), profileImageUrl: 'https://i.pravatar.cc/300?img=13'),
      title: 'Broken Streetlight - Safety Concern',
      description: '',
      dateTime: DateTime.now(),
      status: 'in-progress',
      tags: ['Broken Light', 'Safety Issue'],
      upvotes: 23,
      downvotes: 0,
      latitude: 13.0674,
      longitude: 80.2376,
    ),
    Report(
      id: '3',
      author: User(id: 'user_3', username: 'Amanda Williams', joinDate: DateTime(2024, 2, 28), profileImageUrl: 'https://i.pravatar.cc/300?img=14'),
      title: 'Illegal Garbage Dumping',
      description: '',
      dateTime: DateTime.now(),
      status: 'resolved',
      tags: ['Illegal Dumping', 'Environment'],
      upvotes: 31,
      downvotes: 2,
      imageUrl: 'https://images.unsplash.com/photo-1627916538059-450f1422d057?q=80&w=1974&auto=format&fit=crop',
      latitude: 13.0456,
      longitude: 80.2190,
    ),
    Report(
      id: '4',
      author: User(id: 'user_4', username: 'James Park', joinDate: DateTime(2024, 3, 1), profileImageUrl: 'https://i.pravatar.cc/300?img=16'),
      title: 'Noise Complaint - Construction',
      description: '',
      dateTime: DateTime.now(),
      status: 'open',
      tags: ['Noise Complaint', 'Public Works'],
      upvotes: 8,
      downvotes: 0,
      latitude: 13.0900,
      longitude: 80.2000,
    ),
    Report(
      id: '5',
      author: User(id: 'user_5', username: 'Lisa Tran', joinDate: DateTime(2023, 8, 20), profileImageUrl: 'https://i.pravatar.cc/300?img=17'),
      title: 'Graffiti on Underpass',
      description: '',
      dateTime: DateTime.now(),
      status: 'in-progress',
      tags: ['Graffiti', 'Vandalism'],
      upvotes: 12,
      downvotes: 0,
      latitude: 13.0789,
      longitude: 80.2543,
    ),
    Report(
      id: '6',
      author: User(id: 'user_6', username: 'Robert Green', joinDate: DateTime(2024, 1, 1), profileImageUrl: 'https://i.pravatar.cc/300?img=18'),
      title: 'Unsanitary conditions in public park',
      description: '',
      dateTime: DateTime.now(),
      status: 'open',
      tags: ['Environment', 'Public Works'],
      upvotes: 18,
      downvotes: 3,
      latitude: 13.0567,
      longitude: 80.2234,
    ),
    Report(
      id: '7',
      author: User(id: 'user_7', username: 'Emily White', joinDate: DateTime(2023, 7, 5), profileImageUrl: 'https://i.pravatar.cc/300?img=19'),
      title: 'Damaged sidewalk',
      description: '',
      dateTime: DateTime.now(),
      status: 'resolved',
      tags: ['Infrastructure', 'Safety Issue'],
      upvotes: 42,
      downvotes: 5,
      imageUrl: 'https://images.unsplash.com/photo-1594735515284-88f572c84218?q=80&w=1974&auto=format&fit=crop',
      latitude: 13.0321,
      longitude: 80.2987,
    ),
    // More reports for a denser heatmap visualization
    Report(
      id: '8',
      author: User(id: 'user_8', username: 'David Wilson', joinDate: DateTime(2024, 4, 1), profileImageUrl: 'https://i.pravatar.cc/300?img=20'),
      title: 'Fallen tree blocking path',
      description: '',
      dateTime: DateTime.now().subtract(const Duration(hours: 10)),
      status: 'open',
      tags: ['Environment', 'Safety Issue'],
      upvotes: 5,
      downvotes: 0,
      latitude: 13.0750,
      longitude: 80.2850,
    ),
    Report(
      id: '9',
      author: User(id: 'user_9', username: 'Olivia Green', joinDate: DateTime(2024, 4, 5), profileImageUrl: 'https://i.pravatar.cc/300?img=21'),
      title: 'Water main leak on 1st Street',
      description: '',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      status: 'in-progress',
      tags: ['Water Leak', 'Infrastructure'],
      upvotes: 19,
      downvotes: 2,
      latitude: 13.0600,
      longitude: 80.2450,
    ),
    Report(
      id: '10',
      author: User(id: 'user_10', username: 'Lucas White', joinDate: DateTime(2024, 4, 10), profileImageUrl: 'https://i.pravatar.cc/300?img=22'),
      title: 'Suspicious activity near school',
      description: '',
      dateTime: DateTime.now().subtract(const Duration(hours: 1)),
      status: 'open',
      tags: ['Crime', 'Safety Issue'],
      upvotes: 7,
      downvotes: 0,
      latitude: 13.0800,
      longitude: 80.2600,
    ),
    Report(
      id: '11',
      author: User(id: 'user_11', username: 'Sophia Black', joinDate: DateTime(2024, 4, 15), profileImageUrl: 'https://i.pravatar.cc/300?img=23'),
      title: 'Damaged playground equipment',
      description: '',
      dateTime: DateTime.now().subtract(const Duration(days: 3)),
      status: 'resolved',
      tags: ['Recreation', 'Public Works'],
      upvotes: 35,
      downvotes: 1,
      latitude: 13.0500,
      longitude: 80.2100,
    ),
  ];

  Color _getChipColor(String tag) {
    switch (tag) {
      case 'Pothole':
        return Colors.brown;
      case 'Illegal Dumping':
        return Colors.red;
      case 'Broken Light':
        return Colors.orange;
      case 'Safety Issue':
        return Colors.purple;
      case 'Infrastructure':
        return Colors.blue;
      case 'Public Works':
        return Colors.green;
      case 'Environment':
        return Colors.teal;
      case 'Noise Complaint':
        return Colors.indigo;
      default:
        return AppColors.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredReports = _selectedFilter == 'All'
        ? _mockReports
        : _mockReports.where((r) => r.tags.contains(_selectedFilter)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reports Heatmap',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Background grid pattern
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          image: const DecorationImage(
                            image: NetworkImage('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGRlZnM+CjxwYXR0ZXJuIGlkPSJncmlkIiB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHBhdHRlcm5Vbml0cz0idXNlclNwYWNlT25Vc2UiPgo8cGF0aCBkPSJNIDQwIDAgTCAwIDAgMCA0MCIgZmlsbD0ibm9uZSIgc3Ryb2tlPSJncmF5IiBzdHJva2Utd2lkdGg9IjEiLz4KPC9wYXR0ZXJuPgo8L2RlZnM+CjxyZWN0IHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGZpbGw9InVybCgjZ3JpZCkiIC8+Cjwvc3ZnPgo='),
                            repeat: ImageRepeat.repeat,
                            opacity: 0.3,
                          ),
                        ),
                      ),
                      ...filteredReports.map((report) {
                        return _buildMarker(
                          context,
                          (report.longitude - 80.2) / 0.1 * 0.8 + 0.1,
                          (report.latitude - 13.0) / 0.1 * 0.8 + 0.1,
                          report.tags.isNotEmpty ? report.tags.first : 'default',
                          report.title,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),

            // Legend
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Tag Colors',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildLegendItem(Colors.brown, 'Pothole'),
                    _buildLegendItem(Colors.red, 'Illegal Dumping'),
                    _buildLegendItem(Colors.orange, 'Broken Light'),
                    _buildLegendItem(Colors.purple, 'Safety Issue'),
                    _buildLegendItem(Colors.blue, 'Infrastructure'),
                    _buildLegendItem(Colors.green, 'Public Works'),
                    _buildLegendItem(Colors.teal, 'Environment'),
                    _buildLegendItem(Colors.indigo, 'Noise Complaint'),
                  ],
                ),
              ),
            ),

            // Controls
            Positioned(
              bottom: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Filter Reports',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildFilterChip('All'),
                        _buildFilterChip('Infrastructure'),
                        _buildFilterChip('Safety Issue'),
                        _buildFilterChip('Environment'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isSelected ? AppColors.primaryBlue : Colors.grey.shade200,
      ),
    );
  }

  Widget _buildMarker(BuildContext context, double left, double top, String tag, String reportTitle) {
    final screenWidth = MediaQuery.of(context).size.width - 40;
    final screenHeight = MediaQuery.of(context).size.height - 200;
    final color = _getChipColor(tag);

    return Positioned(
      left: screenWidth * left - 15 + 20,
      top: screenHeight * top - 15 + 100,
      child: Tooltip(
        message: reportTitle,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.location_on,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}