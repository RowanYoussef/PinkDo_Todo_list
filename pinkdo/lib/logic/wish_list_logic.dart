import 'package:flutter/material.dart';
import 'package:pinkdo/database/sql.dart';

class WishListLogic {
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
  }

  void deleteAllwishes() async {
    await sqldb.deleteAllwishes("DELETE FROM wishes");
  }

  double calculateCompletionPercentage(
      List<Map> wishes, List<Map> completedwishes) {
    int totalwishes = wishes.length + completedwishes.length;
    if (totalwishes == 0) return 0.0;
    return completedwishes.length / totalwishes;
  }

  void openWish(Map wish,context) {
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
                'Description: ${wish['Description'] ?? 'No description'}',
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
}
