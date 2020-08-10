using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainScript : MonoBehaviour
{
    private void Awake()
    {
        Application.runInBackground = true;
        Application.targetFrameRate = 30;
        InitMainCamera();
    }

    void Start()
    {
        StartGame();
    }

    private void StartGame()
    {
        GameManager.GetInstance().ManagerCreate();
        GameUIManager.GetInstance().OpenUI(UIConfig.Welcome);
    }

    private void InitMainCamera()
    {
        
        GameObject mainCameraObj = new GameObject("MainCamera");
        Camera mainCamera = mainCameraObj.AddComponent<Camera>();
        mainCamera.clearFlags = CameraClearFlags.SolidColor;
        mainCamera.backgroundColor = Color.grey;
        mainCameraObj.tag = "MainCamera";
        mainCameraObj.transform.position = Vector3.back * 10;
        mainCamera.orthographic = true;
        mainCamera.cullingMask = ~(1 << 5);
        mainCamera.depth = 0;

    }
    
    private void Update()
    {
        //TODO
    }
}
