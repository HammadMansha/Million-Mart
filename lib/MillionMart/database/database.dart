import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

class DatabaseHelper {
  static Database? _dateBase;

  Future<Database> get openDB async => _dateBase ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Get.log("Database Created");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'millionmart.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
       CREATE TABLE carts (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       name TEXT,
       price TEXT,
       slug TEXT,
       image TEXT,
       previous_price TEXT,
       qty INTEGER,
       item TEXT,
       sub_total TEXT,
       size TEXT,
       color TEXT,
      size_key TEXT,
      size_qty TEXT,
      size_price TEXT,
      stock TEXT,
      key TEXT,
      p_id TEXT,
      p_user_id TEXT,
      p_slug TEXT,
      p_name TEXT,
      p_photo TEXT,
      p_size TEXT,
      p_size_qty TEXT,
      p_size_price TEXT,
      p_color TEXT,
      p_price TEXT,
      p_stock TEXT,
      p_type TEXT,
      p_file TEXT,
      p_link TEXT,
      p_license TEXT,
      p_license_qty TEXT,
      p_measure TEXT,
      p_whole_sale_qty TEXT,
      p_whole_sale_discount TEXT,
      p_attributes TEXT,
      license TEXT,
      dp TEXT,
      keys TEXT,
      val TEXT,
      item_price TEXT
       )
      ''');
    //Comparison Item Table

    await db.execute('''
      CREATE TABLE comp (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       name TEXT,
       price TEXT,
       image TEXT,
       rating TEXT,
       des TEXT,
       discount TEXT
       )
      ''');
  }

  //INSERT Comp Item
  Future<int> insertComp(CompData _compData) async {
    await openDB;
    Get.log("Data saved to comp.");
    return await _dateBase!.insert('comp', _compData.toMap());
  }

  //insert into Cart Table
  Future<int> insertProduct(Cart cart) async {
    await openDB;
    Get.log("Data saved to cart.");
    return await _dateBase!.insert('carts', cart.toMap());
  }

  //Get Comp Table Data
  Future<List<CompData>> getCompData() async {
    await openDB;
    final List<Map<String, dynamic>> maps = await _dateBase!.query('comp');
//Get Data
    Get.log(maps.toString());
    // print("comp table data is "+maps.toString());

    // print('Items');
    // print(maps[index]['id']);

    return List.generate(maps.length, (index) {
      return CompData(
          id: maps[index]['id'],
          name: maps[index]['name'],
          rating: maps[index]['rating'],
          price: maps[index]['price'],
          discount: maps[index]['discount'],
          des: maps[index]['des'],
          image: maps[index]['image']);
    });
  }

  // Get Comparison pro Count
  Future<int> getCompCount() async {
    await openDB;
    final List<Map<String, dynamic>> maps = await _dateBase!.query('comp');
    print('count of comp' + maps.length.toString());
    int n = maps.length;
    return n;
  }

  //Delete Comparison Item
  Future<void> deleteComp(String id) async {
    await openDB;
    await _dateBase!.delete("comp", where: "name = ? ", whereArgs: [id]);
  }

  Future<List<Cart>> getCartData() async {
    await openDB;
    final List<Map<String, dynamic>> maps = await _dateBase!.query('carts');
    return List.generate(maps.length, (index) {
      print('Items');
      print(maps[index]['slug']);
      return Cart(
        id: maps[index]['id'],
        name: maps[index]['name'],
        price: maps[index]['price'],
        image: maps[index]['image'],
        size: maps[index]['size'].toString().toLowerCase().contains('null')
            ? 'null'
            : maps[index]['size'],
        previous_price: maps[index]['previous_price'],
        qty: maps[index]['qty'],
        sub_total: maps[index]['sub_total'],
        color: maps[index]['color'].toString().toLowerCase().contains('null')
            ? 'null'
            : maps[index]['color'],
        size_key: 0,
        size_price:
            maps[index]['size_price'].toString().toLowerCase().contains('null')
                ? 'null'
                : maps[index]['size_price'],
        size_qty:
            maps[index]['size_qty'].toString().toLowerCase().contains('null')
                ? 'null'
                : maps[index]['size_qty'],
        stock: maps[index]['stock'].toString().toLowerCase().contains('null')
            ? 'null'
            : maps[index]['stock'],
        slug: maps[index]['slug'].toString(),
        p_name: maps[index]['p_name'],
        key: maps[index]['key'],
        p_id: maps[index]['p_id'],
        p_user_id: maps[index]['p_user_id'],
        p_slug: maps[index]['p_slug'],
        p_photo: maps[index]['p_photo'],
        p_size: maps[index]['p_size'],
        p_size_qty: maps[index]['p_size_qty'],
        p_size_price: maps[index]['p_size_price'],
        p_color: maps[index]['p_color'],
        p_price: maps[index]['p_price'],
        p_stock: maps[index]['p_stock'],
        p_type: maps[index]['p_type'],
        p_file: maps[index]['p_file'],
        p_link: maps[index]['p_link'],
        p_license: maps[index]['p_license'],
        p_license_qty: maps[index]['p_license_qty'],
        p_measure: maps[index]['p_measure'],
        p_whole_sale_qty: maps[index]['p_whole_sale_qty'],
        p_whole_sale_discount: maps[index]['p_whole_sale_discount'],
        p_attributes: maps[index]['p_attributes'],
        license: maps[index]['license'],
        dp: maps[index]['dp'],
        keys: maps[index]['keys'],
        values: maps[index]['val'],
        item_price: maps[index]['item_price'],
      );
    });
  }

  Future<int> getCartCount() async {
    await openDB;
    final List<Map<String, dynamic>> maps = await _dateBase!.query('carts');
    print('count of cart' + maps.length.toString());
    return maps.length;
  }

  Future<int> updateProduct(Cart cart) async {
    await openDB;
    return await _dateBase!
        .update('carts', cart.toMap(), where: 'id=?', whereArgs: [cart.id]);
  }

  Future<int> countIncrement(String name, int qty, num subTotal) async {
    print("Increment DB Function");
    await openDB;
    return await _dateBase!.rawUpdate('''
    UPDATE carts 
    SET qty = ?, sub_total = ? 
    WHERE name = ?
    ''', [qty, subTotal.toString(), '$name']);
  }

  Future<int> countDecrement(String name, int qty, num subTotal) async {
    await openDB;
    return await _dateBase!.rawUpdate('''
    UPDATE carts 
    SET qty = ?, sub_total = ? 
    WHERE name = ?
    ''', [qty, subTotal.toString(), '$name']);
  }

  Future<void> deleteProduct(String id) async {
    await openDB;
    await _dateBase!.delete("carts", where: "name = ? ", whereArgs: [id]);
  }

  Future<void> deleteWholeComp() async {
    await openDB;
    await _dateBase!.delete("comp");
  }

  Future<void> deleteWholeCart() async {
    await openDB;
    await _dateBase!.delete("carts");
  }

  //Check Comp Items
  Future<bool> checkCompItems(String name) async {
    var database = await openDB;
    final res = await _dateBase!
        .rawQuery("""SELECT * FROM comp WHERE name == '$name'; """);

    if (res.isEmpty) {
      print('Product not already exist.');
      return true;
    } else {
      print('Product already exist.');
      return false;
    }
  }

  Future<bool> checkCartItems(String name) async {
    var database = await openDB;
    final res = await _dateBase!
        .rawQuery("""SELECT * FROM carts WHERE name == '$name'; """);

    if (res.isEmpty) {
      print('Product not already exist.');
      return true;
    } else {
      print('Product already exist.');
      return false;
    }
  }
}

class Cart {
  int? id, size_key;
  int qty;
  String? name,
      slug,
      price,
      image,
      previous_price,
      sub_total,
      size_qty,
      size_price,
      size,
      color,
      stock,
      key,
      p_id,
      p_user_id,
      p_slug,
      p_name,
      p_photo,
      p_size,
      p_size_qty,
      p_size_price,
      p_color,
      p_price,
      p_stock,
      p_type,
      p_file,
      p_link,
      p_license,
      p_license_qty,
      p_measure,
      p_whole_sale_qty,
      p_whole_sale_discount,
      p_attributes,
      license,
      dp,
      keys,
      values,
      item_price;

  Cart({
    this.id,
    this.name,
    this.image,
    this.price,
    this.slug,
    this.stock,
    this.size,
    this.size_price,
    this.color,
    this.size_qty,
    this.size_key,
    this.previous_price,
    required this.qty,
    this.sub_total,
    this.key,
    this.p_id,
    this.p_user_id,
    this.p_slug,
    this.p_name,
    this.p_photo,
    this.p_size,
    this.p_size_qty,
    this.p_size_price,
    this.p_color,
    this.p_price,
    this.p_stock,
    this.p_type,
    this.p_file,
    this.p_link,
    this.p_license,
    this.p_license_qty,
    this.p_measure,
    this.p_whole_sale_qty,
    this.p_whole_sale_discount,
    this.p_attributes,
    this.license,
    this.dp,
    this.keys,
    this.values,
    this.item_price,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'previous_price': previous_price,
      'image': image,
      'slug': slug,
      'qty': qty,
      'size_key': size_key,
      'color': color,
      'size': size,
      'sub_total': sub_total,
      "size_qty": size_qty,
      "size_price": size_price,
      "stock": stock,
      "key": key,
      "p_id": p_id,
      "p_user_id": p_user_id,
      "p_slug": p_slug,
      "p_name": p_name,
      "p_photo": p_photo,
      "p_size": p_size,
      "p_size_qty": p_size_qty,
      "p_size_price": p_size_price,
      "p_color": p_color,
      "p_price": p_price,
      "p_stock": p_stock,
      "p_type": p_type,
      "p_file": p_file,
      "p_link": p_link,
      "p_license": p_license,
      "p_license_qty": p_license_qty,
      "p_measure": p_measure,
      "p_whole_sale_qty": p_whole_sale_qty,
      "p_whole_sale_discount": p_whole_sale_discount,
      "p_attributes": p_attributes,
      "license": license,
      "dp": dp,
      "keys": keys,
      "val": values,
      "item_price": item_price,
    };
  }
}

// To parse this JSON data, do
//
//     final compData = compDataFromJson(jsonString);

CompData compDataFromJson(String str) => CompData.fromJson(json.decode(str));

String compDataToJson(CompData data) => json.encode(data.toMap());

class CompData {
  CompData({
    this.id,
    this.name,
    this.price,
    this.image,
    this.des,
    this.discount,
    this.rating,
  });

  int? id;
  String? name;
  String? price;
  String? image;
  String? des;
  String? discount;
  String? rating;

  factory CompData.fromJson(Map<String, dynamic> json) => CompData(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        image: json["image"],
        des: json["des"],
        discount: json["discount"],
        rating: json["rating"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "price": price,
        "image": image,
        "des": des,
        "discount": discount,
        "rating": rating,
      };
}
