import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_page/components/toast.dart';
import 'package:login_page/const.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  void initState() {
    super.initState();
    // Показываем тост сразу после загрузки страницы
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ToastManager().showToast(
        context,
        ToastWidget(
          variant: ToastVariant.informative,
          title: "Успешно",
          description: "Добро пожаловать в приложение фитнес-клуба GYMATECH",
          trailingIcon: SvgPicture.asset(SvgInfo.close),
          showTrailingIcon: false,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: SizedBox(),
      ),
    );
  }
}
