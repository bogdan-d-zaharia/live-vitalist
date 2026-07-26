abstract interface class INotificationsApi {
  Future<void> saveToken(String userId, String fcmToken);
}
