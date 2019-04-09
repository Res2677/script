public class Test4 {
	public static void main (String []args){
		
		System.out.println(hape(99));
	}
	public static int hape (int n){
		int temp = 0;
		for (int i=1;i <= n;i++){
			temp = temp + i;
		}
		return temp;
	}
}
