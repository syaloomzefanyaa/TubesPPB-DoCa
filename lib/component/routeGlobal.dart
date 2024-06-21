import 'package:doca_project/MainPage/HomePage.dart';
import 'package:doca_project/Auth/LoginPage.dart';
import 'package:doca_project/Auth/RegisterPage.dart';
import 'package:doca_project/MainPage/SplashScreen/OnBoardingPage.dart';
import 'package:doca_project/MainPage/SplashScreen/SplashScreenWrapper.dart';
import 'package:doca_project/MainPage/PetCareFeature/ListPet.dart';
import 'package:doca_project/MainPage/PetClinicFeature/PetClinicPage.dart';
import 'package:doca_project/MainPage/PetShopFeature/PetShopPage.dart';
import 'package:doca_project/MainPage/TaskUserFeature/ListTaskUser.dart';
import 'package:get/get.dart';
import 'package:doca_project/MainPage/TaskUserFeature/FormAddTaskUser.dart';
import 'package:doca_project/MainPage/TaskUserFeature/FormEditTaskUser.dart';
import 'package:doca_project/MainPage/ProfileFeature/ProfilePage.dart';
import 'package:doca_project/MainPage/PetShopFeature/DetailProduct.dart';
import 'package:doca_project/MainPage/ProfileFeature/EditProfilePet.dart';
import 'package:doca_project/MainPage/ProfileFeature/AddProfilePet.dart';
import 'package:doca_project/MainPage/ProfileFeature/EditProfileUser.dart';
import 'package:doca_project/MainPage/ProfileFeature/PetProfilePage.dart';

class RouteName {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String completeData = '/complete-data';
  static const String splashWrapper = '/splash-wrapper';
  static const String listPet = '/listpet';
  static const String petClinic = "/petClinic";
  static const String petShop = "/petShop";
  static const String taskUser = "/taskUser";
  static const String addtaskUser = "/addTaskUser";
  static const String editTaskUser = "/editTaskUser";
  static const String profil = "/profileUser";
  static const String detailProduct = "/detailProduct";
  static const String editProfilePet = "/editProfilePet";
  static const String addProfilePet = "/addProfilePet";
  static const String editProfileUser = "/editProfileUser";
}

var homePage = HomePage();
var loginPage = LoginPage();
var registerPage = RegisterPage();
var splashWrapper = SplashScreenWrapper();
var listPet = ListPet();
var petClinic = PetClinicPage();


var profile = ProfilePage();

var petShop = PetShopPage();

var addProfilePet = addPetProfile();


// String baseurl = 'http://10.0.2.2:8000/';
// String baseurl = 'http://172.27.70.191:8000/';
// String baseurl = 'https://mathgasing.cloud/api;
String baseurl = 'http://192.168.61.42:8000/';

final List<GetPage<dynamic>> getPages = [
  GetPage(name: RouteName.home, page: () => homePage),
  GetPage(name: RouteName.login, page: () => loginPage),
  GetPage(name: RouteName.register, page: () => registerPage),
  GetPage(name: RouteName.splashWrapper, page: () => splashWrapper),
  GetPage(name: RouteName.listPet, page: () => listPet),
  GetPage(name: RouteName.petClinic, page: () => petClinic),

  GetPage(name: RouteName.profil, page: () => profile),

  GetPage(name: RouteName.petShop, page: () => petShop),
  GetPage(
    name: RouteName.detailProduct,
    page: () => DetailProduct(product: Get.arguments),
  ),

  GetPage(name: RouteName.addProfilePet, page: () => addPetProfile()),

];

