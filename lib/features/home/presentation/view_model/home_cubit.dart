import 'package:ecommerce_app_huma_volve/features/home/Domian/use_case/get_catergory_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/use_case/get_product_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  GetCatergoryUseCase getCategoriesUseCase;
  GetProductUseCase getProductsUseCase;
  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(HomeInitialState());

  Future<void> LoadHome() async {
    emit(HomeLoadingState());

    final categories = await getCategoriesUseCase.execute();
    categories.fold(
      (failure) => emit(categoriesErrorState(failure.FailureMessage)),
      (categories) {
        emit(categoriesSuccessState(categories));
        LoadProducts(-1, 0);
      },
    );

    LoadProducts(-1, 0);
  }

  Future<void> LoadProducts(int categoryId, int offSet) async {
    emit(productsLoadedState());

    final products = await getProductsUseCase.execute(categoryId, offSet);

    products.fold(
      (failure) => emit(productsErrorState(failure.FailureMessage)),
      (products) => emit(productsSuccessState(products)),
    );
  }
}
