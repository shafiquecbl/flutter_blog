import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myblog/helper/blog_provider.dart';
import 'package:myblog/models/note.dart';
import 'package:myblog/utils/constants.dart';
import 'package:myblog/widgets/delete_popup.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'blog_view_screen.dart';

class BlogEditScreen extends StatefulWidget {
  static const route = '/edit-note';

  @override
  _BlogEditScreenState createState() => _BlogEditScreenState();
}

class _BlogEditScreenState extends State<BlogEditScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  File _image;

  final picker = ImagePicker();

  bool firstTime = true;
  Blog selectedBlog;
  int id;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (firstTime) {
      id = ModalRoute.of(this.context).settings.arguments;

      if (id != null) {
        selectedBlog = Provider.of<BlogProvider>(
          this.context,
          listen: false,
        ).getBlog(id);

        titleController.text = selectedBlog?.title;
        contentController.text = selectedBlog?.content;

        if (selectedBlog?.imagePath != null) {
          _image = File(selectedBlog.imagePath);
        }
      }
    }
    firstTime = false;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration:
                BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back),
              color: black,
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
                icon: Icon(Icons.photo_camera),
                color: black,
                onPressed: () {
                  getImage(ImageSource.camera);
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
                icon: Icon(Icons.insert_photo),
                color: Colors.green.shade500,
                onPressed: () {
                  getImage(ImageSource.gallery);
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
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  if (id != null) {
                    _showDialog();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 5.0, top: 10.0, bottom: 5.0),
              child: TextField(
                controller: titleController,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: createTitle,
                decoration: InputDecoration(
                    hintText: 'Enter Blog Title', border: InputBorder.none),
              ),
            ),
            if (_image != null)
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          image: FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 5.0, top: 10.0, bottom: 5.0),
              child: TextField(
                controller: contentController,
                maxLines: null,
                style: createContent,
                decoration: InputDecoration(
                  hintText: 'Enter Something...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFFD810),
        onPressed: () {
          if (titleController.text.isEmpty)
            titleController.text = 'Untitled Blog';

          saveBlog();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  getImage(ImageSource imageSource) async {
    PickedFile imageFile = await picker.getImage(source: imageSource);

    if (imageFile == null) return;

    File tmpFile = File(imageFile.path);

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(imageFile.path);

    tmpFile = await tmpFile.copy('${appDir.path}/$fileName');

    setState(() {
      _image = tmpFile;
    });
  }

  void saveBlog() {
    String title = titleController.text.trim();
    String content = contentController.text.trim();

    String imagePath = _image != null ? _image.path : null;

    if (id != null) {
      Provider.of<BlogProvider>(
        this.context,
        listen: false,
      ).addOrUpdateBlog(id, title, content, imagePath, EditMode.UPDATE);
      Navigator.of(this.context).pop();
    } else {
      int id = DateTime.now().millisecondsSinceEpoch;

      Provider.of<BlogProvider>(this.context, listen: false)
          .addOrUpdateBlog(id, title, content, imagePath, EditMode.ADD);

      Navigator.of(this.context)
          .pushReplacementNamed(BlogViewScreen.route, arguments: id);
    }
  }

  void _showDialog() {
    showDialog(
        context: this.context,
        builder: (context) {
          return DeletePopUp(selectedBlog);
        });
  }
}
