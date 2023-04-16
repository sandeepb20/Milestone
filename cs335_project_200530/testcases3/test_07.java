// Write a program that generates a random password. The program should take user input for the desired length of the password, and use random number generation to generate a password consisting of upper and lowercase letters, numbers, and special characters.

import java.util.Random;
import java.util.Scanner;

public class RandomPasswordGenerator {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter password length: ");
        int length = scanner.nextInt();

        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+";

        StringBuilder password = new StringBuilder();

        Random random = new Random();

        for (int i = 0; i < length; i++) {
            password.append(characters.charAt(random.nextInt(characters.length())));
        }

        System.out.println("Generated password: " + password);
    }
}
