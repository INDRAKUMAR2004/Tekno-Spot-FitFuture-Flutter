import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final Color neonGreen = const Color(0xFF39FF14);

  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  void fetchNotifications() {
    // Simulated backend data
    final userData = [
      {
        "section": "Today",
        "data": [
          {"id": "1", "title": "New Workout Is Available", "date": "Sept 17", "time": "10:00 AM"},
          {"id": "2", "title": "Don’t Forget To Drink Water", "date": "Sept 17", "time": "8:00 AM"},
        ],
      },
      {
        "section": "Yesterday",
        "data": [
          {"id": "3", "title": "Upper Body Workout Completed!", "date": "Sept 16", "time": "6:00 PM"},
          {"id": "4", "title": "Remember Your Exercise Session", "date": "Sept 16", "time": "3:00 PM"},
        ],
      },
    ];

    setState(() {
      notifications = userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: neonGreen),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // Header
              Center(
                child: Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: neonGreen,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: neonGreen,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Notifications List
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, sectionIndex) {
                    final section = notifications[sectionIndex];
                    final List<dynamic> sectionData = section["data"];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Title
                        Text(
                          section["section"],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: neonGreen,
                            shadows: [
                              Shadow(
                                blurRadius: 5,
                                color: neonGreen,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Notifications inside section
                        ...sectionData.map((notif) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111111),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: neonGreen, width: 1),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.notifications, size: 28, color: neonGreen),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notif["title"],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "${notif["date"]} - ${notif["time"]}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
