using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(RadarChart),true)]
[CanEditMultipleObjects]
public class RadarChartEditor : UnityEditor.UI.ImageEditor
{
    private SerializedProperty _pointCount;
    private SerializedProperty _initRadius;
    private SerializedProperty _pointSprite;
    private SerializedProperty _pointColor;
    private SerializedProperty _pointSize;
    private SerializedProperty _pointsHandlerRatios;
    protected override void OnEnable()
    {
        base.OnEnable();
        _pointCount = serializedObject.FindProperty("_pointCount");
        _initRadius = serializedObject.FindProperty("_initRadius");
        _pointSprite = serializedObject.FindProperty("_pointSprite");
        _pointColor = serializedObject.FindProperty("_pointColor");
        _pointSize = serializedObject.FindProperty("_pointSize");
        _pointsHandlerRatios = serializedObject.FindProperty("_pointsHandlerRatios");
    }

    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        
        serializedObject.Update();
        EditorGUILayout.PropertyField(_pointCount);
        EditorGUILayout.PropertyField(_initRadius);
        EditorGUILayout.PropertyField(_pointSprite);
        EditorGUILayout.PropertyField(_pointColor);
        EditorGUILayout.PropertyField(_pointSize);
        EditorGUILayout.PropertyField(_pointsHandlerRatios);
        
        RadarChart radar = target as RadarChart;
        if (target != null)
        {
            if (GUILayout.Button("生成雷达图"))
            {
                radar.InitPoints();
            }
            if (GUILayout.Button("生成内部可操作性顶点"))
            {
                radar.InitHandlers();
            }
        }
        
        serializedObject.ApplyModifiedProperties();
        if (GUI.changed)
        {
            EditorUtility.SetDirty(target);
        }
    }
}
