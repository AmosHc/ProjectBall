using System;
using UnityEngine;

public class ControllerManager : MonoSingleton<ControllerManager>
{
    private int _agencyID;
    private int _lastAgencyID;
    private Agency _agencyComponent;

    public override void Create()
    {
        _agencyID = 0;
        _lastAgencyID = _agencyID;
    }

    private void Update()
    {
        bool mouseDown = Input.GetMouseButtonDown(0);
        bool onMouse = Input.GetMouseButton(0);
        bool mouseUp = Input.GetMouseButtonUp(0);
        if (mouseDown)
        {
            IsTouchAgency();
        }
        if (onMouse && _agencyID != _lastAgencyID)
        {
            _agencyComponent.OnDrag(_agencyID,Camera.main.ScreenToWorldPoint(Input.mousePosition));
        }

        if (mouseUp && _agencyID != _lastAgencyID)
        {
            _agencyComponent.OnEndDrag();
            _lastAgencyID = _agencyID;
        }
    }

    private void IsTouchAgency()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit2D hit = Physics2D.Raycast(new Vector2(ray.origin.x, ray.origin.y),new Vector2(ray.direction.x, ray.direction.y),
            int.MaxValue, 1 << LayerMask.NameToLayer("Agency"));
        if(hit.collider != null)
        {
            Transform agencyTrsf = hit.collider.transform;
            while (agencyTrsf.parent != null && agencyTrsf.parent.name != "-----SceneUnitPool-----")
            {
                agencyTrsf = agencyTrsf.parent;
            }

            _agencyComponent = agencyTrsf.GetComponent<Agency>();
            if (null != _agencyComponent)
            {
                _agencyID++;
                _agencyComponent.OnStartDrag(_agencyID,Camera.main.ScreenToWorldPoint(Input.mousePosition));
            }
        }
    }
}