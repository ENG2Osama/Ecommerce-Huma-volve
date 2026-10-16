import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/Failure/Failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_product_entity.dart';

abstract class DetailsRepository {
  Future<Either<Failure, HomeProductEntity>> getProductById(int productId);
}
