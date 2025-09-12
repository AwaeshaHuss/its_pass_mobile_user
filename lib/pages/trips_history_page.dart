// Firebase imports removed - using API-based services
import 'package:flutter/material.dart';

class TripsHistoryPage extends StatefulWidget {
  const TripsHistoryPage({super.key});

  @override
  State<TripsHistoryPage> createState() => _TripsHistoryPageState();
}

class _TripsHistoryPageState extends State<TripsHistoryPage> {
  // TODO: Replace with API-based trip history service
  List<Map<String, dynamic>> tripHistory = [];

  Future<List<Map<String, dynamic>>> _loadTripHistory() async {
    // TODO: Implement API call to fetch trip history
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    return tripHistory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'My Trips History',
          style: TextStyle(
            color: Colors.black,
          ),
          
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadTripHistory(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading trip history.",
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No trip history found.",
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          final tripsList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(5),
            shrinkWrap: true,
            itemCount: tripsList.length,
            itemBuilder: (context, index) {
              final trip = tripsList[index];
              return Card(
                color: Colors.white,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pickup - fare amount
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/initial.png',
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Text(
                              trip["pickUpAddress"]?.toString() ?? "Unknown pickup",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Rs ${trip["fareAmount"]?.toString() ?? "0"}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Dropoff
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/final.png',
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Text(
                              trip["dropOffAddress"]?.toString() ?? "Unknown destination",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
