// Firebase imports removed - using API-based services
import 'package:flutter/material.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';

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
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: AppDimensions.elevationM,
        centerTitle: true,
        title: Text(
          'My Trips History',
          style: AppTheme.titleStyle.copyWith(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadTripHistory(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: AppDimensions.iconSizeXL,
                    color: AppTheme.errorColor,
                  ),
                  SizedBox(height: AppDimensions.paddingM),
                  Text(
                    "Error loading trip history.",
                    style: AppTheme.bodyStyle.copyWith(
                      color: AppTheme.errorColor,
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
                strokeWidth: 3,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: AppDimensions.iconSizeXXL,
                    color: AppTheme.textSecondaryColor,
                  ),
                  SizedBox(height: AppDimensions.paddingL),
                  Text(
                    "No trips yet",
                    style: AppTheme.headingStyle.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  SizedBox(height: AppDimensions.paddingS),
                  Text(
                    "Your trip history will appear here",
                    style: AppTheme.bodyStyle.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          final tripsList = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            itemCount: tripsList.length,
            itemBuilder: (context, index) {
              final trip = tripsList[index];
              return Container(
                margin: EdgeInsets.only(bottom: AppDimensions.paddingM),
                child: Card(
                  color: AppTheme.surfaceColor,
                  elevation: AppDimensions.elevationM,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Trip Date and Fare
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              trip["date"]?.toString() ?? "Recent Trip",
                              style: AppTheme.captionStyle.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingM,
                                vertical: AppDimensions.paddingS,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLightColor,
                                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                              ),
                              child: Text(
                                "Rs ${trip["fareAmount"]?.toString() ?? "0"}",
                                style: AppTheme.bodyStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: AppDimensions.paddingM),
                        
                        // Pickup Location
                        _buildLocationRow(
                          icon: Icons.radio_button_checked,
                          iconColor: AppTheme.primaryColor,
                          address: trip["pickUpAddress"]?.toString() ?? "Unknown pickup",
                          label: "Pickup",
                        ),
                        
                        SizedBox(height: AppDimensions.paddingS),
                        
                        // Dropoff Location
                        _buildLocationRow(
                          icon: Icons.location_on,
                          iconColor: AppTheme.errorColor,
                          address: trip["dropOffAddress"]?.toString() ?? "Unknown destination",
                          label: "Destination",
                        ),
                        
                        SizedBox(height: AppDimensions.paddingM),
                        
                        // Trip Status
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingM,
                            vertical: AppDimensions.paddingS,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                            border: Border.all(
                              color: AppTheme.successColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: AppDimensions.iconSizeS,
                                color: AppTheme.successColor,
                              ),
                              SizedBox(width: AppDimensions.paddingS),
                              Text(
                                "Completed",
                                style: AppTheme.captionStyle.copyWith(
                                  color: AppTheme.successColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  
  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String address,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: AppDimensions.iconSizeM,
          height: AppDimensions.iconSizeM,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: AppDimensions.iconSizeS,
            color: iconColor,
          ),
        ),
        SizedBox(width: AppDimensions.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.captionStyle.copyWith(
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                address,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: AppTheme.bodyStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
