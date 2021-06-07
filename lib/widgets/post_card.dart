import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myblog/models/note.dart';
import 'package:myblog/screens/blog_view_screen.dart';

class PostCellWidget extends StatefulWidget {
  final BlogModel model;
  final ValueChanged<bool> isSelected;
  PostCellWidget({@required this.model, this.isSelected});

  @override
  _PostCellWidgetState createState() => _PostCellWidgetState();
}

class _PostCellWidgetState extends State<PostCellWidget> {
  bool isSelected = false;
  Color mycolor = Colors.transparent;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: mycolor,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: ListTile(
          selected: isSelected,
          onLongPress: () {
            toggleSelection();
          },
          onTap: () {
            Navigator.pushNamed(context, BlogViewScreen.route,
                arguments: widget.model.id);
          },
          minVerticalPadding: 5,
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            width: 120,
            height: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: widget.model.image != null
                    ? FileImage(
                        File(widget.model.image),
                      )
                    : AssetImage('assets/empty.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.model.title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Text(
                    widget.model.date,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Spacer(),
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.check_circle,
                        size: 18,
                        color: Colors.blue,
                      ),
                    )
                ],
              )),
        ),
      ),
    );
  }

  void toggleSelection() {
    setState(() {
      if (isSelected) {
        mycolor = Colors.transparent;
        isSelected = false;
        widget.isSelected(isSelected);
      } else {
        mycolor = Colors.grey[300];
        isSelected = true;
        widget.isSelected(isSelected);
      }
    });
  }
}
