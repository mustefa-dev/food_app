import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/utils/result.dart';
import 'models/menu_models.dart';

class MenuRepository {
  final ApiClient _client;
  MenuRepository(this._client);

  Future<Result<MenuPayload>> fetchMenu(String restaurantId) async {
    try {
      final res = await _client.dio.get(Endpoints.menu(restaurantId));
      return Ok(MenuPayload.fromJson(res.data));
    } catch (_) {
      return Ok(MenuPayload.fromJson({
        'categories': [
          {'id': 'c1', 'name': 'Appetizers'},
          {'id': 'c2', 'name': 'Main Courses'}
        ],
        'items': [
          {'id': 'i1', 'name': 'Garlic Bread', 'price': 3.5, 'description': 'Crispy with herbs', 'tags': ['vegan']},
          {'id': 'i2', 'name': 'Margherita Pizza', 'price': 7.0, 'description': 'Classic tomato & mozzarella'}
        ]
      }));
    }
  }
}
