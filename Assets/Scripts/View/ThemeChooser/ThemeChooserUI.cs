
using System.Collections.Generic;
using table;
using Utility;

namespace ProjectBall.View
{
    public class ThemechooserParam : UIOpenScreenParameterBase
    {
        private string _titleName;
        private List<int> _levels;

        public string TitleName
        {
            get => _titleName;
            set => _titleName = value;
        }

        public List<int> Levels
        {
            get => _levels;
            set => _levels = value;
        }
    }
    
    public class ThemeChooserUI : ScreenBase
    {
        private int _idx = 0;
        private int _maxCount = 0;
        private ThemeChooserCtrl _selfCtrl;
        private List<int> _levels;
        private List<ThemeChooserDefine> _ThemeChooserCfgs;
        
        
        public ThemeChooserUI(string uiRes, string UIName, UIOpenScreenParameterBase param = null) : base(uiRes, UIName, param)
        {
        }

        public override void OnCreate()
        {
            _selfCtrl = _uiCtrl as ThemeChooserCtrl;
            _ThemeChooserCfgs = GameConfigManager.GetInstance().GameConfig.ThemeChooser;
        }

        public override void OnShow()
        {
            base.OnShow();
            _idx = 0;
            _maxCount = _ThemeChooserCfgs.Count;
            RefreshPage();
        }

        public void RefreshPage()
        {
            int idx = _idx;
            var cfg = _ThemeChooserCfgs[idx];
            //_selfCtrl.icon.url = self.ThemeChooserCfg[_Idx].icon
            _selfCtrl.title.text = cfg.ThemeName;
            _levels = cfg.levels;
            _selfCtrl.btnPrevObj.SetActive(_idx != 0);
            _selfCtrl.btnNextObj.SetActive(_idx != _maxCount - 1);
        }

        public override void BindAction()
        {
            AddOnClickListener(_selfCtrl.btnPrev, OnPreviousPageClick);
            AddOnClickListener(_selfCtrl.btnNext, OnNextPageClick);
            AddOnClickListener(_selfCtrl.btnJumpTheme, OnOpenJumpTheme);
            AddOnClickListener(_selfCtrl.btnClose,Close);
        }

        private void OnPreviousPageClick()
        {
            _idx = (int)CommonUtility.Fmod(_idx - 1, _maxCount);
            RefreshPage();
        }

        private void OnNextPageClick()
        {
            _idx = (int)CommonUtility.Fmod(_idx + 1, _maxCount);
            RefreshPage();
        }

        private void OnOpenJumpTheme()
        {
            ThemechooserParam param = new ThemechooserParam();
            param.TitleName = _selfCtrl.title.text;
            param.Levels = _levels;
            GameUIManager.GetInstance().OpenUI(UIConfig.SelectLevelUI,param);
        }
    }
}