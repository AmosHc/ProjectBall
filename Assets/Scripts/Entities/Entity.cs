using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Entity : MonoBehaviour
{
    private SceneUnit _unit;

    public SceneUnit Unit
    {
        get => _unit;
        set => _unit = value;
    }

    public virtual void Init(SceneUnit unit)
    {
        _unit = unit;
    }
    
    
}
