
import org.mindrot.jbcrypt.BCrypt;

public class HashGenerator {
    public static void main(String[] args) {
        String[] passwords = {"admin123", "manager123", "customer123"};
        for (String pwd : passwords) {
            System.out.println(pwd + " => " + BCrypt.hashpw(pwd, BCrypt.gensalt(10)));
        }
    }
}