import 'package:flutter/material.dart';
import 'package:login_page/components/toast.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ToastWidget(
        variant: ToastVariant.informative,
        title: "Успешно",
        description: "Добро пожаловать в приложение\n фитнес-клуба GYMATECH",
      ),
    );
  }
}
