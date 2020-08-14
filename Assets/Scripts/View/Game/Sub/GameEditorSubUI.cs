using UnityEngine;
using UnityEngine.SocialPlatforms;
using UnityEngine.UI;
using Utility;

public class GameEditorSubUI : SubScreenBase
    {
        private int _selectAgencyID;
        private GameEditorSubCtrl _ctrl;
        
        public GameEditorSubUI(UISubCtrlBase ctrlBase, UIOpenScreenParameterBase param = null) : base(ctrlBase, param)
        {
        }

        protected override void OnInit()
        {
            _ctrl = _uictrl as GameEditorSubCtrl;
        }

        protected override void BindAction()
        {
            AddOnClickListener(_ctrl.btnContentArea,OnClickContentArea);
            AddOnClickListener(_ctrl.btnRun,OnClickStartGame);
        }

        protected override void OnShow()
        {
            ResourcesMgr.GetInstance().LoadAsset<GameObject>(GameUIManager.UI_RES_PREFIX + "Game/btnOrganItem", InitEditorAgencyList);
        }

        private void InitEditorAgencyList(GameObject obj)
        {
            if (obj != null)
            {
                CommonUtility.RefreshList(_ctrl.rectListOrganEditor, obj, ((LevelInfoParam)_selfParam).LevelsCfg.Agencys,ListItemRender);
            }
            else
            {
                Debug.LogError("prefab "+GameUIManager.UI_RES_PREFIX+"Game/btnOrganItem 加载失败");
            }
        }

        private void ListItemRender(int i,Transform item ,int AgencyID)
        {
            Toggle tog = item.GetComponent<Toggle>();
            AddOnValueChangedListener(tog,(state => { OnSelectedAgency(state, AgencyID); }));
        }

        private void OnSelectedAgency(bool state,int agencyID)
        {
            if( state )
                _selectAgencyID = agencyID;
        }

        private void OnClickContentArea()
        {
            if (_selectAgencyID == -1) 
                return;
            var agencyCfg = GameConfigManager.GetInstance().GameConfig.GetAgencysByID(_selectAgencyID);
            Vector3 touchPosOnScreen = Input.mousePosition;
            var touchPosInWorld = Camera.main.ScreenToWorldPoint(touchPosOnScreen);
            touchPosInWorld.z = 0;
            if (agencyCfg != null)
            {
                EntityManager.GetInstance().CreateEntity<Agency>(agencyCfg.EntityId, touchPosInWorld, Quaternion.identity);
            }

            _selectAgencyID = -1;
        }

        private void OnClickStartGame()
        {
            var levelCfg = ((LevelInfoParam) _selfParam).LevelsCfg;
            EntityManager.GetInstance().CreateEntity<Ball>(Const.PlayBallID, new Vector3(levelCfg.SpawnPoint.X,levelCfg.SpawnPoint.Y), Quaternion.identity);
        }
    }