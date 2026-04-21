import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weatherapp/controller/homepage_controller.dart';
import 'package:weatherapp/resources/images.dart';
import 'package:weatherapp/resources/strings.dart';
import 'package:weatherapp/screen/windCompass.dart';
import '../appColors.dart';
import 'presser_card.dart';
import '../resources/gradient.dart';
import 'cityWeatherDrawer.dart';
import 'package:get/get.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    HomePageController controller = Get.put(HomePageController());

    return Obx(() =>
        DefaultTabController(
          length: 2,
          child: Scaffold(
            key: controller.scaffoldKey,

            endDrawer: Drawer(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Container(padding: EdgeInsets.only(top: 40), decoration: BoxDecoration(gradient: lgr3),
                    child: cityWeather(controller))
            ),


            body: AnimatedContainer(
              duration: Duration(microseconds: 1),
              decoration: BoxDecoration(
                image: DecorationImage(colorFilter: ColorFilter.mode(AppColors.primaryPurpleAlpha200, BlendMode.color), image: AssetImage(appImages.firstBackgroundImage), fit: BoxFit.cover),
              ),
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(appImages.secondBackgroundImage), fit: BoxFit.fitWidth, alignment: Alignment(0, 0.74)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.05),
                    headingAnimatedContainer(MediaQuery
                        .of(context)
                        .size
                        .width, MediaQuery
                        .of(context)
                        .size
                        .height, controller.isExpanded.value, controller),
                    Stack(
                      alignment: Alignment(0, 0.98),
                      children: [
                        bottomAnimationContainer(
                          controller,
                          MediaQuery
                              .of(context)
                              .size
                              .width,
                          MediaQuery
                              .of(context)
                              .size
                              .height,
                          controller.isExpanded.value,
                          controller.textHighLighter.value,
                          controller.hours,
                          controller.hoursOnly,
                          controller.next7DaysOnlyDay,
                          controller.days,
                          controller.currentTime.value,
                           controller.showWeekly.value,

                          onIconTap: () {
                            controller.isExpanded.value = !controller.isExpanded.value;
                          },

                        ),
                        bottomMenuBar(
                          controller.scaffoldKey,
                          onDrawerTap: () {
                            controller.scaffoldKey.currentState?.openEndDrawer();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }


  Widget bottomMenuBar(GlobalKey<ScaffoldState> scaffoldKey, {void Function()? onDrawerTap}) {
    return Positioned(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(55), bottomRight: Radius.circular(55)),
          image: DecorationImage(image: AssetImage(appImages.backgroundBottomMenu), fit: BoxFit.fitWidth),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(appImages.leftIcon, width: 55),
            Stack(
              children: [
                Image.asset(appImages.centerBottomMenu),
                Positioned(
                  left: 99.0,
                  top: 10,
                  child: InkWell(
                    onTap: () {
                      // showBottomSheet();
                    },
                    child: Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [BoxShadow(spreadRadius: 4, color: AppColors.primaryPurple)],
                        border: Border.all(width: 2, color: AppColors.primaryPurple),
                      ),
                      child: Center(child: SvgPicture.asset(appImages.addSymbol, width: 33)),
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: onDrawerTap,
              child: SvgPicture.asset(appImages.rightIcon, width: 55),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomAnimationContainer(HomePageController controller, double w, double h, bool isExpanded, bool textHighLighter, List<String> hours, List<int> hoursOnly, List<int> next7DaysOnlyDay, List<String> days, String currentTime, bool showWeekly,
      {void Function()? onIconTap, void Function()? onHourTap, void Function()? onWeeklyTap}) {
    double visibilityDouble = controller.weatherData.value.current?.visKm ?? 0;
    int visibility = visibilityDouble.round();
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      width: w,
      height: isExpanded ? h * 0.40 : h * 0.76,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(55), color: AppColors.primaryPurpleAlpha160),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: onIconTap,
                child: Transform.rotate(
                  angle: isExpanded ? 180 * pi / 90 : 90 * pi / 90,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, isExpanded ? 12 : 0),
                    child: Icon(Icons.keyboard_double_arrow_up_outlined, color: AppColors.onPrimary),
                  ),
                ),
              ),
            ],
          ),
          TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: appStrings.hourlyForecast),
              Tab(text: appStrings.weeklyForecast),
            ],
          ),

          Center(
            child: Container(
              decoration: BoxDecoration(gradient: rlgr),
              margin: EdgeInsets.symmetric(vertical: 8),
              width: w,
              height: 3,
            ),
          ),

          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: TabBarView(
                children: [
                  // Hourly Forecast Tab
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 130, child: hoursGeneratingList(hours, controller, hoursOnly)),
                        SizedBox(height: 20),
                        airQualityCard(controller),
                        SizedBox(height: 10),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [uvIndexCard(controller), sunRiseCard(currentTime)]),
                        SizedBox(height: 10),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [weatherWindCard(controller), weatherInfoCard(Icons.water_drop, appStrings.rainfall, "Daily Chance ${controller.weatherData.value.forecast?.forecastday?[0].day?.dailyChanceOfRain ?? 0}%", controller.weatherData.value.forecast?.forecastday?[0].day?.condition?.text ?? "", fontSize: 25)]),
                        SizedBox(height: 10),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                          weatherInfoCard(Icons.thermostat, appStrings.feelsLike, "${controller.weatherData.value.current?.feelslikeC ?? 0}", controller.getWeatherFeeling(controller.weatherData.value.current?.feelslikeC ?? 0)),
                          weatherInfoCard(Icons.hot_tub, appStrings.humidity, "${controller.weatherData.value.current?.humidity ?? 0}%", "The dew point is ${controller.weatherData.value.current?.dewpointC ?? 0} right now."),
                        ]),
                        SizedBox(height: 10),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                          weatherInfoCard(Icons.visibility, appStrings.visibility, "$visibility Km", controller.getVisibilityDescription(visibilityDouble)),
                          weatherPressureCard(),
                        ]),
                        SizedBox(height: 150),
                      ],
                    ),
                  ),


                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 130, child: daysGeneratingList(days, controller, next7DaysOnlyDay)),
                        SizedBox(height: 20),
                        airQualityCard(controller),
                        SizedBox(height: 10),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [uvIndexCard(controller), sunRiseCard(currentTime)]),
                        SizedBox(height: 10),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [weatherWindCard(controller), weatherInfoCard(Icons.water_drop, appStrings.rainfall, "Daily Chance ${controller.weatherData.value.forecast?.forecastday?[0].day?.dailyChanceOfRain ?? 0}%", controller.weatherData.value.forecast?.forecastday?[0].day?.condition?.text ?? "", fontSize: 25)]),
                        SizedBox(height: 10),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                          weatherInfoCard(Icons.thermostat, appStrings.feelsLike, "${controller.weatherData.value.current?.feelslikeC ?? 0}", controller.getWeatherFeeling(controller.weatherData.value.current?.feelslikeC ?? 0)),
                          weatherInfoCard(Icons.hot_tub, appStrings.humidity, "${controller.weatherData.value.current?.humidity ?? 0}%", "The dew point is ${controller.weatherData.value.current?.dewpointC ?? 0} right now."),
                        ]),
                        SizedBox(height: 10),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                          weatherInfoCard(Icons.visibility, appStrings.visibility, "$visibility Km", controller.getVisibilityDescription(visibilityDouble)),
                          weatherPressureCard(),
                        ]),
                        SizedBox(height: 150),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),



        ],
      ),
    );
  }

  Widget sunRiseCard(String currentTime) {
    return Container(
      width: 180,
      height: 180,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColors.primaryPurpleAlpha250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wb_twilight_outlined, color: AppColors.mutedText),
              SizedBox(width: 8),
              Text(
                appStrings.sunRise.toUpperCase(),
                style: TextStyle(color: AppColors.mutedText, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            currentTime,
            style: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Image.asset(appImages.weatherSunRaiseImage),
          Text(appStrings.sunset645, style: TextStyle(color: AppColors.onPrimary)),
        ],
      ),
    );
  }

  Widget uvIndexCard(HomePageController controller) {
    double uvIndexDouble = controller.weatherData.value.current?.uv ?? 0;
    int uvIndex = uvIndexDouble.round();
    return Container(
      width: 180,
      height: 180,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColors.primaryPurpleAlpha250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Icon(Icons.sunny, color: AppColors.mutedText, size: 20),
              SizedBox(width: 10),
              Text(
                appStrings.uvIndex.toUpperCase(),
                style: TextStyle(fontSize: 14, color: AppColors.mutedText, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            "$uvIndexDouble",
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.onPrimary, fontSize: 35),
          ),
          Text(
            controller.getUVIndexDescription(uvIndex),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.onPrimary),
          ),
          progressPointer(9, controller.getUVPointerPosition(uvIndex)),
        ],
      ),
    );
  }

  Widget airQualityCard(HomePageController controller) {
    int airIndex = controller.weatherData.value.current?.airQuality?.usEpaIndex ?? 0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 180,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColors.primaryPurpleAlpha250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(appImages.airQualityCardImage, height: 20),
              SizedBox(width: 10),
              Text(
                appStrings.airQuality.toUpperCase(),
                style: TextStyle(fontSize: 14, color: AppColors.mutedText, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            " $airIndex-${controller.getAirQualityDescription(airIndex)}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: AppColors.onPrimary),
          ),
          progressPointer(9, controller.getPointerLeftPosition(airIndex)),
          Divider(thickness: 1.0, color: Colors.grey.shade700),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(appStrings.showMore, style: TextStyle(fontSize: 21, color: AppColors.onPrimary)),
              Icon(Icons.arrow_forward_ios, color: AppColors.onPrimary),
            ],
          ),
        ],
      ),
    );
  }

  Widget tabHighlighter(bool textHighLighter, Gradient lgr, Gradient rlg) {
    return Container(height: 2, width: 105, decoration: BoxDecoration(gradient: textHighLighter ? lgr : rlg));
  }

  Widget headingAnimatedContainer(double w, double h, bool isExpanded, HomePageController controller) {
    return AnimatedContainer(
      duration: Duration(seconds: 2),
      curve: Curves.ease,
      height: isExpanded ? h * 0.19 : h * 0.19,
      width: w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            "${controller.weatherData.value.location?.name ?? ""}, ${controller.weatherData.value.location?.country ?? ""}",
            style: TextStyle(color: AppColors.onPrimary, fontSize: isExpanded ? 25 : 35),
          ),
          if (isExpanded)...[
            Text(
              '${controller.weatherData.value.current?.tempC ?? ""}',
              style: TextStyle(color: AppColors.onPrimary, fontSize: 67),
            ),
          ],


          Text(
            isExpanded ? (controller.weatherData.value.current?.condition?.text ?? "")
                : "${controller.weatherData.value.current?.tempC ?? ""} | ${controller.weatherData.value.current?.condition?.text ?? ""}",
            style: TextStyle(color: AppColors.mutedText1, fontWeight: FontWeight.bold, fontSize: isExpanded ? 15 : 16),
          ),
          Text(
            isExpanded ? "${(controller.weatherData.value.forecast?.forecastday?[0].day?.mintempC ?? "")} | ${(controller.weatherData.value.forecast?.forecastday?[0].day?.maxtempC ?? "")}" : appStrings.blank,
            style: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.bold, fontSize: isExpanded ? 15 : 0),
          ),
        ],
      ),
    );
  }

  Widget hoursGeneratingList(List<String> hours, HomePageController controller, List<int> hoursOnly) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: hours.length,
      itemBuilder: (context, index) {
        return Container(
          height: 60,
          width: 55,
          padding: EdgeInsets.all(6),
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(55), color: AppColors.primaryPurpleAlpha250),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(hours[index], style: TextStyle(color: AppColors.onPrimary, fontSize: 14)),
              if (controller.weatherData.value.forecast?.forecastday?[0].hour?[0].condition?.icon != null)
                Image.network("https:${controller.weatherData.value.forecast?.forecastday?[0].hour?[hoursOnly[index]].condition?.icon}",
                  scale: 0.49,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error_outline, color: Colors.white),
                ),
              Text(
                "${(controller.weatherData.value.forecast?.forecastday?[0].hour?[hoursOnly[index]]?.tempC ?? "")}",
                style: TextStyle(color: AppColors.onPrimary, fontSize: 14),
              )
            ],
          ),
        );
      },
    );
  }

  Widget progressPointer(double top, double left) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          height: 6,
          decoration: BoxDecoration(gradient: lgr2, borderRadius: BorderRadius.circular(50)),
        ),
        Positioned(
          top: top,
          left: left,
          child: Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: AppColors.onPrimary,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(width: 0.4, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget weatherWindCard(HomePageController controller) {
    num doubleDegreeWind = controller.weatherData.value.current?.windDegree ?? 0;
    double degreeWind = doubleDegreeWind.toDouble();
    return Container(
        width: 180,
        height: 180,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColors.primaryPurpleAlpha250),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.air, color: AppColors.mutedText,),
                SizedBox(width: 8),
                Text("Wind".toUpperCase(),
                  style: TextStyle(color: AppColors.mutedText, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Center(
              child: WindCompass(
                windDegree: degreeWind,
                windKph: controller.weatherData.value.current?.windKph ?? 0,
                windDir: controller.weatherData.value.current?.windDir ?? "",
              ),
            )

          ],
        )
    );
  }

  Widget weatherPressureCard() {
    return Container(
        width: 180,
        height: 180,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColors.primaryPurpleAlpha250),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.speed_outlined, color: AppColors.mutedText,),
                SizedBox(width: 8),
                Text("Pressure".toUpperCase(),
                  style: TextStyle(color: AppColors.mutedText, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Center(
              child: RotatingButtonOverZebraRing(),
            ),


          ],
        )
    );
  }

  Widget weatherInfoCard(IconData icon, String iconText, String middleText, String bottomText, {double fontSize = 45}) {
    return Container(
      width: 180,
      height: 180,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColors.primaryPurpleAlpha250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.mutedText),
              SizedBox(width: 8),
              Text(
                iconText.toUpperCase(),
                style: TextStyle(color: AppColors.mutedText, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            middleText,
            style: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.bold, fontSize: fontSize),
          ),
          SizedBox(height: 12),
          Text(bottomText, style: TextStyle(color: AppColors.onPrimary)),
        ],
      ),
    );
  }

  Widget daysGeneratingList(List<String> days, HomePageController controller, List<int> next7DaysOnlyDay) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: days.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            print(next7DaysOnlyDay);
            print(days);

          },
          child: Container(
            height: 60,
            width: 55,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(55), color: AppColors.primaryPurpleAlpha250),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(days[index], style: TextStyle(color: AppColors.onPrimary, fontSize: 14)),
                if (controller.weatherData.value.forecast?.forecastday?[0].day?.condition?.icon != null)
                  Image.network("https:${controller.weatherData.value.forecast?.forecastday?[0].day?.condition?.icon}",
                    scale: 0.49,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error_outline, color: Colors.white),
                  ),
                Text("${(controller.weatherData.value.forecast?.forecastday?[2].day?.avgtempC ?? "")}", style: TextStyle(color: AppColors.onPrimary, fontSize: 14)),
              ],
            ),
          ),
        );
      },
    );
  }
}
