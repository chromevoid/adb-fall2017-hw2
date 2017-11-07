import java.util.List;
import java.util.ArrayList;

/**
 * Created by chrome on 11/7/17.
 */

public class Fractal {
    public static void main(String[] args) {
        List<Integer> outvec1 = gen(0.5, 8);
        System.out.println(outvec1);
        List<Integer> outvec2 = gen(0.3, 70000);
        System.out.println(outvec2);
    }

    static public List<Integer> gen(double fractal, int N) {
        List<Integer> p = new ArrayList<Integer>();
        for (int i = 1; i <= N; i++) {
            p.add(i);
        }
        java.util.Collections.shuffle(p);
        List<Integer> outvec = p;
        while (p.size() > 1) {
            p = new ArrayList<Integer>(p.subList(0, (int)(fractal * p.size())));
            outvec.addAll(p);
        }
        java.util.Collections.shuffle(outvec);
        return outvec;
    }
}
