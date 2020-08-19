using System;
using System.Collections.Generic;
using UnityEngine;

public class ControllerManager : MonoSingleton<ControllerManager>
{
    
    private int _frameGotHitTarget;
    
    GameObject _touchTarget;
    GameObject _focused;
    TouchInfo[] _touches;
    private int _touchCount;
    private Vector2 _touchPosition;
    private int _frameGotTouchPosition;


    static bool _touchScreen;
    /// <summary>
    /// 如果是true，表示触摸输入，将使用Input.GetTouch接口读取触摸屏输入。
    /// 如果是false，表示使用鼠标输入，将使用Input.GetMouseButtonXXX接口读取鼠标输入。
    /// 一般来说，不需要设置，底层会自动根据系统环境设置正确的值。
    /// </summary>
    public static bool touchScreen
    {
        get
        {
            return _touchScreen;
        }
        set
        {
            _touchScreen = value;
        }
    }
    
    public override void Create()
    {
        _frameGotHitTarget = -1;

        _touches = new TouchInfo[5];
        for (int i = 0; i < _touches.Length; i++)
	        _touches[i] = new TouchInfo();
        if (Application.platform == RuntimePlatform.WindowsPlayer
            || Application.platform == RuntimePlatform.WindowsEditor
            || Application.platform == RuntimePlatform.OSXPlayer
            || Application.platform == RuntimePlatform.OSXEditor)
            touchScreen = false;
        else
            touchScreen = Input.touchSupported && SystemInfo.deviceType != DeviceType.Desktop;
    }

    private void Update()
    {
        HandleEvents();
    }
    
    public int touchCount
    {
	    get { return _touchCount; }
    }

    public int[] GetAllTouch(int[] result)
    {
	    if (result == null)
		    result = new int[_touchCount];
	    int i = 0;
	    for (int j = 0; j < 5; j++)
	    {
		    TouchInfo touch = _touches[j];
		    if (touch.touchId != -1)
		    {
			    result[i++] = touch.touchId;
			    if (i >= result.Length)
				    break;
		    }
	    }
	    return result;
    }
    
    void HandleEvents()
    {
        GetHitTarget();
        UpdateTouchPosition();

        if (touchScreen)
            HandleTouchEvents();
        else
            HandleMouseEvents();
    }
    
    void UpdateTouchPosition()
    {
	    if (_frameGotTouchPosition != Time.frameCount)
	    {
		    _frameGotTouchPosition = Time.frameCount;
		    if (touchScreen)
		    {
			    for (int i = 0; i < Input.touchCount; ++i)
			    {
				    Touch uTouch = Input.GetTouch(i);
				    _touchPosition = uTouch.position;
			    }
		    }
		    else
		    {
			    Vector2 pos = Input.mousePosition;
			    if (pos.x >= 0 && pos.y >= 0) //编辑器环境下坐标有时是负
			    {
				    _touchPosition = pos;
			    }
		    }
	    }
    }
    
    public GameObject HitTest(Vector2 stagePoint)
    {
	    if (Camera.main == null)
	    {
		    return null;
	    }

	    HitTestContext.screenPoint = new Vector2(stagePoint.x, stagePoint.y);
	    HitTestContext.worldPoint = Camera.main.ScreenToWorldPoint(HitTestContext.screenPoint);
	    HitTestContext.direction = Vector3.back;
	    HitTestContext.camera = Camera.main;

	    GameObject ret = HitTest();
	    return ret;
    }	

	protected GameObject HitTest()
	{
		RaycastHit2D hit2D;
		GameObject target = null;
		if (HitTestContext.HitTest(out hit2D))
		{
			target = hit2D.collider.gameObject;
		}
		return target;
	}
	
