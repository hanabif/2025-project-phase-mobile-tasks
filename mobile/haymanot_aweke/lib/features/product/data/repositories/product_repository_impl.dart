// ignore_for_file: avoid_print

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../model/Product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Unit>> createProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        final model = ProductModel.fromEntity(product);
        print('Creating product: ${model.name}');
        await remoteDataSource.createProduct(model);
        await localDataSource.cacheProduct(model);
        return const Right(unit);
      } on ServerException catch (e) {
        print('Create product failed: $e');
        return Left(ServerFailure());
      }
    } else {
      print('Create product failed: No internet');
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      try {
        print('Deleting product with id: $id');
        await remoteDataSource.deleteProduct(id);
        await localDataSource.deleteProduct(id);
        return const Right(unit);
      } on ServerException catch (e) {
        print('Delete product failed: $e');
        return Left(ServerFailure());
      }
    } else {
      print('Delete product failed: No internet');
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    // if (await networkInfo.isConnected) {
      try {
        print('Fetching all products from remote');
        final remoteProducts = await remoteDataSource.getAllProducts();
        await localDataSource.cacheProductList(remoteProducts);
        return Right(remoteProducts);
      } on ServerException catch (e) {
        print('Get all products failed: $e');
        return Left(ServerFailure());
      }
    // } else {
    //   try {
    //     print('Fetching products from cache');
    //     final localProducts = await localDataSource.getLastProductList();
    //     return Right(localProducts);
    //   } on CacheException catch (e) {
    //     print('Get all products from cache failed: $e');
    //     return Left(CacheFailure());
    //   }
    // }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        print('Getting product by id: $id');
        final remoteProduct = await remoteDataSource.getProductById(id);
        await localDataSource.cacheProduct(remoteProduct);
        return Right(remoteProduct);
      } on ServerException catch (e) {
        print('Get product by id failed: $e');
        return Left(ServerFailure());
      }
    } else {
      try {
        print('Getting product from local cache by id: $id');
        final localProduct = await localDataSource.getProductById(id);
        return Right(localProduct);
      } on CacheException catch (e) {
        print('Get product from cache failed: $e');
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        final model = ProductModel.fromEntity(product);
        print('Updating product with id: ${model.id}');
        await remoteDataSource.updateProduct(model);
        await localDataSource.cacheProduct(model);
        return const Right(unit);
      } on ServerException catch (e) {
        print('Update product failed: $e');
        return Left(ServerFailure());
      }
    } else {
      print('Update product failed: No internet');
      return Left(NetworkFailure());
    }
  }
}
