import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_users_app/appInfo/app_info.dart';
import 'package:uber_users_app/global/global_var.dart';
import 'package:uber_users_app/methods/common_methods.dart';
import 'package:uber_users_app/models/address_models.dart';
import 'package:uber_users_app/models/prediction_model.dart';
import 'package:uber_users_app/widgets/loading_dialog.dart';

class PredictionPlaceUI extends StatefulWidget {
  final PredictionModel? predictedPlaceData;

  const PredictionPlaceUI({super.key, this.predictedPlaceData});

  @override
  State<PredictionPlaceUI> createState() => _PredictionPlaceUIState();
}

class _PredictionPlaceUIState extends State<PredictionPlaceUI> {
  fetchClickedPlaceDetails(String placeId) async {
    // Show loading dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Getting details..."),
    );

    // Construct the API URL
    String urlPlaceDetailAPI =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleMapKey";
    // Debug: Check the URL - $urlPlaceDetailAPI

    // Send the request to the API
    var responseFromPlaceDetailsAPI =
        await CommonMethods.sendRequestToAPI(urlPlaceDetailAPI);

    // Close the loading dialog
    Navigator.pop(context);

    // Debug: Check if there's an error in the response
    if (responseFromPlaceDetailsAPI == "error") {
      // Error: Failed to fetch place details
      return;
    }

    // Debug: Check the response structure
    // API Response: $responseFromPlaceDetailsAPI

    // Check the status of the response
    if (responseFromPlaceDetailsAPI["status"] == "OK") {
      AddressModel dropOffLocation = AddressModel();

      // Extract place name
      dropOffLocation.placeName = responseFromPlaceDetailsAPI["result"]["name"];
      // Debug: Check place name - ${dropOffLocation.placeName}

      // Extract latitude
      dropOffLocation.latitudePosition =
          responseFromPlaceDetailsAPI["result"]["geometry"]["location"]["lat"];
      // Debug: Check latitude - ${dropOffLocation.latitudePosition}

      // Extract longitude
      dropOffLocation.longitudePosition =
          responseFromPlaceDetailsAPI["result"]["geometry"]["location"]["lng"];
      // Debug: Check longitude - ${dropOffLocation.longitudePosition}

      // Set the place ID
      dropOffLocation.placeID = placeId;
      // Debug: Check place ID - ${dropOffLocation.placeID}

      // Update the drop-off location in the provider
      Provider.of<AppInfoClass>(context, listen: false)
          .updateDropOffLocation(dropOffLocation);

      // Pop the current screen and return "placeSelected"
      Navigator.pop(context, "placeSelected");
    } else {
      // Error: ${responseFromPlaceDetailsAPI["status"]} - ${responseFromPlaceDetailsAPI["error_message"]}
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        fetchClickedPlaceDetails(
            widget.predictedPlaceData!.place_id.toString());
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.share_location,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.predictedPlaceData!.main_text.toString(),
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      widget.predictedPlaceData!.secondary_text.toString(),
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
