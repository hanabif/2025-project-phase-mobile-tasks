import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:haymanot_aweke/features/product/data/model/Product_model.dart';
import 'package:haymanot_aweke/features/product/domain/entities/product.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  var testProductModel = ProductModel(
    id: "1",
    imageUrl: 'https://example.com/image.jpg',
    name: 'Test Product',
    price: 99.99,
    description: 'This is a test product',
  );
  test('should be a subclass of product entity', () async {
    //assert
    expect(testProductModel, isA<Product>());
  });

  test('should return valid model from json', () async {
    // arrange
    final jsonMap = json.decode(fixture('product.json'));
    // act
    final result = ProductModel.fromJson(jsonMap);
    // assert
    expect(result, testProductModel);
  });

  test('should return a JSON map containing proper data', () {
    // act
    final result = testProductModel.toJson();
    // assert
    final expectedMap = {
      'id': '1',
      'name': 'Test Product',
      'imageUrl': 'https://example.com/image.jpg',
      'price': 99.99,
      'description': 'This is a test product',
    };
    expect(result, expectedMap);
  });
}
