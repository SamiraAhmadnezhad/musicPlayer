package controller;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;
import java.util.Scanner;

public class Controller {
    public  String run (String command) throws IOException {
        System.out.println("rec");
        switch (command){
            case "giveMusics":
                return giveMusics();
        }
        return "eshteb zadi!!!";
    }

    private String giveMusics() throws IOException {

        String musicFilePath = "D:\\Ap_TA\\fall 403\\musicplayer\\ReadyGo_back-update_0\\src\\music1.mp3";
        System.out.println("Processing 'giveMusics' request for file: " + musicFilePath);
        try {
            Path path = Paths.get(musicFilePath);
            byte[] fileContent = Files.readAllBytes(path);
            String base64EncodedString = Base64.getEncoder().encodeToString(fileContent);
            System.out.println("Successfully read and encoded file. Base64 string length: " + base64EncodedString.length());
            System.out.println(base64EncodedString);
            return base64EncodedString;
        } catch (IOException e) {
            System.err.println("Error reading music file: " + musicFilePath + " - " + e.getMessage());
            throw e;
        }
    }
}