	private void GetHitTarget()
	{
		if (_frameGotHitTarget == Time.frameCount)
			return;

		_frameGotHitTarget = Time.frameCount;

		if (touchScreen)
		{
			_touchTarget = null;
			for (int i = 0; i < Input.touchCount; ++i)
			{
				Touch uTouch = Input.GetTouch(i);

				Vector2 pos = uTouch.position;

				TouchInfo touch = null;
				TouchInfo free = null;
				for (int j = 0; j < 5; j++)
				{
					if (_touches[j].touchId == uTouch.fingerId)
					{
						touch = _touches[j];
						break;
					}

					if (_touches[j].touchId == -1)
						free = _touches[j];
				}
				if (touch == null)
				{
					touch = free;
					if (touch == null || uTouch.phase != TouchPhase.Began)
						continue;

					touch.touchId = uTouch.fingerId;
				}

				if (uTouch.phase == TouchPhase.Stationary)
					_touchTarget = touch.target;
				else
				{
					_touchTarget = HitTest(pos);
					touch.target = _touchTarget;
				}
			}
		}
		else
		{
			Vector2 pos = Input.mousePosition;
			TouchInfo touch = _touches[0];
			if (pos.x < 0 || pos.y < 0) //点击在窗口外
				_touchTarget = null;
			else
				_touchTarget = HitTest(pos);
			touch.target = _touchTarget;
		}

		HitTestContext.ClearRaycastHitCache();
	}
	private void HandleMouseEvents()
	{
		TouchInfo touch = _touches[0];
		if (touch.x != _touchPosition.x || touch.y != _touchPosition.y)
		{
			touch.x = _touchPosition.x;
			touch.y = _touchPosition.y;
			touch.Move();
		}

//			if (touch.lastRollOver != touch.target)
//				HandleRollOver(touch);

		if (Input.GetMouseButtonDown(0) || Input.GetMouseButtonDown(1) || Input.GetMouseButtonDown(2))
		{
			if (!touch.began)
			{
				_touchCount = 1;
				touch.Begin();
				touch.button = Input.GetMouseButtonDown(2) ? 2 : (Input.GetMouseButtonDown(1) ? 1 : 0);

				touch.UpdateEvent();
				EventManager.OnTouchBegin.BroadCastEvent(touch.evt);
			}
		}
		if (Input.GetMouseButtonUp(0) || Input.GetMouseButtonUp(1) || Input.GetMouseButtonUp(2))
		{
			if (touch.began)
			{
				_touchCount = 0;
				touch.End();

				GameObject clickTarget = touch.ClickTest();
				if (clickTarget != null)
				{
					touch.UpdateEvent();

					if (Input.GetMouseButtonUp(1) || Input.GetMouseButtonUp(2))
						EventManager.OnRightClick.BroadCastEvent(touch.evt);
					else
						EventManager.OnClick.BroadCastEvent(touch.evt);
				}

				touch.button = -1;
			}
		}
	}

	private	void HandleTouchEvents()
	{
		int tc = Input.touchCount;
		for (int i = 0; i < tc; ++i)
		{
			Touch uTouch = Input.GetTouch(i);

			if (uTouch.phase == TouchPhase.Stationary)
				continue;

			Vector2 pos = uTouch.position;

			TouchInfo touch = null;
			for (int j = 0; j < 5; j++)
			{
				if (_touches[j].touchId == uTouch.fingerId)
				{
					touch = _touches[j];
					break;
				}
			}
			if (touch == null)
				continue;

			if (touch.x != pos.x || touch.y != pos.y)
			{
				touch.x = pos.x;
				touch.y = pos.y;
				if (touch.began)
					touch.Move();
			}

//				if (touch.lastRollOver != touch.target)
//					HandleRollOver(touch);

			if (uTouch.phase == TouchPhase.Began)
			{
				if (!touch.began)
				{
					_touchCount++;
					touch.Begin();
					touch.button = 0;

					touch.UpdateEvent();
					EventManager.OnTouchBegin.BroadCastEvent(touch.evt);
				}
			}
			else if (uTouch.phase == TouchPhase.Canceled || uTouch.phase == TouchPhase.Ended)
			{
				if (touch.began)
				{
					_touchCount--;
					touch.End();

					if (uTouch.phase != TouchPhase.Canceled)
					{
						GameObject clickTarget = touch.ClickTest();
						if (clickTarget != null)
						{
							touch.clickCount = uTouch.tapCount;
							touch.UpdateEvent();
							EventManager.OnClick.BroadCastEvent(touch.evt);
						}
					}

					touch.target = null;
//						HandleRollOver(touch);

					touch.touchId = -1;
				}
			}
		}
	}
}

