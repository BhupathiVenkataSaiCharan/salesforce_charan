@isTest
public class MathOperationsTest {

    // test for addition of positive numbers
    @isTest
    static void positiveAdd(){
        Integer num1 = 5;
        Integer num2 = 3;
        Integer actualAddition = MathOperations.addNum(num1,num2);

        system.assertEquals(8, actualAddition, 'Addition is incorrect');
    }
    
    //test for subtraction of positive numbers
    @isTest
    static void positiveSub(){
        Integer num1 = 10;
        Integer num2 = 5;
        Integer actualSubtraction = MathOperations.subNum(num1,num2);
        
        system.assertEquals(5,actualSubtraction, 'Subtraction is incorrect');
    }
}