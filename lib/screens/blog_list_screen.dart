import 'package:flutter/material.dart';
import 'package:myblog/helper/blog_provider.dart';
import 'package:myblog/screens/blog_edit_screen.dart';
import 'package:provider/provider.dart';
import 'package:myblog/widgets/post_card.dart';
import 'package:myblog/models/note.dart';

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  String searchTitle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Blog',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 15,
        ),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color(0xFFFFD810),
          elevation: 2,
          onPressed: () {
            goToBlogEditScreen(context);
          },
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
                decoration: InputDecoration(
                  hintText: 'Search for articles',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchTitle = value;
                  });
                }),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Available Blogs',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: SizedBox(
              height: 100,
              child: FutureBuilder(
                future: searchTitle == null || searchTitle == ""
                    ? Provider.of<BlogProvider>(context, listen: false)
                        .getBlogs()
                    : Provider.of<BlogProvider>(context, listen: false)
                        .searchBlogs(searchTitle),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  return Consumer<BlogProvider>(
                    child: Center(
                      child: Text('No Blog Available'),
                    ),
                    builder: (context, blogprovider, child) =>
                        blogprovider.items.length <= 0
                            ? child
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: blogprovider.items.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return Container();
                                  } else {
                                    final i = index - 1;
                                    final item = blogprovider.items[i];

                                    return PostCellWidget(
                                        model: BlogModel(
                                      item.id,
                                      item.title,
                                      item.content,
                                      item.date,
                                      item.imagePath,
                                    ));
                                  }
                                },
                              ),
                  );
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  void goToBlogEditScreen(BuildContext context) {
    Navigator.of(context).pushNamed(BlogEditScreen.route);
  }
}
