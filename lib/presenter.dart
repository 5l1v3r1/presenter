/**
 * A simple way to animate DOM elements in Dart.
 * 
 * Using presenter is super easy. Here's an example of how you could make an
 * element fade out:
 * 
 *     Element someElement = ...;
 *     Keyframes kf = propertyKeyframes('opacity', '1.0', '0.0');
 *     Animatable anim = new Animatable(someElement, kf);
 *     anim.run(true, duration: 1.0);
 * 
 */
library presenter;

import 'dart:async';
import 'dart:html';

part 'src/animatable.dart';
part 'src/escapes.dart';
part 'src/keyframes.dart';
part 'src/property_keyframes.dart';
part 'src/transform_fade_keyframes.dart';
