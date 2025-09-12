import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:itspass_user/appInfo/app_info.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';
import 'package:itspass_user/global/global_var.dart';
import 'package:itspass_user/main.dart';
import 'package:itspass_user/methods/common_methods.dart';
import 'package:itspass_user/models/prediction_model.dart';
import 'package:itspass_user/widgets/prediction_place_ui.dart';

class SearchDestinationPlace extends StatefulWidget {
  const SearchDestinationPlace({super.key});

  @override
  State<SearchDestinationPlace> createState() => _SearchDestinationPlaceState();
}

class _SearchDestinationPlaceState extends State<SearchDestinationPlace> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController destinationTextEditingController =
      TextEditingController();

  List<PredictionModel> dropOffPredictionsPlacesList = [];
  String? selectedDestinationPlaceId;
  String? selectedDestinationAddress;
  searchLocation(String locationName) async {
    if (locationName.length > 1) {
      String encodedLocationName = Uri.encodeComponent(locationName);
      String apiPlacesUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$encodedLocationName&key=$googleMapKey&components=country:jo&language=ar";
      // API PLACE URL: $apiPlacesUrl

      var responseFromPlacesAPI =
          await CommonMethods.sendRequestToAPI(apiPlacesUrl);

      if (responseFromPlacesAPI == "error") {
        return;
      }

      if (responseFromPlacesAPI["status"] == "OK") {
        var predictionsResultsInJson = responseFromPlacesAPI["predictions"];
        var predictionsList = (predictionsResultsInJson as List)
            .map(
              (eachPlacePrediction) =>
                  PredictionModel.fromJson(eachPlacePrediction),
            )
            .toList();

        // Check if the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            dropOffPredictionsPlacesList = predictionsList;
          });
          // Predicted places: $predictionsResultsInJson
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String userAddress = Provider.of<AppInfoClass>(context, listen: false)
            .pickUpLocation!
            .humanReadableAddress ??
        '';

    pickUpTextEditingController.text = userAddress;
    mq = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: AppDimensions.iconSizeM,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Set Dropoff Location",
          style: AppTheme.headingStyle.copyWith(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(AppDimensions.paddingM),
            padding: EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Pickup Location
                Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: AppDimensions.paddingM),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingM,
                          vertical: AppDimensions.paddingS,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          border: Border.all(
                            color: AppTheme.dividerColor,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: pickUpTextEditingController,
                          enabled: false,
                          style: AppTheme.bodyStyle.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                          decoration: InputDecoration(
                            hintText: "Pickup Address",
                            hintStyle: AppTheme.bodyStyle.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.paddingM),
                // Destination Location
                Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: AppDimensions.paddingM),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingM,
                          vertical: AppDimensions.paddingS,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          border: Border.all(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: TextField(
                          controller: destinationTextEditingController,
                          onChanged: (value) {
                            searchLocation(value);
                            // Clear selection when user types
                            if (selectedDestinationPlaceId != null) {
                              setState(() {
                                selectedDestinationPlaceId = null;
                                selectedDestinationAddress = null;
                              });
                            }
                          },
                          style: AppTheme.bodyStyle,
                          decoration: InputDecoration(
                            hintText: "Where to? (e.g., تاج مول)",
                            hintStyle: AppTheme.bodyStyle.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            suffixIcon: destinationTextEditingController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: AppTheme.textSecondaryColor,
                                      size: AppDimensions.iconSizeS,
                                    ),
                                    onPressed: () {
                                      destinationTextEditingController.clear();
                                      setState(() {
                                        dropOffPredictionsPlacesList.clear();
                                        selectedDestinationPlaceId = null;
                                        selectedDestinationAddress = null;
                                      });
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Display prediction results
          Expanded(
            child: dropOffPredictionsPlacesList.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingS,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: AppDimensions.paddingXS),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Set selected destination
                            setState(() {
                              selectedDestinationPlaceId = dropOffPredictionsPlacesList[index].place_id;
                              selectedDestinationAddress = dropOffPredictionsPlacesList[index].main_text;
                              destinationTextEditingController.text = dropOffPredictionsPlacesList[index].main_text ?? '';
                              dropOffPredictionsPlacesList.clear();
                            });
                          },
                          child: PredictionPlaceUI(
                            predictedPlaceData: dropOffPredictionsPlacesList[index],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(height: AppDimensions.paddingXS),
                    itemCount: dropOffPredictionsPlacesList.length,
                  )
                : Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingXL),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 64.sp,
                            color: AppTheme.textSecondaryColor.withOpacity(0.5),
                          ),
                          SizedBox(height: AppDimensions.paddingM),
                          Text(
                            "Start typing to search for places",
                            style: AppTheme.bodyStyle.copyWith(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 16.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppDimensions.paddingS),
                          Text(
                            "Try searching in Arabic: تاج مول، عبدون، وسط البلد",
                            style: AppTheme.bodyStyle.copyWith(
                              color: AppTheme.textSecondaryColor.withOpacity(0.7),
                              fontSize: 14.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          
        ],
      ),
      // Confirm Ride Button - Fixed positioning
      bottomNavigationBar: selectedDestinationPlaceId != null
          ? Container(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: _confirmRide,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingL,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car,
                        size: AppDimensions.iconSizeM,
                      ),
                      SizedBox(width: AppDimensions.paddingS),
                      Text(
                        'Confirm Ride',
                        style: AppTheme.headingStyle.copyWith(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
  
  void _confirmRide() {
    if (selectedDestinationPlaceId == null || selectedDestinationAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a destination first'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }
    
    // Navigate to ride confirmation/booking screen
    // You can pass the destination details to the next screen
    Navigator.pop(context, {
      'placeId': selectedDestinationPlaceId,
      'address': selectedDestinationAddress,
    });
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ride confirmed to: $selectedDestinationAddress'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
}
