// HW INTERFACE ///////////////////////////////////////////////////////////////////////////////////////////
class HWInterface {
  int lastSystemFrameCount = 0;
  int numHits = 0;

  HWInterface() {
    
  }
  
  void trigger(int systemFrameCount) {
    // println(numHits);
    
    if(systemFrameCount - lastSystemFrameCount < 5) {
        mainController.triggerAction(numHits);
        numHits++;
    }
    else {
      numHits = 1;
      mainController.triggerAction(numHits);
        
    }
    
    lastSystemFrameCount = systemFrameCount;
    
  }
}