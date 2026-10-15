import '../flavor/flavor_config.dart';

class ApiEndpoints {
  static String get baseUrl => FlavorConfig.instance.baseUrl;
  static const String loginEndpoint = '/login';
  static const String usersEndpoint = '/members';
  static const String createGroup = "/create-room-with-many-members";
  static const String getRooms = "/get-rooms";
  static String getRoomMessages(int roomId) => "/get-room-messages/$roomId";
  static String sendMessage(int roomId) => "/send-message/$roomId";
  static const String broadcastingAuth = "/broadcasting/auth";
}
