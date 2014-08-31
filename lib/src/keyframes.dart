part of presenter;

/**
 * A function which acts on an element.
 */
typedef void KeyframeSetter(Element e);

/**
 * A CSS3 animation described by a CSS's "keyframes" feature.
 */
class Keyframes {
  /**
   * The CSS keyframes animation.
   */
  final String contents;
  
  /**
   * The keyframes name referenced by the CSS3 `animation` property.
   */
  final String name;
  
  /**
   * Call this before running the keyframes animation.
   */
  final KeyframeSetter prepareForward;
  
  /**
   * Call this before running the keyframes animation backwards.
   */
  final KeyframeSetter prepareBackward;
  
  /**
   * Call this to set the final CSS properties from this keyframes animation.
   */
  final KeyframeSetter doneForward;
  
  /**
   * Call this to set the initial CSS properties from this keyframes animation.
   */
  final KeyframeSetter doneBackward;
  
  void runPrepareForward(Element e) {
    if (prepareForward == null) return;
    prepareForward(e);
  }
  
  void runPrepareBackward(Element e) {
    if (prepareBackward == null) return;
    prepareBackward(e);
  }
  
  void runDoneForward(Element e) {
    if (doneForward == null) return;
    doneForward(e);
  }
  
  void runDoneBackward(Element e) {
    if (doneBackward == null) return;
    doneBackward(e);
  }
  
  /**
   * Returns the `id` attribute that the generated style tag will have.
   */
  String get styleId => '#presenter-animation-$name';
  
  /**
   * Create a new keyframes animation given its [contents] and [name]. You may
   * also specify the four state-setting functions.
   */
  Keyframes(this.contents, this.name, {this.prepareForward: null,
            this.prepareBackward: null, this.doneForward: null,
            this.doneBackward: null});
  
  /**
   * Generate a style element for this keyframes animation.
   */
  StyleElement toStyle() {
    StyleElement e = new StyleElement();
    e.text = '@-webkit-keyframes $name {\n$contents\n}\n@keyframes $name {\n' +
        '$contents\n}';
    e.id = styleId;
    return e;
  }
  
  /**
   * Add this keyframes animation to the DOM if it's not there already.
   */
  void addToDOM() {
    if (querySelector(styleId) != null) {
      return;
    }
    StyleElement e = toStyle();
    querySelector('head').append(e);
  }
  
  /**
   * Remove this keyframes animation from the DOM if it's there.
   */
  void removeFromDOM() {
    Element e = querySelector(styleId);
    if (e != null) e.remove();
  }
}
