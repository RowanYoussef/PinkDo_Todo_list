import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pinkdo/database/sql.dart';

class WishList extends StatefulWidget {
  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  Sqldb sqldb = Sqldb();

  Future<List<Map>> readData() async {
    List<Map> data = await sqldb.readData("SELECT * FROM wishes");
    return data;
  }

  void deleteWish(int id) async {
    await sqldb.deleteData("DELETE FROM wishes WHERE id = $id");
    setState(() {});
  }

  void deleteAllwishes() async {
    await sqldb.deleteAllwishes("DELETE FROM wishes"); 
    setState(() {});
  }

  double calculateCompletionPercentage(List<Map> wishes) {
    if (wishes.isEmpty) return 0.0;
    int completedTasks = wishes.where((wish) => wish['completed'] == 1).length;
    return completedTasks / wishes.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Wishes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink[300],
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.delete, color: Colors.pink[200]),
                      title: Text('Delete All Wishes',
                          style: TextStyle(color: Colors.pink[200])),
                      onTap: () {
                        deleteAllwishes();
                        Navigator.pop(context); // Close the popup menu
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.task, color: Colors.pink[200]),
                      title: Text('Your Tasks',
                          style: TextStyle(color: Colors.pink[200])),
                      onTap: () async {
                        Navigator.pop(context); // Close the popup menu
                        Navigator.pop(context, true); // Return to previous screen
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[50]!, Colors.pink[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: FutureBuilder(
            future: readData(),
            builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                double completionPercentage =
                    calculateCompletionPercentage(snapshot.data!);
                return Column(
                  children: [
                    LinearPercentIndicator(
                      lineHeight: 20.0,
                      percent: completionPercentage,
                      center: Text(
                        "${(completionPercentage * 100).toStringAsFixed(1)}%",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.0),
                      ),
                      progressColor: Colors.pink[300],
                      backgroundColor: Colors.pink[100]!,
                      barRadius: Radius.circular(10),
                    ),
                    SizedBox(height: 20),
                    snapshot.data!.isEmpty
                        ? Center(
                            child: Text(
                              "No wishes available",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18,
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, i) {
                                bool isChecked =
                                    snapshot.data![i]['completed'] == 1;
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    title: Text(
                                      "${snapshot.data![i]['wish']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isChecked
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.pink[200],
                                      child: Icon(
                                        Icons.star,
                                        color: Colors.white,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          value: isChecked,
                                          onChanged: (bool? value) async {
                                            bool newValue = value ?? false;
                                            setState(() {
                                              isChecked = newValue;
                                            });
                                            await sqldb.updateData(
                                                "UPDATE wishes SET completed = ${newValue ? 1 : 0} WHERE id = ${snapshot.data![i]['id']}");
                                          },
                                          activeColor: Colors.pink[300],
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.pink.shade200),
                                          onPressed: () {
                                            deleteWish(snapshot.data![i]['id']);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                );
              } else {
                return Center(
                  child: Text(
                    "Error loading wishes",
                    style: TextStyle(
                      color: Colors.pink[200],
                      fontSize: 18,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/Wish');
          if (result != null) {
            setState(() {});
          }
        },
        backgroundColor: Colors.pink[300],
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}

