import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:haymanot_aweke/core/error/exceptions.dart';
import 'package:haymanot_aweke/features/product/data/datasources/product_remote_data_source.dart';
import 'package:haymanot_aweke/features/product/data/model/Product_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'product_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = ProductRemoteDataSourceImpl(client: mockHttpClient, baseUrl: 'https://g5-flutter-learning-path-be.onrender.com');
  });

  void setUpMockHttpClientSuccess200WithList() {
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response(fixture('product_list.json'), 200));
  }

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('product_remote.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getAllProducts', () {
    final List<dynamic> jsonList =
        (json.decode(fixture('product_list.json'))
            as Map<String, dynamic>)['data'];

    final tProductModelList =
        jsonList.map((jsonItem) => ProductModel.fromJson(jsonItem)).toList();

    test(
      'should perform a GET request on /products with application/json header',
      () async {
        //arrange
        setUpMockHttpClientSuccess200WithList();

        //act
        await dataSource.getAllProducts();

        //assert
        verify(
          mockHttpClient.get(
            Uri.parse('https://g5-flutter-learning-path-be-tvum.onrender.com'),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should return list of ProductModels when response code is 200',
      () async {
        setUpMockHttpClientSuccess200WithList();

        final result = await dataSource.getAllProducts();

        expect(result, equals(tProductModelList));
      },
    );

    test(
      'should throw ServerException when response code is not 200',
      () async {
        setUpMockHttpClientFailure404();

        final call = dataSource.getAllProducts;

        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getProductById', () {
    final tId = '6672776eb905525c145fe0bb';

    test(
      'should perform a GET request with product ID in the URL and application/json header',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        await dataSource.getProductById(tId);

        // assert
        verify(
          mockHttpClient.get(
            Uri.parse(
              'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/$tId',
            ),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    final tProductModel = ProductModel.fromJson(
      (json.decode(fixture('product_remote.json'))
          as Map<String, dynamic>)['data'],
    );

    test(
      'should return ProductModel when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        final result = await dataSource.getProductById(tId);

        // assert
        expect(result, equals(tProductModel));
      },
    );

    test(
      'should throw ServerException when the response code is not 200',
      () async {
        // arrange
        setUpMockHttpClientFailure404();

        // act
        final call = dataSource.getProductById;

        // assert
        expect(() => call(tId), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('createProduct', () {
    late ProductRemoteDataSourceImpl dataSource;
    late MockClient mockHttpClient;
    late http.MultipartRequest capturedRequest;

    
    var tProductModel = ProductModel(
      id: '1',
      name: 'Cartier bracelete',
      imageUrl: 'example1.jpg',
      price: 123,
      description: 'long description',
    );

    setUp(() {
      mockHttpClient = MockClient();
      dataSource = ProductRemoteDataSourceImpl(client: mockHttpClient, baseUrl: 'https://g5-flutter-learning-path-be-tvum.onrender.com');
    });

    test('should send a multipart POST request with correct data', () async {
      // Arrange
      final file = File(tProductModel.imageUrl);
      await file.create(recursive: true);
      await file.writeAsBytes([1, 2, 3]);

      // Stub send() to capture the request and simulate 201
      when(mockHttpClient.send(any)).thenAnswer((invocation) async {
        capturedRequest =
            invocation.positionalArguments[0] as http.MultipartRequest;
        return http.StreamedResponse(Stream.value(utf8.encode('')), 201);
      });

      // Act
      await dataSource.createProduct(tProductModel);

      // Assert URL and method
      expect(
        capturedRequest.url.toString(),
        equals(
          'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products',
        ),
      );
      expect(capturedRequest.method, equals('POST'));

      // Assert fields (price may come as '123.0')
      expect(capturedRequest.fields['name'], equals('Cartier bracelete'));
      expect(capturedRequest.fields['description'], equals('long description'));
      expect(capturedRequest.fields['price'], equals('123.0'));

      // Assert file attachment
      expect(capturedRequest.files.length, equals(1));
      expect(capturedRequest.files.first.field, equals('image'));

      // Clean up
      await file.delete();
    });

    test('should complete normally when status code is 201', () async {
      // Arrange
      final file = File(tProductModel.imageUrl);
      await file.create(recursive: true);
      await file.writeAsBytes([1, 2, 3]);

      when(mockHttpClient.send(any)).thenAnswer(
        (_) async => http.StreamedResponse(Stream.value(utf8.encode('')), 201),
      );

      // Act & Assert: wait for completion before deleting
      await expectLater(dataSource.createProduct(tProductModel), completes);

      // Clean up
      await file.delete();
    });

    test('should throw ServerException on failure status code', () async {
      // Arrange: 
      final file = File(tProductModel.imageUrl);
      await file.create(recursive: true);
      await file.writeAsBytes([1, 2, 3]);

      when(mockHttpClient.send(any)).thenAnswer(
        (_) async => http.StreamedResponse(Stream.value(utf8.encode('')), 400),
      );

      // Act & Assert: catch ServerException, then delete
      await expectLater(
        () => dataSource.createProduct(tProductModel),
        throwsA(isA<ServerException>()),
      );

      await file.delete();
    });

    test('should throw exception if image file not found', () async {
      // Ensure file does not exist
      final file = File(tProductModel.imageUrl);
      if (await file.exists()) await file.delete();

      // Act & Assert (no file to delete)
      await expectLater(
        () => dataSource.createProduct(tProductModel),
        throwsA(
          predicate(
            (e) =>
                e is Exception && e.toString().contains('Image file not found'),
          ),
        ),
      );
    });
  });

  group('deleteProduct', () {
    final tId = '6672940692adcb386d593686'; 

    void setUpMockHttpClientSuccess() {
      when(
        mockHttpClient.delete(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('', 200)); 
    }

    void setUpMockHttpClientFailure() {
      when(
        mockHttpClient.delete(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('Error', 404)); 
    }

    test(
      'should perform a DELETE request with correct URL and headers',
      () async {
        // arrange
        setUpMockHttpClientSuccess();

        // act
        await dataSource.deleteProduct(tId);

        // assert
        verify(
          mockHttpClient.delete(
            Uri.parse(
              'https://g5-flutter-learning-path-be.onrender.com/api/v1/products/$tId',
            ),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test('should complete normally when response code is 200', () async {
      // arrange
      setUpMockHttpClientSuccess();

      // act
      final call = dataSource.deleteProduct(tId);

      // assert
      expect(call, completes);
    });

    test(
      'should throw ServerException when the response code is not 200',
      () async {
        // arrange
        setUpMockHttpClientFailure();

        // act
        final call = dataSource.deleteProduct;

        // assert
        expect(() => call(tId), throwsA(isA<ServerException>()));
      },
    );
  });

  group('updateProduct', () {
    final tProductModel = ProductModel(
      id: '6672940692adcb386d593686',
      name: 'TV',
      imageUrl: 'https://example.com/image.png',
      price: 123.4,
      description: "36' TV",
    );

    void setUpMockHttpClientSuccess() {
      when(
        mockHttpClient.put(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('', 200));
    }

    void setUpMockHttpClientFailure() {
      when(
        mockHttpClient.put(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 400));
    }

    test(
      'should perform a PUT request with correct URL, headers, and body',
      () async {
        // arrange
        setUpMockHttpClientSuccess();

        // act
        await dataSource.updateProduct(tProductModel);

        // assert
        final expectedBody = json.encode({
          'name': 'TV',
          'description': "36' TV",
          'price': 123.4,
        });

        verify(
          mockHttpClient.put(
            Uri.parse(
              'https://g5-flutter-learning-path-be.onrender.com/api/v1/products/${tProductModel.id}',
            ),
            headers: {'Content-Type': 'application/json'},
            body: expectedBody,
          ),
        );
      },
    );

    test('should complete normally when status code is 200', () async {
      // arrange
      setUpMockHttpClientSuccess();

      // act
      final call = dataSource.updateProduct(tProductModel);

      // assert
      expect(call, completes);
    });

    test('should throw ServerException when status code is not 200', () async {
      // arrange
      setUpMockHttpClientFailure();

      // act
      final call = dataSource.updateProduct;

      // assert
      expect(() => call(tProductModel), throwsA(isA<ServerException>()));
    });
  });

}
