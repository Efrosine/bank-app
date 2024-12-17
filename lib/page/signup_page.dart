import 'package:flutter/material.dart';

import '../apiservice/api_service.dart';
import 'signin_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final ApiService service = ApiService();

  final nameControl = TextEditingController();
  final emailControl = TextEditingController();
  final passwordControl = TextEditingController();
  final confirmPasswordControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 96, 244),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height + 200,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                  right: -200,
                  width: 400,
                  bottom: -150,
                  height: 400,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white30,
                        border: Border.all(color: Colors.white70, width: 5)),
                  )),
              Positioned.fill(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
                  child: Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Register',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 54),
                        TextField(
                          controller: nameControl,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: emailControl,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Suggested code may be subject to a license. Learn more: ~LicenseLog:1994651105.
                        TextField(
                          controller: passwordControl,
                          // obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: confirmPasswordControl,
                          decoration: InputDecoration(
                            labelText: 'Confirmed Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                              onPressed: () async {
                                try {
                                  var meesage = await service.register(
                                    nameControl.text,
                                    emailControl.text,
                                    passwordControl.text,
                                    confirmPasswordControl.text,
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(meesage)));

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SigninPage(),
                                      ));
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())));
                                }
                              },
                              child: Text('Register')),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SigninPage(),
                                ));
                          },
                          child: Text('Sudah punya akun?'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
