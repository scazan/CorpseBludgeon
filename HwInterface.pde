// HW INTERFACE ///////////////////////////////////////////////////////////////////////////////////////////
class HWInterface {
  int lastSystemFrameCount = 0;
  int numClicks = 0;

  HWInterface() {
    
  }
  
  void trigger(int systemFrameCount) {
    // println(numClicks);
    
    if(systemFrameCount - lastSystemFrameCount < 5) {
        mainController.triggerAction(numClicks);
        numClicks++;
    }
    else {
      numClicks = 1;
      mainController.triggerAction(numClicks);
        
    }
    
    lastSystemFrameCount = systemFrameCount;
    
  }
}