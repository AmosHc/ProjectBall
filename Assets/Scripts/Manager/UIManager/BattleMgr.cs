public class BattleMgr
{
    private BattleMgr _inst;

    public BattleMgr Inst
    {
        get
        {
            if(_inst == null)
                _inst = new BattleMgr();
            return _inst;
        }
    }
    
    private BattleMgr(){}
    
    
}