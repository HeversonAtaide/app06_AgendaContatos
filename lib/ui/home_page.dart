import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app06/helpers/contact_helper.dart';
import 'package:flutter_app06/ui/contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Contatos"),
          backgroundColor: Colors.red,
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<OrderOptions>(
              itemBuilder: (context) =>
              <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(
                  child: Text("Ordernar de A-Z"),
                  value: OrderOptions.orderaz,
                ),
                const PopupMenuItem<OrderOptions>(
                  child: Text("Ordernar de Z-A"),
                  value: OrderOptions.orderza,
                )
              ],
              onSelected: _orderList,
            )
          ]
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showOptions(context, index);
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contacts[index].localImage != null
                            ? FileImage(File(contacts[index].localImage))
                            : AssetImage("images/person-male.png"),
                    fit: BoxFit.cover)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contacts[index].name ?? "",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(contacts[index].email ?? "",
                        style: TextStyle(fontSize: 18)),
                    Text(contacts[index].telefone ?? "",
                        style: TextStyle(fontSize: 18))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showContactPage({Contact contact}) async {
    final reContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ContactPage(
                  contact: contact,
                )));
    if (reContact != null) {
      if (contact != null) {
        await helper.updateContact(reContact);
      } else {
        await helper.saveContact(reContact);
      }
      _getAllContacts();
    }
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(context: context, builder: (context) {
      return BottomSheet(
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FlatButton(
                    child: Text("Ligar",
                      style: TextStyle(color: Colors.red, fontSize: 20),),
                    onPressed: () {
                      launch("tel:${contacts[index].telefone}");
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FlatButton(
                    child: Text("Editar",
                      style: TextStyle(color: Colors.red, fontSize: 20),),
                    onPressed: () {
                      Navigator.pop(context);
                      _showContactPage(contact: contacts[index]);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FlatButton(
                    child: Text("Excluir",
                      style: TextStyle(color: Colors.red, fontSize: 20),),
                    onPressed: () {
                      helper.deleteContact(contacts[index].idContato);
                      setState(() {
                        contacts.removeAt(index);
                        Navigator.pop(context);
                      });
                    },
                  ),
                )

              ],
            ),
          );
        }, onClosing: () {},
      );
    });
  }

  void _getAllContacts() {
    helper.getAllContact().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contacts.sort((a,b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a,b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;

    }
    setState(() {

    });
  }
}


