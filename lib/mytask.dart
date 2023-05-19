import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:todo/edittask.dart';
import 'package:todo/profile.dart';

import 'calender.dart';
import 'connect.dart';
import 'home.dart';
import 'notification.dart';

class Mytask extends StatefulWidget {
  const Mytask({super.key});

  @override
  State<Mytask> createState() => _MytaskState();
}

class _MytaskState extends State<Mytask> {
  Future<dynamic> getTask() async {
    var response = await get(Uri.parse('${Con.url}mytask.php'));
    var res = jsonDecode(response.body);
    print(res);
    return res;
  }

  Future<void> deleteTask(String taskId) async {
    var data = {
      "task_id": taskId,
    };

    var response =
        await post(Uri.parse('${Con.url}deletetask.php'), body: data);
    var res = jsonDecode(response.body);

    if (res['message'] == 'Form Data') {
      Fluttertoast.showToast(msg: 'Deleted Task');
    } else {
      Fluttertoast.showToast(msg: 'Delete Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Task",
            style: TextStyle(
              color: Color.fromRGBO(0, 112, 173, 1),
              fontSize: 17,
            )),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 60,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        elevation: 2.00,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(
              Icons.notification_add,
              color: Color.fromRGBO(0, 112, 173, 1),
            ),
          )
        ],
        leading: Container(
          margin: EdgeInsets.only(left: 8, top: 6, bottom: 6, right: 8),
          decoration: BoxDecoration(
            color: Color.fromRGBO(229, 246, 247, 1.000),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ));
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color.fromRGBO(0, 112, 173, 1),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: FutureBuilder(
          future: getTask(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color.fromRGBO(1, 166, 255, 1),
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                          child: Icon(
                            Icons.account_circle_rounded,
                          ),
                        ),
                        title: Text(snapshot.data![index]['name'],
                            style: TextStyle(
                                color: Color.fromRGBO(0, 112, 173, 1),
                                fontWeight: FontWeight.w600)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(snapshot.data![index]['starttime']),
                              SizedBox(
                                width: 5,
                              ),
                              Text(snapshot.data![index]['endtime']),
                            ],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return EditTask(
                                        id: snapshot.data![index]['task_id'],
                                      );
                                    },
                                  ));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color.fromRGBO(0, 112, 173, 1),
                                )),
                            IconButton(
                                onPressed: () {
                                  deleteTask(snapshot.data![index]['task_id']);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color.fromRGBO(0, 112, 173, 1),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No Task'),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(0, 112, 173, 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomAppBar(
            color: Colors.white,
            elevation: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Color.fromRGBO(0, 112, 173, 1),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 60),
                  child: IconButton(
                    icon: Icon(
                      Icons.calendar_month,
                      color: Color.fromRGBO(0, 112, 173, 1),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Calender(),
                          ));
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.message,
                    color: Color.fromRGBO(0, 112, 173, 1),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Notifiy(),
                        ));
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    color: Color.fromRGBO(0, 112, 173, 1),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(),
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
