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
class XBeeInterface extends HWInterface {
  OscP5 oscP5;
  NetAddress myRemoteLocation;

  XBeeInterface {
    // all of your setup() stuff goes here
    oscP5 = new OscP5(this, 12000);
    myRemoteLocation = new NetAddress("127.0.0.1", 12000);
  }

  void oscEvent(OscMessage theOscMessage) {
    int firstValue = theOscMessage.get(0).intValue();
    int secondValue = theOscMessage.get(1).intValue();
    int thirdValue = theOscMessage.get(2).intValue();
    
    //this.trigger(frameCount);
  }
}
