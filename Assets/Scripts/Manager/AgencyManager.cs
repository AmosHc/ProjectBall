using UnityEngine;

public class AgencyManager : MonoSingleton<AgencyManager>
{
    private int _agencyID;
    private int _lastAgencyID;
    private Agency _agencyComponent;
    public override void Create()
    {
        base.Create();
        _agencyID = 0;
        _lastAgencyID = _agencyID;
        
        EventManager.OnTouchBegin.Subscribe(OnTouchBegin);
        EventManager.OnTouchMove.Subscribe(OnTouchMove);
        EventManager.OnTouchEnd.Subscribe(OnTouchEnd);
    }

    private void OnTouchBegin(InputEvent evt)
    {
        if (evt.target != null)
        {
            Transform agencyTrsf = evt.target.transform;
            while (agencyTrsf.parent != null && agencyTrsf.parent.name != "-----SceneUnitPool-----")
            {
                agencyTrsf = agencyTrsf.parent;
            }

            _agencyComponent = agencyTrsf.GetComponent<Agency>();
            if (null != _agencyComponent)
            {
                _agencyID++;
                _agencyComponent.OnStartDrag(_agencyID,HitTestContext.worldPoint);
            }
        }
    }
    
    private void OnTouchMove(InputEvent evt)
    {
        if (_agencyID != _lastAgencyID)
        {
            _agencyComponent.OnDrag(_agencyID,Camera.main.ScreenToWorldPoint(Input.mousePosition));
        }
    }
    
    private void OnTouchEnd(InputEvent evt)
    {
        if (_agencyID != _lastAgencyID)
        {
            _agencyComponent.OnEndDrag();
            _lastAgencyID = _agencyID;
        }
    }
}