import 'package:ekklesia/features/event/event_chat_screen.dart';
import 'package:ekklesia/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:ekklesia/services/event_service.dart';
import 'package:ekklesia/models/event.dart';
import 'package:intl/intl.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late Future<List<Event>> _events;

  @override
  void initState() {
    super.initState();
    _events = EventService().getAllEvents(); // Fetch all events
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Events", style: Theme.of(context).textTheme.displayLarge),
            SizedBox(height: 10),
            FutureBuilder<List<Event>>(
              future: _events,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No events found.'));
                } else {
                  final events = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Card(
                          color: AppColors.background,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 5,
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          EventChatScreen(event: event),
                                ),
                              );
                            },
                            contentPadding: const EdgeInsets.all(16.0),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  event.title,
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                                event.eventCompleted
                                    ? Icon(Icons.check, color: Colors.green)
                                    : Icon(Icons.timelapse, color: Colors.red),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(event.description),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      size: 20,
                                      color: AppColors.secondary,
                                    ),
                                    Text(
                                      DateFormat(
                                        'MMM dd, yyyy',
                                      ).format(event.eventDate),
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.displaySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
