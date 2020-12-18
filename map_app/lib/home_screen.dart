import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_app/constants.dart';
import 'package:map_app/detail_screen.dart';
import 'package:map_app/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _image='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIMG();
  }
  getIMG()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var v=prefs.getString('image');
    setState(() {
      _image=v;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchInput(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Trending',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w400
              ),
            ),
          ),
          Expanded(
            child: PlaceStaggeredGridview(),
          )
        ],
      ),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: mBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.library_add,
          size: 24,
          color: Colors.pinkAccent,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotesScreen()),
          );
        },
      ),
      actions: [
        GestureDetector(
          onTap: (){
            getIMG();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfilePage(img: _image,)),
            );
          },
          child: UnconstrainedBox(
            child: Container(
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(88)),
              child: Image.network(
                _image!=null?_image:"https://media.istockphoto.com/vectors/user-icon-human-person-sign-vector-id587957104?k=6&m=587957104&s=170667a&w=0&h=umaeFHgEnWFB-A45hQYZXvrcqKh-2fnsx68pwcWCR1c=",
                fit: BoxFit.fill,
                width: 36,
                height: 40,
              ),
            ),
          ),
        )
      ],
    );
  }
}

/////////////// WIDGETS //////////////////////////////
class PlaceStaggeredGridview extends StatelessWidget {
  const PlaceStaggeredGridview({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: StaggeredGridView.countBuilder(
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        crossAxisCount: 4,
        itemCount: placeList.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        itemBuilder: (context, index) => PlaceItem(index),
      ),
    );
  }
}

class PlaceItem extends StatelessWidget {
  final int index;

  const PlaceItem(
      this.index, {
        Key key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailScreen(image: placeList[index].imageUrl,title: placeList[index].title, place: placeList[index].subtitle,);
            },
          ),
        );
      },
      child: Container(
        alignment: Alignment.bottomLeft,
        height: placeList[index].height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                placeList[index].imageUrl,
              ),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                placeList[index].title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                placeList[index].subtitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
            prefixIcon: Container(
              padding: EdgeInsets.all(12),
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 24,
                color: Colors.pinkAccent,
              ),
            ),
            border: InputBorder.none,
            hintText: 'Search here...'
        ),
      ),
    );
  }
}
