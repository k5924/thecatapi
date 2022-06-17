import 'package:flutter/material.dart';
import 'package:thecatapi/src/models/export.dart';
import 'package:thecatapi/src/providers/export.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TheCatAPI connection = TheCatAPI();
  final ScrollController controller = ScrollController();
  List<Cat> cats = [];
  int pageNumber = 1;
  bool hasMore = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetch();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future fetch() async {
    if (isLoading) return;
    isLoading = true;
    final result = await connection.getData(pageNumber: pageNumber);

    if (result != null) {
      setState(() {
        pageNumber++;
        isLoading = false;
        if (result.length < 2) {
          hasMore = false;
        }
        cats.addAll(result);
      });
    }
  }

  Future refresh() async {
    setState(() {
      isLoading = false;
      hasMore = true;
      pageNumber = 1;
      cats.clear();
    });
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          controller: controller,
          itemCount: cats.length + 1,
          itemBuilder: (context, index) {
            if (index < cats.length) {
              final cat = cats[index];
              return Image.network(cat.url);
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                    child: hasMore
                        ? const CircularProgressIndicator()
                        : const Text("No more data to load")),
              );
            }
          },
        ),
      ),
    );
  }
}
