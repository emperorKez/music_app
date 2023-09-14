import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoMusicFound extends StatelessWidget {
  const NoMusicFound({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Music player"),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: Colors.deepPurple,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset(
                      "images/sad.png",
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Sorry ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  const Text(
                    " No music found!!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      label: const Text("Exit"),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
