import 'dart:async';
import 'package:ekklesia/models/event.dart';
import 'package:ekklesia/services/event_service.dart';
import 'package:ekklesia/services/user_service.dart';
import 'package:ekklesia/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {
  const EventCard({super.key});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late Future<Event?> _latestEventFuture;
  bool _isRegistered = false;

  @override
  void initState() {
    super.initState();
    _latestEventFuture = EventService().getLatestEvent(); // Fetch latest event
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Event?>(
      future: _latestEventFuture,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            margin: const EdgeInsets.all(16.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // No event found state
        if (!snapshot.hasData || snapshot.data == null) {
          return Card(
            margin: const EdgeInsets.all(16.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text('No upcoming event found.')),
            ),
          );
        }

        // Event found
        final event = snapshot.data!;
        final String formattedDate = DateFormat(
          'MMM dd, yyyy',
        ).format(event.eventDate);

        // Check if the user is already registered for the event
        _checkIfUserIsRegistered(event.id);

        return Card(
          margin: const EdgeInsets.all(16.0),
          color: AppColors.background,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Countdown timer widget (compact version)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: CountdownTimer(eventDate: event.eventDate)),
                  ],
                ),
                const SizedBox(height: 8),
                // Event title
                Text(
                  event.title, // Display the event title dynamically
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Event description
                Text(
                  event.description, // Display the event description
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                // Event date
                Row(
                  children: [
                    Icon(Icons.calendar_month),
                    SizedBox(width: 2),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Register button
                ElevatedButton(
                  style:
                      _isRegistered
                          ? ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          )
                          : ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                  onPressed: () {
                    if (!_isRegistered) {
                      // Handle registration logic if not registered
                      _registerForEvent(event);
                    }
                  },
                  child:
                      _isRegistered
                          ? Text(
                            "Attending",
                            style: TextStyle(color: Colors.white),
                          )
                          : Text(
                            "Register for Event",
                            style: TextStyle(color: Colors.white),
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _checkIfUserIsRegistered(int eventId) async {
    final attendantId = await UserService().getUuid(); // This is a UUID string

    try {
      final isRegistered = await EventService().isUserRegisteredForEvent(
        attendantId!,
        eventId,
      );
      setState(() {
        _isRegistered = isRegistered;
      });
    } catch (e) {
      print('Error during check: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error checking registration: $e")),
        );
      }
    }
  }

  // Register user for the event
  Future<void> _registerForEvent(Event event) async {
    final attendantId = await UserService().getUuid();
    final eventId = event.id;

    try {
      // Register user in event_attendees table
      await EventService().registerForEvent(attendantId!, eventId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully registered for the event!"),
          ),
        );
      }
      // Update the button to "Attending"
      setState(() {
        _isRegistered = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}

class CountdownTimer extends StatefulWidget {
  final DateTime eventDate;

  const CountdownTimer({super.key, required this.eventDate});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.eventDate.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), _updateCountdown);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateCountdown(Timer timer) {
    setState(() {
      _remainingTime = widget.eventDate.difference(DateTime.now());

      // Stop the timer when the event has passed (remaining time is negative)
      if (_remainingTime.isNegative) {
        _timer.cancel();
        _remainingTime =
            Duration.zero; // Set it to zero to stop negative countdown
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_remainingTime == Duration.zero) {
      return Row(
        children: const [
          Icon(
            Icons.live_tv, // Icon representing the event is live
            color: Colors.green,
          ),
          SizedBox(width: 8),
          Text(
            "Event is Live",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      );
    }

    // Calculate days, hours, minutes, and seconds in a more compact form
    String days = _remainingTime.inDays > 0 ? "${_remainingTime.inDays}d " : "";
    String hours = (_remainingTime.inHours % 24).toString().padLeft(2, '0');
    String minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    final String countdown = "$days$hours:$minutes:$seconds";

    return Row(
      children: [
        Icon(Icons.live_tv, color: Colors.red),
        SizedBox(width: 2),
        Text(
          "Upcoming in",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.red,
          ),
        ),
        SizedBox(width: 2),
        Text(
          countdown,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
