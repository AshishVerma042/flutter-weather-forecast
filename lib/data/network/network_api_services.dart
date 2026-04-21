import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../../common/Constants/utils.dart';
import '../../common/constants.dart';
import '../../resources/routes/routes.dart';
import '../app_exceptions.dart';
import '../app_url/app_url.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  bool refresh = true;

  bool isRefreshing = false;

  // Future<void> refreshTokenAndRetry(String url) async {
  //   if (isRefreshing) {
  //     return;
  //   }
  //   isRefreshing = true;
  //   try {
  //     String refreshToken = await Utils.getPreferenceValues(Constants.refreshToken) ?? "";
  //     String accessToken = await Utils.getPreferenceValues(Constants.accessToken) ?? "";
  //     if (refreshToken.isEmpty || accessToken.isEmpty) {
  //       throw AuthenticationException("Refresh token or access token is missing ${refreshToken.isEmpty} ${accessToken.isEmpty}");
  //     }
  //     Utils.printLog("Refresh Token API URL: ${AppUrl.refreshToken}");
  //     Map<String, dynamic> data = {
  //       "refreshToken": refreshToken,
  //       "accessToken": accessToken,
  //     };
  //     Utils.printLog("Refresh Token API Request Body: $data");
  //     String jsonBody = jsonEncode(data);
  //     Utils.printLog("Final JSON Body: $jsonBody");
  //     final response = await http
  //         .post(
  //           Uri.parse(AppUrl.refreshToken),
  //           headers: {
  //             'accesstoken': accessToken,
  //             'Content-Type': 'application/json',
  //           },
  //           body: jsonBody,
  //         )
  //         .timeout(const Duration(seconds: 600));
  //     Utils.printLog("Refresh Token API Response: ${response.body}");
  //     if (response.statusCode == 200) {
  //       var responseJson;
  //       try {
  //         responseJson = jsonDecode(response.body);
  //       } catch (e) {
  //         throw FormatException("Failed to parse response JSON: $e");
  //       }
  //       var data = responseJson['data'];
  //       if (data != null && data.containsKey('accessToken')) {
  //         String newAccessToken = data['accessToken'];
  //         Utils.savePreferenceValues(Constants.accessToken, newAccessToken);
  //         refresh = false;
  //       } else {
  //         throw Exception("Token refresh failed: 'accessToken' missing in response data");
  //       }
  //     } else {
  //       throw Exception("Token refresh failed: ${response.body}");
  //     }
  //   } catch (e) {
  //     Utils.printLog("Token refresh failed: $e");
  //     rethrow;
  //   } finally {
  //     isRefreshing = false;
  //   }
  // }

  @override
  Future<dynamic> getApi(String url) async {

    Utils.printLog(url);
    dynamic responseJson;



    try {
      final response = await http.get(Uri.parse(url), headers: {
        'content-Type': 'application/json',

      }).timeout(const Duration(seconds: 600));

      print(response.statusCode);

      if (response.statusCode == 401 || response.statusCode == 463) {
        if (refresh) {
          refresh = true;
          // await refreshTokenAndRetry(url);
          await getApi(url);
        }
        Utils.savePreferenceValues(Constants.refreshLogin, "");
      } else {
        responseJson = returnResponse(response);
      }
    } on SocketException {
      throw InternetException('');
    } on TimeoutException {
      throw RequestTimeOut('');
    } on UnauthorizedException {
      throw AuthenticationException('');
    } catch (e) {
      Utils.printLog("Error: $e");
      rethrow;
    }

    Utils.printLog(responseJson);
    return responseJson;
  }

  @override
  Future<dynamic> getApiWithParameter(var page, var status, var search, String url) async {
    Utils.printLog(url);
    dynamic responseJson;
    String token = await Utils.getPreferenceValues(Constants.accessToken) ?? "";

    try {
      final uri = Uri.parse(url).replace(queryParameters: {'page': page, 'status': status, 'search': search});
      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
        'Authorization': token,
      }).timeout(const Duration(seconds: 600));
      if (response.statusCode == 401 || response.statusCode == 463) {
        if (refresh) {
          refresh = true;
          // await refreshTokenAndRetry(url);
          await getApiWithParameter(page, status, search, url);
        }
      } else {
        responseJson = returnResponse(response);
      }
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    } on TimeoutException {
      throw RequestTimeOut('');
    } on UnauthorizedException {
      throw AuthenticationException('');
    }
    Utils.printLog(responseJson);

    return responseJson;
  }

  @override
  Future<dynamic> postApi(var data, String url) async {
    Utils.printLog(url);
    Utils.printLog(data);
    dynamic responseJson;
    String token = await Utils.getPreferenceValues(Constants.accessToken) ?? "";

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Accept': 'application/json',
              'Authorization': token,
            },
            body: data, //jsonEncode(data) //if raw form then we set jsonEncode if form the only data
          )
          .timeout(const Duration(seconds: 600));
      if (response.statusCode == 401 || response.statusCode == 463) {
        if (refresh) {
          refresh = true;
          // await refreshTokenAndRetry(url);
          await postApi(data, url);
        }
      } else {
        responseJson = returnResponse(response);
      }
      Utils.printLog('Response: $response');
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    } on TimeoutException {
      throw RequestTimeOut('');
    } on UnauthorizedException {
      throw AuthenticationException('');
    }
    Utils.printLog(responseJson);
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw InvalidUrlException(response.body);
      case 401:
        throw AuthenticationException(response.body);
      case 408:
        throw FetchDataException(response.body);
      case 498:
        throw InvalidUrlException(response.body);
      default:
        throw FetchDataException(response.body);
    }
  }

  @override
  Future<dynamic> multiPartApi(var data, String url, String path, String path2) async {
    Utils.printLog(url);
    Utils.printLog(data);
    Utils.printLog(path);
    dynamic responseJson;
    String token = await Utils.getPreferenceValues(Constants.accessToken) ?? "";
    try {
      if (path == '' && path2 == '') {
        final response = await http
            .post(
              Uri.parse(url),
              headers: {
                'accesstoken': token,
              },
              body: data,
            )
            .timeout(const Duration(seconds: 600));
        if (response.statusCode == 401 || response.statusCode == 463) {
          if (refresh) {
            refresh = true;
            // await refreshTokenAndRetry(url);
            await multiPartApi(data, url, path, path2);
          }
        } else {
          responseJson = returnResponse(response);
        }
      } else {
        var request = http.MultipartRequest("POST", Uri.parse(url));
        if (data != null) {
          for (String key in data.keys) {
            request.fields[key] = data[key];
          }
        }
        request.headers['accesstoken'] = token;
        var avatarFile = File(path);
        var avatarStream = avatarFile.openRead();
        var avatarLength = await avatarFile.length();

        request.files.add(http.MultipartFile(
          'avatar',
          avatarStream,
          avatarLength,
          filename: path.split("/").last,
        ));
        var coverImageFile = File(path2);
        var coverImageStream = coverImageFile.openRead();
        var coverImageLength = await coverImageFile.length();

        request.files.add(http.MultipartFile(
          'coverImage',
          coverImageStream,
          coverImageLength,
          filename: path2.split("/").last,
        ));
        final response = await request.send();
        final responseHttp = await http.Response.fromStream(response);
        if (response.statusCode == 401 || response.statusCode == 463) {
          if (refresh) {
            refresh = true;
            // await refreshTokenAndRetry(url);
            await multiPartApi(data, url, path, path2);
          }
        } else {
          responseJson = returnResponse(responseHttp);
        }
      }
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    } on TimeoutException {
      throw RequestTimeOut('');
    } on UnauthorizedException {
      throw AuthenticationException('');
    }

    Utils.printLog(responseJson);
    return responseJson;
  }

  Future<dynamic> formDataApi(String filePath, String mediaLibraryType, String userId, String url) async {
    Utils.printLog(url);
    Utils.printLog(filePath);
    Utils.printLog(mediaLibraryType);

    dynamic responseJson;
    String token = await Utils.getPreferenceValues(Constants.accessToken) ?? "";

    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.headers['accesstoken'] = token;
      request.headers['Content-Type'] = 'multipart/form-data';

      if (filePath.isNotEmpty && await File(filePath).exists()) {
        var mediaFile = File(filePath);
        var mediaStream = mediaFile.openRead();
        var mediaLength = await mediaFile.length();
        var mimeType = lookupMimeType(filePath);

        // Check for null mimeType and provide a fallback
        mimeType ??= 'image/jpeg'; // Default MßIME type if not found

        // mimeType ??= "application/pdf";

        print(mimeType); // Ensure you have the mimeType value here

        request.files.add(http.MultipartFile(
          'mediaFile',
          mediaStream,
          mediaLength,
          filename: filePath.split("/").last,
          contentType: MediaType.parse(mimeType), // Use MediaType.parse for correct format
        ));
      } else {
        throw Exception('File not found at $filePath');
      }

      if (mediaLibraryType.isNotEmpty) {
        request.fields['mediaLibraryType'] = mediaLibraryType;
      }

      if (userId.isNotEmpty) {
        request.fields['userId'] = userId;
      }

      final response = await request.send();
      final responseHttp = await http.Response.fromStream(response);
      if (response.statusCode == 401 || response.statusCode == 463) {
        if (refresh) {
          refresh = true;
          // await refreshTokenAndRetry(url);
          await formDataApi(filePath, mediaLibraryType, userId, url);
        }
      } else {
        responseJson = returnResponse(responseHttp);
      }
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    } on TimeoutException {
      throw RequestTimeOut('');
    } on UnauthorizedException {
      throw AuthenticationException('');
    }

    Utils.printLog(responseJson);
    return responseJson;
  }

  @override
  Future postEncodeApi(data, String url) async {
    Utils.printLog(url);
    Utils.printLog(data);
    dynamic responseJson;
    String token = await Utils.getPreferenceValues(Constants.accessToken) ?? "";

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'content-Type': "application/json",
              'accesstoken': token,
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 600));
      print("Response==>${response.statusCode}");

      // Check if the response status is 463 (session expired)
      if (response.statusCode == 401 || response.statusCode == 463) {
        if (refresh) {
          refresh = true;
          // await refreshTokenAndRetry(url);
          await postEncodeApi(data, url);
        }
      } else {
        responseJson = returnResponse(response);

      }
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    } on TimeoutException {
      throw RequestTimeOut('');
    } on UnauthorizedException {
      throw AuthenticationException('');
    }

    Utils.printLog(responseJson);
    return responseJson;
  }

  Future<dynamic> putEncodeApi(data, String url, {bool isSocialLogin = false}) async {
    Utils.printLog("isSocialLogin: $isSocialLogin");
    Utils.printLog("URL: $url");
    Utils.printLog("Data: $data");

    dynamic responseJson;
    String token = await Utils.getPreferenceValues(Constants.accessToken) ?? "";
    String? socialToken = await Utils.getPreferenceValues(Constants.isSocialLogin);

    Utils.printLog("socialToken: $socialToken");

    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: {
              'Content-Type': "application/json",
              'accesstoken': isSocialLogin ? socialToken ?? token : token,
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 600)); // Timeout after 10 minutes
      Utils.printLog("Status code: ${response.statusCode}");
      if (response.statusCode == 401 || response.statusCode == 463) {
        if (refresh) {
          refresh = true;
          // await refreshTokenAndRetry(url);
          await putEncodeApi(data, url, isSocialLogin: isSocialLogin);
        }
      } else {
        responseJson = returnResponse(response);
      }
    } on SocketException {
      throw InternetException('No Internet Connection');
    } on TimeoutException {
      throw TimeoutException('Request timed out');
    } on UnauthorizedException {
      throw AuthenticationException('Authentication failed');
    } catch (e) {
      // Handle any other exceptions
      throw Exception('An error occurred: $e');
    }

    Utils.printLog("Response: $responseJson");
    return responseJson;
  }

  Future postEncodeApiForFCM(data, String url) async {
    // var fcmToken = await FirebaseMessaging.instance.getToken();
    //print(fcmToken);
    Utils.printLog(url);
    Utils.printLog(data);
    dynamic responseJson;
    String token = await Utils.getPreferenceValues(Constants.accessToken) ?? "";

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'content-Type': "application/json",
              'accesstoken': token,
              'devicetype': Platform.isIOS ? "IOS" : "ANDROID",
              //'fcmtoken' : fcmToken.toString()
            },
            body: jsonEncode(data), //jsonEncode(data) //if raw form then we set jsonEncode if form the only data
          )
          .timeout(const Duration(seconds: 600));
      if (response.statusCode == 401 || response.statusCode == 463) {
        if (refresh) {
          refresh = true;
          // await refreshTokenAndRetry(url);
          await postEncodeApiForFCM(data, url);
        }
      } else {
        responseJson = returnResponse(response);
      }
      Utils.printLog('Response: $response');
      // Utils.printLog("Fcm:$fcmToken");
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    } on TimeoutException {
      throw RequestTimeOut('');
    } on UnauthorizedException {
      throw AuthenticationException('');
    }
    Utils.printLog(responseJson);
    return responseJson;
  }

  Future<dynamic> deleteApi(String url) async {
    Utils.printLog(url);
    dynamic responseJson;

    String token = await Utils.getPreferenceValues(Constants.accessToken) ?? "";
    String refreshLogin = await Utils.getPreferenceValues(Constants.refreshLogin) ?? "";
    if (token.isEmpty) {
      throw AuthenticationException("Access token is missing");
    }

    try {
      final response = await http.delete(Uri.parse(url), headers: {
        'content-Type': 'application/json',
        'accesstoken': token,
      }).timeout(const Duration(seconds: 600));

      print(response.statusCode);

      if (response.statusCode == 401 || response.statusCode == 463) {
        if (refresh) {
          refresh = true;
          // await refreshTokenAndRetry(url);
          await deleteApi(url);
        }
        Utils.savePreferenceValues(Constants.refreshLogin, "");
      } else {
        responseJson = returnResponse(response);
      }
    } on SocketException {
      throw InternetException('');
    } on TimeoutException {
      throw RequestTimeOut('');
    } on UnauthorizedException {
      throw AuthenticationException('');
    } catch (e) {
      Utils.printLog("Error: $e");
      rethrow;
    }

    Utils.printLog(responseJson);
    return responseJson;
  }
}
