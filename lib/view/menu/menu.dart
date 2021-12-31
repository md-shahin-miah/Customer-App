import 'package:flutter/material.dart';
import 'package:blue/global/tracker.dart';
import 'package:blue/model/menu_category_model.dart';
import 'package:blue/view/menu/edit_category.dart';
import 'package:need_resume/need_resume.dart';

import 'menu_item.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends ResumableState<MenuPage> {
  bool isLoading = true;
  @override
  void initState() {
    if (AppStateTracker.isMenuReload) {
      MenuCategoryModel.categories.clear();
    }
    MenuCategoryModel.getCategories().then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  void onResume() {
    if (AppStateTracker.isMenuReload) {
      MenuCategoryModel.categories.clear();
    }
    MenuCategoryModel.getCategories().then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('OrderE - Merchant'),
      // ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.deepOrange,),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: MenuCategoryModel.categories.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MenuItemPage(
                              '${MenuCategoryModel.categories[index].id}',
                              MenuCategoryModel
                                  .categories[index].categoryName))),
                  child: Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(2, 2),
                        ),
                      ],
                      color: Colors.grey[50],
                    ),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          '${MenuCategoryModel.categories[index].categoryName}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                            '${MenuCategoryModel.categories[index].description}'),
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        onPressed: () {
                          push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditCategoryPage(
                                      MenuCategoryModel.categories[index])));
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
