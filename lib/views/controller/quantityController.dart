import 'package:get/get.dart'; // Import the GetX package

class MyController extends GetxController {
  final quantity = 1.obs;
  final errorText = ''.obs;

  RxDouble finishedQty = 0.0.obs;
  RxDouble totalOrderQty = 0.0.obs;

  RxDouble maxQuantity = 10.0.obs;

  //update quantity for woppr
  void updateQuantity(String value) {
    final parsedQuantity = int.tryParse(value);
    if (parsedQuantity == null) {
      errorText.value = 'Quantity must be a valid number';
    } else if (parsedQuantity <= 0 || parsedQuantity > maxQuantity.value) {
      errorText.value = 'Quantity must be between 1 and ${maxQuantity.value}';
    } else {
      errorText.value = '';
      quantity.value = parsedQuantity;
    }
  }

  //insert quantity for skipp process
  void skipProcessQuantity(String value) {
    final parsedQuantity = int.tryParse(value);
    if (parsedQuantity == null) {
      errorText.value = 'Quantity must be a valid number';
    } else {
      errorText.value = '';
      quantity.value = parsedQuantity;
    }
  }
}
