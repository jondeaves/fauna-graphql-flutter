import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

String addTodo = """
mutation CreateTodoItem(\$data: TodoItemInput!) {
  createTodoItem(data: \$data) {
    _id
    title
    description
    completed
  }
}
""";

class TodoFormErrors {
  String? title;
  String? description;

  TodoFormErrors({
    this.title,
    this.description,
  });

  void set(String key, String value) {
    switch (key) {
      case 'title':
        title = value;
        break;
      case 'description':
        description = value;
        break;
    }
  }
}

class TodoForm extends StatefulWidget {
  final Function closeSheet;

  TodoForm(this.closeSheet);

  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();

  late bool _loading;
  late bool _isValid;
  late TodoFormErrors _errors;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    bool devMode = false;
    assert(devMode = true);

    _loading = false;
    _isValid = devMode;

    _errors = new TodoFormErrors();

    _titleController =
        TextEditingController(text: devMode ? 'Testing an item' : null);
    _descriptionController = TextEditingController(
        text: devMode ? 'This description was generated in dev mode' : null);

    _titleController.addListener(() {
      setState(() {
        _isValid = _formKey.currentState!.validate();
      });
    });

    _descriptionController.addListener(() {
      setState(() {
        _isValid = _formKey.currentState!.validate();
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  String? _titleValidator(value) =>
      value.isEmpty ? 'Please provide a title' : null;

  String? _descriptionValidator(value) =>
      value.isEmpty ? 'Please provide a description' : null;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildTextField('Title', null, _titleValidator, false,
                  _titleController, !_loading, _errors.title),
              _buildTextField('Description', null, _descriptionValidator, false,
                  _descriptionController, !_loading, _errors.description),
              Mutation(options: MutationOptions(
                document: gql(addTodo),
                onError: (error) {
                  print(error);
                },
                onCompleted: (dynamic resultData) {
                  print(resultData);
                  setState(() {
                    _loading = false;
                  });

                  widget.closeSheet();
                }
              ), builder: (RunMutation runMutation, QueryResult? result) {
                return ElevatedButton(
                    onPressed: _isValid && !_loading
                        ? () async {
                      setState(() {
                        _loading = true;
                      });

                      print({
                        "data": {
                          "title": _titleController.text,
                          "description": _descriptionController.text,
                          "completed": false,
                        }
                      });

                      runMutation({
                        "data": {
                          "title": _titleController.text,
                          "description": _descriptionController.text,
                          "completed": false,
                        }
                      });
                    }
                        : null,
                    child: !_loading ? Text("Add Todo") : SizedBox(width: 16.0, height: 16.0, child: CircularProgressIndicator()));
              })
            ],
          )),
    );
  }

  Widget _buildTextField(
      String label,
      String? helper,
      FormFieldValidator<String>? validator,
      bool obscure,
      TextEditingController controller,
      bool enabled,
      String? errorText) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          helperText: helper,
          labelText: label,
          errorText: errorText,
        ),
        style: errorText == null
            ? null
            : TextStyle(
                color: Colors.red[800],
              ),
        validator: validator,
      ),
    );
  }
}
