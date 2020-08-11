using table;
using UnityEngine;
using UnityEngine.UI;
using Utility;

public class SelectLevelUI : ScreenBase
{
    private SelectLevelCtrl _ctrl;
        
    public SelectLevelUI(string uiRes, string UIName, UIOpenScreenParameterBase param = null) : base(uiRes, UIName, param)
    {
    }

    public override void OnCreate()
    {
        _ctrl = _uiCtrl as SelectLevelCtrl;
    }

    public override void BindAction()
    {
        AddOnClickListener(_ctrl.btnClose,Close);
    }

    public override void OnShow()
    {
        _ctrl.txtTitle.text = ((ThemechooserParam) _selfParam).TitleName;
        ResourcesMgr.GetInstance().LoadAsset<GameObject>(GameUIManager.UI_RES_PREFIX+"SelectLevel/btnLevel",InitLevels);
    }

    private void InitLevels(GameObject obj)
    {
        if (_selfParam == null) 
            return;
        CommonUtility.RefreshList(_ctrl.groupLevels.transform, obj, ((ThemechooserParam) _selfParam).Levels,ListItemRender);
    }

    private void ListItemRender(int i,Transform item ,int levelID)
    {
        LevelsDefine levelCfg = GameConfigManager.GetInstance().GameConfig.GetLevelsByLevelID(levelID);
        item.Find("Text").GetComponent<Text>().text = levelCfg.LevelName;
        Button btn = item.GetComponent<Button>();
        AddOnClickListener(btn,(() => OnStartGameClick(levelCfg)));
    }

    private void OnStartGameClick(LevelsDefine levelCfg)
    {
        LevelInfoParam param = new LevelInfoParam();
        param.LevelsCfg = levelCfg;
        GameUIManager.GetInstance().OpenUI(UIConfig.GameUI,param);
    }
    //GameConfigManager.GetInstance().GameConfig.GetLevelsByLevelID();
        
}