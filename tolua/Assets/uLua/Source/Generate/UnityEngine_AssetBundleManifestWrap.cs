﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class UnityEngine_AssetBundleManifestWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(UnityEngine.AssetBundleManifest), typeof(UnityEngine.Object));
		L.RegFunction("GetAllAssetBundles", GetAllAssetBundles);
		L.RegFunction("GetAllAssetBundlesWithVariant", GetAllAssetBundlesWithVariant);
		L.RegFunction("GetAssetBundleHash", GetAssetBundleHash);
		L.RegFunction("GetDirectDependencies", GetDirectDependencies);
		L.RegFunction("GetAllDependencies", GetAllDependencies);
		L.RegFunction("New", _CreateUnityEngine_AssetBundleManifest);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUnityEngine_AssetBundleManifest(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				UnityEngine.AssetBundleManifest obj = new UnityEngine.AssetBundleManifest();
				ToLua.PushSealed(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: UnityEngine.AssetBundleManifest.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetAllAssetBundles(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			UnityEngine.AssetBundleManifest obj = (UnityEngine.AssetBundleManifest)ToLua.CheckObject(L, 1, typeof(UnityEngine.AssetBundleManifest));
			string[] o = obj.GetAllAssetBundles();
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetAllAssetBundlesWithVariant(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			UnityEngine.AssetBundleManifest obj = (UnityEngine.AssetBundleManifest)ToLua.CheckObject(L, 1, typeof(UnityEngine.AssetBundleManifest));
			string[] o = obj.GetAllAssetBundlesWithVariant();
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetAssetBundleHash(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.AssetBundleManifest obj = (UnityEngine.AssetBundleManifest)ToLua.CheckObject(L, 1, typeof(UnityEngine.AssetBundleManifest));
			string arg0 = ToLua.CheckString(L, 2);
			UnityEngine.Hash128 o = obj.GetAssetBundleHash(arg0);
			ToLua.PushValue(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDirectDependencies(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.AssetBundleManifest obj = (UnityEngine.AssetBundleManifest)ToLua.CheckObject(L, 1, typeof(UnityEngine.AssetBundleManifest));
			string arg0 = ToLua.CheckString(L, 2);
			string[] o = obj.GetDirectDependencies(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetAllDependencies(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.AssetBundleManifest obj = (UnityEngine.AssetBundleManifest)ToLua.CheckObject(L, 1, typeof(UnityEngine.AssetBundleManifest));
			string arg0 = ToLua.CheckString(L, 2);
			string[] o = obj.GetAllDependencies(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

