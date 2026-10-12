import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/endpoints/api_endpoints.dart';
import '../models/profile_model.dart';
import 'profile_payload_normalizer.dart';

class GetProfileRemoteDataSource {
  GetProfileRemoteDataSource(this.apiConsumer);

  final ApiConsumer apiConsumer;

  Future<ProfileModel> getProfile({
    required int employeeId,
    required String language,
  }) async {
    final response = await apiConsumer.get(
      ApiEndpoints.employeeDetails(employeeId),
      queryParameters: {'lang': language},
    );

    final data = ProfilePayloadNormalizer.normalize(response.data);

    return ProfileModel.fromJson(data);
  }
}
