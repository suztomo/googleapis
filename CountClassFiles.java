import java.util.Enumeration;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
public class CountClassFiles {
  public static void main(String[] args) throws Exception {
    int jarFileCount = 1;
    int classFileCount = 0;
    for (String argument: args) {
      System.err.println("argument: " + argument);
      jarFileCount++;
      JarFile jarFile = new JarFile(argument);
      Enumeration<JarEntry> entries = jarFile.entries();
      while (entries.hasMoreElements()) {
        JarEntry entry = entries.nextElement();
        classFileCount++;
      }
    }
    System.out.println("JAR file count: " + jarFileCount);
    System.out.println("Class file count: " + classFileCount);
  }
}