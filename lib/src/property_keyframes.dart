part of presenter;

/**
 * Generate [Keyframes] that animate a transition between two values of a CSS
 * [property]. The initial value is [start], the final value is [end].
 * 
 * Pass `true` for [disableEvents] to disable user interaction on the target
 * element before the animation has been completed. This is useful for fade-in
 * transitions.
 */
Keyframes propertyKeyframes(String property, String start, String end,
                            {bool disableEvents: false}) {
  String content = """
from {
  $property: $start;
}
to {
  $property: $end;
}
""";
  
  // prepare method based on whether to disable the pointer
  KeyframeSetter prepare = !disableEvents ? null : (Element e) {
    e.style.pointerEvents = 'none';
  };
  
  // generate a name that is somewhat unique to this animation but will be the
  // same every time
  String name = 'presenter-keyframes-property-' + _escapeStr(property) + '-' +
      _escapeStr(start) + '-' + _escapeStr(end);
  
  // generate the keyframes
  return new Keyframes(content, name,
      prepareBackward: (Element e) {
        if (prepare != null) prepare(e);
        e.style.setProperty(property, end);
      },
      prepareForward: (Element e) {
        if (prepare != null) prepare(e);
        e.style.setProperty(property, start);
      },
      doneForward: (Element e) {
        e.style.setProperty(property, end);
        if (disableEvents) e.style.pointerEvents = 'auto';
      }, doneBackward: (Element e) {
        e.style.setProperty(property, start);
        if (disableEvents) e.style.pointerEvents = 'none';
      });
}
