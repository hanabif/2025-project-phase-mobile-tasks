import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class BasePage extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final bool useSafeArea;
  final EdgeInsetsGeometry? padding;

  const BasePage({
    Key? key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.useSafeArea = true,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: useSafeArea ? SafeArea(child: _buildBody()) : _buildBody(),
    );
  }

  Widget _buildBody() {
    if (padding != null) {
      return Padding(padding: padding!, child: body);
    }
    return body;
  }
}
