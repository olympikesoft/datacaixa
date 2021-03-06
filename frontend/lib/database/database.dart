import 'dart:io';
import 'package:datacaixa/database/dao/client_dao.dart';
import 'package:datacaixa/database/dao/order_dao.dart';
import 'package:datacaixa/database/dao/order_item_dao.dart';
import 'package:datacaixa/database/dao/product_group_dao.dart';
import 'package:datacaixa/database/dao/product_dao.dart';
import 'package:datacaixa/database/dao/table_dao.dart';
import 'package:datacaixa/database/dao/user_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataStore implements DataStoreHelper {
  Database db;
  String dbName = 'datacaixa.db';
  String path;
  ClientDao clientDao;
  TableDao tableDao;
  OrderDao orderDao;
  ProductDao productDao;
  OrderItemDao orderItemDao;
  ProductGroupDao productGroupDao;
  UserDao userDao;

  @override
  void create(Database database, int version) async {
    OrderDao.createTable(database);
    OrderItemDao.createTable(database);
    ProductGroupDao.createTable(database);
    ProductDao.createTable(database);
    TableDao.createTable(database);
    ClientDao.createTable(database);
    UserDao.createTable(database);
  }

  @override
  Future<Database> connect() async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, dbName);

    bool dbExists = await databaseExists(path);
    if(dbExists) {
     await Directory(databasesPath).create(recursive: true);
    }
    db = await openDatabase(path, version: 1, onCreate: create);
    createDaos();
    return db;
  }

  @override
  void createDaos() {
    orderDao = OrderDao(db);
    productDao = ProductDao(db);
    productGroupDao = ProductGroupDao(db);
    orderItemDao = OrderItemDao(db);
    tableDao = TableDao(db);
    userDao = UserDao(db);
    clientDao = ClientDao(db);
  }

  @override
  void preload() async {

  }

  @override
  void disconnect() async {
    await db.close();
  }

  @override
  void delete() async {
    await deleteDatabase(path);
  }
}

abstract class DataStoreHelper {
  void create(Database db, int version);
  Future<Database> connect();
  void disconnect();
  void createDaos();
  void delete();
  void preload();
}