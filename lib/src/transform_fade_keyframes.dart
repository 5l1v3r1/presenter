part of presenter;

/**
 * Generate [Keyframes] that animate a change in the CSS3 transformation while
 * simultaneously changing the opacity of an element. This is useful for fancy
 * page load animations where an element slides in and fades in. 
 * 
 * Pass `true` for [disableEvents] to disable user interaction on the target
 * element before the animation has been completed. This is useful for fade-in
 * transitions.
 * 
 * Pass `true` for [hideOnZero] if you want to set `display: none` on the
 * affected element when its opacity reaches 0.
 */
Keyframes transformFadeKeyframes(String transformStart, double opacityStart,
                                 {String transformEnd: 'none',
                                  double opacityEnd: 1.0,
                                  bool disableEvents: false,
                                  bool hideOnZero: true}) {
  String content = """
from {
  -webkit-transform: $transformStart;
  transform: $transformStart;
  opacity: $opacityStart;
}
to {
  -webkit-transform: $transformEnd;
  transform: $transformEnd;
  opacity: $opacityEnd;
}
""";
  
  // prepare method based on whether to disable the pointer
  KeyframeSetter prepare = (Element e) {
    if (disableEvents) e.style.pointerEvents = 'none';
    if (hideOnZero) e.style.display = 'block';
  };
  
  KeyframeSetter doneSetter = (Element e) {
    e.style.transform = transformEnd;
    e.style.opacity = '$opacityEnd';
    if (hideOnZero && opacityEnd.abs() < 0.001) {
      e.style.display = 'none';
    }
    if (disableEvents) e.style.pointerEvents = 'auto';
  };
  
  KeyframeSetter startSetter = (Element e) {
    e.style.opacity = '$opacityStart';
    e.style.transform = transformStart;
    if (hideOnZero && opacityStart.abs() < 0.001) {
      e.style.display = 'none';
    }
    if (disableEvents) e.style.pointerEvents = 'none';
  };
  
  // generate a name that is somewhat unique to this animation but will be the
  // same every time
  String name = 'presenter-keyframes-transformfade-' +
      _escapeStr(transformStart) + '-' + _escapeStr(transformEnd) + '-' +
      _escapeNumber(opacityStart) + '-' + _escapeNumber(opacityEnd) + '-' +
      '$disableEvents';
  
  // generate the keyframes
  return new Keyframes(content, name,
      prepareBackward: (Element e) {
        doneSetter(e);
        prepare(e);
      },
      prepareForward: (Element e) {
        startSetter(e);
        prepare(e);
      },
      doneForward: doneSetter,
      doneBackward: startSetter);
}
