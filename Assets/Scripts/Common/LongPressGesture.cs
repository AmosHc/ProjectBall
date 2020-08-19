using UnityEngine;

/// <summary>
/// 长按手势
/// </summary>
public class LongPressGesture
{
    
    private const float TRIGGER = 1.5f;
    private const float INTERVAL = 1f;
    private const int HOLDRANGERADIUS = 50;
    
    private GameObject _host;

    /// <summary>
    /// 第一次派发事件的触发时间
    /// </summary>
    private float _trigger;
    
    /// <summary>
    /// 派发onAction的时间间隔，单位秒
    /// </summary>
    private float _interval;

    /// <summary>
    /// 如果为真则onAction只派发一次，如果为假，每duration时间发一次
    /// </summary>
    private bool _once;

    /// <summary>
    /// 长按后移出此半径范围则手势停止
    /// </summary>
    private int _holdRangeRadius;

    private Vector2 _startpoint;
    private bool _started;
    private int _touchID;
    public GameObject Host => _host;

    public float Trigger
    {
        get => _trigger;
        set => _trigger = value;
    }

    public bool Once
    {
        get => _once;
        set => _once = value;
    }

    public float Interval
    {
        get => _interval;
        set => _interval = value;
    }

    public int HoldRangeRadius
    {
        get => _holdRangeRadius;
        set => _holdRangeRadius = value;
    }
    
    public LongPressGesture(GameObject host)
    {
        _host = host;
        _trigger = TRIGGER;
        _interval = INTERVAL;
        _holdRangeRadius = HOLDRANGERADIUS;
        Enable(true);
    }

    public void Dispose()
    {
        Enable(false);
        _host = null;
    }
    
    public void Enable(bool value)
		{
			if (value)
			{
//				if (_host == GRoot.inst)
//				{
//					Stage.inst.onTouchBegin.Add(__touchBegin);
//					Stage.inst.onTouchEnd.Add(__touchEnd);
//				}
//				else
//				{
//					host.onTouchBegin.Add(__touchBegin);
//					host.onTouchEnd.Add(__touchEnd);
//				}
			}
			else
			{
//				if (host == GRoot.inst)
//				{
//					Stage.inst.onTouchBegin.Remove(__touchBegin);
//					Stage.inst.onTouchEnd.Remove(__touchEnd);
//				}
//				else
//				{
//					host.onTouchBegin.Remove(__touchBegin);
//					host.onTouchEnd.Remove(__touchEnd);
//				}
				Timers.GetInstance().Remove(__timer);
			}
		}

		public void Cancel()
		{
			Timers.GetInstance().Remove(__timer);
			_started = false;
		}

		void __touchBegin()
		{
//			InputEvent evt = context.inputEvent;
//			_startPoint = _host.GlobalToLocal(new Vector2(evt.x, evt.y));
//			_started = false;
//
//			Timers.GetInstance().Add(trigger, 1, __timer);
//			context.CaptureTouch();
		}

		void __timer(object param)
		{
//			Vector2 pt = host.GlobalToLocal(Stage.inst.touchPosition);
//			if (Mathf.Pow(pt.x - _startPoint.x, 2) + Mathf.Pow(pt.y - _startPoint.y, 2) > Mathf.Pow(holdRangeRadius, 2))
//			{
//				Timers.inst.Remove(__timer);
//				return;
//			}
//			if (!_started)
//			{
//				_started = true;
//				onBegin.Call();
//
//				if (!once)
//					Timers.GetInstance().Add(interval, 0, __timer);
//			}
//
//			onAction.Call();
		}

		void __touchEnd()
		{
//			Timers.GetInstance().Remove(__timer);
//
//			if (_started)
//			{
//				_started = false;
//				onEnd.Call();
//			}
		}
    
    
}