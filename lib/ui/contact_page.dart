import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter_app06/helpers/contact_helper.dart';
import 'package:image_picker/image_picker.dart';

enum OrderOptions { orderaz, orderza }

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  bool _userEdited = false;
  final _nameEditingController = TextEditingController();
  final _emailEditingController = TextEditingController();
  final _telefoneEditingController = TextEditingController();

  final _nameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                _editedContact.name ?? "Novo Contato",
              ),
              backgroundColor: Colors.red,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (_editedContact.name != null &&
                    _editedContact.name.isNotEmpty) {
                  Navigator.pop(context, _editedContact);
                } else {
                  FocusScope.of(context).requestFocus(_nameFocus);
                }
              },
              child: Icon(
                Icons.save,
                color: Colors.white,
              ),
              backgroundColor: Colors.red,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: _editedContact.localImage != null
                                  ? FileImage(File(_editedContact.localImage))
                                  : AssetImage("images/person-male.png"),
                              fit: BoxFit.cover)),
                    ),
                    onTap: () {
                      ImagePicker.pickImage(source: ImageSource.camera)
                          .then((file) {
                        if (file != null) {
                          setState(() {
                            _editedContact.localImage = file.path;
                          });
                        } else
                          return;
                      });
                    },
                  ),
                  TextField(
                    focusNode: _nameFocus,
                    controller: _nameEditingController,
                    decoration: InputDecoration(
                      labelText: "Nome",
                    ),
                    onChanged: (text) {
                      setState(() {
                        _userEdited = true;
                        _editedContact.name = text;
                      });
                    },
                  ),
                  TextField(
                    controller: _emailEditingController,
                    decoration: InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (text) {
                      _userEdited = true;
                      _editedContact.email = text;
                    },
                  ),
                  TextField(
                    controller: _telefoneEditingController,
                    decoration: InputDecoration(labelText: "Telefone"),
                    keyboardType: TextInputType.phone,
                    onChanged: (text) {
                      _userEdited = true;
                      _editedContact.telefone = text;
                    },
                  )
                ],
              ),
            )));
  }

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameEditingController.text = _editedContact.name;
      _emailEditingController.text = _editedContact.email;
      _telefoneEditingController.text = _editedContact.telefone;
    }
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
