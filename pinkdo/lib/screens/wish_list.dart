import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pinkdo/Themes/themeNotifier.dart';
import 'package:pinkdo/database/sql.dart';
import 'package:provider/provider.dart';

class WishList extends StatefulWidget {
  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  Sqldb sqldb = Sqldb();

  Future<List<Map>> readData() async {
    List<Map> data =
        await sqldb.readData("SELECT * FROM wishes WHERE completed = 0");
    return data;
  }

  Future<List<Map>> readCompleted() async {
    List<Map> data =
        await sqldb.readData("SELECT * FROM wishes WHERE completed = 1");
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

  double calculateCompletionPercentage(
      List<Map> wishes, List<Map> completedwishes) {
    int totalwishes = wishes.length + completedwishes.length;
    if (totalwishes == 0) return 0.0;
    return completedwishes.length / totalwishes;
  }

  void openWish(Map wish) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                wish['wish'],
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              SizedBox(height: 20),
              Text(
                'Description: ${wish['description'] ?? 'No description'}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
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
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'My Wishes',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).primaryColor,
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
                          leading: Icon(Icons.delete,
                              color: Theme.of(context).colorScheme.primary),
                          title: Text('Delete All Wishes',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          onTap: () {
                            deleteAllwishes();
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.task,
                              color: Theme.of(context).colorScheme.primary),
                          title: Text('Your Tasks',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          onTap: () async {
                            Navigator.pop(context);
                            Navigator.pop(context, true);
                          },
                        ),
                        ListTile(
                          leading: Icon(themeNotifier.isBlue() ? Icons.girl : Icons.boy,
                              color: Theme.of(context).colorScheme.primary),
                          title: Text(
                              themeNotifier.isBlue()
                                  ? "Pink mode"
                                  : "Blue mode",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          onTap: () {
                            themeNotifier.toggleTheme();
                            Navigator.pop(context);
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
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.secondary
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: FutureBuilder<List<List<Map>>>(
                future: Future.wait([readData(), readCompleted()]),
                builder: (BuildContext context,
                    AsyncSnapshot<List<List<Map>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    List<Map> wishes = snapshot.data![0];
                    List<Map> completedwishes = snapshot.data![1];
                    double completionPercentage =
                        calculateCompletionPercentage(wishes, completedwishes);

                    return Column(
                      children: [
                        LinearPercentIndicator(
                          lineHeight: 20,
                          percent: completionPercentage,
                          center: Text(
                            "${(completionPercentage * 100).toStringAsFixed(1)}%",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0),
                          ),
                          progressColor: Theme.of(context).primaryColor,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          barRadius: Radius.circular(10),
                        ),
                        SizedBox(height: 20),
                        wishes.isEmpty && completedwishes.isEmpty
                            ? Center(
                                child: Text(
                                  "No tasks available",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 18),
                                ),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      wishes.length + completedwishes.length,
                                  itemBuilder: (context, i) {
                                    Map wish = {};
                                    if (i >= wishes.length) {
                                      wish = completedwishes[i - wishes.length];
                                    } else {
                                      wish = wishes[i];
                                    }
                                    bool isChecked = wish['completed'] == 1;
                                    return Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 5,
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        title: Text(
                                          "${wish['wish']}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: isChecked
                                                ? Colors.grey
                                                : Colors.black,
                                          ),
                                        ),
                                        onTap: () {
                                          openWish(wish);
                                        },
                                        leading: CircleAvatar(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                                                try {
                                                  await sqldb.updateData(
                                                      "UPDATE wishes SET completed = ${newValue ? 1 : 0} WHERE id = ${wish['id']}");
                                                } catch (e) {
                                                  print("$e");
                                                }
                                              },
                                              activeColor: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                              onPressed: () {
                                                deleteWish(wish['id']);
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
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18),
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
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
