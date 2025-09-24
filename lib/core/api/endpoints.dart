class Endpoints {
  static String get baseUrl => const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.165.232.137:5152');
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const me = '/auth/me';
  static const restaurants = '/restaurants';
  static String restaurant(String id) => '/restaurants/$id';
  static String menu(String restaurantId) => '/restaurants/$restaurantId/menu';
  static const cartPricing = '/pricing/quote';
  static const orders = '/orders';
  static String order(String id) => '/orders/$id';
  static const addresses = '/addresses';
  static const favorites = '/favorites';
}
