import 'dart:typed_data';
import 'dart:math';

class SoundGenerator {
  static Uint8List generateBeepSound({
    int sampleRate = 44100,
    double frequency = 800.0,
    double duration = 0.1,
    double volume = 0.3,
  }) {
    final int numSamples = (sampleRate * duration).round();
    final Uint8List samples = Uint8List(numSamples * 2); // 16-bit samples
    
    for (int i = 0; i < numSamples; i++) {
      final double time = i / sampleRate;
      final double amplitude = sin(2 * pi * frequency * time) * volume;
      final int sample = (amplitude * 32767).round().clamp(-32768, 32767);
      
      // Convert to little-endian 16-bit
      samples[i * 2] = sample & 0xFF;
      samples[i * 2 + 1] = (sample >> 8) & 0xFF;
    }
    
    return samples;
  }
  
  static Uint8List generateClickSound() {
    return generateBeepSound(
      frequency: 1000.0,
      duration: 0.05,
      volume: 0.2,
    );
  }
}
