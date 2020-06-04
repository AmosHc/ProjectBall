#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using XLua;
using System.Collections.Generic;


namespace XLua.CSObjectWrap
{
    using Utils = XLua.Utils;
    public class UICtrlBaseWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(UICtrlBase);
			Utils.BeginObjectRegister(type, L, translator, 0, 1, 8, 7);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetScreenPriority", _m_GetScreenPriority);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "ctrlCanvas", _g_get_ctrlCanvas);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "mReferenceResolution", _g_get_mReferenceResolution);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "screenPriority", _g_get_screenPriority);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "mUseMask", _g_get_mUseMask);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "mAlwaysShow", _g_get_mAlwaysShow);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "mHideOtherScreenWhenThisOnTop", _g_get_mHideOtherScreenWhenThisOnTop);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "mBCareAboutMoney", _g_get_mBCareAboutMoney);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "MoneyType", _g_get_MoneyType);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "mReferenceResolution", _s_set_mReferenceResolution);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "screenPriority", _s_set_screenPriority);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "mUseMask", _s_set_mUseMask);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "mAlwaysShow", _s_set_mAlwaysShow);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "mHideOtherScreenWhenThisOnTop", _s_set_mHideOtherScreenWhenThisOnTop);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "mBCareAboutMoney", _s_set_mBCareAboutMoney);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "MoneyType", _s_set_MoneyType);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 1, 0, 0);
			
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					UICtrlBase gen_ret = new UICtrlBase();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to UICtrlBase constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetScreenPriority(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        int gen_ret = gen_to_be_invoked.GetScreenPriority(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ctrlCanvas(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.ctrlCanvas);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_mReferenceResolution(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector2(L, gen_to_be_invoked.mReferenceResolution);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_screenPriority(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.screenPriority);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_mUseMask(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.mUseMask);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_mAlwaysShow(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.mAlwaysShow);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_mHideOtherScreenWhenThisOnTop(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.mHideOtherScreenWhenThisOnTop);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_mBCareAboutMoney(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.mBCareAboutMoney);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_MoneyType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.MoneyType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_mReferenceResolution(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector2 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.mReferenceResolution = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_screenPriority(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
                ESceenPriority gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.screenPriority = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_mUseMask(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.mUseMask = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_mAlwaysShow(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.mAlwaysShow = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_mHideOtherScreenWhenThisOnTop(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.mHideOtherScreenWhenThisOnTop = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_mBCareAboutMoney(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.mBCareAboutMoney = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_MoneyType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UICtrlBase gen_to_be_invoked = (UICtrlBase)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.MoneyType = (EUICareAboutMoneyType[])translator.GetObject(L, 2, typeof(EUICareAboutMoneyType[]));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
