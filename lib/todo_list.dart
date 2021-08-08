import 'package:fauna_todo/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

String editTodo = """
mutation EditTodo (
  \$id: ID!,
  \$title: String!,
  \$description: String!,
  \$completed: Boolean!
) {
  updateTodoItem(id: \$id, data: {
    title: \$title
    description: \$description
    completed: \$completed
  }) {
    _id
    title
    description
    completed
  }
}
""";

class TodoList extends StatelessWidget {
  final List<TodoItem> _todos;

  TodoList(this._todos);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _todos.length,
      itemBuilder: (context, i) {
        final todoItem = _todos[i];

        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(todoItem.title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(todoItem.description, style: TextStyle(fontSize: 14.0)),
            ],
          ),
          trailing: Mutation(options: MutationOptions(
              document: gql(editTodo),
              onError: (error) {
                print(error);
              },
              onCompleted: (dynamic resultData) {
                print(resultData);
              }
          ), builder: (RunMutation runMutation, QueryResult? result) {
            return IconButton(
              onPressed: () {
                print({
                  "data": {
                    "id": todoItem.id,
                    "title": todoItem.title,
                    "description": todoItem.description,
                    "completed": !todoItem.completed,
                  }
                });
                runMutation({
                  "id": todoItem.id,
                  "title": todoItem.title,
                  "description": todoItem.description,
                  "completed": !todoItem.completed,
                });
              },
                    icon: Icon(
                todoItem.completed
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: todoItem.completed ? Colors.green : Colors.black,
                size: 24.0,
                semanticLabel: 'Incomplete',
              )
            );
          }),
        );
      },
    );
  }
}
