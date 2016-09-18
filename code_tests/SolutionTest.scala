import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable
import org.scalatest._
import scala.util.control.Breaks._

class SolutionTest extends FunSuite with BeforeAndAfter {

  var solution: Solution = _

  before {
    solution = new Solution
  }

  test("some new arguments are given") {
    val stops = solution.solution(
      List(40, 40, 100, 80, 20).toArray,
      List(3, 3, 2, 2, 3).toArray,
      3,
      5,
      200
    )
    assert(stops == 6)
  }

}

class Solution {

  def solution(A: Array[Int], B: Array[Int], M: Int, X: Int, Y: Int): Int = {

    var totalStops = 0
    val people = 0.until(A.length).toList.toBuffer

    while (people.size > 0) {
      var weight = 0
      var peopleUp = List[Int]().toBuffer

      for (i <- people if peopleUp.size < X && weight + A(i) < Y) {
        peopleUp += i
        weight += A(i)
      }
      people --= peopleUp

      val stops = mutable.HashMap[Int, String]().withDefaultValue("")
      for (i <- peopleUp) {
        stops(B(i)) = ""
      }
      totalStops += stops.size

      totalStops += 1
    }

    totalStops
  }
}
