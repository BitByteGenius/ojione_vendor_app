import 'package:get/get.dart';
import '../controllers/stay_controller.dart';

class StayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StayController>(() => StayController());
  }
}
