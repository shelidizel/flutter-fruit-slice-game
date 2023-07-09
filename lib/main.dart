import 'package:flutter/material.dart';

import 'model/touch_slice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  TouchSlice? touchSlice;

  

  _setNewSlice(details){
    touchSlice = TouchSlice(pointsList: <Offset>[details.localFocalPoint]);
  }

  _addPointToSlice(details) {
    if(touchSlice == null || touchSlice!.pointsList.isEmpty){
      return;
    }
    if(touchSlice!.pointsList.length > 16) {
      touchSlice!.pointsList.removeAt(0);
    }

    touchSlice!.pointsList.add(details.localFocalPoint);
  }

  @override
  Widget build(BuildContext context) {
    Widget _getSlice () {
    if(touchSlice == null){
      return const SizedBox();
    }

    return CustomPaint(
      painter : SlicePainter(
        pointsList : touchSlice!.pointsList
      )
    );
  }
  Widget _getGestureDetector () {
    return GestureDetector (
      onScaleStart : (details) {
        setState(() {
          _setNewSlice(details);
        });
      },
      onScaleUpdate : (details) {
        setState(() {
          _addPointToSlice(details);
        });
      },
      onScaleEnd : (details) {
        touchSlice = null;
      }
    );
  }

  List<Widget> getStackWidgets() {

    List<Widget> widgetsOnStack = [];

    widgetsOnStack.add(_getSlice());
    widgetsOnStack.add(_getGestureDetector());

    return widgetsOnStack;
  }
    return Stack(
      children: getStackWidgets(),
    );
  }

   

  

  

}



class SlicePainter extends CustomPainter {

  SlicePainter({required this.pointsList});

  List<Offset> pointsList = [];
  final Paint paintObject = Paint();
  
  @override
  void paint(Canvas canvas, Size size) {
    _drawPath(canvas);
  }
  

  void _drawPath(Canvas canvas) {

    Path path = Path();

    paintObject..color = Colors.white
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke;

    if(pointsList!.length < 2){
      return;
    }

    path.moveTo(pointsList![0].dx, pointsList![0].dy);

    for(int i = 0; i < pointsList!.length; i++){
       if(pointsList.isEmpty){
        continue;
       }

       path.lineTo(pointsList![i].dx, pointsList![i].dy);

       canvas.drawPath(path, paintObject);
    }


    
  }
  @override
  bool shouldRepaint(SlicePainter oldDelegate) {
    return true;
  }


}

