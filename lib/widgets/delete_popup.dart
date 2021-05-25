import 'package:flutter/material.dart';
import 'package:myblog/helper/blog_provider.dart';
import 'package:myblog/models/note.dart';
import 'package:provider/provider.dart';

class DeletePopUp extends StatelessWidget {
  final Blog selectedNote;

  DeletePopUp(this.selectedNote);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Text('Delete?'),
      content: Text('Do you want to delete the blog?'),
      actions: [
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            Provider.of<BlogProvider>(context, listen: false)
                .deleteBlog(selectedNote.id);
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
        TextButton(
          child: Text('No'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
