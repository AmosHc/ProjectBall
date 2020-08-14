using table;
using UnityEngine;
using UnityEngine.EventSystems;

public class Agency : Entity
{
    private Vector3 _mouseOffset = Vector3.negativeInfinity;
    private int _dragID;
    private AgencysDefine _config;
    public override void Init(SceneUnit unit,EntityTemplateDefine config)
    {
        base.Init(unit,config);
        _config = GameConfigManager.GetInstance().GameConfig.GetAgencysByEntityId(config.EntityId);
    }
    
    public void OnStartDrag(int dragID, Vector3 mousePos)
    {
        mousePos.z = transform.position.z;
        _mouseOffset = transform.position - mousePos;
        _dragID = dragID;
    }

    public void OnDrag(int dragID, Vector3 mousePos)
    {
        if (_mouseOffset == Vector3.negativeInfinity || _dragID != dragID) 
            return;
        mousePos.z = transform.position.z;
        transform.position = mousePos + _mouseOffset;
    }

    public void OnEndDrag()
    {
        _mouseOffset = Vector3.negativeInfinity;
    }
}