import 'package:flutter/material.dart';
import 'package:flutter_login_getx/core/base_controller.dart';
import 'package:flutter_login_getx/core/routes/app_navigation.dart';
import 'package:flutter_login_getx/data/repositories/auth_repository.dart';
import 'package:get/get.dart';

import '../../data/repositories/session_repository.dart';

class LoginController extends BaseController {
  final AuthRepository authRepository;
  final SessionRepository sessionRepository;
  LoginController(this.authRepository, this.sessionRepository);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var obscurePassword = true.obs;

  var rememberMe = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    final (username, password, rememberMe) = await sessionRepository.loadCredentials();
    if (rememberMe && username != null && username.isNotEmpty && password != null && password.isNotEmpty) {
      emailController.text = username;
      passwordController.text = password;
      this.rememberMe.value = true;
      startLoading();
      await onClickLogin();
      stopLoading();
    }
  }

  void onClickObscurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void onToggleRememberMe({bool? value}) {
    rememberMe.value = !rememberMe.value;
  }

  Future<void> onClickLogin() async {
    startLoading();
    await Future.delayed(Duration(seconds: 2));
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and password cannot be empty");
      return;
    }

    try {
      final user = await authRepository.login(username: email, password: password);
      if (user.result != null) {
        if (rememberMe.value) {
          await sessionRepository.saveCredentials(email.trim(), password.trim(), true);
        } else {
          await sessionRepository.clearCredentials();
        }

        stopLoading();
        VNavigation.offAllUntilNavigation();
      } else {
        stopLoading();
        Get.snackbar("Error", "Something went wrong");
      }
    } catch (e) {
      stopLoading();
      Get.snackbar("Error", e.toString());
    }
  }
}
