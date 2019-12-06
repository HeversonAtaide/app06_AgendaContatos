import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

String contactTable = "contactTable";
String idColumn = "idColumn";
String nameColumn = "nameColumn";
String emailColumn = "emailColumn";
String phoneColumn = "phoneColumn";
String imgColumn = "imgColumn";

class ContactHelper {

  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _database;

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDb();
      return _database;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contactsnew.db");

    return await openDatabase(
        path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)"
      );
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.idContato = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int idContato) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, idColumn],
        where: "$idColumn = ?",
        whereArgs: [idContato]);
    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact.delete(
        contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update(
        contactTable, contact.toMap(), where: "$idColumn = ?",
        whereArgs: [contact.idContato]);
  }

  Future<List> getAllContact() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM  $contactTable");
    List<Contact> listContact = List();
    for (Map m in listMap) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int> getNumber() async{
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future close() async{
    Database dbContact = await db;
    dbContact.close();
  }
}

class Contact {

  Contact();

  int idContato;
  String name;
  String email;
  String telefone;
  String localImage;

  Contact.fromMap(Map map){
    idContato = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    telefone = map[phoneColumn];
    localImage = map[imgColumn];
  }

  Map toMap(){


    Map<String, dynamic> map = {
      nameColumn : name,
      emailColumn : email,
      phoneColumn : telefone,
      imgColumn : localImage
    };
    /*map[nameColumn] = name;
    map[emailColumn] = email;
    map[phoneColumn] = telefone;
    map[imgColumn] = localImage;*/

    if(idContato != null){
      map[idColumn] = idContato;
    }
    return map;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Contact(id: $idContato, name: $name, email: $email, telefone: $telefone, localImage: $localImage\n";
  }

}