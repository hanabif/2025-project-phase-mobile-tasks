import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haymanot_aweke/core/usecases/usecase_params.dart';
import 'package:haymanot_aweke/features/product/data/model/Product_model.dart';
import 'package:haymanot_aweke/features/product/presentation/bloc/product_bloc.dart';
import 'package:haymanot_aweke/features/product/presentation/pages/add_update_page.dart';
import 'package:haymanot_aweke/features/product/presentation/pages/retrieve_all_products_page.dart';
import 'package:mockito/mockito.dart';

class MockProductBloc extends Mock implements ProductBloc {}

void main() {
  late MockProductBloc mockProductBloc;

  final mockProducts = [
    ProductModel(
      id: '1',
      name: 'Item 1',
      description: 'Desc',
      price: 10,
      imageUrl: 'example.com/image.jpg',
    ),
    ProductModel(
      id: '2',
      name: 'Item 2',
      description: 'Desc',
      price: 20,
      imageUrl: 'example.com/image.jpg',
    ),
  ];

  setUp(() {
    mockProductBloc = MockProductBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<ProductBloc>(
      create: (context) => mockProductBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('add product wth valid name', (WidgetTester tester) async {
    //act
    await tester.pumpWidget(
      _makeTestableWidget(AddUpdatePage(isEditing: false)),
    );

    final addProductBtn = find.byIcon(Icons.add);
    expect(addProductBtn, findsOneWidget);
    await tester.tap(addProductBtn);
    await tester.pumpAndSettle();

    final nameField = find.byKey(const Key('nameField'));
    final desciptionField = find.byKey(const Key('descriptionField'));
    final priceField = find.byKey(const Key('priceField'));
    final submitBtn = find.byKey(const Key('submitButton'));

    //valid input
    await tester.enterText(nameField, 'Test product');
    await tester.enterText(desciptionField, 'This is test description');
    await tester.enterText(priceField, '10.00');
    await tester.tap(submitBtn);

    //assert
    verify(mockProductBloc.createProduct(any as ProductParams)).called(1);
    expect(find.text('Test product'), findsOneWidget);
  });
  testWidgets('don\'t add product wth empty name', (WidgetTester tester) async {
    await tester.pumpWidget(
      _makeTestableWidget(const AddUpdatePage(isEditing: false)),
    );

    final addProductBtn = find.byIcon(Icons.add);
    expect(addProductBtn, findsOneWidget);
    await tester.tap(addProductBtn);
    await tester.pumpAndSettle();

    final nameField = find.byKey(const Key('nameField'));
    final desciptionField = find.byKey(const Key('descriptionField'));
    final priceField = find.byKey(const Key('priceField'));
    final submitBtn = find.byKey(const Key('submitButton'));

    //invalid input
    await tester.enterText(nameField, '');
    await tester.enterText(desciptionField, 'This is test description');
    await tester.enterText(priceField, '10.00');
    await tester.tap(submitBtn);

    //assert
    verifyNoMoreInteractions(mockProductBloc.createProduct);
    expect(find.text('Enter product name'), findsOneWidget);
  });

  testWidgets('display products and verify update', (
    WidgetTester tester,
  ) async {
    //arrange
    when(() => mockProductBloc.state).thenReturn(
      LoadedAllProductState(products: mockProducts) as ProductState Function(),
    );
    whenListen(
      mockProductBloc,
      Stream.fromIterable([LoadedAllProductState(products: mockProducts)]),
    );
    //act
    await tester.pumpWidget(
      BlocProvider<ProductBloc>.value(
        value: mockProductBloc,
        child: const MaterialApp(home: RetrieveAllProductsPage()),
      ),
    );

    await tester.pumpAndSettle();

    //assert
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    final nameField = find.byKey(const Key('nameField'));
    final desciptionField = find.byKey(const Key('descriptionField'));
    final priceField = find.byKey(const Key('priceField'));
    final submitBtn = find.byKey(const Key('submitButton'));

    //valid input
    await tester.enterText(nameField, 'Test product');
    await tester.enterText(desciptionField, 'This is test description');
    await tester.enterText(priceField, '10.00');
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    expect(find.text('Test product'), findsOneWidget);
  });
  
  testWidgets('navigate back to the main ecommerce list page while tapping the back button in product detail page', (WidgetTester tester)async{
    when(() => mockProductBloc.state).thenReturn(
      LoadedAllProductState(products: mockProducts) as ProductState Function(),
    );
    whenListen(
      mockProductBloc,
      Stream.fromIterable([LoadedAllProductState(products: mockProducts)]),
    );
    //act
    await tester.pumpWidget(
      BlocProvider<ProductBloc>.value(
        value: mockProductBloc,
        child: const MaterialApp(home: RetrieveAllProductsPage()),
      ),
    );

    //add input
    final addProductBtn = find.byIcon(Icons.add);
    expect(addProductBtn, findsOneWidget);
    await tester.tap(addProductBtn);
    await tester.pumpAndSettle();

    final nameField = find.byKey(const Key('nameField'));
    final desciptionField = find.byKey(const Key('descriptionField'));
    final priceField = find.byKey(const Key('priceField'));
    final submitBtn = find.byKey(const Key('submitButton'));

    //valid input
    await tester.enterText(nameField, 'Test product');
    await tester.enterText(desciptionField, 'This is test description');
    await tester.enterText(priceField, '10.00');
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    //tap the new product
    await tester.tap(find.text('Test product'));
    await tester.pumpAndSettle();

    //check if it is detail page
    expect(find.text('Size'), findsOneWidget);

    //tap the back button
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    //check if it is the home page
    expect(find.byIcon(Icons.add), findsOneWidget);

  });
}
