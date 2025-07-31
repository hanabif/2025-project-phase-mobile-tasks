import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:haymanot_aweke/core/error/exceptions.dart';
import 'package:haymanot_aweke/features/product/data/datasources/product_local_data_source.dart';
import 'package:haymanot_aweke/features/product/data/model/Product_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'product_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ProductLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastProductList', () {
    final tProductList =
        (json.decode(fixture('product_list_cached.json')) as List)
            .map((jsonItem) => ProductModel.fromJson(jsonItem))
            .toList();

    test(
      'should return List<ProductModel> from SharedPreferences when there is cached data',
      () async {
        // arrange
        when(
          mockSharedPreferences.getString('CACHED_PRODUCT_LIST'),
        ).thenReturn(fixture('product_list_cached.json'));

        // act
        final result = await dataSource.getLastProductList();

        // assert
        verify(mockSharedPreferences.getString('CACHED_PRODUCT_LIST'));
        expect(result, equals(tProductList));
      },
    );
    test(
      'should throw CacheException when there is no cached product list',
      () async {
        // Arrange: mock SharedPreferences to return null for any getString call
        when(
          mockSharedPreferences.getString('CACHED_PRODUCT_LIST'),
        ).thenReturn(null);

        // Act: store the method (don't call yet)
        final call = dataSource.getLastProductList;

        // Assert: calling the method should throw CacheException
        expect(() => call(), throwsA(isA<CacheException>()));
      },
    );
  });

  group('cacheProductList', () {
    final tProductModelList = [
      ProductModel(
        id: '1',
        name: 'Product 1',
        imageUrl: 'url1',
        price: 10.0,
        description: 'desc 1',
      ),
      ProductModel(
        id: '2',
        name: 'Product 2',
        imageUrl: 'url2',
        price: 20.0,
        description: 'desc 2',
      ),
    ];

    test('should call SharedPreferences to cache the data', () async {
      // arrange
      final expectedJsonString = json.encode(
        tProductModelList.map((product) => product.toJson()).toList(),
      );
      when(
        mockSharedPreferences.setString(
          'CACHED_PRODUCT_LIST',
          expectedJsonString,
        ),
      ).thenAnswer((_) async => true);

      // act
      await dataSource.cacheProductList(tProductModelList);

      // assert
      final expectedJsonStringOriginal = json.encode(
        tProductModelList.map((product) => product.toJson()).toList(),
      );
      verify(
        mockSharedPreferences.setString(
          'CACHED_PRODUCT_LIST',
          expectedJsonStringOriginal,
        ),
      );
    });
  });

  group('getProductById', () {
    // Example product model with id = 1
    final tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      imageUrl: 'https://example.com/image.png',
      price: 99.99,
      description: 'Test Description',
    );

    final tProductList = [tProductModel];

    test(
      'should return ProductModel with matching ID from SharedPreferences',
      () async {
        // arrange
        final expectedJsonString = json.encode(
          tProductList.map((product) => product.toJson()).toList(),
        );

        when(
          mockSharedPreferences.getString('CACHED_PRODUCT_LIST'),
        ).thenReturn(expectedJsonString);

        // act
        final result = await dataSource.getProductById('1');

        // assert
        expect(result, equals(tProductModel));
      },
    );

    test('should throw CacheException when there is no cached data', () async {
      // arrange
      when(
        mockSharedPreferences.getString('CACHED_PRODUCT_LIST'),
      ).thenReturn(null);

      // act
      final call = dataSource.getProductById;

      // assert
      expect(() => call('1'), throwsA(isA<CacheException>()));
    });

    test(
      'should throw CacheException when no product with the given ID exists',
      () async {
        // arrange: cache a list that doesn't include the product with ID = 99
        final expectedJsonString = json.encode(
          tProductList.map((product) => product.toJson()).toList(),
        );

        when(
          mockSharedPreferences.getString('CACHED_PRODUCT_LIST'),
        ).thenReturn(expectedJsonString);

        // act
        final call = dataSource.getProductById;

        // assert
        expect(() => call('99'), throwsA(isA<CacheException>()));
      },
    );
  });

  group('deleteProduct', () {
    final tProduct1 =  ProductModel(
      id: '1',
      name: 'Product 1',
      imageUrl: 'url1',
      price: 10.0,
      description: 'Desc 1',
    );
    final tProduct2 =  ProductModel(
      id: '2',
      name: 'Product 2',
      imageUrl: 'url2',
      price: 20.0,
      description: 'Desc 2',
    );
    final cachedList = [tProduct1, tProduct2];

    test(
      'should remove the product with matching ID and save updated list',
      () async {
        // arrange
        final cachedJsonString = json.encode(
          cachedList.map((product) => product.toJson()).toList(),
        );
        when(
          mockSharedPreferences.getString('CACHED_PRODUCT_LIST'),
        ).thenReturn(cachedJsonString);
        when(
          mockSharedPreferences.setString(any, any),
        ).thenAnswer((_) async => true);

        // act
        await dataSource.deleteProduct('1');

        // assert
        final updatedList = [tProduct2];
        final updatedJson = json.encode(
          updatedList.map((p) => p.toJson()).toList(),
        );
        verify(
          mockSharedPreferences.setString('CACHED_PRODUCT_LIST', updatedJson),
        );
      },
    );

    test('should throw CacheException if no cached list exists', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // act
      final call = dataSource.deleteProduct;

      // assert
      expect(() => call('1'), throwsA(isA<CacheException>()));
    });
  });

  group('cacheProduct', () {
    final existingProduct =  ProductModel(
      id: '1',
      name: 'Old Product',
      imageUrl: 'old_url',
      price: 99.9,
      description: 'Old desc',
    );

    final newProduct =  ProductModel(
      id: '2',
      name: 'New Product',
      imageUrl: 'new_url',
      price: 49.9,
      description: 'New desc',
    );

    test(
      'should add product to existing cached list and update SharedPreferences',
      () async {
        // arrange
        final cachedJsonString = json.encode([existingProduct.toJson()]);
        when(
          mockSharedPreferences.getString('CACHED_PRODUCT_LIST'),
        ).thenReturn(cachedJsonString);
        when(
          mockSharedPreferences.setString(any, any),
        ).thenAnswer((_) async => true);

        // act
        await dataSource.cacheProduct(newProduct);

        // assert
        final updatedList = [existingProduct, newProduct];
        final expectedJson = json.encode(
          updatedList.map((p) => p.toJson()).toList(),
        );

        verify(
          mockSharedPreferences.setString('CACHED_PRODUCT_LIST', expectedJson),
        );
      },
    );

    test('should start new list if no product is cached', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      when(
        mockSharedPreferences.setString(any, any),
      ).thenAnswer((_) async => true);

      // act
      await dataSource.cacheProduct(newProduct);

      // assert
      final expectedJson = json.encode([newProduct.toJson()]);
      verify(
        mockSharedPreferences.setString('CACHED_PRODUCT_LIST', expectedJson),
      );
    });
  });

}
