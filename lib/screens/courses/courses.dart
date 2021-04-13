import 'package:esprit/screens/courses/addnewcoursescreen.dart';
import 'package:esprit/screens/courses/courseService.dart';
import 'package:esprit/screens/courses/coursesModel.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:esprit/CalendarAPI/dashboard_screen.dart';
import 'package:esprit/CalendarAPI/secrets.dart';
import 'package:esprit/CalendarAPI/utils/calendar_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:esprit/src/utils/my_urls.dart';
import 'alertdialog.dart';
import 'package:http/http.dart' as http;
import 'package:esprit/screens/courses/laststep.dart';
import 'package:esprit/screens/courses/coursesRoute.dart';
import 'package:esprit/Home/AppTheme/appthemeColors.dart';

class Coursespage extends StatefulWidget {
  @override
  CoursespageState createState() {
    return CoursespageState();
  }
}

class CoursespageState extends State<Coursespage>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  // ignore: unused_field
  List<CourseList> _courses;
  List<CourseList> _usercourses;
  List<CourseList> filteredUsers = List();

  bool _loading;
  String courseid;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    _loading = true;
    Services.getCourses().then((courses) {
      setState(() {
        _courses = courses;
        _loading = false;
      });
    });
    Services.getuserCourses().then((courses) {
      setState(() {
        _usercourses = courses;
        filteredUsers = _usercourses;
        _loading = false;
      });
    });
    super.initState();
  }

  void prompt(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<http.Response> deleteCourse() async {
    var url = '${MyUrls.serverUrl}/coursedelete/$courseid';
    var response = await http.get(url);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            _loading ? 'Loading...' : 'My Courses',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        //Init Floating Action Bubble
        body: Column(children: <Widget>[
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.all(15.0),
              hintText: 'Filter by Title or Description',
            ),
            onChanged: (string) {
              setState(() {
                filteredUsers = _usercourses
                    .where((u) =>
                        (u.title.toLowerCase().contains(string.toLowerCase()) ||
                            u.description
                                .toLowerCase()
                                .contains(string.toLowerCase())))
                    .toList();
              });
            },
          ),
          SizedBox(height: 30),
          Expanded(
              child: ListView.builder(
            itemCount: null == filteredUsers ? 0 : filteredUsers.length,
            itemBuilder: (context, index) {
              CourseList course = filteredUsers[index];

              return new Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: AppThemeColors.nearlyWhite,
                  elevation: 2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20),
                        ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(32.0),
                            child: Image.network(
                              '${MyUrls.serverUrl}/uploads/${course.imagepath}',
                              height: 100.0,
                              width: 100.0,
                            ),
                          ),
                          title: Text(
                            'Title: ${course.title}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Description: ${course.description}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Category: ${course.category}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Posted at: ${course.date} ${course.time}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        SizedBox(height: 15),

                        // ignore: deprecated_member_use
                        new ButtonTheme.bar(
                            // make buttons use the appropriate styles for cards
                            child: new ButtonBar(children: <Widget>[
                          new FlatButton(
                            child: const Text(
                              'Update',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            onPressed: () {/* ... */},
                          ),
                          new FlatButton(
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.red,
                              ),
                            ),
                            onPressed: () async {
                              courseid = course.id;
                              final action = await Dialogs.alertDialog(
                                  context,
                                  "Deleting Course",
                                  "You sure you can to continue deleting this course?",
                                  "Cancel",
                                  "Delete");
                              //cancel and save are the button text for cancel and save operation
                              if (action == alertDialogAction.save) {
                                deleteCourse();
                                ToastUtils.showCustomToast(
                                    context, "Course Successfully deleted");
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => CoursesScreen()));
                              }
                            },
                          )
                        ]))
                      ]));
            },
          )),
        ]),
        floatingActionButton: FloatingActionBubble(
          // Menu items
          items: <Bubble>[
            Bubble(
              title: "Add new course!",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.screen_share_rounded,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateNewCourseScreen()),
                );
                _animationController.reverse();
              },
            ),
            // Floating action menu item
            Bubble(
              title: "Schedule an Event",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.people_alt_rounded,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () async {
                await Firebase.initializeApp();
                var _clientID = new ClientId(Secret.ANDROID_CLIENT_ID, "");
                const _scopes = const [cal.CalendarApi.CalendarScope];
                await clientViaUserConsent(_clientID, _scopes, prompt)
                    .then((AuthClient client) async {
                  CalendarClient.calendar = cal.CalendarApi(client);
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              },
            ),
            //Floating action menu item
            Bubble(
              title: "Close",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.close_rounded,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
              },
            ),
          ],

          // animation controller
          animation: _animation,

          // On pressed change animation state
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),

          // Floating Action button Icon color
          iconColor: Colors.blue,

          // Flaoting Action button Icon
          iconData: Icons.ac_unit,
          backGroundColor: Colors.white,
        ));
  }
}
