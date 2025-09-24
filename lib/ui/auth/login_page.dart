import 'package:flutter/material.dart';
import 'package:flutter_login_getx/core/constants/size.dart';
import 'package:flutter_login_getx/core/constants/space.dart';
import 'package:flutter_login_getx/ui/widgets/text.dart';
import 'package:get/get.dart';

import '../../core/color.dart';
import '../../core/constants/constants.dart';
import '../widgets/button.dart';
import '../widgets/loading_page.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => VLoadingOverlay(
            isLoading: controller.isLoadingObs.value,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        spaceVerticalCustom(50),
                        SizedBox(width: 232, height: 29, child: Image.asset('${imagePath}logo.png', fit: BoxFit.contain)),
                        spaceVerticalCustom(50),
                        VText("Login", fontSize: textSizeSuperLarge, isBold: true, color: VColor.onSurface),
                        spaceVerticalSmall,
                        VText("Login to your account", fontSize: textSizeLarge, isBold: true, color: VColor.onSurface),
                        spaceVerticalCustom(30),
                        TextField(
                          controller: controller.emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: const Icon(Icons.email, size: 20),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                          ),
                        ),
                        spaceVerticalLarge,
                        Obx(
                          () => TextField(
                            controller: controller.passwordController,
                            obscureText: controller.obscurePassword.value,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: const Icon(Icons.lock, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(controller.obscurePassword.value ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  controller.onClickObscurePassword();
                                },
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        spaceVerticalLarge,
                        Material(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              Obx(
                                () => Checkbox(
                                  value: controller.rememberMe.value,
                                  shape: const CircleBorder(),
                                  checkColor: VColor.primary,
                                  activeColor: Colors.white,
                                  fillColor: WidgetStateProperty.all(Colors.white),
                                  side: BorderSide.none,
                                  onChanged: (value) {
                                    controller.onToggleRememberMe();
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.onToggleRememberMe();
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: const Text("Remember me", style: TextStyle(color: VColor.onSurface)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: VButton(text: "Login", onPressed: controller.isLoadingObs.value ? null : controller.onClickLogin),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
