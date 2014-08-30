part of presenter;

Keyframes transformFadeKeyframes(String transformStart, double opacityStart,
                                 {String transformEnd: 'none',
                                  double opacityEnd: 1.0,
                                  bool disableEvents: false}) {
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
  KeyframeSetter prepare = !disableEvents ? null : (Element e) {
    e.style.pointerEvents = 'none';
  };
  
  // generate a name that is somewhat unique to this animation but will be the
  // same every time
  String name = 'presenter-keyframes-transformfade-' +
      _escapeStr(transformStart) + '-' + _escapeStr(transformEnd) + '-' +
      _escapeNumber(opacityStart) + '-' + _escapeNumber(opacityEnd) + '-' +
      '$disableEvents';
  
  // generate the keyframes
  return new Keyframes(content, name, prepareBackward: prepare,
      prepareForward: prepare,
      doneForward: (Element e) {
        e.style.transform = transformEnd;
        e.style.opacity = '$opacityEnd';
        if (disableEvents) e.style.pointerEvents = 'auto';
      }, doneBackward: (Element e) {
        e.style.opacity = '$opacityStart';
        e.style.transform = transformStart;
        if (disableEvents) e.style.pointerEvents = 'none';
      });
}
