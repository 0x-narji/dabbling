/**
 * @author : _fede
 * @created : 2021-10-21
 */
import java.util.*;

public class S7 {
  public static void main(String[] args) {

    /* jsr-201 */
    for (String arg : args) {
      switch (arg) {
        case "foo", "bar", "baz":
          System.out.println("A common word: " + arg);
          break;
        default:
          System.out.println(arg);
      }
    }

    /* lambda */
    Arrays.asList(args).forEach(System.out::println);
  }
}
