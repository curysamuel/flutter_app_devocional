import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "dart:convert";
import "package:masked_text/masked_text.dart";

import "../models/book.dart";
import "../models/oldBookList.dart";

const PRIMARY_COLOR = Colors.brown;
const SECONDARY_COLOR = Colors.grey;

class MyHomePageOld extends StatefulWidget {
  OldBookList bookList = new OldBookList();

  MyHomePageOld() {
    bookList = bookList;
  }

  @override
  _MyHomePageOldState createState() => new _MyHomePageOldState();
}

class _MyHomePageOldState extends State<MyHomePageOld> {
  void edit(index, newStartDate, newEndDate) {
    setState(() {
      if (index < widget.bookList.list.length) {
        var book = widget.bookList.list.elementAt(index);

        book.startDate = newStartDate;
        book.endDate = newEndDate;
        book.done = book.endDate != null && book.endDate != "";
        save();
      }
    });
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("data", jsonEncode(widget.bookList.list));
  }

  Future loadData() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("data");
    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Book> result = decoded.map((x) => Book.fromJson(x)).toList();
      setState(() {
        widget.bookList.list = result;
      });
    }
  }

  _MyHomePageOldState() {
    loadData();
  }

  Future<bool> editDialog(BuildContext context, int index, Book book) {
    TextEditingController newDataStartCtrl =
        TextEditingController(text: book.startDate);
    TextEditingController newDataEndCtrl =
        TextEditingController(text: book.endDate);

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
              "Leitura de " + book.title + "?",
              style: new TextStyle(color: PRIMARY_COLOR),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  new MaskedTextField(
                    maskedTextFieldController: newDataStartCtrl,
                    mask: "xx/xx/xxxx",
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    inputDecoration: new InputDecoration(
                        labelText: "Iniciou " + book.title + " dia..."),
                  ),
                  new MaskedTextField(
                    maskedTextFieldController: newDataEndCtrl,
                    mask: "xx/xx/xxxx",
                    keyboardType: TextInputType.number,
                    inputDecoration: new InputDecoration(
                        labelText: "Finalizou " + book.title + " dia..."),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Cancelar",
                    style: new TextStyle(color: Colors.red.withOpacity(0.5))),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              new FlatButton(
                child: new Text("Salvar"),
                onPressed: () {
                  edit(index, newDataStartCtrl.text, newDataEndCtrl.text);
                  newDataStartCtrl.text = "";
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // widget.bookList.list =
    //     widget.bookList.list.where((f) => f.newTest).toList();
    return new Scaffold(
      body: new ListView.builder(
        itemCount: widget.bookList.list.length,
        padding: const EdgeInsets.all(4.0),
        itemBuilder: (context, i) {
          final item = widget.bookList.list[i];
          return new ListTile(
            title: new Text(
              item.title,
              style: new TextStyle(
                  color: item.done
                      ? PRIMARY_COLOR.withOpacity(0.5)
                      : PRIMARY_COLOR),
            ),
            subtitle: new Text(
              item.startDate != null && item.startDate != ""
                  ? (item.startDate +
                      " - " +
                      (item.endDate != null ? item.endDate : ""))
                  : "",
              style: new TextStyle(
                  fontStyle: FontStyle.italic, color: SECONDARY_COLOR),
            ),
            leading: const Icon(Icons.import_contacts),
            trailing: new RaisedButton(
              padding: const EdgeInsets.all(8.0),
              textColor: PRIMARY_COLOR,
              child: new Text("Intervalo"),
              onPressed: () {
                editDialog(context, i, item);
              },
            ),
          );
        },
      ),
    );
  }
}
