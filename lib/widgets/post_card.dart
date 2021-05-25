import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myblog/models/note.dart';
import 'package:myblog/screens/blog_view_screen.dart';

class PostCellWidget extends StatelessWidget {
  final BlogModel model;
  PostCellWidget({@required this.model});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, BlogViewScreen.route,
              arguments: model.id);
        },
        child: Container(
          child: Row(
            children: [
              Container(
                width: 120,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                    image: model.image != null
                        ? FileImage(
                            File(model.image),
                          )
                        : AssetImage('assets/empty.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      model.date,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
