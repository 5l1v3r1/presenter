part of presenter;

/**
 * Run a set of [Keyframes] on an element.
 */
class Animatable {
  /**
   * The element this object applies to.
   */
  final Element element;
  
  /**
   * The keyframes used to animate the element.
   */
  final Keyframes keyframes;
  
  bool _finished = null;
  Future _future = new Future.sync(() => null);
  
  /**
   * Create an [Animatable] acting on an [element] using [keyframes].
   */
  Animatable(this.element, this.keyframes);
  
  /**
   * Run the animation.
   * 
   * If [forward] is true, the animation will be run in forwards order.
   * Otherwise, it will go backwards.
   * 
   * The [duration] property indicates how long the animation will take to run.
   * If [duration] is 0, the animation will take effect immediately.
   * 
   * The [delay] property specifies an amount of time to wait before the
   * animation begins.
   * 
   * The [timingFunction] is the value passed to the CSS3
   * `animation-timing-function` property.
   * 
   * The returned [Future] completes when the animation has completed. If you
   * call [run] before the previous animation is completed, the new animation
   * will only begin once all other queued animations are completed.
   */
  Future run(bool forward, {num duration: 0, num delay: 0,
             String timingFunction: 'ease'}) {
    return _future = _future.then((_) {
      if (delay != 0) {
        Duration duration = new Duration(milliseconds: (delay * 1000).round());
        return new Future.delayed(duration);
      } else {
        return null;
      }
    }).then((_) {
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
      element.style.animationTimingFunction = timingFunction;
      
      var listener;
      listener = (_) {
        element.removeEventListener('onanimationend', listener);
        if (forward) keyframes.runDoneForward(element);
        else keyframes.runDoneBackward(element);
        element.style.animation = '';
      };
      element.addEventListener('onanimationend', listener);
    });
  }
}
