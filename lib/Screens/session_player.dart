
import 'package:cat_cow_yoga/viewModel/SessionProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionPlayer extends StatelessWidget {
  const SessionPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Consumer<SessionProvider>(
        builder:  (context, provider, _) {
          if(provider.session == null) {
            return const Scaffold(body: Center(child: Text("No session loaded")));
          }
          final session = provider.session!;
          if (provider.currentSequenceIndex >= session.sequence.length) {
            return Container(
              child:  Center(
                  child: Text(
                  "Session Complete",
                    style: TextStyle(
                      color: Colors.cyan
                    ),
              )),
            );
          }

          final script = session.sequence[provider.currentSequenceIndex].script;
          if (provider.currentScriptIndex >= script.length) {
            return const SizedBox(); // Avoid crash
          }

          final step = script[provider.currentScriptIndex];

          final stepDuration = step.endSec - step.startSec;
          final stepElapsed = provider.stepElapsed;
          final progress = (stepElapsed / stepDuration).clamp(0.0, 1.0);

          return Scaffold(
            backgroundColor: Colors.white,

            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/${provider.session!.images[step.imageRef]}", height: 300),
                  const SizedBox(height: 20),
                  Text(
                    step.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),

                  const SizedBox(height: 30),
                  
                  //Progress bar
                  
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 40.0),

                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey[300],
                      color: Colors.cyan,
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text(
                    "Step Time: ${stepElapsed}s / $stepDuration s",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          provider.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          color: Colors.black,
                          size: 64,
                        ),
                        onPressed: () {
                          provider.isPlaying ? provider.pause() : provider.resume();
                        },
                      )
                    ],
                  ),


                ],
              ),

            ),
            floatingActionButton: FloatingActionButton(
              heroTag: "restart",
                onPressed: () {
                  provider.restartSession();
                },
                    backgroundColor: Colors.cyan,
              child:
                 Icon(Icons.replay),

            ),
          );
        }
    );
  }
}
