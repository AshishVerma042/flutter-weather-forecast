import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/controller/homepage_controller.dart';
import 'package:weatherapp/screen/homePage.dart';
import 'package:weatherapp/screen/slantedCard.dart';

import '../models/weather_data_model.dart';
import '../resources/routes/routes.dart';

Widget cityWeather(HomePageController controller) {
  final TextEditingController _controller = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            InkWell(onTap: (){
              Get.off(RoutesClass.homeScreen);
            },
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white60)),
            const SizedBox(width: 10),
            const Text(
              "Weather",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ],
        ),
      ),

      // Search Field
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 19, 3, 83),
          ),
          child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: searchFocusNode,
              controller: controller.searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search for a city or airport",
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white60),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                // Optional: implement live filtering or debounce
                print("User is typing: $value");
              },
              onSubmitted: (value) async {
                if (value.trim().isEmpty) return;
                searchFocusNode.unfocus();
                controller.searchCityWeather();
                await controller.fetchWeatherForSearchedCities();
                print("Submit value: $value");
                controller.saveTasks();

                print(controller.searchedCities);

              },
            ),
          ),

    ],
  ),

        ),
      ),

      Expanded(
        child: ListView.builder(padding: EdgeInsets.only(top: 10),
          itemCount: controller.weatherSearchList.length ,
          itemBuilder: (context, index) {
            final WeatherDataModel weather = controller.weatherSearchList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Stack(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0, right: 6, left: 6),
                    child: SlantedCard(),
                  ),
                  Positioned(
                    top: 0,
                    child: SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Text(
                                     "${weather.current?.tempC ?? 0}°" ,
                                      style: const TextStyle(fontSize: 57, color: Colors.white),
                                    ),
                                     Text(
                                      "H:${weather.forecast?.forecastday?[0].day?.maxtempC ?? 0}°   L:${weather.forecast?.forecastday?[0].day?.mintempC ?? 0}°",
                                      style: TextStyle(fontSize: 14, color: Colors.white54),
                                    ),
                                  ],
                                ),
                                // if (weather.imageUrl != null && weather.imageUrl!.isNotEmpty)
                                //   Image.asset(weather.imageUrl!, scale: 1.3),
                                SizedBox(width: 37),
                                if (weather.forecast?.forecastday?[0].day?.condition?.icon != null)
                                  Image.network("https:${weather.forecast?.forecastday?[0].day?.condition?.icon}",
                                    scale: 0.49,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error_outline, color: Colors.white),
                                  ),

                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${weather.location?.name ?? 'Unknown City'}, ${weather.location?.country ?? 'Unknown City'}",
                                  style: const TextStyle(fontSize: 14, color: Colors.white),
                                ),
                                Text(
                                 weather.forecast?.forecastday?[0].day?.condition?.text ?? "",
                                  style: const TextStyle(fontSize: 14, color: Colors.white),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}
