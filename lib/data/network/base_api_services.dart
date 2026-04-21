abstract class BaseApiServices{

  Future<dynamic> getApi(String url);

  Future<dynamic> getApiWithParameter(var page, var status, var search, String url);

  Future<dynamic> postApi(dynamic data,String url);

  Future<dynamic> postEncodeApi(dynamic data,String url);

  Future<dynamic> multiPartApi(var data, String url, String path,String path2 );

}
