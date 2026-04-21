import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/models/weather_data_model.dart';
import 'package:weatherapp/resources/images.dart';

import '../common/Constants/utils.dart';
import '../common/common_methods.dart';
import '../data/response/status.dart';
import '../repository/weather_repository.dart';
import '../resources/strings.dart';

class HomePageController extends GetxController{
  final _api = WeatherRepository();

  final TextEditingController searchController = TextEditingController();
  var isExpanded = true.obs;
  var showWeekly = true.obs;
  int il = -1;
  var textHighLighter = true.obs;
  List<String> hours = [];
  List<int> hoursOnly = [];
  List<int> next7DaysOnlyDay = [];
  List<String> days = [];
  var currentTime = "".obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<WeatherDataModel> weatherList = <WeatherDataModel>[];

  List<String> searchedCities = [];

  List<dynamic> weatherSearchList = [];

  void searchCityWeather() {
    String city = searchController.text.trim();
    if (city.isNotEmpty && !searchedCities.contains(city)) {
      searchedCities.add(city);
    }
    searchController.clear();
  }
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTasks = prefs.getStringList('tasks');

    if (savedTasks != null && savedTasks.isNotEmpty) {
        searchedCities.addAll(savedTasks);
    }
  }
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', searchedCities);

  }


  Future<void> fetchWeatherForSearchedCities() async {
    for (String city in searchedCities) {
      try {
        final WeatherDataModel data = await _api.weatherApi(city, 0);
        weatherSearchList.insert(0, data);
        if (weatherSearchList.length > searchedCities.length) {
          weatherSearchList = weatherSearchList.sublist(0, searchedCities.length);
        }
      } catch (e) {
        CommonMethods.showToast("Failed to load data for $city");
      }
    }
    update();
  }



  void loadData(){
    final List<Map<String, dynamic>> data  =
    [
      {
        "image_url": appImages.moonWindCloud,
        "place": "Montreal, Canada",
        "temperature": "19",
        "weather": "Fast Wind"
      },
      {
        "image_url": appImages.sunRainAngledCloud,
        "place": "New York, USA",
        "temperature": "22",
        "weather": "Shower"
      },
      {
        "image_url": appImages.moonRainCloud,
        "place": "Tokyo, Japan",
        "temperature": "30",
        "weather": "Mid Rain"
      },
      {
        "image_url": appImages.sunRainCloud,
        "place": "Paris, France",
        "temperature": "18",
        "weather": "Cloudy"
      }
    ];

    weatherList = data.map((item) => WeatherDataModel.fromJson(item)).toList();

  }

  @override
  void onInit() {
    hours = generateNext24Hours();
    currentTime.value = hours[0];
    hoursOnly = generateNext24HoursOnly();
    next7DaysOnlyDay = getNext7DaysOnlyDay();
    days = generateNext7Days();
    loadData();
    weatherApi("delhi", 7);
    super.onInit();
    loadTasks();
  }


  List<String> generateNext24Hours() {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    return List.generate(24, (index) {
      int hour = (currentHour + index) % 24;
      String period = hour >= 12 ? appStrings.pm : appStrings.am;
      int displayHour = hour % 12 == 0 ? 12 : hour % 12;
      return '$displayHour $period';
    });
  }
  List<int> generateNext24HoursOnly() {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    return List.generate(24, (index) {
      int hour = (currentHour + index) % 24;
      return hour ;
    });
  }

  List<int> getNext7DaysOnlyDay() {
    List<int> daysList = [];
    for (int i = 0; i <= 6; i++) {
      daysList.add(i);
    }
    return daysList;
  }


  List<String> generateNext7Days() {
    DateTime now = DateTime.now();
    List<String> nextDays = [];

    for (int i = 0; i < 7; i++) {
      DateTime day = now.add(Duration(days: i));
      String weekday = getWeekdayShort(day.weekday);
      nextDays.add(weekday);
    }
    return nextDays;
  }

  String getWeekdayShort(int weekday) {
    switch (weekday) {
      case 1:
        return appStrings.mon;
      case 2:
        return appStrings.tue;
      case 3:
        return appStrings.wed;
      case 4:
        return appStrings.thu;
      case 5:
        return appStrings.fri;
      case 6:
        return appStrings.sat;
      case 7:
        return appStrings.sun;
      default:
        return appStrings.blank;
    }
  }
  String getVisibilityDescription(double visibilityKm) {
    if (visibilityKm <= 0.1) {
      return '🚫 Very Poor – Dangerously low visibility';
    } else if (visibilityKm <= 1.0) {
      return '🌫️ Poor – Very limited visibility';
    } else if (visibilityKm <= 5.0) {
      return '🌁 Moderate – Moderate visibility';
    } else if (visibilityKm <= 10.0) {
      return '🌤️ Good – Good visibility';
    } else {
      return '☀️ Excellent – Clear visibility';
    }
  }

  String getAirQualityDescription(int category) {
    switch (category) {
      case 1:
        return 'Good: Air quality is healthy';
      case 2:
        return 'Moderate';
      case 3:
        return 'Unhealthy for Sensitive Groups';
      case 4:
        return 'Unhealthy';
      case 5:
        return 'Very Unhealthy';
      case 6:
        return 'Hazardous';
      default:
        return 'Unknown category';
    }
  }

  double getPointerLeftPosition(int category) {
    switch (category) {
      case 1:
        return 10;
      case 2:
        return 40;
      case 3:
        return 70;
      case 4:
        return 100;
      case 5:
        return 130;
      case 6:
        return 160;
      default:
        return 0;
    }
  }
  String getUVIndexDescription(int uvIndex) {
    switch (uvIndex) {
      case 0:
      case 1:
      case 2:
        return 'Low: Minimal risk';
      case 3:
      case 4:
      case 5:
        return 'Moderate: Use sunscreen';
      case 6:
      case 7:
        return 'High: Extra protection needed';
      case 8:
      case 9:
      case 10:
        return 'Very High: Avoid midday sun';
      default:
        return 'Extreme: Avoid sun exposure';
    }
  }

  double getUVPointerPosition(int uvIndex) {
    switch (uvIndex) {
      case 0:
        return 0;
      case 1:
        return 14;
      case 2:
        return 28;
      case 3:
        return 42;
      case 4:
        return 56;
      case 5:
        return 70;
      case 6:
        return 84;
      case 7:
        return 98;
      case 8:
        return 112;
      case 9:
        return 126;
      case 10:
        return 140;
      default:
        return 140;
    }
  }



  final rxRequestStatus = Status.COMPLETED.obs;
  final weatherData = WeatherDataModel().obs;

  void setError(String value) => error.value = value;
  RxString error = ''.obs;
  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  void setWeatherData(WeatherDataModel value) => weatherData.value = value;

  void handleError(error, stackTrace) {
    setError(error.toString());
    setRxRequestStatus(Status.ERROR);
    if (error.toString().contains("{")) {
      final errorResponse = json.decode(error.toString());
      CommonMethods.showToast(errorResponse is Map && errorResponse.containsKey('message') ? errorResponse['message'] : "An unexpected error occurred.");
    }
    Utils.printLog("Error===> ${error.toString()}");
    Utils.printLog("stackTrace===> ${stackTrace.toString()}");
  }

  Future<void> weatherApi(String location,int days) async {
    await Future.delayed(Duration(seconds: 1));
    var connection = await CommonMethods.checkInternetConnectivity();
    Utils.printLog("CheckInternetConnection===> ${connection.toString()}");

    if (connection == true) {
      setRxRequestStatus(Status.LOADING);

      _api.weatherApi(location,days).then((value) {
        setRxRequestStatus(Status.COMPLETED);
        setWeatherData(value);
        CommonMethods.showToastSuccess(value.location?.name??"");
        Utils.printLog("weatherData===> ${weatherData.value.location?.name}");

        Utils.printLog("Response===> ${value.toString()}");
      }).onError((error, stackTrace) {
        handleError(error, stackTrace);
      });
    } else {
      CommonMethods.showToast(appStrings.weUnableCheckData);
    }
  }
  String getWeatherFeeling(double feelsLikeTempC) {
    if (feelsLikeTempC <= 0) {
      return '❄️ Very Cold – Risk of frostbite';
    } else if (feelsLikeTempC <= 10) {
      return '🧥 Cold – Jacket needed';
    } else if (feelsLikeTempC <= 20) {
      return '🙂 Cool/Comfortable – Ideal for most';
    } else if (feelsLikeTempC <= 27) {
      return '🌤️ Warm – Dress lightly';
    } else if (feelsLikeTempC <= 35) {
      return '🔥 Hot – Stay hydrated';
    } else if (feelsLikeTempC <= 43) {
      return '🥵 Very Hot – Dangerous heat';
    } else {
      return '🌡️ Extreme Heat – Risk of heat stroke';
    }
  }





}