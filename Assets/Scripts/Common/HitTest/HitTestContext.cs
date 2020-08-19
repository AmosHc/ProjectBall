using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HitTestContext
{
    //set before hit test
    public static Vector2 screenPoint;
    public static Vector3 worldPoint;
    public static Vector3 direction;
    public static Camera camera;
    public static int displayIndex;

    public static int layerMask = -1;
    public static float maxDistance = Mathf.Infinity;

    public static Camera cachedMainCamera;

    static Dictionary<Camera, RaycastHit2D?> raycastHits = new Dictionary<Camera, RaycastHit2D?>();

    /// <summary>
    /// 
    /// </summary>
    /// <param name="camera"></param>
    /// <param name="hit"></param>
    /// <returns></returns>
    public static bool GetRaycastHitFromCache(Camera camera, out RaycastHit2D hit)
    {
        RaycastHit2D? hitRef;
        if (!raycastHits.TryGetValue(camera, out hitRef))
        {
            Ray ray = camera.ScreenPointToRay(HitTestContext.screenPoint);
            hit = Physics2D.Raycast(ray.origin, ray.direction, maxDistance, layerMask);
            if (hit)
            {
                raycastHits[camera] = hit;
                return true;
            }
            else
            {
                raycastHits[camera] = null;
                return false;
            }
        }
        else if (hitRef == null)
        {
            hit = new RaycastHit2D();
            return false;
        }
        else
        {
            hit = (RaycastHit2D)hitRef;
            return true;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="camera"></param>
    /// <param name="hit"></param>
    public static void CacheRaycastHit(Camera camera, ref RaycastHit2D hit)
    {
        raycastHits[camera] = hit;
    }

    /// <summary>
    /// 
    /// </summary>
    public static void ClearRaycastHitCache()
    {
        raycastHits.Clear();
    }

    public static bool HitTest(out RaycastHit2D hit)
    {
        Ray ray = camera.ScreenPointToRay(HitTestContext.screenPoint);
        hit = Physics2D.Raycast(ray.origin, ray.direction, maxDistance, layerMask);
        if (hit)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}
