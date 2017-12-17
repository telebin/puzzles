package test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class Adv17b {

   public static void main(String[] args) throws IOException {
      long start = System.currentTimeMillis();
      int steps = Integer.parseInt(Files.readAllLines(
            Paths.get("C:\\Users\\Adrian\\RubymineProjects\\psychic-bear\\AoC2017\\inputs\\day17.txt")).get(0));
      int pos = 0;
      int len = 1;
      int onPos1 = 0;
      for (int i = 1; i < 50_000_000; ++i)
         if ((pos = (pos + steps) % len++ + 1) == 1)
            onPos1 = i;
      System.out.println(onPos1);
      System.out.println("time = " + (System.currentTimeMillis() - start));
   }
}
