part of presenter;

class Animatable {
  final Element element;
  final Keyframes keyframes;
  
  bool _finished = null;
  Future _future = new Future.sync(() => null);
  
  Animatable(this.element, this.keyframes);
  
  Future run(bool forward, {num duration: 0}) {
    return _future = _future.then((_) {
      keyframes.addToDOM();
      if (forward == _finished) return null;
      if (forward) keyframes.runPrepareForward(element);
      else keyframes.runPrepareBackward(element);
      
      // apply short animations immediately
      if (duration.abs() < 0.001) {
        if (forward) keyframes.runDoneForward(element);
        else keyframes.runDoneBackward(element);
        return null;
      }
      
      // longer lasting animations use animation keyframes
      element.style.animation = keyframes.name;
      element.style.animationDuration = '${duration}s';
      element.style.animationDirection = forward ? 'normal' : 'reverse';
      element.style.animationFillMode = 'forwards';
      return Window.animationEndEvent.forElement(element).first.then((_) {
        if (forward) keyframes.runDoneForward(element);
        else keyframes.runDoneBackward(element);
        element.style.animation = '';
      });
    });
  }
}
