// HW INTERFACE ///////////////////////////////////////////////////////////////////////////////////////////
class HWInterface {
  int lastSystemFrameCount = 0;
  int comboThreshold = 12;
  int numHits = 0;

  HWInterface() {
  }

  void trigger(int systemFrameCount) {

    // SGC: Only qualify a number of hits that occurred within a specificied (comboThreshold) period (in frames)
    // as being a "combo"
    if (systemFrameCount - lastSystemFrameCount < comboThreshold) {
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
  int prevValue = 500;

  XBeeInterface() {
    // all of your setup() stuff goes here
    oscP5 = new OscP5(root, 12000);
    myRemoteLocation = new NetAddress("127.0.0.1", 12000);
  }

  public void oscEvent(OscMessage theOscMessage) {
    int firstValue = theOscMessage.get(0).intValue();
    int secondValue = theOscMessage.get(1).intValue();
    int thirdValue = theOscMessage.get(2).intValue();
    
    //println( "port 1 is " + str(firstValue) + " port 2 is " + str(secondValue) + " port 3 is " + str(thirdValue) );
    println("firstValue: " + firstValue);    
    if ( ( firstValue - prevValue ) >= 75 && firstValue > 550 ) {
      println( "DIFF: " + str( firstValue - prevValue ) + " >> " + firstValue + ", " + prevValue);
      this.trigger(frameCount);
      //      this.trigger(frameCount);
      println( "A HIT!!!!!!" );
    }
    prevValue = firstValue;
  }
}

