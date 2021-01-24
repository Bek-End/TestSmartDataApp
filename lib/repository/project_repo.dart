import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/models/about_me_model/about_me_response.dart';
import 'package:test_app/models/author_model/author_response.dart';
import 'package:test_app/models/book_model/book_response.dart';
import 'package:test_app/models/favourite_model/favourite_response.dart';
import 'package:test_app/models/login_model/login_response.dart';
import 'package:test_app/models/register_model/register_response.dart';

class ProjectRepo {
  Dio _dio;
  final String mainUrl = "https://mobile.fakebook.press/";

  ProjectRepo() {
    _dio = Dio(BaseOptions(baseUrl: mainUrl));
  }

  Future<RegisterResponse> registerUser(String user, String email,
      String password, String confirmPassword) async {
    final String customurl = "api/register";
    var data = {
      "name": user,
      "email": email,
      "password": password,
      "password_confirmation": confirmPassword
    };
    try {
      Response response = await _dio.post(customurl, data: data);
      if (response.statusCode == HttpStatus.created) {
        return RegisterResponse.fromJson(response.data);
      }
      print("Register Response ${response.data}");
      return RegisterResponse.withError("Error registering user");
    } catch (error, stackTrace) {
      print("Erorr: $error, stackTrace: $stackTrace");
      return RegisterResponse.withError("Error registering user");
    }
  }

  Future<LoginResponse> loginUser(
      String email, String password, String confirmPassword) async {
    final String customUrl = "api/login";
    var data = {
      "email": email,
      "password": password,
      "password_confirmation": confirmPassword
    };
    try {
      Response response = await _dio.post(customUrl, data: data);
      print("Login Response ${response.data}");
      if (response.statusCode == HttpStatus.ok) {
        LoginResponse loginResponse = LoginResponse.fromjson(response.data);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", loginResponse.loginModel.data.token);
        prefs.setString("email", email);
        prefs.setString("password", password);
        _dio.interceptors
            .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
          var customHeaders = {
            HttpHeaders.authorizationHeader:
                'Bearer ${prefs.getString("token")}'
            // other headers
          };
          options.headers.addAll(customHeaders);
          return options;
        }));
        return loginResponse;
      }
      return LoginResponse.withError("Error logging in");
    } catch (error, stackTrace) {
      print("Erorr: $error, stackTrace: $stackTrace");
      return LoginResponse.withError("Error logging in");
    }
  }

  Future<bool> localLoginUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("token") != null) {
      _dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        var customHeaders = {
          HttpHeaders.authorizationHeader: 'Bearer ${prefs.getString("token")}'
          // other headers
        };
        options.headers.addAll(customHeaders);
        return options;
      }));
      return true;
    } else {
      return false;
    }
  }

  Future<AuthorResponse> getAuthors() async {
    final String customUrl = "api/authors";
    try {
      Response response = await _dio.get(customUrl);
      print("Get authors Response ${response.data}");
      if (response.statusCode == HttpStatus.ok) {
        return AuthorResponse.fromJson(response.data);
      }
      return AuthorResponse.withError("Error getting authors");
    } catch (error, stackTrace) {
      print("Erorr: $error, stackTrace: $stackTrace");
      return AuthorResponse.withError("Error getting authors");
    }
  }

  Future<BookResponse> getBooks() async {
    final String customUrl = "api/books";
    try {
      Response response = await _dio.get(customUrl);
      print("Get books Response ${response.data}");
      if (response.statusCode == HttpStatus.ok) {
        return BookResponse.fromJson(response.data);
      }
      return BookResponse.withError("Error getting books");
    } catch (error, stackTrace) {
      print("Erorr: $error, stackTrace: $stackTrace");
      return BookResponse.withError("Error getting books");
    }
  }

  Future<BookResponse> getFavBooks() async {
    final String customUrl = "api/favorite-books";
    try {
      Response response = await _dio.get(customUrl);
      print("Get favorite-books Response ${response.data}");
      if (response.statusCode == HttpStatus.ok) {
        return BookResponse.fromJson(response.data);
      }
      return BookResponse.withError("Error getting favorite-books");
    } catch (error, stackTrace) {
      print("Erorr: $error, stackTrace: $stackTrace");
      return BookResponse.withError("Error getting favorite-books");
    }
  }

  Future<FavouriteResponse> addToFavBooks(int bookId) async {
    final String customUrl = "api/books/$bookId/add-to-favorites";
    try {
      Response response = await _dio.post(customUrl);
      print("Added favorite-books Response ${response.data}");
      if (response.statusCode == HttpStatus.ok) {
        return FavouriteResponse.fromJson(response.data);
      }
      return FavouriteResponse.withError("Error adding fav books");
    } catch (error, stackTrace) {
      print("Erorr: $error, stackTrace: $stackTrace");
      return FavouriteResponse.withError("Error adding fav books");
    }
  }

  Future<FavouriteResponse> removeFromFavs(int bookid) async {
    final String customUrl = "api/books/$bookid/remove-from-favorites";
    try {
      Response response = await _dio.post(customUrl);
      print("Removed favorite-books Response ${response.data}");
      if (response.statusCode == HttpStatus.ok) {
        return FavouriteResponse.fromJson(response.data);
      }
      return FavouriteResponse.withError("Error removing fav books");
    } catch (error, stackTrace) {
      print("Erorr: $error, stackTrace: $stackTrace");
      return FavouriteResponse.withError("Error removing fav books");
    }
  }

  Future<AboutMeResponse> aboutMe() async {
    final String customUrl = "api/me";
    try {
      Response response = await _dio.get(customUrl);
      print("Got about me info Response ${response.data}");
      if (response.statusCode == HttpStatus.ok) {
        return AboutMeResponse.fromjson(response.data);
      }
      return AboutMeResponse.withError("Error getting about me info");
    } catch (error, stackTrace) {
      print("Erorr: $error, stackTrace: $stackTrace");
      return AboutMeResponse.withError("Error getting about me info");
    }
  }

  Future<bool> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String customUrl = "api/logout";
    try {
      Response response = await _dio.post(customUrl);
      if (response.statusCode == HttpStatus.ok) {
        await prefs.remove("token");
        await prefs.remove("email");
        await prefs.remove("password");
        return true;
      }
      return false;
    } catch (error) {
      print("Error logging out $error");
      return false;
    }
  }
}

final projectRepo = ProjectRepo();
