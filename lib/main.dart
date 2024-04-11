import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class TodoItem {
  final int id;
  String name;
  String group;

  TodoItem({required this.id, required this.name, required this.group});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoItem> _todoList = [];

  final nameController = TextEditingController();
  final groupController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    groupController.dispose();
    super.dispose();
  }

  void _addItem(TodoItem newItem) {
    setState(() {
      _todoList.add(newItem);
    });
  }

  void _updateItem(int index, TodoItem updatedItem) {
    setState(() {
      _todoList[index] = updatedItem;
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _todoList.removeAt(index);
    });
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                _deleteItem(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_todoList[index].name),
            subtitle: Text(_todoList[index].group),
            onTap: () {
              nameController.text = _todoList[index].name;
              groupController.text = _todoList[index].group;

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Обновить задачу"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("ID: ${_todoList[index].id}"),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: 'Имя'),
                        ),
                        TextFormField(
                          controller: groupController,
                          decoration: InputDecoration(labelText: 'Группа'),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text("Обновить"),
                        onPressed: () {
                          _updateItem(
                            index,
                            TodoItem(
                              id: _todoList[index].id,
                              name: nameController.text,
                              group: groupController.text,
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            onLongPress: () {
              _showDeleteConfirmationDialog(index);
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Добавить задачу"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Имя'),
                    ),
                    TextFormField(
                      controller: groupController,
                      decoration: InputDecoration(labelText: 'Группа'),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.add),
                        SizedBox(width: 4),
                        Text("Добавить задачу"),
                      ],
                    ),
                    onPressed: () {
                      _addItem(TodoItem(
                        id: _todoList.length + 1,
                        name: nameController.text,
                        group: groupController.text,
                      ));
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        label: Text("Добавить задачу"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
