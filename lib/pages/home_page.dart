import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:itspass_user/appInfo/app_info.dart';
import 'package:itspass_user/authentication/register_screen.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';
import 'package:itspass_user/pages/search_destination_place.dart';
import 'package:itspass_user/widgets/custome_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../global/global_var.dart';
import '../global/trip_var.dart';
import '../methods/common_methods.dart';
import '../methods/manage_drivers_methods.dart';
import '../methods/push_notification_service.dart';
import '../models/direction_details.dart';
import '../models/online_nearby_drivers.dart';
import '../widgets/bid_dialog.dart';
import '../widgets/info_dialog.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/payment_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPositionOfUser;
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  CommonMethods cMethods = CommonMethods();
  double searchContainerHeight = 230.h;
  double bottomMapPadding = 0;
  double rideDetailsContainerHeight = 0;
  double requestContainerHeight = 0;
  double tripContainerHeight = 0;
  DirectionDetails? tripDirectionDetailsInfo;
  List<LatLng> polylineCoOrdinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  bool isDrawerOpened = true;
  String stateOfApp = "normal";
  bool nearbyOnlineDriversKeysLoaded = false;
  BitmapDescriptor? carIconNearbyDriver;
  List<OnlineNearbyDrivers>? availableNearbyOnlineDriversList;
  bool requestingDirectionDetailsInfo = false;
  String selectedPaymentMethod = "Cash";
  TextEditingController bidController = TextEditingController();
  double actualFareAmountCar = 0.0;
  double? bidAmount;
  String selectedVehicle = "Car";
  String estimatedTimeCar = "";
  double actualFareAmount = 0.0;
  String estimatedTime = "";

  makeDriverNearbyCarIcon() {
    if (carIconNearbyDriver == null) {
      ImageConfiguration configuration =
          createLocalImageConfiguration(context, size: const Size(0.5, 0.5));
      BitmapDescriptor.fromAssetImage(
              configuration, "assets/images/tracking.png")
          .then((iconImage) {
        carIconNearbyDriver = iconImage;
      });
    }
  }

  void updateMapTheme(GoogleMapController controller) {
    getJsonFileFromThemes("themes/night_style.json")
        .then((value) => setGoogleMapStyle(value, controller));
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller) {
    controller.setMapStyle(googleMapStyle);
  }

  getCurrentLiveLocationOfUser() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionOfUser = positionOfUser;
    LatLng positionOfUserInLatLng = LatLng(
        currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: positionOfUserInLatLng, zoom: 15);
    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    await CommonMethods.convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(
        currentPositionOfUser!, context);

    await getUserInfoAndCheckBlockStatus();
    await initializeGeoFireListener();
  }

  getUserInfoAndCheckBlockStatus() async {
    // TODO: Replace with API call to check user status
    try {
      // API call to get user info and check block status would go here
      // final userInfo = await apiService.getUserInfo();
      // if (userInfo.blockStatus == "no") {
      //   setState(() {
      //     userName = userInfo.name;
      //     userPhone = userInfo.phone;
      //     userEmail = userInfo.email;
      //   });
      // } else {
      //   Navigator.push(context, MaterialPageRoute(builder: (c) => const RegisterScreen()));
      //   cMethods.displaySnackBar("You are blocked. Contact admin: gulzarsoft@gmail.com", context);
      // }
    } catch (e) {
      Navigator.push(context, MaterialPageRoute(builder: (c) => const RegisterScreen()));
    }
  }

  displayUserRideDetailsContainer() async {
    await retrieveDirectionDetails();
    if (mounted) {
      setState(() {
        searchContainerHeight = 0;
        bottomMapPadding = 240;
        rideDetailsContainerHeight = 500;
        isDrawerOpened = false;
      });
    }
  }

  retrieveDirectionDetails() async {
    var pickUpLocation =
        Provider.of<AppInfoClass>(context, listen: false).pickUpLocation;
    var dropOffDestinationLocation =
        Provider.of<AppInfoClass>(context, listen: false).dropOffLocation;

    var pickupGeoGraphicCoOrdinates = LatLng(
        pickUpLocation!.latitudePosition!, pickUpLocation.longitudePosition!);
    var dropOffDestinationGeoGraphicCoOrdinates = LatLng(
        dropOffDestinationLocation!.latitudePosition!,
        dropOffDestinationLocation.longitudePosition!);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Getting direction..."),
    );

    var detailsFromDirectionAPI =
        await CommonMethods.getDirectionDetailsFromAPI(
            pickupGeoGraphicCoOrdinates,
            dropOffDestinationGeoGraphicCoOrdinates);
    if (mounted) {
      setState(() {
        tripDirectionDetailsInfo = detailsFromDirectionAPI;
      });
    }

    Navigator.pop(context);

    PolylinePoints pointsPolyline = PolylinePoints();
    List<PointLatLng> latLngPointsFromPickUpToDestination =
        pointsPolyline.decodePolyline(tripDirectionDetailsInfo!.encodedPoints!);

    polylineCoOrdinates.clear();
    if (latLngPointsFromPickUpToDestination.isNotEmpty) {
      latLngPointsFromPickUpToDestination.forEach((PointLatLng latLngPoint) {
        polylineCoOrdinates
            .add(LatLng(latLngPoint.latitude, latLngPoint.longitude));
      });
    }

    polylineSet.clear();
    if (mounted) {
      setState(() {
        Polyline polyline = Polyline(
          polylineId: const PolylineId("polylineID"),
          color: Colors.pink,
          points: polylineCoOrdinates,
          jointType: JointType.round,
          width: 4,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
        );
        polylineSet.add(polyline);
      });
    }

    LatLngBounds boundsLatLng;
    if (pickupGeoGraphicCoOrdinates.latitude >
            dropOffDestinationGeoGraphicCoOrdinates.latitude &&
        pickupGeoGraphicCoOrdinates.longitude >
            dropOffDestinationGeoGraphicCoOrdinates.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: dropOffDestinationGeoGraphicCoOrdinates,
        northeast: pickupGeoGraphicCoOrdinates,
      );
    } else if (pickupGeoGraphicCoOrdinates.longitude >
        dropOffDestinationGeoGraphicCoOrdinates.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(pickupGeoGraphicCoOrdinates.latitude,
            dropOffDestinationGeoGraphicCoOrdinates.longitude),
        northeast: LatLng(dropOffDestinationGeoGraphicCoOrdinates.latitude,
            pickupGeoGraphicCoOrdinates.longitude),
      );
    } else if (pickupGeoGraphicCoOrdinates.latitude >
        dropOffDestinationGeoGraphicCoOrdinates.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(dropOffDestinationGeoGraphicCoOrdinates.latitude,
            pickupGeoGraphicCoOrdinates.longitude),
        northeast: LatLng(pickupGeoGraphicCoOrdinates.latitude,
            dropOffDestinationGeoGraphicCoOrdinates.longitude),
      );
    } else {
      boundsLatLng = LatLngBounds(
        southwest: pickupGeoGraphicCoOrdinates,
        northeast: dropOffDestinationGeoGraphicCoOrdinates,
      );
    }

    controllerGoogleMap!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 72));

    Marker pickUpPointMarker = Marker(
      markerId: const MarkerId("pickUpPointMarkerID"),
      position: pickupGeoGraphicCoOrdinates,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
          title: pickUpLocation.placeName, snippet: "Pickup Location"),
    );

    Marker dropOffDestinationPointMarker = Marker(
      markerId: const MarkerId("dropOffDestinationPointMarkerID"),
      position: dropOffDestinationGeoGraphicCoOrdinates,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(
          title: dropOffDestinationLocation.placeName,
          snippet: "Destination Location"),
    );
    if (mounted) {
      setState(() {
        markerSet.add(pickUpPointMarker);
        markerSet.add(dropOffDestinationPointMarker);
      });
    }

    Circle pickUpPointCircle = Circle(
      circleId: const CircleId('pickupCircleID'),
      strokeColor: Colors.blue,
      strokeWidth: 4,
      radius: 14,
      center: pickupGeoGraphicCoOrdinates,
      fillColor: Colors.pink,
    );

    Circle dropOffDestinationPointCircle = Circle(
      circleId: const CircleId('dropOffDestinationCircleID'),
      strokeColor: Colors.blue,
      strokeWidth: 4,
      radius: 14,
      center: dropOffDestinationGeoGraphicCoOrdinates,
      fillColor: Colors.pink,
    );
    if (mounted) {
      setState(() {
        circleSet.add(pickUpPointCircle);
        circleSet.add(dropOffDestinationPointCircle);
      });
    }
  }

  resetAppNow() {
    setState(() {
      polylineCoOrdinates.clear();
      polylineSet.clear();
      markerSet.clear();
      circleSet.clear();
      rideDetailsContainerHeight = 0;
      requestContainerHeight = 0;
      tripContainerHeight = 0;
      searchContainerHeight = 200.h;
      bottomMapPadding = 260.h;
      isDrawerOpened = true;

      status = "";
      nameDriver = "";
      photoDriver = "";
      phoneNumberDriver = "";
      carDetailsDriver = "";
      tripStatusDisplay = 'Driver is Arriving';
    });
  }

  cancelRideRequest() {
    // TODO: Replace with API call to cancel ride request
    if (mounted) {
      setState(() {
        stateOfApp = "normal";
      });
    }
  }

  displayRequestContainer() {
    if (mounted) {
      setState(() {
        rideDetailsContainerHeight = 0;
        requestContainerHeight = 220;
        bottomMapPadding = 200;
        isDrawerOpened = true;
      });
    }
    makeTripRequest();
  }

  updateAvailableNearbyOnlineDriversOnMap() {
    if (mounted) {
      setState(() {
        markerSet.clear();
      });
    }

    Set<Marker> markersTempSet = Set<Marker>();

    for (OnlineNearbyDrivers eachOnlineNearbyDriver
        in ManageDriversMethods.nearbyOnlineDriversList) {
      LatLng driverCurrentPosition = LatLng(
          eachOnlineNearbyDriver.latDriver!, eachOnlineNearbyDriver.lngDriver!);

      Marker driverMarker = Marker(
        markerId: MarkerId(
            "driver ID = " + eachOnlineNearbyDriver.uidDriver.toString()),
        position: driverCurrentPosition,
        icon: carIconNearbyDriver!,
      );

      markersTempSet.add(driverMarker);
    }

    setState(() {
      if (mounted) {
        markerSet = markersTempSet;
      }
    });
  }

  initializeGeoFireListener() {
    // TODO: Replace with API-based driver location tracking
  }

  makeTripRequest() {
    // TODO: Replace with API call to create trip request
    var pickUpLocation =
        Provider.of<AppInfoClass>(context, listen: false).pickUpLocation;
    var dropOffDestinationLocation =
        Provider.of<AppInfoClass>(context, listen: false).dropOffLocation;

    if (pickUpLocation == null || dropOffDestinationLocation == null) {
      return;
    }

    // API call would go here to create trip request
  }

  displayTripDetailsContainer() {
    setState(() {
      requestContainerHeight = 0;
      tripContainerHeight = 295;
      bottomMapPadding = 281;
    });
  }

  updateFromDriverCurrentLocationToPickUp(driverCurrentLocationLatLng) async {
    if (!requestingDirectionDetailsInfo) {
      requestingDirectionDetailsInfo = true;

      if (currentPositionOfUser == null) {
        requestingDirectionDetailsInfo = false;
        return;
      }

      var userPickUpLocationLatLng = LatLng(
        currentPositionOfUser!.latitude,
        currentPositionOfUser!.longitude,
      );

      var directionDetailsPickup =
          await CommonMethods.getDirectionDetailsFromAPI(
              driverCurrentLocationLatLng, userPickUpLocationLatLng);

      if (directionDetailsPickup == null) {
        requestingDirectionDetailsInfo = false;
        return;
      }

      setState(() {
        tripStatusDisplay =
            "Driver is Coming ${directionDetailsPickup.durationTextString}";
      });

      requestingDirectionDetailsInfo = false;
    }
  }

  updateFromDriverCurrentLocationToDropOffDestination(
      driverCurrentLocationLatLng) async {
    if (!requestingDirectionDetailsInfo) {
      requestingDirectionDetailsInfo = true;

      var dropOffLocation =
          Provider.of<AppInfoClass>(context, listen: false).dropOffLocation;

      if (dropOffLocation == null) {
        requestingDirectionDetailsInfo = false;
        return;
      }

      var userDropOffLocationLatLng = LatLng(
        dropOffLocation.latitudePosition!,
        dropOffLocation.longitudePosition!,
      );

      var directionDetailsPickup =
          await CommonMethods.getDirectionDetailsFromAPI(
              driverCurrentLocationLatLng, userDropOffLocationLatLng);

      if (directionDetailsPickup == null) {
        requestingDirectionDetailsInfo = false;
        return;
      }

      setState(() {
        tripStatusDisplay =
            "Drop Off Location ${directionDetailsPickup.durationTextString}";
      });

      requestingDirectionDetailsInfo = false;
    }
  }

  noDriverAvailable() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => InfoDialog(
        title: "No Driver Available",
        description:
            "No driver found in the nearby location. Please try again shortly.",
      ),
    );
  }

  searchDriver() {
    if (availableNearbyOnlineDriversList!.length == 0) {
      cancelRideRequest();
      resetAppNow();
      noDriverAvailable();
      return;
    }

    var currentDriver = availableNearbyOnlineDriversList![0];
    sendNotificationToDriver(currentDriver);
    availableNearbyOnlineDriversList!.removeAt(0);
  }

  sendNotificationToDriver(OnlineNearbyDrivers currentDriver) {
    // TODO: Replace with API call to send notification to driver
    try {
      // API call to update driver status and send notification would go here
    } catch (e) {
      // Handle error
    }
  }

  CommonMethods commonMethods = CommonMethods();

  void _calculateFareAndTime() {
    int totalMinutes = 0;
    if (estimatedTimeCar.contains("hours")) {
      List<String> timeParts = estimatedTimeCar.split(" ");
      int hours = int.tryParse(timeParts[0]) ?? 0;
      int minutes = int.tryParse(timeParts[2]) ?? 0;
      totalMinutes = (hours * 60) + minutes;
    } else {
      totalMinutes = int.tryParse(estimatedTimeCar.split(" ")[0]) ?? 0;
    }

    if (selectedVehicle == "Car") {
      setState(() {
        actualFareAmount = actualFareAmountCar;
        estimatedTime = estimatedTimeCar;
      });
    } else if (selectedVehicle == "Auto") {
      setState(() {
        actualFareAmount = actualFareAmountCar * 0.8;
        int updatedMinutes = (totalMinutes * 1.2).toInt();
        estimatedTime = commonMethods.formatTime(updatedMinutes);
      });
    } else if (selectedVehicle == "Bike") {
      setState(() {
        actualFareAmount = actualFareAmountCar * 0.4;
        int updatedMinutes = (totalMinutes * 0.8).toInt();
        estimatedTime = commonMethods.formatTime(updatedMinutes);
      });
    }
  }

  Widget _buildVehicleOption(String vehicleType, String imagePath, double fare, String time) {
    bool isSelected = selectedVehicle == vehicleType;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedVehicle = vehicleType;
          });
          // Recalculate fare when vehicle changes
          if (tripDirectionDetailsInfo != null) {
            _calculateFareAndTime();
          }
        },
        child: Container(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                width: 40.w,
                height: 30.h,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.directions_car,
                    size: 30.sp,
                    color: AppTheme.primaryColor,
                  );
                },
              ),
              SizedBox(height: AppDimensions.paddingXS),
              Text(
                vehicleType,
                style: AppTheme.captionStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
                ),
              ),
              SizedBox(height: AppDimensions.paddingXS),
              Text(
                '${fare.toStringAsFixed(0)} JOD',
                style: AppTheme.captionStyle.copyWith(
                  fontSize: 12.sp,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmRideBooking() {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(
        messageText: "Booking your ride...",
      ),
    );

    // Simulate booking process
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ride booked successfully! Fare: ${actualFareAmount.toStringAsFixed(0)} JOD',
          ),
          backgroundColor: AppTheme.successColor,
          duration: const Duration(seconds: 3),
        ),
      );
      
      // Transition to request container to find driver
      displayRequestContainer();
    });
  }

  @override
  Widget build(BuildContext context) {
    String? userAddress = Provider.of<AppInfoClass>(context, listen: false)
                .pickUpLocation !=
            null
        ? (Provider.of<AppInfoClass>(context, listen: false)
                    .pickUpLocation!
                    .placeName!
                    .length >
                35
            ? "${Provider.of<AppInfoClass>(context, listen: false).pickUpLocation!.placeName!.substring(0, 35)}..."
            : Provider.of<AppInfoClass>(context, listen: false)
                .pickUpLocation!
                .placeName)
        : 'Fetching Your Current Location.';

    if (tripDirectionDetailsInfo != null) {
      var fareString = cMethods.calculateFareAmountInPKR(
        tripDirectionDetailsInfo!,
      );
      actualFareAmountCar = double.tryParse(fareString) ?? 0.0;
      estimatedTimeCar =
          tripDirectionDetailsInfo!.durationTextString.toString();
    }


    if (tripDirectionDetailsInfo != null) {
      _calculateFareAndTime();
    }

    // final appProvider = Provider.of<AppInfoClass>(context, listen: false);
    makeDriverNearbyCarIcon();

    return SafeArea(
      child: Scaffold(
        key: sKey,
        drawer: CustomDrawer(userName: userName),
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(top: 26, bottom: bottomMapPadding),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              polylines: polylineSet,
              markers: markerSet,
              circles: circleSet,
              initialCameraPosition: googlePlexInitialPosition,
              onMapCreated: (GoogleMapController mapController) async {
                controllerGoogleMap = mapController;
                googleMapCompleterController.complete(controllerGoogleMap);

                setState(() {
                  bottomMapPadding = 260.h;
                });

                await getCurrentLiveLocationOfUser();
              },
            ),

            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  if (isDrawerOpened == true) {
                    sKey.currentState!.openDrawer();
                  } else {
                    resetAppNow();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white60,
                    radius: 30,
                    child: Icon(
                      isDrawerOpened == true ? Icons.menu : Icons.close,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 150),
                child: Container(
                  height: searchContainerHeight,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radiusXL),
                      topRight: Radius.circular(AppDimensions.radiusXL),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: AppDimensions.elevationL,
                        spreadRadius: 0.5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingL, 
                          vertical: AppDimensions.paddingM),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // From Location
                          _buildLocationRow(
                            icon: Icons.radio_button_checked,
                            iconColor: AppTheme.primaryColor,
                            label: "From",
                            address: userAddress ?? 'Unknown location',
                          ),

                          SizedBox(height: AppDimensions.paddingM),

                          Divider(
                            height: 1,
                            thickness: 1,
                            color: AppTheme.dividerColor,
                            indent: AppDimensions.paddingXL,
                            endIndent: AppDimensions.paddingXL,
                          ),

                          SizedBox(height: AppDimensions.paddingM),

                          // To Location
                          GestureDetector(
                            onTap: () async {
                              var responseFromSearchPage = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) =>
                                          const SearchDestinationPlace()));

                              if (responseFromSearchPage != null && responseFromSearchPage is Map) {
                                displayUserRideDetailsContainer();
                              }
                            },
                            child: _buildLocationRow(
                              icon: Icons.location_on,
                              iconColor: AppTheme.errorColor,
                              label: "To",
                              address: "Where would you like to go?",
                              isClickable: true,
                            ),
                          ),

                          SizedBox(height: AppDimensions.paddingM),

                          // Request Ride Button
                          SizedBox(
                            width: double.infinity,
                            height: AppDimensions.buttonHeightL,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) =>
                                          const SearchDestinationPlace()));
                              },
                              style: AppTheme.primaryButtonStyle,
                              child: Text(
                                "Request a Ride",
                                style: AppTheme.buttonTextStyle,
                              ),
                            ),
                          ),
                          
                          SizedBox(height: AppDimensions.paddingS),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Ride Details Container with Confirm Button
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 150),
                child: Container(
                  height: rideDetailsContainerHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radiusXL),
                      topRight: Radius.circular(AppDimensions.radiusXL),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: AppDimensions.elevationL,
                        spreadRadius: 0.5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: rideDetailsContainerHeight > 0
                      ? SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(AppDimensions.paddingL),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Handle bar
                                Center(
                                  child: Container(
                                    width: 40.w,
                                    height: 4.h,
                                    decoration: BoxDecoration(
                                      color: AppTheme.dividerColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppDimensions.paddingL),

                                // Trip Details Header
                                Text(
                                  'Trip Details',
                                  style: AppTheme.headingStyle.copyWith(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: AppDimensions.paddingM),

                                // Route Info
                                if (tripDirectionDetailsInfo != null) ...[
                                  Container(
                                    padding: EdgeInsets.all(AppDimensions.paddingM),
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceColor,
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.route,
                                          color: AppTheme.primaryColor,
                                          size: AppDimensions.iconSizeM,
                                        ),
                                        SizedBox(width: AppDimensions.paddingM),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Distance: ${tripDirectionDetailsInfo!.distanceTextString}',
                                                style: AppTheme.bodyStyle.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: AppDimensions.paddingXS),
                                              Text(
                                                'Duration: ${tripDirectionDetailsInfo!.durationTextString}',
                                                style: AppTheme.bodyStyle.copyWith(
                                                  color: AppTheme.textSecondaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: AppDimensions.paddingM),
                                ],

                                // Vehicle Selection
                                Text(
                                  'Select Vehicle',
                                  style: AppTheme.bodyStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: AppDimensions.paddingS),
                                
                                Row(
                                  children: [
                                    _buildVehicleOption('Car', 'assets/vehicles/home_car.png', actualFareAmountCar, estimatedTimeCar),
                                    SizedBox(width: AppDimensions.paddingS),
                                    _buildVehicleOption('Auto', 'assets/vehicles/auto.png', actualFareAmountCar * 0.8, estimatedTime),
                                    SizedBox(width: AppDimensions.paddingS),
                                    _buildVehicleOption('Bike', 'assets/vehicles/bike.png', actualFareAmountCar * 0.4, estimatedTime),
                                  ],
                                ),
                                SizedBox(height: AppDimensions.paddingL),

                                // Payment Method
                                Text(
                                  'Payment Method',
                                  style: AppTheme.bodyStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: AppDimensions.paddingS),
                                
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppDimensions.paddingM,
                                    vertical: AppDimensions.paddingS,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppTheme.dividerColor),
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        selectedPaymentMethod == 'Cash' ? Icons.money : Icons.credit_card,
                                        color: AppTheme.primaryColor,
                                        size: AppDimensions.iconSizeM,
                                      ),
                                      SizedBox(width: AppDimensions.paddingM),
                                      Expanded(
                                        child: Text(
                                          selectedPaymentMethod,
                                          style: AppTheme.bodyStyle,
                                        ),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: AppTheme.textSecondaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: AppDimensions.paddingXL),

                                // Confirm Ride Button
                                SizedBox(
                                  width: double.infinity,
                                  height: AppDimensions.buttonHeightL,
                                  child: ElevatedButton(
                                    onPressed: _confirmRideBooking,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      foregroundColor: Colors.white,
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
                                          'Confirm Ride - ${actualFareAmount.toStringAsFixed(0)} JOD',
                                          style: AppTheme.buttonTextStyle.copyWith(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppDimensions.paddingM),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String address,
    bool isClickable = false,
  }) {
    return Row(
      children: [
        Container(
          width: AppDimensions.iconSizeL + 8,
          height: AppDimensions.iconSizeL + 8,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: AppDimensions.iconSizeM,
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
              SizedBox(height: AppDimensions.paddingXS),
              Text(
                address,
                style: AppTheme.bodyStyle.copyWith(
                  color: isClickable 
                      ? AppTheme.textSecondaryColor 
                      : AppTheme.textPrimaryColor,
                  fontWeight: isClickable 
                      ? FontWeight.normal 
                      : FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (isClickable)
          Icon(
            Icons.arrow_forward_ios,
            size: AppDimensions.iconSizeS,
            color: AppTheme.textSecondaryColor,
          ),
      ],
    );
  }
}
