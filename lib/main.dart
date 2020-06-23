import "package:flutter/material.dart";
import "widgets/myHomePageOld.dart";

const PRIMARY_COLOR = Colors.brown;
const SECONDARY_COLOR = Colors.grey;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Leitura bíblica",
      debugShowCheckedModeBanner: false,
      color: Colors.grey,
      theme: new ThemeData(
        primarySwatch: PRIMARY_COLOR,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "Velho Testamento"),
                Tab(text: "Novo Testamento"),
              ],
            ),
            title: Text('Leitura bíblica'),
          ),
          body: TabBarView(
            children: [
              MyHomePageOld(),
              MyHomePageOld(),
            ],
          ),
        ),
      ),
    );
  }
}
