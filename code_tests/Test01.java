// you can also use imports, for example:
import java.util.*;

// you can write to stdout for debugging purposes, e.g.
// System.out.println("this is a debug message");

class Test01 {
  public static void main(String[] args) {
    Solution s = new Solution();
    int result = s.solution(
      new int[] { 40, 40, 100, 80, 20 },
      new int[] {  3,  3,   2,  2,  3 },
      3,
      5,
      200
    );
    System.out.println("TOTAL STOPS: " + result);
  }
}

class Solution {

    private LinkedList<Integer> people = new LinkedList<Integer>();

    /**
     * Build a suitable data structure with correlated weights and stops
     */

     private void buildPeopleSequence(int[] A) {
        for (int i = 0; i < A.length; i++) {
            people.addLast(new Integer(i));
        }
    }

    /**
     * Fill up the elevator with as many people as possible.
     */

    private int loadPeople(int[] A, LinkedList<Integer> loaded, int X, int Y) {
        int weight = 0;

        Iterator<Integer> idIterator = people.iterator();
        while (idIterator.hasNext() && loaded.size() <= X && weight < Y) {
            Integer nextId = (Integer) idIterator.next();
            int next_weight = weight + A[nextId];
            if (next_weight > Y) {
                break;
            }
            weight = next_weight;     // update weight
            loaded.push((Integer) nextId);
            idIterator.remove();
        }

        System.out.println("Loaded " + loaded.size() + " people, with weight = " + weight);

        return weight;
    }

    /**
     * Move up the elevator and check for desired stops, given the persons inside.
     */

    private int moveUpElevator(LinkedList<Integer> loaded, int[] B) {

        HashSet<Integer> stops = new HashSet<Integer>();

        for (int i = 0; i < loaded.size(); i++) {
          stops.add(B[loaded.get(i)]);
        }

        return stops.size();
    }

    /**
     * Load people and move up elevator computing required stops.
     */

    public int solution(int[] A, int[] B, int M, int X, int Y) {
        buildPeopleSequence(A);
        int total_stops = 0;

        while (people.size() > 0) {
            LinkedList<Integer> loaded = new LinkedList<Integer>();

            int weight = loadPeople(A, loaded, X, Y);
            total_stops += moveUpElevator(loaded, B);
            ++total_stops;
      }

        return total_stops;
    }
}
