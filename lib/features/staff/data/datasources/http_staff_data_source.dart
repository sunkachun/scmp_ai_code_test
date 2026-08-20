import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/user_page.dart';
import '../models/user_model.dart';
import 'staff_remote_datasource.dart';

class HttpStaffDataSource implements StaffRemoteDataSource {
  HttpStaffDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<UserPage> getUsers(int page) async {
    final response = await _apiClient.get(
      '${AppConstants.baseUrl}${AppConstants.usersEndpoint}$page',
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final users = (json['data'] as List)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
      final currentPage = json['page'] as int;
      final totalPages = json['total_pages'] as int;
      return UserPage(
        users: users,
        currentPage: currentPage,
        totalPages: totalPages,
        hasMore: currentPage < totalPages,
      );
    }
    throw Exception('Failed to load users');
  }
}
