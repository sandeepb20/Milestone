//Java Program to demonstrate the use of If else-if ladder.  
//It is a program of grading system for fail, D grade, C grade, B grade, A grade and A+.  

public class IfElseIfExample { 
    char h; 
public static void main(String[] args) {  
    int marks=65;  
      
    if(marks<50){  
        char a;
        System.out.println("fail");  
    }  
    else if(marks>=50 && marks<60){  
        char b;
        System.out.println("D grade");  
    }  
    else if(marks>=60 && marks<70){  
        char c;
        System.out.println("C grade");  
    }  
    else if(marks>=70 && marks<80){  
        char d;
        System.out.println("B grade");  
    }  
    else if(marks>=80 && marks<90){  
        char e;
        System.out.println("A grade");  
    }else if(marks>=90 && marks<100){
        char f;  
        System.out.println("A+ grade");  
    }else{  
        char g = h;
        System.out.println("Invalid!");  
    } 
    h = g;
}  
}  