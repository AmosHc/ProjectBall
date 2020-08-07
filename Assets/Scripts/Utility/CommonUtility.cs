namespace Utility
{
    public class CommonUtility
    {
        public static double Fmod(double x, double y)
        {
            return x - (int)(x / y) * y;
        }

    }
}