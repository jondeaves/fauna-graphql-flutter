import 'package:fauna_todo/todo_item.dart';
import 'package:fauna_todo/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

String getTodosQuery = """
query getAllTodos {
  todos(_size:10) {
    data {
      _id
      title
      description
      completed
    }
    before
    after
  }
}
""";

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getTodosQuery),
          pollInterval: Duration(seconds: 120),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            return Text('Loading');
          }

          List<TodoItem> items = [];
          for (var i = 0; i < result.data?["todos"]["data"].length; i++) {
            TodoItem? item = TodoItem.fromMap(result.data?["todos"]["data"][i]);

            if (item != null) {
              items.add(item);
            }
          }

          return TodoList(items);
        });
  }
}
