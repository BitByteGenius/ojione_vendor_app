import 'package:get/get.dart';
import '../controllers/local_experiences_controller.dart';

class LocalExperiencesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocalExperiencesController>(() => LocalExperiencesController());
  }
}
