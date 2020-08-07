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
        GameObject mainCamera = new GameObject("MainCamera");
        mainCamera.AddComponent<Camera>();
        mainCamera.tag = "MainCamera";
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

    private void Update()
    {
        //TODO
    }
}
