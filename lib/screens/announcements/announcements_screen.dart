import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/announcements_controller.dart';
import '../../models/announcement_model.dart' as announcement_model;
import 'announcement_detail_screen.dart';

class AnnouncementsScreen extends StatelessWidget {
  final AnnouncementsController controller = Get.put(AnnouncementsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengumuman'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => controller.setSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Cari pengumuman...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          // Category filter chips
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  FilterChip(
                    label: Text('Semua'),
                    selected: controller.selectedCategory.value.isEmpty,
                    onSelected: (selected) {
                      if (selected) controller.setCategory('');
                    },
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Akademik'),
                    selected: controller.selectedCategory.value == 'academic',
                    onSelected: (selected) {
                      if (selected) controller.setCategory('academic');
                    },
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Umum'),
                    selected: controller.selectedCategory.value == 'general',
                    onSelected: (selected) {
                      if (selected) controller.setCategory('general');
                    },
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Penting'),
                    selected: controller.selectedCategory.value == 'urgent',
                    onSelected: (selected) {
                      if (selected) controller.setCategory('urgent');
                    },
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Administratif'),
                    selected:
                        controller.selectedCategory.value == 'administrative',
                    onSelected: (selected) {
                      if (selected) controller.setCategory('administrative');
                    },
                  ),
                ],
              ),
            ),
          ),

          // Announcements list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              final filteredAnnouncements = controller
                  .getFilteredAnnouncements();

              if (filteredAnnouncements.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.announcement_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tidak ada pengumuman',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshAnnouncements,
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: filteredAnnouncements.length,
                  itemBuilder: (context, index) {
                    final announcement = filteredAnnouncements[index];
                    return AnnouncementCard(announcement: announcement);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter Pengumuman'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date range picker could be added here
            Text('Filter berdasarkan tanggal akan ditambahkan'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final announcement_model.Announcement announcement;

  const AnnouncementCard({Key? key, required this.announcement})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Get.to(() => AnnouncementDetailScreen(announcement: announcement));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with category and priority
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(announcement.category),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      announcement.getCategoryLabel(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (announcement.isUrgent()) ...[
                    SizedBox(width: 8),
                    Icon(Icons.warning, color: Colors.red, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'URGENT',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  Spacer(),
                  Text(
                    _formatDate(announcement.createdAt),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Title
              Text(
                announcement.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 8),

              // Content preview
              Text(
                announcement.content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 12),

              // Footer with creator and read more
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    announcement.creator?.name ?? 'Admin',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Spacer(),
                  Text(
                    'Baca selengkapnya',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 12, color: Colors.blue),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'academic':
        return Colors.blue;
      case 'general':
        return Colors.green;
      case 'urgent':
        return Colors.red;
      case 'administrative':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
