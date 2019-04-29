import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as h;
import 'package:stack/stack.dart';

main() async {
  var j = await h.get('https://bit.ly/2CZGCgM');
  var d = json.decode(j.body);
  List<Plan> plans = d
      .map<Plan>((v) => Plan(
          List<Map>.from(v.map((x) => Map.from(x))), 'Day ${d.indexOf(v) + 1}'))
      .toList();

  runApp(MyApp(plans));
}

class MyApp extends StatelessWidget {
  MyApp(this.plans);

  final List<Plan> plans;
  var white = Colors.white, grey = Colors.grey.shade400;

  @override
  build(BuildContext context) => MaterialApp(
        title: 'Widgets Guide',
        theme: ThemeData(
            dividerColor: Colors.transparent, fontFamily: 'GoogleSans'),
        home: StackView<Plan>(
            sList: [plans.first],
            tList: plans.sublist(1, plans.length),
            view: (c, source, target) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Stack(children: view(c, source, true))),
                    target.length == 0
                        ? SizedBox()
                        : Stack(
                            alignment: Alignment.bottomCenter,
                            children: view(c, target, false))
                  ]);
            }),
      );

  view(c, List<Delegate<Plan>> delegates, bool isSource) {
    return delegates.map<Widget>((i) {
      var widgets = i.message.widgets;
      return i.build(
          c,
          Material(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.grey.shade200)),
              shadowColor: Colors.black12,
              color: Colors.grey.shade50,
              child: Column(children: [
                Material(
                    elevation: 6.0,
                    borderRadius: BorderRadius.circular(20),
                    shadowColor: Colors.black26,
                    color: white,
                    child: Container(
                        alignment: Alignment.center,
                        height: 75,
                        child: ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 13),
                            leading: FlutterLogo(
                              size: 45,
                            ),
                            title: Text(i.message.day),
                            subtitle: Text('${widgets.length} Widgets')))),
                isSource
                    ? Expanded(
                        child: Stack(children: [
                        Positioned.fill(
                            child: Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(left: 48.5),
                                child: Container(color: grey, width: 3))),
                        ListView(
                            padding: EdgeInsets.only(bottom: 20, left: 22),
                            children: List.generate(widgets.length, (index) {
                              Map widget = widgets[index];
                              return ExpansionTile(
                                  initiallyExpanded: index == 0,
                                  title: Row(children: [
                                    Icon(Icons.adjust),
                                    SizedBox(width: 10),
                                    Text(widget['title'])
                                  ]),
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 50, right: 15),
                                        child: Column(children: [
                                          ListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.zero,
                                              title: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Text('Description')),
                                              subtitle: Text(widget['desc'])),
                                          Document(
                                              'AIzaSyDBDzMvT95Hevkvk3y_bdZk7vn4kNqlzIc',
                                              widget['url'],
                                              widget['type'])
                                        ]))
                                  ]);
                            }).toList())
                      ]))
                    : SizedBox()
              ])));
    }).toList();
  }
}

class Plan {
  List<Map> widgets;
  String day;

  Plan(this.widgets, this.day);
}
