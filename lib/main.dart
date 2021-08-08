import 'package:fauna_todo/client_provider.dart';
import 'package:fauna_todo/home_screen.dart';
import 'package:fauna_todo/todo_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await initHiveForFlutter();

  runApp(FaunaTodo());
}

final graphqlEndpoint = 'https://graphql.fauna.com/graphql';
final scaffoldState = GlobalKey<ScaffoldState>();
PersistentBottomSheetController? controller;

class FaunaTodo extends StatefulWidget {
  @override
  _FaunaTodoState createState() => _FaunaTodoState();
}

class _FaunaTodoState extends State<FaunaTodo> {
  late bool _isSheetOpen;

  @override
  void initState() {
    super.initState();

    _isSheetOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return ClientProvider(
      uri: graphqlEndpoint,
      child: MaterialApp(
          title: 'Fauna Todo',
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            key: scaffoldState,
            body: HomeScreen(),
            floatingActionButton: FloatingActionButton(
                child: _isSheetOpen ? Icon(Icons.close) : Icon(Icons.add),
                onPressed: () {
                  void closeSheet() {
                    if (controller != null) {
                      controller?.close();
                      controller = null;
                    }

                    setState(() {
                      _isSheetOpen = false;
                    });
                  }

                  if (_isSheetOpen) {
                    closeSheet();

                    return;
                  } else {
                    controller = scaffoldState.currentState?.showBottomSheet(
                        (context) => Container(
                            height: 300,
                            color: Colors.amber,
                            child: TodoForm(closeSheet)));

                    setState(() {
                      _isSheetOpen = true;
                    });
                  }
                }),
          )),
    );
  }
}
