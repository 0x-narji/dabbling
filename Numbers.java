
public class Numbers {
	
	public static class Statistics {
		
		private int sum = 0;
		private int rowSum = 0;
		private int count = 0;
		
		public void addOne(int x) {
			sum += x;
			rowSum += x;
			count++;
		}
		
		public void resetRow() {
			rowSum = 0;
		}
		
		public int getSum() {
			return sum;
		}
		
		public int getRowSum() {
			return rowSum;
		}
		
		public int getCount() {
			return count;
		}
		
		public double getAverage() {
			return 1. * sum / count;
		}
	}
	
	public static void main(String args[]) {
		
		int[][] numbers = {
	  		{ 0x00, 0x01, 0x02,  0x03, 0x10, 0x19 },
			{ 0x04, 0x05, 0x06, 0x07, 0x11, 0x1A },
			{ 0x08, 0x09, 0x0A, 0x0B, 0x12, 0x1B },
			{ 0x0C, 0x0D, 0x0E, 0x0F, 0x13, 0x1C },
			{ 0x14, 0x15, 0x16, 0x17, 0x18, 0x1D },
		};
		
		Statistics stats = new Statistics();
	
		for (int[] row : numbers) 
		{
			for (int j : row) {
				System.out.printf("%5d", j);
				stats.addOne(j);
			}

			System.out.printf("\t\t%d\t\t%d\n", stats.getRowSum(), stats.getSum());
			stats.resetRow();
		}
		
		System.out.printf("\n\navg: %.2f\n", stats.getAverage());
	}
}
