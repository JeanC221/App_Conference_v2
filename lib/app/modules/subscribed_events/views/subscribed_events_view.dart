import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/subscribed_events_controller.dart';
import '../../../data/models/event_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/conference_app_bar.dart';
import '../../../core/widgets/animated_list_item.dart';
import '../../../core/widgets/empty_state.dart';

class SubscribedEventsView extends GetView<SubscribedEventsController> {
  const SubscribedEventsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConferenceAppBar(
        title: 'My Subscribed Events',
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.subscribedEvents.isEmpty
                ? _buildEmptyState()
                : _buildEventsList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: Icons.event_busy_rounded,
      title: 'No Subscribed Events',
      message: 'You haven\'t subscribed to any events yet. Browse event tracks to find interesting events.',
      buttonText: 'Browse Events',
      onButtonPressed: () => Get.toNamed('/event-tracks'),
    );
  }

  Widget _buildEventsList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (controller.upcomingEvents.isNotEmpty) ...[
          const Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...controller.upcomingEvents.asMap().entries.map(
                (entry) => AnimatedListItem(
                  index: entry.key,
                  child: _buildEventCard(entry.value, isPast: false),
                ),
              ),
          const SizedBox(height: 24),
        ],
        
        if (controller.pastEvents.isNotEmpty) ...[
          const Text(
            'Past Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...controller.pastEvents.asMap().entries.map(
                (entry) => AnimatedListItem(
                  index: entry.key + controller.upcomingEvents.length,
                  child: _buildEventCard(entry.value, isPast: true),
                ),
              ),
        ],
      ],
    );
  }

  Widget _buildEventCard(Event event, {required bool isPast}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isPast ? Colors.grey.shade50 : AppTheme.cardColor,
      child: InkWell(
        onTap: () => controller.navigateToEventDetails(event),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isPast
                          ? Colors.grey.shade200
                          : AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          event.dateTime.day.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isPast
                                ? Colors.grey.shade700
                                : AppTheme.primaryColor,
                          ),
                        ),
                        Text(
                          _getMonthAbbreviation(event.dateTime.month),
                          style: TextStyle(
                            fontSize: 12,
                            color: isPast
                                ? Colors.grey.shade700
                                : AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isPast
                                ? Colors.grey.shade700
                                : AppTheme.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: isPast
                                  ? Colors.grey.shade500
                                  : AppTheme.textSecondaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${event.dateTime.hour}:${event.dateTime.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 14,
                                color: isPast
                                    ? Colors.grey.shade500
                                    : AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 14,
                              color: isPast
                                  ? Colors.grey.shade500
                                  : AppTheme.textSecondaryColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event.location,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isPast
                                      ? Colors.grey.shade500
                                      : AppTheme.textSecondaryColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isPast && event.averageRating != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.averageRating!.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isPast)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${event.availableSpots} spots left',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => controller.navigateToEventDetails(event),
                        icon: const Icon(Icons.info_outline_rounded, size: 16),
                        label: const Text('Details'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () => controller.unsubscribeFromEvent(event.id),
                        icon: const Icon(Icons.cancel_rounded, size: 16),
                        label: const Text('Unsubscribe'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthAbbreviation(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
