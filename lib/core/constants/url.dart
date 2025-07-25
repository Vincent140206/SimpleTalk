class Urls {
  static const String baseUrl = 'http://10.0.2.2:5000/';

  // Authentication and User URLs
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String deleteAccount = '/api/auth/delete';
  static const String sendOTP = '/api/auth/send-otp';
  static const String verifyOTP = '/api/auth/verify-otp';
  static const String updateProfileImage = '/api/user/update-photo';
  static const String getProfile = '/api/user/profile';
  static const String deleteProfileImage = '/api/user/delete';

  // Contact URLs
  static const String addContacts = '/api/contacts/add';
  static const String getContacts = '/api/contacts/';

  // Message URL
  static const String fetchMessage = '/api/messages';

  // Cloudinary URLs
  static const String uploadImage = 'https://api.cloudinary.com/v1_1/dtnk3lxej/image/upload';
}