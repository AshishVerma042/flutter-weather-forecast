class Images {
  // svg
  get addSymbol => "assets/icon/Symbol.svg";
  get leftIcon =>"assets/icon/Hover.svg";
  get rightIcon =>"assets/icon/Hover_1.svg";
  get centerBottomMenu => "assets/image/Subtract.png";
  get backgroundBottomMenu => "assets/image/RectangleBottom.png";
  get secondBackgroundImage =>"assets/image/House_1.png";
  get firstBackgroundImage =>"assets/image/Image.png";
  get weatherWindCardImage => "assets/image/windCompass1.png";
  get weatherPressureImage => "assets/image/pressure1.png";
  get weatherSunRaiseImage => "assets/image/icon1.png";
  get airQualityCardImage => "assets/icon/hexagonIcon.png";
  get moonWindCloud => "assets/icon/Moon cloud fast wind.png";
  get sunRainAngledCloud => "assets/icon/Sun cloud angled rain.png";
  get moonRainCloud=> "assets/icon/Moon cloud mid rain.png";
  get sunRainCloud => "assets/icon/Sun cloud mid rain.png";

  static final Images _appImages = Images._internal();
  factory Images() {
    return _appImages;
  }
  Images._internal();
}

Images appImages = Images();
