import 'package:ecommerce_app_huma_volve/core/constant/api_EndPoint.dart';
import 'package:ecommerce_app_huma_volve/core/netWork/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/details/Data/data_source/details_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/Data/model/product_model.dart';

class DetailsRemoteDataSourceIm implements DetailsRemoteDataSource {
  final ApiClient apiClient;

  DetailsRemoteDataSourceIm({required this.apiClient});

  @override
  Future<HomeProductModel> getProductById(int productId) async {
    final response = await apiClient.dio.get(
      '${ApiEndPoints.products}/$productId',
    );
    final data = response.data as Map<String, dynamic>;
    return HomeProductModel.fromJson(data);
  }
}
