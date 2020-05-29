using System;
using UnityEngine;
using XLua;

[LuaCallCSharp]
public class LuaScreenBase : ScreenBase
{
   private LuaTable _self;
   private Action _onInitFun = null;
   private Action _onShownFun = null;
   private Action _onCloseFun = null;
   private Action _onDispose = null;

   public LuaScreenBase(string UIName, UIOpenScreenParameterBase param = null):base(UIName, param)
   {
   }

   public void ConnectLua(LuaTable peerTable)
   {
      _self = peerTable;
      _onInitFun = peerTable.Get<Action>("OnInit");
      _onShownFun = peerTable.Get<Action>("OnShown");
      _onCloseFun = peerTable.Get<Action>("OnClose");
      _onDispose = peerTable.Get<Action>("OnDispose");
   }

   protected override void OnLoadSuccess()
   {
      base.OnLoadSuccess();
      if (_onInitFun != null)
      {
         _onInitFun();
      }
   }

   public override void OnShow()
   {
      base.OnShow();
      if (_onShownFun != null)
      {
         _onShownFun();
      }
   }

   public override void OnClose()
   {
      base.OnClose();
      if (_onCloseFun != null)
      {
         _onCloseFun();
      }
   }

   public override void Dispose()
   {
      base.Dispose();
      if (_onDispose != null)
      {
         _onDispose();
      }
   }
}
