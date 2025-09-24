import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../data/auth_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(ref.watch(apiClientProvider)));
final authStateProvider = StateProvider<bool>((ref) => false);
