import 'package:get/get.dart';

class RouteController extends GetxController {
  var lastRoute = ''.obs;

  void saveLastRoute(String route) {
    lastRoute.value = route;
  }
}
