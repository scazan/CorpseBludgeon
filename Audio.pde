//Audio
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

// SOUND ///////////////////////////////////////////////////////////////////////////////////////////
class AudioCollection {
  Minim minim;
  AudioSource[] samples;
  boolean loop;
  
  AudioCollection(String sampleArray[], boolean looping) {
    minim = new  Minim ( root );
    loop = looping;

    if(loop) {
      samples = new AudioPlayer[sampleArray.length];  
    } else {
      samples = new AudioSample[sampleArray.length];
    }

    if(loop) {
      for(int i=0;i<sampleArray.length;i++){
        samples[i] = minim.loadFile(sketchPath + "/data/sound/" + sampleArray[i] );
      }
    } else {
      for(int i=0;i<sampleArray.length;i++){
        samples[i] = minim.loadSample(sketchPath + "/data/sound/" + sampleArray[i] );
      }
    }
  }

  void play(int sampleNumber, boolean loop) {
    // if(player != null) {
    //   player.close();
    // }
    if(loop) {
      // ((AudioPlayer)samples[sampleNumber]).loop();
    } else {
      // ((AudioSample)samples[sampleNumber]).trigger();  
    }
    
  }

  void stop() {
    for(int i=0; i<samples.length; i++) {
      // (AudioSample)samples[i].close();

      if(loop) {
        ((AudioPlayer)samples[i]).close();
      } else {
        ((AudioSample)samples[i]).close();
      }
    }
    samples = null;

    minim.stop();
    minim = null;
  }

  void destroy() {
    this.stop();
    
    // minim.stop();
    // samples = null;
    // minim = null;
  }
}
