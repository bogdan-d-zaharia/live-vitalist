abstract interface class INotificationsApi {
  Future<void> registerDevice();
  Future<void> saveToken(String userId, String fcmToken);
}
