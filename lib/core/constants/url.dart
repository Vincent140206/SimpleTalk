class Urls {
  static const String baseUrl = 'http://10.0.2.2:5000/';

  // Authentication URLs
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';

  // Contact URLs
  static const String addContacts = '/api/contacts/add';
  static const String getContacts = '/api/contacts/';

  // Message URL
  static const String fetchMessage = '/api/messages';
}