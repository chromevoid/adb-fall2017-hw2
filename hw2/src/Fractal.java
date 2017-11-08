import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Created by chrome on 11/7/17.
 */

public class Fractal {
    public static void main(String[] args) {
        List<Integer> outvec_test = gen(0.5, 8);
        System.out.println(outvec_test);

        List<Integer> outvec = gen(0.3, 70002);

        int stock_symbol = outvec.get(ThreadLocalRandom.current().nextInt(outvec.size()));
        int last_stock_symbol = stock_symbol;

        // symbol_price_table is used to track the last price of a symbol
        HashMap<Integer,Integer> symbol_price_table = new HashMap<Integer,Integer>();
        // init the symbol_price_table with random number in the range (50, 500)
        for (int i = 1; i <= 70002; i++) {
            symbol_price_table.put(i, ThreadLocalRandom.current().nextInt(50,  501));
        }

        for (int time = 1; time <= 10000000; time++) {
            // make sure that different symbols are interleaved
            while (stock_symbol == last_stock_symbol) {
                stock_symbol = outvec.get(ThreadLocalRandom.current().nextInt(outvec.size())); // range outvec
            }
            last_stock_symbol = stock_symbol;

            int quantity = ThreadLocalRandom.current().nextInt(100, 10001); // range [100, 10000]

            // make sure that price of the same symbol is increased or decreased in range (1, 5)
            // also price should be in range (50, 500)
            int pre_price = symbol_price_table.get(stock_symbol);
            int price = 0;
            while (price < 50 || price > 500) {
                int random = ThreadLocalRandom.current().nextInt(1,  6); // range [1, 5]
                int sign = ThreadLocalRandom.current().nextInt(2) == 0 ? 1 : -1; // range [0, 1]
                price = pre_price + sign * random;
            }
            symbol_price_table.put(stock_symbol, price);
            String result = Integer.toString(stock_symbol) + "," + Integer.toString(time) + "," +
                    Integer.toString(quantity) + "," + Integer.toString(pre_price) +"\n";
            try {
                whenAppendStringUsingBufferedWritter_thenOldContentShouldExistToo(result);
            }
            catch (IOException ex) {
                System.out.println("Error");
            }
            System.out.println(time);
//            System.out.println(Integer.toString(stock_symbol) + "," +
//                    Integer.toString(time) + "," + Integer.toString(quantity) + "," + Integer.toString(pre_price) +"\n");
        }

    }

    static public void whenAppendStringUsingBufferedWritter_thenOldContentShouldExistToo(String str)
            throws IOException {
        BufferedWriter writer = new BufferedWriter(new FileWriter("trade.txt", true));
        writer.append(str);
        writer.close();
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
