import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasematerial/controller/auth_controller.dart';
import 'package:firebasematerial/controller/contact_controller.dart';
import 'package:firebasematerial/view/update_contact.dart';
import 'package:firebasematerial/view/add_contact.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final String? username;

  const Dashboard({Key? key, this.username}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var cc = ContactController();
  @override
  void initState() {
    super.initState();
    cc.getContact();
  }

  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                'Hai, ${widget.username ?? ''}',
                style: const TextStyle(fontSize: 24),
              ),
              ElevatedButton(
                onPressed: () {
                  _authController.signOut();
                  Navigator.pop(context);
                },
                child: const Text('Logout'),
              ),
            ]),
            const SizedBox(height: 20),
            const Text(
              'Contact List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: cc.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  final List<DocumentSnapshot> data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onLongPress: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateContact(
                                    username: widget.username,
                                    id: data[index]['id'],
                                    name: data[index]['name'],
                                    phone: data[index]['phone'],
                                    email: data[index]['email'],
                                    address: data[index]['address'],
                                  ),
                                ));
                          },
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Text(
                                    data[index]['name']
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              title: Text(data[index]['name']),
                              subtitle: Text(data[index]['phone']),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  cc.deleteContact(
                                      data[index]['id'].toString());
                                  setState(() {
                                    cc.getContact();
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => const AddContact()),
            ),
          );
          cc.getContact();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
