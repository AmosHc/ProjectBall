using System;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;

public class Timers : MonoSingleton<Timers>
{
    public static int _repeat;
    public static float _time;

    public static bool _catchCallbackExceptions = false;

    private Dictionary<TimerCallback, Anymous_T> _items;
    private Dictionary<TimerCallback, Anymous_T> _toAdd;
    private List<Anymous_T> _toRemove;
    private List<Anymous_T> _pool;

//    private TimersEngine _engine;
    private GameObject _gameObject;

    public override void Create()
    {
        _items = new Dictionary<TimerCallback, Anymous_T>();
        _toAdd = new Dictionary<TimerCallback, Anymous_T>();
        _toRemove = new List<Anymous_T>();
        _pool = new List<Anymous_T>(100);
    }


    private Anymous_T GetFromPool()
    {
        Anymous_T t;
        int cnt = _pool.Count;
        if (cnt > 0)
        {
            t = _pool[cnt - 1];
            _pool.RemoveAt(cnt - 1);
            t.Deleted = false;
            t.Elapsed = 0;
        }
        else
            return new Anymous_T();

        return t;
    }

    private void ReturnToPool(Anymous_T t)
    {
        t.Callback = null;
        _pool.Add(t);
    }

    public void Add(float interval, int repeat, TimerCallback callback, object callbackParam)
    {
        if (callback == null)
        {
            Debug.LogWarning("Timer Callback is null, " + interval + "," + repeat);
            return;
        }

        Anymous_T t;
        if (_items.TryGetValue(callback, out t))
        {
            t.Set(interval, repeat, callback, callbackParam);
            t.Elapsed = 0;
            t.Deleted = false;
            return;
        }

        if (_toAdd.TryGetValue(callback, out t))
        {
            t.Set(interval, repeat, callback, callbackParam);
            return;
        }

        t = GetFromPool();
        t.Interval = interval;
        t.Repeat = repeat;
        t.Callback = callback;
        t.Param = callbackParam;
        _toAdd[callback] = t;
    }


    public bool Exists(TimerCallback callback)
    {
        if (_toAdd.ContainsKey(callback))
            return true;
        Anymous_T at;
        if (_items.TryGetValue(callback, out at))
            return !at.Deleted;
        return false;
    }

    public void Remove(TimerCallback callback)
    {
        Anymous_T t;
        if (_toAdd.TryGetValue(callback, out t))
        {
            _toAdd.Remove(callback);
            ReturnToPool(t);
        }
    }

    public void Update()
    {
        float dt = Time.unscaledDeltaTime;
        Dictionary<TimerCallback, Anymous_T>.Enumerator iter;
        if (_items.Count > 0)
        {
            iter = _items.GetEnumerator();
            while (iter.MoveNext())
            {
                Anymous_T i = iter.Current.Value;
                if (i.Deleted)
                {
                    _toRemove.Add(i);
                    continue;
                }

                i.Elapsed += dt;
                if(i.Elapsed < i.Interval)
                    continue;

                i.Elapsed -= i.Interval;
                if (i.Elapsed < 0 || i.Elapsed > 0.03f)
                    i.Elapsed = 0;
                if (i.Repeat > 0)
                {
                    i.Repeat--;
                    if (i.Repeat == 0)
                    {
                        i.Deleted = true;
                        _toRemove.Add(i);
                    }
                }

                _repeat = i.Repeat;
                if (i.Callback != null)
                {
                    if (_catchCallbackExceptions)
                    {
                        try
                        {
                            i.Callback(i.Param);
                        }
                        catch (System.Exception e)
                        {
                            i.Deleted = true;
                            Debug.LogWarning("Timer(internal=" + i.Interval + ", repeat=" + ") callback error > " +
                                             e.Message);
                        }
                    }
                    else
                    {
                        i.Callback(i.Param);
                    }
                }
            }
            iter.Dispose();

            int len = _toRemove.Count;
            if (len > 0)
            {
                for (int i = 0; i < len; i++)
                {
                    Anymous_T t = _toRemove[i];
                    if (t.Deleted && t.Callback != null)
                    {
                        _items.Remove(t.Callback);
                        ReturnToPool(t);
                    }
                }
                _toRemove.Clear();
            }

            if (_toAdd.Count > 0)
            {
                iter = _toAdd.GetEnumerator();
                while (iter.MoveNext())
                {
                    _items.Add(iter.Current.Key,iter.Current.Value);
                }
                iter.Dispose();
                _toAdd.Clear();
            }
        }
    }
}

public class Anymous_T
{
    private float _interval;
    private int _repeat;
    private TimerCallback _callback;
    private object _param;
    private float _elapsed;
    private bool _deleted;

    public float Interval
    {
        get => _interval;
        set => _interval = value;
    }

    public int Repeat
    {
        get => _repeat;
        set => _repeat = value;
    }

    public TimerCallback Callback
    {
        get => _callback;
        set => _callback = value;
    }

    public object Param
    {
        get => _param;
        set => _param = value;
    }

    public float Elapsed
    {
        get => _elapsed;
        set => _elapsed = value;
    }

    public bool Deleted
    {
        get => _deleted;
        set => _deleted = value;
    }

    public void Set(float interval, int repeat, TimerCallback callback, object param)
    {
        this._interval = interval;
        this._repeat = repeat;
        this._callback = callback;
        this._param = param;
    }

}