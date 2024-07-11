import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.pink[200],
      ),
      body: getTasks(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("clicked");
        },
        tooltip: 'Add Task',
        child: Icon(Icons.add , color: Colors.white,),
        backgroundColor: Colors.pink[200],
      ),
    );
  }

  ListView getTasks() {
    TextStyle? titleStyle = Theme.of(context).textTheme.headlineMedium;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) => Card(
        color: Colors.pink[50],
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[400],
            child: Icon(Icons.timer),
          ),
          title: Text(
            'NA',
            style: titleStyle,
          ),
          subtitle: Text('date'),
          trailing: Icon(
            Icons.delete,
            color: Colors.grey,
          ),
          onTap: () {
            print("succes");
          },
        ),
      ),
    );
  }
}
