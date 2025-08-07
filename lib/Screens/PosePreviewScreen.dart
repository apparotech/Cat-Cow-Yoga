
import 'package:cat_cow_yoga/Screens/session_player.dart';
import 'package:cat_cow_yoga/viewModel/SessionProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PosePreviewScreen extends StatelessWidget {
  const PosePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context).session;

    if (session == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
          backgroundColor: Colors.blue,
          title: const Text(
              "Yoga Session Preview",
            style: TextStyle(
              color: Colors.white
            ),
          ),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: session.sequence.length,
          itemBuilder:  (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: session.sequence[index].script.map((s) => ListTile(
                leading: Image.asset("assets/images/${session.images[s.imageRef]}", height: 60),
                title: Text(s.text),
              )).toList(),
            );
          }
      ),
      floatingActionButton:  FloatingActionButton.extended(
          onPressed: () async {
            await context.read<SessionProvider>().playSession();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SessionPlayer()),
            );
          },
          label: const Text("Start Session"),
        icon: const Icon(Icons.play_arrow),
      ),


    );
  }
}
