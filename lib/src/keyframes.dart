part of presenter;

typedef void KeyframeSetter(Element e);

class Keyframes {
  final String contents;
  final String name;
  
  final KeyframeSetter prepareForward;
  final KeyframeSetter prepareBackward;
  final KeyframeSetter doneForward;
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
    prepareForward(e);
  }
  
  void runDoneBackward(Element e) {
    if (doneBackward == null) return;
    prepareBackward(e);
  }
  
  String get styleId => '#presentor-animation-$name';
  
  Keyframes(this.contents, this.name, {this.prepareForward: null,
            this.prepareBackward: null, this.doneForward: null,
            this.doneBackward: null});
  
  StyleElement toStyle() {
    StyleElement e = new StyleElement();
    e.text = '@-webkit-keyframes $name {\n$contents\n}\n@keyframes $name {\n' +
        '$contents\n}';
    return e;
  }
  
  void addToDOM() {
    if (querySelector(styleId) != null) {
      return;
    }
    StyleElement e = toStyle();
    e.id = styleId;
    querySelector('head').append(e);
  }
  
  void removeFromDOM() {
    Element e = querySelector(styleId);
    if (e != null) e.remove();
  }
}
