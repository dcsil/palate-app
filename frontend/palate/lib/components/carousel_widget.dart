import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'carousel_model.dart';
export 'carousel_model.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({
    super.key,
    required this.images,
  });

  final List<String>? images;

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  late CarouselModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CarouselModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final imagePathChildren = widget!.images!.toList();

        return Container(
          width: double.infinity,
          height: double.infinity,
          child: PageView.builder(
            controller: _model.pageViewController ??= PageController(
                initialPage: max(0, min(0, imagePathChildren.length - 1))),
            scrollDirection: Axis.horizontal,
            itemCount: imagePathChildren.length,
            itemBuilder: (context, imagePathChildrenIndex) {
              final imagePathChildrenItem =
                  imagePathChildren[imagePathChildrenIndex];
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imagePathChildrenItem,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
