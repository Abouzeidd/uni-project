import 'package:get/get.dart';

import 'models.dart';
import 'order service.dart';

class HistoryController extends GetxController {
  var orders = <Order>[].obs;
  var loading = true.obs; // optional: loading indicator
  final OrderService orderService = OrderService();

  /// Load orders for a specific user
  Future<void> loadOrders(String email) async {
    try {
      loading.value = true;
      final fetchedOrders = await orderService.getUserOrders(email);
      orders.value = fetchedOrders;
    } catch (e) {
      print("Error loading orders: $e");
    } finally {
      loading.value = false;
    }
  }
}
