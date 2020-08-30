import 'dart:typed_data';

class BitConverter {
  static List<int> getBytesUint16(int int16) {
    const int SIZE = 2;

    ByteData data = ByteData(SIZE);
    data.setUint16(0, int16);

    List<int> out = <int>[];
    for(int i = SIZE - 1; i >= 0; i--) {
      out.add(data.getUint8(i));
    }
    return out;
  }

  static int getUint16(List<int> bytes, {int offset = 0}) {
    const int SIZE = 2;

    ByteData data = ByteData(SIZE);
    for(int i = 0; i < SIZE; i++) {
      data.setUint8((SIZE - 1) - i, bytes[offset + i]);
    }

    return data.getUint16(0);
  }
}