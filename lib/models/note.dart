import 'package:intl/intl.dart';

class Blog {
  int _id;
  String _title;
  String _content;
  String _imagePath;

  Blog(this._id, this._title, this._content, this._imagePath);

  int get id => _id;
  String get title => _title;
  String get content => _content;
  String get imagePath => _imagePath;

  String get date {
    final date = DateTime.fromMillisecondsSinceEpoch(id);
    return DateFormat('EEE h:mm a, dd/MM/yyyy').format(date);
  }
}

class BlogModel {
  int id;
  String title, image, content, date;

  BlogModel(
    this.id,
    this.title,
    this.content,
    this.date,
    this.image,
  );
}