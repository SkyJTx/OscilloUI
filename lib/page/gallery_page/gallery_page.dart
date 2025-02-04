import 'package:fluent_ui/fluent_ui.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => GalleryPageState();
}

class GalleryPageState extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Gallery Page'),
    );
  }
}
