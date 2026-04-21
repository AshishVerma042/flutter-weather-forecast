
import 'package:weatherapp/models/weather_data_model.dart';

import '../../data/app_url/app_url.dart';
import '../../data/network/network_api_services.dart';


class WeatherRepository {
  final _apiServices = NetworkApiServices();

  Future<WeatherDataModel> weatherApi(String location ,int days, {String aqi="yes", String alerts="yes"}) async {
    dynamic response = await _apiServices.getApi("${AppUrl.weatherApi}$location&days=$days&aqi=$aqi&alerts=$alerts");
    return WeatherDataModel.fromJson(response);
  }
}
