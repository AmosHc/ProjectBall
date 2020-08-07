using System.Collections.Generic;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace UIFramework.ScreenBase
{
    //------------------基本事件封装，界面卸载时全部自动卸载事件，防止漏卸---------------------
    public class UIBase
    {
        private List<Button> _allOnClickObjs;
        private List<Toggle> _allOnValueChangedObjs;
        
        protected void InitBtnListenerTabs()
        {
            _allOnClickObjs = new List<Button>();
            _allOnValueChangedObjs = new List<Toggle>();
        }

        protected void UnBindListenerAction()
        {
            RemoveAllOnClickListener();
            RemoveAllOnValueChangedListener();
        }

        protected void AddOnClickListener(Button obj,UnityAction action)
        {
            if (obj != null)
            {
                obj.onClick.AddListener(action);
                if (!_allOnClickObjs.Contains(obj))
                {
                    _allOnClickObjs.Add(obj);
                }
            }
        }

        protected void RemoveAllOnClickListener()
        {
            foreach (var obj in _allOnClickObjs)
            {
                obj.onClick.RemoveAllListeners();
            }

            _allOnClickObjs = null;
        }
        
        protected void AddOnValueChangedListener(Toggle obj,UnityAction<bool> action)
        {
            if (obj != null)
            {
                obj.onValueChanged.AddListener(action);
                if (!_allOnValueChangedObjs.Contains(obj))
                {
                    _allOnValueChangedObjs.Add(obj);
                }
            }
        }

        protected void RemoveAllOnValueChangedListener()
        {
            foreach (var obj in _allOnValueChangedObjs)
            {
                obj.onValueChanged.RemoveAllListeners();
            }

            _allOnValueChangedObjs = null;
        }
    }
}