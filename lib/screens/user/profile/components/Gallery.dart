import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Gallery extends StatefulWidget {

  Gallery({required this.uid});
  String uid;
  @override
  _GalleryState createState() => _GalleryState(uid: uid);
}

class _GalleryState extends State<Gallery> {

  OverlayEntry? _popupDialog;
  List<String>? imageUrls = [];
  String? uid;
  _GalleryState({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getimages(uid!),
    );
  }

  Widget _createGridTileWidget(String url) => Builder(
    builder: (context) => GestureDetector(
      onLongPress: () {
        _popupDialog = _createPopupDialog(url);
        Overlay.of(context)?.insert(_popupDialog!);
      },
      onLongPressEnd: (details) => _popupDialog!.remove(),
      child: Image.network(url, fit: BoxFit.cover),
    ),
  );

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(url),
      ),
    );
  }

  Widget _createPhotoTitle() => Container(
      width: double.infinity,
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage('https://placeimg.com/640/480/people'),
        ),
        title: Text(
          'john.doe',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ));

  Widget _createActionBar() => Container(
    padding: EdgeInsets.symmetric(vertical: 10.0),
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.favorite_border,
          color: Colors.black,
        ),
        Icon(
          Icons.chat_bubble_outline_outlined,
          color: Colors.black,
        ),
        Icon(
          Icons.send,
          color: Colors.black,
        ),
      ],
    ),
  );

  Widget _createPopupContent(String url) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _createPhotoTitle(),
          Image.network(url, fit: BoxFit.fitWidth),
          _createActionBar(),
        ],
      ),
    ),
  );

  getimages(String key) {
    imageUrls!.clear();
    var stream=FirebaseFirestore.instance.collection("Posts").where("uid",isEqualTo: key);
    return StreamBuilder(
        stream: stream.snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          snapshot.data!.docs.map((e) => {
            imageUrls!.add(e["url"]),
          });
         return GridView.count(
           crossAxisCount: 3,
           childAspectRatio: 1.0,
           children: imageUrls!.map(_createGridTileWidget).toList(),
         );
        }
    );

  }
}

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? opacityAnimation;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.easeOutExpo);
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: controller!, curve: Curves.easeOutExpo));

    controller!.addListener(() => setState(() {}));
    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacityAnimation!.value),
      child: Center(
        child: FadeTransition(
          opacity: scaleAnimation!,
          child: ScaleTransition(
            scale: scaleAnimation!,
            child: widget.child,
          ),
        ),
      ),
    );
  }


}