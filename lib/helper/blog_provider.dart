import 'package:flutter/material.dart';
import 'package:myblog/helper/database_helper.dart';
import 'package:myblog/models/note.dart';
import 'package:myblog/utils/constants.dart';

class BlogProvider with ChangeNotifier {
  List _items = [];

  List get items {
    return [..._items];
  }

  Blog getBlog(int id) {
    return _items.firstWhere((note) => note.id == id, orElse: () => null);
  }

  Future deleteBlog(int id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    return DatabaseHelper.delete(id);
  }

  Future addOrUpdateBlog(int id, String title, String content, String imagePath,
      EditMode editMode) async {
    final blog = Blog(id, title, content, imagePath);

    if (EditMode.ADD == editMode) {
      _items.insert(0, blog);
    } else {
      _items[_items.indexWhere((note) => note.id == id)] = blog;
    }

    notifyListeners();

    DatabaseHelper.insert({
      'id': blog.id,
      'title': blog.title,
      'content': blog.content,
      'imagePath': blog.imagePath,
    });
  }

  Future getBlogs() async {
    final notesList = await DatabaseHelper.getBlogsFromDB();

    _items = notesList
        .map(
          (item) => Blog(
              item['id'], item['title'], item['content'], item['imagePath']),
        )
        .toList();

    notifyListeners();
  }

  Future searchBlogs(search) async {
    final notesList = await DatabaseHelper.search(search);

    _items = notesList
        .map(
          (item) => Blog(
              item['id'], item['title'], item['content'], item['imagePath']),
        )
        .toList();

    notifyListeners();
  }
}
