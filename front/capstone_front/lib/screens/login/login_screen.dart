import 'package:capstone_front/services/auth_service.dart';
import 'package:capstone_front/services/login_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<String> _userInfo = ['', ''];
  bool _canLogin = false;

  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('login.login'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              const SizedBox(
                height: 100,
              ),
              Row(
                children: [
                  Flexible(
                    child: loginTextField(
                        context, tr("login.kmu_email"), 0, false),
                  ),
                  const Text("@kookmin.ac.kr"),
                ],
              ),
              loginTextField(context, tr("login.password"), 1, true),
              Row(
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () async {
                        String result = await login(
                            '${_userInfo[0]}@kookmin.ac.kr', _userInfo[1]);
                        switch (result) {
                          case "success":
                            var uuid = await storage.read(key: 'uuid');
                            var isLogined = await AuthService.signIn({
                              "uuid": uuid,
                              "email": '${_userInfo[0]}@kookmin.ac.kr',
                            });
                            if (isLogined) {
                              var accessToken =
                                  await storage.read(key: "accessToken");
                              await AuthService.getUserInfo(
                                  uuid!, accessToken!);

                              await storage.write(
                                  key: 'isLogin', value: 'true');
                              makeToast(tr("login.login_success"));
                              context.go('/');
                            }
                          case "email":
                            makeToast(tr("login.email_not_varified"));
                          case "invalid-credential":
                            makeToast(tr("login.invalid_credential"));
                          default:
                            makeToast(tr("login.login_fail"));
                        }
                      },
                      child: Ink(
                        height: 50,
                        decoration: BoxDecoration(
                          color: _canLogin
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            tr('login.login'),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        context.push('/signup');
                      },
                      child: Ink(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            tr('login.signup'),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField loginTextField(
      BuildContext context, String label, int index, bool isObscure) {
    return TextField(
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFFB4B9C3),
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        border: const OutlineInputBorder(borderSide: BorderSide.none),
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      onChanged: (text) {
        setState(() {
          _userInfo[index] = text;
          _checkCanLogin();
        });
      },
    );
  }

  void _checkCanLogin() {
    for (int i = 0; i < _userInfo.length; i++) {
      if (_userInfo[i] == '') {
        _canLogin = false;
        return;
      }
    }
    _canLogin = true;
  }

  void makeToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      fontSize: 20,
    );
  }
}
