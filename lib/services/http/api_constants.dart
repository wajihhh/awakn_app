class ApiConstants {
  static String baseUrl = 'https://eternal-network.3.133.97.239.nip.io/awakn';

  static String user = '/user';
  static String objectives = '/objectives';
  static String category = '/category';
  static String alarms = '/alarms';

  static String signIn = '$user/login';
  static String guestSignIn = '$user/guest-login';
  static String signUp = '$user/signup';

  static String profile = '$user/profile';
  static String changePassword = '$user/change-pass';
  static String forgotPassword = '$user/forgot-pass';
  static String resetPassword = '$user/reset-pass';
  static String userUpdate = '$user/update';
  static String logout = '$user/logout';
  static String favourite = '$user/favourites';
  static String setupAlarm = '$alarms/setup';
  static String getFeedTimeline = '$objectives/feed_timeline';
}
