using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(CircleImage),true)]
[CanEditMultipleObjects]
public class CircleImageEditor : UnityEditor.UI.ImageEditor
{
    private SerializedProperty _FillPercent;
    private SerializedProperty _Segments;
    protected override void OnEnable()
    {
        base.OnEnable();
        _FillPercent = serializedObject.FindProperty("fillPercent");
        _Segments = serializedObject.FindProperty("segments");
    }

    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        
        serializedObject.Update();
        EditorGUILayout.Slider(_FillPercent, 0, 1, new GUIContent("ShowPercent"));
        EditorGUILayout.PropertyField(_Segments);
        serializedObject.ApplyModifiedProperties();
        if (GUI.changed)
        {
            EditorUtility.SetDirty(target);
        }
    }
}
