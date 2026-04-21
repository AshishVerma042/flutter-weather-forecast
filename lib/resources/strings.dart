class AppStrings {
  static final AppStrings _appStrings = AppStrings._internal();
  factory AppStrings() {
    return _appStrings;
  }
  AppStrings._internal();

  String get rainfall=>"Rainfall";
  String get inLastHour => "1.8mm in last hour";
  String get expectedInNext=>"1.2 expected in next 24h.";
  String get feelsLike =>"Feels like";
  String get ninTeen=>"19°";
  String get similarToTheActualTemperature=>"Similar to the actual temperature.";
  String get visibility =>"Visibility";
  String get eightKM=>"8 Km";
  String get humidity=>"Humidity";
  String get nintyPercent=>"90 %";
  String get theDewPoint=>"The dew point is 17 right now.";
  String get sunRise=>"Sunrise";
  String get sunSet=>"Sunset: 6:45 PM";
  String get uvIndex=>"UV Index";
  String get four => "4";
  String get moderate => "Moderate";
  String get airQuality => "Air Quality";
  String get lowHealthRisk => "3-Low Health Risk";
  String get showMore => "Show More";
  String get montreal => '"Montreal"';
  String get ninTeenMostlyClear => "19°| Mostly Clear";
  String get mostlyClear => '"Mostly Clear"';
  String get hlDegree => "H:24°   L:18°" ;
  String get twentyFour => "24°";
  String get weeklyForecast => "Weekly Forecast";
  String get hourlyForecast => '"Hourly Forecast"';
  String get pm =>'PM';
  String get am =>'AM';
  String get mon=>'Mon';
  String get tue=>'Tue';
  String get wed=>'Wed';
  String get thu=>'Thu';
  String get fri=>'Fri';
  String get sat=>'Sat';
  String get sun=>'Sun';
  String get blank=>'';
  String get sunset645=>"Sunset: 6:45 PM";
  String get w =>"W";
  String get eather=>'eather';
  String get app=>"App";

  String get weUnableCheckData => "weUnableCheckData";
}

AppStrings appStrings = AppStrings();

