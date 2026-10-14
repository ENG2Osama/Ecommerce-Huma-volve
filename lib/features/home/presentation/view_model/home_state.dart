import 'package:ecommerce_app_huma_volve/features/home/Data/model/product_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_product_entity.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class categoriesLoadedState extends HomeState {}

class categoriesErrorState extends HomeState {
  final String errorMessage;

  categoriesErrorState(this.errorMessage);
}

class categoriesSuccessState extends HomeState {
  final List<HomeCategoryEntity> categories;

  categoriesSuccessState(this.categories);
}

class productsLoadedState extends HomeState {}

class productsErrorState extends HomeState {
  final String errorMessage;

  productsErrorState(this.errorMessage);
}

class productsSuccessState extends HomeState {
  final List<HomeProductEntity> products;

  productsSuccessState(this.products);
}
