// Class to manage the communication with the cube
// Frames are sended to the cube with 64 bytes, each byte represents a column, with one bit for each pixel of this column

class SerialComm extends PApplet{
  public Serial currentPort;
  public String portName;
  private boolean connected = false;  // Connection state
  private int[] sendBuffer = new int[64];

  public void SerialComm() {
  }
  public void connect(String port) {
    if(connected == true) {
      disconnect();
    }
    currentPort = new Serial(this, port, 115200);
    connected = true;
    portName = port;
    println("Waiting 2 seconds for the cube initialization ...");
    delay(2000);
    sendFrames();
  }
  public void disconnect() {
    if(connected == true) {
      currentPort.stop();
      connected = false;
    }
    portName = null;
  }
  public void sendFrames() {
    int n = 0;
    for(int i=0;i<=dim-1;i++){
      for(int j=0;j<=dim-1;j++){
        int toSend = 0;
        for(int k=0;k<=dim-1;k++){
          toSend = bitWrite(toSend, k, led_value[j][i][k]);
        }
        sendBuffer[n] = toSend;
        n++;
      }
    }
    for (int i = 0; i <= 63; ++i) {
      currentPort.write(toSignedByte(sendBuffer[i]));
    }
    /*for (int m = 0; m <= 63; ++m) {   // uncomment to see what is sended
      print(sendBuffer[m]);
      print(", ");
    }
    println(""); */
  }
  public boolean available() {
    return connected;
  }
  public String getPortName() {
    return portName;
  }
}