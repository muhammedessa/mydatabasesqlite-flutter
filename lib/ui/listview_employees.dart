import 'package:flutter/material.dart';
import 'package:mydatabasesqlite/model/employee.dart';
import 'package:mydatabasesqlite/util/database_helper.dart';
import 'package:mydatabasesqlite/ui/employee_screen.dart';

class ListViewEmployees extends StatefulWidget {
  @override
  _ListViewEmployeesState createState() => new _ListViewEmployeesState();
}

class _ListViewEmployeesState extends State<ListViewEmployees> {
  List<Employee> items = new List();
  DatabaseHelper db = new DatabaseHelper();

  @override
  void initState() {
    super.initState();

    db.getAllEmployees().then((employees) {
      setState(() {
        employees.forEach((employee) {
          items.add(Employee.fromMap(employee));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All Employees',
      home: Scaffold(
        appBar: AppBar(
          title: Text('All Employees'),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(height: 5.0),
                    ListTile(

                      title: Text(
                        '${items[position].name}',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      subtitle: Text(
                        '${items[position].age} - ${items[position].city} - ${items[position].department}',
                        style: new TextStyle(
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      leading: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(20.0)),
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 18.0,
                            child: Text(
                              '${items[position].id}',
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent,),
                              onPressed: () => _deleteEmployee(context, items[position], position)
                          ),
                        ],
                      ),
                      onTap: () => _navigateToEmployee(context, items[position]),
                    ),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.add),
          onPressed: () => _createNewEmployee(context),
        ),
      ),
    );
  }

  void _deleteEmployee(BuildContext context, Employee employee, int position) async {
    db.deleteEmployee(employee.id).then((employees) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToEmployee(BuildContext context, Employee employee) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeScreen(employee)),
    );

    if (result == 'update') {
      db.getAllEmployees().then((employees) {
        setState(() {
          items.clear();
          employees.forEach((employee) {
            items.add(Employee.fromMap(employee));
          });
        });
      });
    }
  }

  void _createNewEmployee(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeScreen(Employee('', '', '', '', ''))),
    );

    if (result == 'save') {
      db.getAllEmployees().then((employees) {
        setState(() {
          items.clear();
          employees.forEach((employee) {
            items.add(Employee.fromMap(employee));
          });
        });
      });
    }
  }
}
