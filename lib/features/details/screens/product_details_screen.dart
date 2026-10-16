import 'package:ecommerce_app_huma_volve/core/constant/api_constant.dart';
import 'package:ecommerce_app_huma_volve/core/netWork/api_client.dart';
import 'package:ecommerce_app_huma_volve/core/theme.dart';
import 'package:ecommerce_app_huma_volve/core/widgets/primary_button.dart';
import 'package:ecommerce_app_huma_volve/features/details/Data/data_source/details_remote_data_source_im.dart';
import 'package:ecommerce_app_huma_volve/features/details/Data/repository/details_repository_im.dart';
import 'package:ecommerce_app_huma_volve/features/details/Domain/use_case/get_product_by_id_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/details/widgets/share_plus_buttom.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_product_entity.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int? productId;

  const ProductDetailsScreen({super.key, this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final GetProductByIdUseCase _getProductByIdUseCase;
  HomeProductEntity? _product;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final apiClient = ApiClient(ApiConstants.baseUrl);
    final remoteDataSource = DetailsRemoteDataSourceIm(apiClient: apiClient);
    final repository = DetailsRepositoryIm(remoteDataSource);
    _getProductByIdUseCase = GetProductByIdUseCase(repository);

    final id = widget.productId ?? 0;
    _loadProductById(id);
  }

  Future<void> _loadProductById(int productId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _getProductByIdUseCase.execute(productId);

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.FailureMessage;
        });
      },
      (product) {
        setState(() {
          _product = product;
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentProduct = _product;
    final imageUrl =
        currentProduct?.images != null && currentProduct!.images!.isNotEmpty
        ? currentProduct.images![0]
        : 'https://via.placeholder.com/600x800?text=No+Image';

    if (_isLoading && currentProduct == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (currentProduct == null) {
      return Scaffold(
        body: Center(
          child: Text(
            _errorMessage ?? 'Product not found',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppTheme.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 16),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              SharePlusButtom(productId: _product!.id ?? 0),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, size: 18),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${currentProduct.id}',
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 15)),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              transform: Matrix4.translationValues(0.0, -32.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            currentProduct.title ?? '',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(fontSize: 28, height: 1.2),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${(currentProduct.price ?? 0).toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(color: AppTheme.primary, fontSize: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentProduct.description ?? '',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(height: 1.6, fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      child: const Text('Add to Cart'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${currentProduct.title} added to cart',
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: AppTheme.primary,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
