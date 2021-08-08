class TodoItem {
  final String id;
  final String title;
  final String description;
  final bool completed;

  TodoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
  });

  static List<TodoItem> listFromMap(Map<String, dynamic>? data) {
    List<TodoItem> items = [];

    return items;
  }

  static TodoItem? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    return TodoItem(
      id: data["_id"],
      title: data["title"],
      description: data["description"],
      completed: data["completed"],
    );
  }

  @override
  String toString({int indentation = 0, bool spacer: false}) {
    String titleIndention = List.filled(indentation, "\t").join();
    String indention = List.filled(indentation + 2, "\t").join();

    String resp = '$titleIndention Todo: $id\n'
        '$indention Title: $title\n'
        '$indention Description: $description\n'
        '$indention Completed: $completed\n';

    resp += '${spacer == true ? '\n' : ''}';

    return resp;
  }
}
