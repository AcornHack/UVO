import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: PoliticsApp()));
}

class _NewsStory {
  final String title;
  final String description;
  final Color color;

  const _NewsStory({
    this.title,
    this.description,
    this.color,
  });
}

class _Messages {
  final String sender;
  final String content;

  _Messages({this.sender, this.content});
}

const kDuration = const Duration(milliseconds: 500);

final kStories = [
  _NewsStory(
    title: "Brexit",
    description:
        "If Parliament cannot resolve Brexit, a new referendum is needed",
    color: Colors.red[200],
  ),
  _NewsStory(
    title: "Education Reforms",
    description: "A Levels become linear instead of modular",
    color: Colors.green[200],
  ),
  _NewsStory(
    title: "Irish Backstop",
    description: "How this will affect the Irish youth",
    color: Colors.blue[200],
  ),
];

class PoliticsApp extends StatefulWidget {
  @override
  _PoliticsAppState createState() => _PoliticsAppState();
}

class _PoliticsAppState extends State<PoliticsApp>
    with SingleTickerProviderStateMixin {
  List<_NewsStory> stories;
  Set<String> selectedTitles;

  @override
  void initState() {
    super.initState();
    stories = List.from(kStories);
    selectedTitles = Set.from([stories[0].title]);
  }

  String _titleAfter(String title) {
    int i = kStories.indexWhere((test) => test.title == title);
    if (i < kStories.length - 1) {
      return kStories[i + 1].title;
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: stories.length > 0 ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                final story = stories[i];
                return AbsorbPointer(
                  absorbing: i > 0,
                  child: Dismissible(
                    background: Container(
                      child: Text("👍", style: theme.textTheme.display3,),
                      alignment: Alignment.centerLeft,
                      padding:EdgeInsets.all(32),
                      height: double.infinity,
                    ),
                    secondaryBackground: Container(
                      child: Text("👎", style: theme.textTheme.display3,),
                      alignment: Alignment.centerRight,
                      padding:EdgeInsets.all(32),
                      height: double.infinity,
                    ),
                    resizeDuration: kDuration,
                    key: Key(story.title),
                    onResize: () {
                      setState(() {
                        String nextTitle = _titleAfter(story.title);
                        if (nextTitle != null) {
                          selectedTitles.add(nextTitle);
                        }
                      });
                    },
                    onDismissed: (direction) {
                      setState(() {
                        return stories.removeAt(i);
                      });
                    },
                    child: AnimatedContainer(
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              selectedTitles.contains(story.title) ? 24.0 : 42.0),
                      duration: kDuration,
                      child: AnimatedOpacity(
                        duration: kDuration,
                        opacity: selectedTitles.contains(story.title) ? 1.0 : 0.5,
                        child: Card(
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              color: story.color,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return detailpage(
                                        story: story,
                                      );
                                    }));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          story.title,
                                          style: theme.textTheme.display1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, i) {
                return SizedBox(height: 16.0);
              },
              itemCount: stories.length,
            ),
          ) : Center(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.check, size: 100.0,color: Colors.green,),
              Text("Well done!",style: theme.textTheme.display2,),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("You're a good citizen!", style: theme.textTheme.display1.copyWith(fontSize: 24),),
              )
            ],
          ),),
        ),
      ),
    );
  }
}

class detailpage extends StatefulWidget {
  final _NewsStory story;

  const detailpage({Key key, this.story}) : super(key: key);

  @override
  _detailpageState createState() => _detailpageState();
}

class _detailpageState extends State<detailpage> {
  List<_Messages> list = [
    _Messages(sender: "Victoria", content: "I don't understand politics!"),
    _Messages(sender: "Sophie", content: "Who's the Prime Minister?")
  ];
  TextEditingController controller;
  FocusNode focusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            backgroundColor: widget.story.color,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.story.title),
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(widget.story.description,
                      style: theme.textTheme.display1.copyWith(fontSize: 24)))),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
              _Messages message = list[i];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      child: Text(message.sender[0]),
                      backgroundColor: widget.story.color,
                      foregroundColor: Colors.white,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      padding: EdgeInsets.all(16),
                      color: Colors.grey[300],
                      child: Text(message.content),
                    )
                  ],
                ),
              );
            }, childCount: list.length),
          ),
          SliverFillRemaining(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 16.0,
        color: Colors.grey[100],
        child: Container(
            margin: EdgeInsets.only(bottom: mq.viewInsets.bottom),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                )),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: widget.story.color,
                  ),
                  onPressed: () {
                    setState(() {
                      list.add(
                          _Messages(sender: "Laila", content: controller.text));
                      focusNode.unfocus();
                      controller.text = "";
                    });
                  },
                )
              ],
            )),
      ),
    );
  }
}
