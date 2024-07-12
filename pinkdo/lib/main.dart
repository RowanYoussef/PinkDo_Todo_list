import 'package:flutter/material.dart';
import 'package:pinkdo/database/sql.dart';

void main() => runApp(PinkDoApp());

class PinkDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PinkDoHome(),
    );
  }
}

class PinkDoHome extends StatefulWidget {
  @override
  State<PinkDoHome> createState() => _PinkDoHomeState();
}

class _PinkDoHomeState extends State<PinkDoHome> {
  Sqldb sqldb = Sqldb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () async {
                  try {
                    int response = await sqldb.insertData(
                        "INSERT INTO 'tasks' ('task') VALUES ('task one')");
                    print(response);
                  } catch (e) {
                    print("Error inserting data: $e");
                  }
                },
                child: Text("Insert Data"),
              ),
            ),
            Center(
              child: MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () async {
                  try {
                    List<Map> response =
                        await sqldb.readData("SELECT * FROM 'tasks'");
                    print(response);
                  } catch (e) {
                    print("Error reading data: $e");
                  }
                },
                child: Text("Read Data"),
              ),
            ),
            Center(
              child: MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () async {
                  try {
                    int response = 
                        await sqldb.deleteData("DELETE FROM 'tasks' WHERE id = 3");
                    print(response);
                  } catch (e) {
                    print("Error reading data: $e");
                  }
                },
                child: Text("delete Data"),
              ),
            ),
            Center(
              child: MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () async {
                  try {
                    int response = 
                        await sqldb.updateData("UPDATE 'tasks' SET 'task' = 'task six' WHERE id = 6");
                    print(response);
                  } catch (e) {
                    print("Error reading data: $e");
                  }
                },
                child: Text("update Data"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
