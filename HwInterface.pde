// HW INTERFACE ///////////////////////////////////////////////////////////////////////////////////////////
class HWInterface {
  int lastSystemFrameCount = 0;
  int comboThreshold = 5;
  int numHits = 0;

  HWInterface() {
    
  }
  
  void trigger(int systemFrameCount) {
    
    // SGC: Only qualify a number of hits that occurred within a specificied (comboThreshold) period (in frames)
    // as being a "combo"
    if(systemFrameCount - lastSystemFrameCount < comboThreshold) {
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


//HARDWARE CODE should extend HWInterface. 
// Should ultimately call the inherited trigger() method of itself whenever a hit occurs.