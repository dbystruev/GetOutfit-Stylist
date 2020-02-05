import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        decoration: InputDecoration(
          filled: true,
          hintText: "Search for a user...",
          prefixIcon: Icon(
            Icons.account_box,
            size: 28,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => print('cleared'),
          ),
        ),
      ),
    );
  }

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      child: Center(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 70),
              child: SvgPicture.asset(
                'assets/images/search.svg',
                height: orientation == Orientation.portrait ? 300 : 200,
              ),
            ),
            Text(
              'Find Users',
              style: TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          shrinkWrap: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      body: buildNoContent(),
    );
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('UserResult'),
    );
  }
}
