import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haymanot_aweke/core/platform/network_info.dart';
import 'package:haymanot_aweke/features/product/data/datasources/product_local_data_source.dart';
import 'package:haymanot_aweke/features/product/data/datasources/product_remote_data_source.dart';
import 'package:haymanot_aweke/features/product/data/repositories/product_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}

class MockLocalDataSource extends Mock implements ProductLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}


void main(){
  late ProductRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp((){
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
}
