using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

public class CustomImageEditor : MonoBehaviour
{
    private const int UI_LAYER = 5;

    [MenuItem(("GameObject/UI/CustomImage"))]
    private static void AddImage()
    {
        Transform canvasTrans = GetCanvasTrans();
        Transform image = AddCustomImage();
        if (Selection.activeGameObject != null && Selection.activeGameObject.layer == UI_LAYER)
        {
            image.SetParent(Selection.activeGameObject.transform);
        }
        else
        {
            image.SetParent(canvasTrans);
        }

        image.localPosition = Vector3.zero;
    }

    private static Transform AddCustomImage()
    {
        GameObject img = new GameObject("Image");
        SetLayer(img);
        img.AddComponent<RectTransform>();
        img.AddComponent<PolygonCollider2D>();
        img.AddComponent<CustomImage>();
        return img.transform;
    }
    
    private static Transform GetCanvasTrans()
    {
        Canvas canvas = GameObject.FindObjectOfType<Canvas>();
        if (canvas == null)
        {
            GameObject canvasObj = new GameObject("Canvas");
            SetLayer(canvasObj);
            canvasObj.AddComponent<RectTransform>();
            canvasObj.AddComponent<Canvas>().renderMode = RenderMode.ScreenSpaceOverlay;
            canvasObj.AddComponent<CanvasScaler>();
            canvasObj.AddComponent<GraphicRaycaster>();
            return canvas.transform;
        }
        else
        {
            return canvas.transform;
        }
    }

    private static void SetLayer(GameObject ui)
    {
        ui.layer = UI_LAYER;
    }
}
