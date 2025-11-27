import 'package:get/get.dart';
import '../../models/message_model.dart';
import '../services/messages_service.dart';

class MessagesController extends GetxController {
  final MessagesService _messagesService = MessagesService();

  var messages = <Message>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    isLoading.value = true;
    try {
      messages.value = await _messagesService.fetchMessages();
    } catch (e) {
      print('Error fetching messages: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
