import 'package:flutter/material.dart';
import 'package:ukl/services/nasabah.dart';
import 'package:ukl/widgets/alert.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserService user = UserService();
  final formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  bool showPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/register');
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Center(  // Center the child in the body
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.9, // Adjust width
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  // Center items vertically
              mainAxisSize: MainAxisSize.min,  // Take up only as much space as needed
              children: [
                // App Logo
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.asset("images/1.png", height: 200), // Use your logo image
                ),
                
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: username,
                        decoration: InputDecoration(
                          label: Text("Username"),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Username harus diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: password,
                        obscureText: showPass,
                        decoration: InputDecoration(
                          label: Text("Password"),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPass = !showPass;
                              });
                            },
                            icon: showPass ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password harus diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // Login Button
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    var data = {
                                      "username": username.text,
                                      "password": password.text,
                                    };
                                    var result = await user.login(data);
                                    setState(() {
                                      isLoading = false;
                                    });
                                    AlertMessage().showAlert(context, result.message, result.status);
                                    if (result.status) {
                                      Future.delayed(Duration(seconds: 2), () {
                                        Navigator.pushNamed(context, '/dashboard');
                                      });
                                    }
                                  }
                                },
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("LOGIN"),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Optional Footer: Forgot Password
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Dont Have account? Register',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}