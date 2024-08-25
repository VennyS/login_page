import 'package:flutter/material.dart';
import 'package:widgets/toast.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  BaseScreenState createState() => BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ToastManager.showToast(
          context,
          const ToastWidget(
            variant: ToastVariant.informative,
            showTitle: true,
            title: "Успешно",
            showDescription: true,
            description: "Добро пожаловать в приложение фитнес-клуба GYMATECH",
          ),
          ToastSide.top);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(),
      ),
    );
  }
}
