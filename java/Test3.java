public class Test3 {
	public static void main (String[] args){ 
		int score[] = {67,69,75,88};
		int temp;
		for (int i = 0; i < score.length; i++) {
			for (int j = i+1; j < score.length; j++) {
			if (score[i] < score[j]) {
				temp = score[i];
				score[i] = score[j];
				score[j] = temp;
				}
			}
		} for (int i = 0; i < score.length; i++) { 
			System.out.print(score[i]+"  "); 
		} 
	}
}
