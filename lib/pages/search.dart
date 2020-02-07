import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getoutfit_stylist/controllers/firebase.dart';
import 'package:getoutfit_stylist/models/user.dart';
import 'package:getoutfit_stylist/widgets/progress.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      body:
          searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
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

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          filled: true,
          hintText: "Search for a user...",
          prefixIcon: Icon(
            Icons.account_box,
            size: 28,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: clearSearch,
          ),
        ),
        onChanged: handleSearch,
      ),
    );
  }

  Widget buildSearchResults() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress(context);
        }
        List<UserResult> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          final User user = User.fromDocument(doc);
          final UserResult searchResult = UserResult(user);
          searchResults.add(searchResult);
        });
        return ListView(children: searchResults);
      },
      future: searchResultsFuture,
    );
  }

  void clearSearch() {
    searchController.clear();
    setState(() => searchResultsFuture = null);
  }

  void handleSearch(String query) {
    final String queryLowercase = query.trim().toLowerCase();
    if (queryLowercase.isEmpty) {
      setState(() => searchResultsFuture = null);
      return;
    }
    Future<QuerySnapshot> users = usersRef
        .where(
          'displayNameLowercase',
          isGreaterThanOrEqualTo: queryLowercase,
        )
        .where(
          'displayNameLowercase',
          isLessThan: queryLowercase + '~',
        )
        .getDocuments();
    setState(() {
      searchResultsFuture = users;
    });
  }
}

class UserResult extends StatelessWidget {
  final User user;

  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(children: <Widget>[
        GestureDetector(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            ),
            subtitle: Text(
              user.username,
              style: TextStyle(color: Colors.white),
            ),
            title: Text(
              user.displayName,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          onTap: () => print('${user.displayName} (${user.username}) tapped'),
        ),
        Divider(
          color: Colors.white54,
          height: 2,
        ),
      ]),
    );
  }
}
