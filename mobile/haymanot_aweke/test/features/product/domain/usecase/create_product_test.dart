import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haymanot_aweke/features/product/domain/entities/product.dart';
import 'package:haymanot_aweke/features/product/domain/repositories/product_repository.dart';
import 'package:haymanot_aweke/features/product/domain/usecases/create_product.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_product_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late CreateProductUsecase createProductUsecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    createProductUsecase = CreateProductUsecase(mockProductRepository);
  });

  final testProduct = Product(
    id: "1",
    imageUrl: 'https://example.com/image.png',
    name: 'Test Product',
    price: 99.99,
    description: 'This is a test product',
  );

  test(
    'should call createProduct on the repository and return Right(unit)',
    () async {
      //arrange
      when(
        mockProductRepository.createProduct(testProduct),
      ).thenAnswer((_) async => const Right(unit));

      //act
      final result = await createProductUsecase(Params(testProduct));

      //assert
      expect(result, Right(testProduct));
       verify(
        mockProductRepository.createProduct(testProduct),
      ).called(1); 
      verifyNoMoreInteractions(mockProductRepository); 
    },
  );
}
