import 'package:chatApp/cubits/login_cubit.dart';
import 'package:chatApp/cubits/register_cubit.dart';
import 'package:chatApp/cubits/home_page_cubit.dart';
import 'package:chatApp/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'register.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => HomeCubit()..getUsers()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Login(),
        routes: {
          '/login': (context) => Login(),
          '/register': (context) => Register(),
          //'/chat': (context) => Chat(),
          '/home': (context) => const Home(),
        },
      ),
    );
  }
}