class TouchInfo
	{
		public float x;
		public float y;
		public int touchId;
		public int clickCount;
		public KeyCode keyCode;
		public char character;
		public EventModifiers modifiers;
		public int mouseWheelDelta;
		public int button;

		public float downX;
		public float downY;
		public bool began;
		public bool clickCancelled;
		public float lastClickTime;
		public GameObject target;
		public List<GameObject> downTargets;
		public GameObject lastRollOver;
//		public List<EventDispatcher> touchMonitors;

		public InputEvent evt;

//		static List<EventBridge> sHelperChain = new List<EventBridge>();

		public TouchInfo()
		{
			evt = new InputEvent();
			downTargets = new List<GameObject>();
//			touchMonitors = new List<EventDispatcher>();
			Reset();
		}

		public void Reset()
		{
			touchId = -1;
			x = 0;
			y = 0;
			clickCount = 0;
			button = -1;
			keyCode = KeyCode.None;
			character = '\0';
			modifiers = 0;
			mouseWheelDelta = 0;
			lastClickTime = 0;
			began = false;
			target = null;
			downTargets.Clear();
			lastRollOver = null;
			clickCancelled = false;
//			touchMonitors.Clear();
		}

		public void UpdateEvent()
		{
			evt.target = this.target;
			evt.touchId = this.touchId;
			evt.x = this.x;
			evt.y = this.y;
			evt.clickCount = this.clickCount;
			evt.keyCode = this.keyCode;
			evt.character = this.character;
			evt.modifiers = this.modifiers;
			evt.mouseWheelDelta = this.mouseWheelDelta;
			evt.button = this.button;
		}

		public void Begin()
		{
			began = true;
			clickCancelled = false;
			downX = x;
			downY = y;

			downTargets.Clear();
			if (target != null)
			{
				downTargets.Add(target);
				Transform objTrans = target.transform;
				while (objTrans != null)
				{
					downTargets.Add(objTrans.gameObject);
					objTrans = objTrans.parent;
				}
			}
		}

		public void Move()
		{
			UpdateEvent();

			if (Mathf.Abs(x - downX) > 50 || Mathf.Abs(y - downY) > 50) clickCancelled = true;

//			if (touchMonitors.Count > 0)
//			{
//				int len = touchMonitors.Count;
//				for (int i = 0; i < len; i++)
//				{
//					EventDispatcher e = touchMonitors[i];
//					if (e != null)
//					{
//						if ((e is DisplayObject) && ((DisplayObject)e).stage == null)
//							continue;
//						if ((e is GObject) && !((GObject)e).onStage)
//							continue;
//						e.GetChainBridges("onTouchMove", sHelperChain, false);
//					}
//				}
//
//				Stage.inst.BubbleEvent("onTouchMove", evt, sHelperChain);
//				sHelperChain.Clear();
//			}
//			else
//				Stage.inst.DispatchEvent("onTouchMove", evt);
			EventManager.OnTouchMove.BroadCastEvent(evt);
		}

		public void End()
		{
			began = false;

			UpdateEvent();

//			if (touchMonitors.Count > 0)
//			{
//				int len = touchMonitors.Count;
//				for (int i = 0; i < len; i++)
//				{
//					EventDispatcher e = touchMonitors[i];
//					if (e != null)
//						e.GetChainBridges("onTouchEnd", sHelperChain, false);
//				}
//				target.BubbleEvent("onTouchEnd", evt, sHelperChain);
//
//				touchMonitors.Clear();
//				sHelperChain.Clear();
//			}
//			else
//				target.BubbleEvent("onTouchEnd", evt);
			EventManager.OnTouchEnd.BroadCastEvent(evt);

			if (Time.realtimeSinceStartup - lastClickTime < 0.35f)
			{
				if (clickCount == 2)
					clickCount = 1;
				else
					clickCount++;
			}
			else
				clickCount = 1;
			lastClickTime = Time.realtimeSinceStartup;
		}

		public GameObject ClickTest()
		{
			if (downTargets.Count == 0
				|| clickCancelled
				|| Mathf.Abs(x - downX) > 50 || Mathf.Abs(y - downY) > 50)
				return null;

			Transform objTrans = downTargets[0].transform;
			if (objTrans != null) //依然派发到原来的downTarget，虽然可能它已经偏离当前位置，主要是为了正确处理点击缩放的效果
				return objTrans.gameObject;

			objTrans = target.transform;
			while (objTrans != null)
			{
				int i = downTargets.IndexOf(objTrans.gameObject);
				if (i != -1 && objTrans != null)
					return objTrans.gameObject;
				objTrans = objTrans.parent;
			}

			downTargets.Clear();

			return objTrans.gameObject;
		}
	}