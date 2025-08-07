import 'package:cat_cow_yoga/service/json_loader.dart';
import 'package:cat_cow_yoga/viewModel/SessionProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/PosePreviewScreen.dart';
import 'screens/session_player.dart';
import 'package:cat_cow_yoga/model/yoga_sequence.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:FutureBuilder(
          future: loadYogaSession(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Scaffold(body: Center(child: Text("Error: ${snapshot.error}")));
            } else {
              final session = snapshot.data!;


              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<SessionProvider>().setSession(session);
              });

              return const PosePreviewScreen();
            }
          },
        )

      ),
    );
  }
}
