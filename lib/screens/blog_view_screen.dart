import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myblog/helper/blog_provider.dart';
import 'package:myblog/models/note.dart';
import 'package:myblog/utils/constants.dart';
import 'package:myblog/widgets/delete_popup.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'blog_edit_screen.dart';

class BlogViewScreen extends StatefulWidget {
  static const route = '/note-view';

  @override
  _BlogViewScreenState createState() => _BlogViewScreenState();
}

class _BlogViewScreenState extends State<BlogViewScreen> {
  Blog selectedBlog;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final id = ModalRoute.of(context).settings.arguments;

    final provider = Provider.of<BlogProvider>(context);

    if (provider.getBlog(id) != null) {
      selectedBlog = provider.getBlog(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Container(
            decoration:
                BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100], shape: BoxShape.circle),
              child: IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  _onShare(context);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100], shape: BoxShape.circle),
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () => _showDialog(),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                selectedBlog?.title,
                style: viewTitleStyle,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.access_time,
                    size: 18,
                  ),
                ),
                Text('${selectedBlog?.date}')
              ],
            ),
            if (selectedBlog.imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.file(
                  File(selectedBlog.imagePath),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                selectedBlog.content,
                style: viewContentStyle,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFFD810),
        onPressed: () {
          Navigator.pushNamed(context, BlogEditScreen.route,
              arguments: selectedBlog.id);
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;

    if (selectedBlog.imagePath.isNotEmpty) {
      await Share.shareFiles([selectedBlog.imagePath],
          text: selectedBlog.content,
          subject: selectedBlog.title,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(selectedBlog.content,
          subject: selectedBlog.title,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  _showDialog() {
    showDialog(
        context: this.context,
        builder: (context) {
          return DeletePopUp(selectedBlog);
        });
  }
}
