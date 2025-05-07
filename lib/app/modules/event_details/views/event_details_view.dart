import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_details_controller.dart';
import '../../../domain/entities/event.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/conference_app_bar.dart';
import '../../../core/widgets/animated_list_item.dart';
import '../../../core/widgets/empty_state.dart';

class EventDetailsView extends GetView<EventDetailsController> {
  const EventDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() => ConferenceAppBar(
              title: controller.selectedEvent.value != null
                  ? 'Event Details'
                  : controller.track.value?.name ?? 'Events',
            )),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.selectedEvent.value != null
                ? _buildEventDetails()
                : _buildEventsList(),
      ),
    );
  }

  Widget _buildEventsList() {
    return controller.events.isEmpty
        ? EmptyState(
            icon: Icons.event_busy_rounded,
            title: 'No Events Available',
            message:
                'There are no events available for this track at the moment.',
            buttonText: 'Back to Tracks',
            onButtonPressed: () => Get.back(),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.events.length,
            itemBuilder: (context, index) {
              final event = controller.events[index];
              return AnimatedListItem(
                index: index,
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  color:
                      event.isPast ? Colors.grey.shade50 : AppTheme.cardColor,
                  child: InkWell(
                    onTap: () => controller.selectEvent(event),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: _buildEventListItem(event),
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildEventListItem(Event event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEventDateBox(event),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: event.isPast
                          ? Colors.grey.shade700
                          : AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildEventInfoRow(
                    icon: Icons.access_time_rounded,
                    text:
                        '${event.dateTime.hour}:${event.dateTime.minute.toString().padLeft(2, '0')}',
                    isPast: event.isPast,
                  ),
                  const SizedBox(height: 4),
                  _buildEventInfoRow(
                    icon: Icons.location_on_rounded,
                    text: event.location,
                    isPast: event.isPast,
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
            _buildEventInfoRow(
              icon: Icons.people_rounded,
              text: '${event.currentParticipants}/${event.maxParticipants}',
              isPast: event.isPast,
            ),
            TextButton.icon(
              onPressed: () => controller.selectEvent(event),
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('View Details'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventDateBox(Event event) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: event.isPast
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color:
                  event.isPast ? Colors.grey.shade700 : AppTheme.primaryColor,
            ),
          ),
          Text(
            _getMonthAbbreviation(event.dateTime.month),
            style: TextStyle(
              fontSize: 14,
              color:
                  event.isPast ? Colors.grey.shade700 : AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventInfoRow(
      {required IconData icon, required String text, required bool isPast}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: double.infinity),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isPast ? Colors.grey.shade500 : AppTheme.textSecondaryColor,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isPast ? Colors.grey.shade500 : AppTheme.textSecondaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetails() {
    final event = controller.selectedEvent.value!;
    final isPast = event.isPast;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEventHeader(event),
          const SizedBox(height: 24),
          _buildEventInfo(event),
          const SizedBox(height: 24),
          _buildEventDescription(event),
          const SizedBox(height: 24),
          _buildActionButtons(event),
          if (isPast) ...[
            const SizedBox(height: 32),
            _buildFeedbackSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildEventHeader(Event event) {
    return Card(
      elevation: 0,
      color: AppTheme.primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event.dateTime.day.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Text(
                    _getMonthAbbreviation(event.dateTime.month),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryColor,
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
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: event.isPast
                              ? Colors.grey.shade300
                              : AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          event.isPast ? 'Past' : 'Upcoming',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: event.isPast
                                ? Colors.grey.shade700
                                : Colors.white,
                          ),
                        ),
                      ),
                      if (event.averageRating != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                event.averageRating!.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventInfo(Event event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Event Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.access_time_rounded,
              'Time',
              '${event.dateTime.hour}:${event.dateTime.minute.toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.calendar_today_rounded,
              'Date',
              '${event.dateTime.day}/${event.dateTime.month}/${event.dateTime.year}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.location_on_rounded,
              'Location',
              event.location,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.people_rounded,
              'Participants',
              '${event.currentParticipants}/${event.maxParticipants} (${event.availableSpots} spots left)',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventDescription(Event event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              event.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Event event) {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: event.isPast ||
                    (!event.hasAvailableSpots && !controller.isSubscribed.value)
                ? null
                : controller.toggleSubscription,
            icon: Icon(
              controller.isSubscribed.value
                  ? Icons.bookmark_remove_rounded
                  : Icons.bookmark_add_rounded,
            ),
            label: Text(
              controller.isSubscribed.value
                  ? 'Unsubscribe'
                  : 'Subscribe to Event',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor:
                  controller.isSubscribed.value ? Colors.red : null,
              disabledBackgroundColor: Colors.grey.shade300,
            ),
          ),
        ));
  }

  Widget _buildFeedbackSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Provide Feedback',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Rate this event:',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    onPressed: () => controller.rating.value = index + 1.0,
                    icon: Icon(
                      index < controller.rating.value
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.feedbackController,
              decoration: const InputDecoration(
                labelText: 'Your feedback (optional)',
                hintText: 'Share your thoughts about this event...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.submitFeedback,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Submit Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    // Ensure the month is within the valid range (1-12)
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12. Received: $month');
    }

    return months[month - 1];
  }
}
