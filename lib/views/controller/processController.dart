import 'package:get/get.dart'; // Import the GetX package

class MyControllerProcess extends GetxController {
  final quantity = 0.obs;
  final errorText = ''.obs;

  RxDouble finishedQty = 0.0.obs;
  RxDouble totalOrderQty = 0.0.obs;
  RxString reason = ''.obs;
  RxDouble maxQuantity = 10.0.obs;

  var hasError = true.obs;

  void validateText(String newText) {
    hasError.value = newText.isEmpty;
    reason.value = newText; // Update the value in the controller
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

  void skipProcessReason(String value) {
    if (value.isEmpty) {
      errorText.value = 'Reason cannot be Empty';
    } else {
      errorText.value = '';
      reason.value = value;
    }
  }
}
