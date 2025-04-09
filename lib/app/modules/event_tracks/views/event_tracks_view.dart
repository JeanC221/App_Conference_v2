import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_tracks_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/conference_app_bar.dart';
import '../../../core/widgets/animated_list_item.dart';
import '../../../core/widgets/empty_state.dart';

class EventTracksView extends GetView<EventTracksController> {
  const EventTracksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConferenceAppBar(
        title: 'Event Tracks',
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.tracks.isEmpty
                ? const EmptyState(
                    icon: Icons.category_rounded,
                    title: 'No Tracks Available',
                    message: 'There are no event tracks available at the moment.',
                  )
                : _buildTracksList(),
      ),
    );
  }

  Widget _buildTracksList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: controller.tracks.length,
      itemBuilder: (context, index) {
        final track = controller.tracks[index];
        return AnimatedListItem(
          index: index,
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => controller.navigateToTrackEvents(
                track.id,
                track.name,
              ),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getTrackColor(index).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getTrackIcon(index),
                            color: _getTrackColor(index),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            track.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      track.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          final eventCount = controller.getEventCountForTrack(track.id);
                          return Text(
                            '$eventCount ${eventCount == 1 ? 'event' : 'events'}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textSecondaryColor,
                            ),
                          );
                        }),
                        TextButton.icon(
                          onPressed: () => controller.navigateToTrackEvents(
                            track.id,
                            track.name,
                          ),
                          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                          label: const Text('View Events'),
                        ),
                      ],
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

  Color _getTrackColor(int index) {
    final colors = [
      AppTheme.primaryColor,
      AppTheme.secondaryColor,
      AppTheme.accentColor,
      Colors.purple,
      Colors.blue,
    ];
    return colors[index % colors.length];
  }

  IconData _getTrackIcon(int index) {
    final icons = [
      Icons.smartphone_rounded,
      Icons.web_rounded,
      Icons.psychology_rounded,
      Icons.cloud_rounded,
      Icons.security_rounded,
    ];
    return icons[index % icons.length];
  }
}

class EventDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Title',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8),
                  // Fix the Row layout issue by using intrinsic width
                  IntrinsicWidth(
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16),
                        SizedBox(width: 8),
                        Text('Date & Time'),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  // Fix another Row layout
                  IntrinsicWidth(
                    child: Row(
                      children: [
                        Icon(Icons.location_on, size: 16),
                        SizedBox(width: 8),
                        Text('Location'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Event details
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Event description goes here...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  
                  // Speaker section
                  SizedBox(height: 24),
                  Text(
                    'Speaker',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.person),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Speaker Name',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  'Speaker bio goes here...',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
