import 'package:flutter/material.dart';
import 'stories_bloc.dart';
export 'stories_bloc.dart';

// InheritedWidget allows us to reach to the StoriesProvider from anywhere in the heirarchy
class StoriesProvider extends InheritedWidget {
  // -- Boilerplate
  final StoriesBloc bloc;

  StoriesProvider({Key key, Widget child})
      : bloc = StoriesBloc(),
        super(key: key, child: child);
  // Whether the framework should notify widgets that inherit from this widget.
  @override
  bool updateShouldNotify(_) => true;

  static StoriesBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<StoriesProvider>()).bloc;
  }
  // Boilerplate --
}
