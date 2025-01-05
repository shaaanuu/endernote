import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomeNew extends StatelessWidget {
  const HomeNew({super.key});

  @override
  Widget build(BuildContext context) {
    Future fetchDir() async {
      final dirPath = await getApplicationDocumentsDirectory();

      return dirPath.path;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("For testing purposes..."),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("The documents directory is....."),
          FutureBuilder(
            future: fetchDir(),
            builder: (context, snapshot) => Text(
              snapshot.hasData ? snapshot.data : "none..",
            ),
          ),
        ],
      ),
    );
  }
}
