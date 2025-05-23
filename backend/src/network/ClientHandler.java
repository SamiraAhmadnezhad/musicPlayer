package network;

import controller.Controller;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.net.Socket;
import java.util.Scanner;

public class ClientHandler extends Thread{
    private Socket socket;
    public ClientHandler (Socket socket){
        this.socket=socket;
    }
    @Override
    public void run() {
        try {
            DataInputStream dis = new DataInputStream(socket.getInputStream());
            DataOutputStream dos = new DataOutputStream(socket.getOutputStream());
            StringBuilder request=new StringBuilder();
            int c=dis.read();
            while (c!=0){
                request.append((char) c);
                c=dis.read();
            }
            Scanner scan = new Scanner(request.toString());
            String command = scan.nextLine();
            System.out.println(command);
            String response =new Controller().run(command);
            dos.writeBytes(response);
            dos.flush();
            dos.close();
            dis.close();
            socket.close();
        } catch (Exception e) {
        }
    }
}
