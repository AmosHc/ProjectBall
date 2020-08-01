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
    public class MapSceneManagerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(MapSceneManager);
			Utils.BeginObjectRegister(type, L, translator, 0, 1, 0, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CreateSceneUnit", _m_CreateSceneUnit);
			
			
			
			
			
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
					
					MapSceneManager gen_ret = new MapSceneManager();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to MapSceneManager constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateSceneUnit(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                MapSceneManager gen_to_be_invoked = (MapSceneManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 7&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.Vector3>(L, 5)&& translator.Assignable<UnityEngine.Quaternion>(L, 6)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 7)) 
                {
                    int _inType = LuaAPI.xlua_tointeger(L, 2);
                    int _baseID = LuaAPI.xlua_tointeger(L, 3);
                    string _resPath = LuaAPI.lua_tostring(L, 4);
                    UnityEngine.Vector3 _position;translator.Get(L, 5, out _position);
                    UnityEngine.Quaternion _rotation;translator.Get(L, 6, out _rotation);
                    float _size = (float)LuaAPI.lua_tonumber(L, 7);
                    
                        SceneUnit gen_ret = gen_to_be_invoked.CreateSceneUnit( _inType, _baseID, _resPath, _position, _rotation, _size );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 6&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.Vector3>(L, 5)&& translator.Assignable<UnityEngine.Quaternion>(L, 6)) 
                {
                    int _inType = LuaAPI.xlua_tointeger(L, 2);
                    int _baseID = LuaAPI.xlua_tointeger(L, 3);
                    string _resPath = LuaAPI.lua_tostring(L, 4);
                    UnityEngine.Vector3 _position;translator.Get(L, 5, out _position);
                    UnityEngine.Quaternion _rotation;translator.Get(L, 6, out _rotation);
                    
                        SceneUnit gen_ret = gen_to_be_invoked.CreateSceneUnit( _inType, _baseID, _resPath, _position, _rotation );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 7&& translator.Assignable<EUnitClassType>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.Vector3>(L, 5)&& translator.Assignable<UnityEngine.Quaternion>(L, 6)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 7)) 
                {
                    EUnitClassType _type;translator.Get(L, 2, out _type);
                    int _baseID = LuaAPI.xlua_tointeger(L, 3);
                    string _resPath = LuaAPI.lua_tostring(L, 4);
                    UnityEngine.Vector3 _position;translator.Get(L, 5, out _position);
                    UnityEngine.Quaternion _rotation;translator.Get(L, 6, out _rotation);
                    float _size = (float)LuaAPI.lua_tonumber(L, 7);
                    
                        SceneUnit gen_ret = gen_to_be_invoked.CreateSceneUnit( _type, _baseID, _resPath, _position, _rotation, _size );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 6&& translator.Assignable<EUnitClassType>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.Vector3>(L, 5)&& translator.Assignable<UnityEngine.Quaternion>(L, 6)) 
                {
                    EUnitClassType _type;translator.Get(L, 2, out _type);
                    int _baseID = LuaAPI.xlua_tointeger(L, 3);
                    string _resPath = LuaAPI.lua_tostring(L, 4);
                    UnityEngine.Vector3 _position;translator.Get(L, 5, out _position);
                    UnityEngine.Quaternion _rotation;translator.Get(L, 6, out _rotation);
                    
                        SceneUnit gen_ret = gen_to_be_invoked.CreateSceneUnit( _type, _baseID, _resPath, _position, _rotation );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to MapSceneManager.CreateSceneUnit!");
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
