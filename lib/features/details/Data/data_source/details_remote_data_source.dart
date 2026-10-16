import 'package:ecommerce_app_huma_volve/features/home/Data/model/product_model.dart';

abstract class DetailsRemoteDataSource {
  Future<HomeProductModel> getProductById(int productId);
}
