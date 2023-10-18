import 'package:get/get.dart';

class GetQuantityController extends GetxController {
  RxDouble _total = 0.0.obs;

  double get total => _total.value;

  setTotal(double total) {
    _total.value = total;
  }
}
