#include "LuaBindings.h"

sol::state LuaBindings::m_LuaState;
std::vector <std::unique_ptr<Bitmap >> m_Bitmaps;

void LuaBindings::InitializeStuff(GameEngine* pGameEngine)
{
	m_LuaState.open_libraries(sol::lib::base);

	BindEngine(pGameEngine);
	BindDraw(pGameEngine);

	LoadLuaScript("game1.lua");
}

void LuaBindings::LoadLuaScript(const std::string& scriptName)
{
	m_LuaState.script_file(scriptName);
}

void LuaBindings::Initialize()
{
	m_LuaState["initialize"]();
}

void LuaBindings::GameStart()
{
}

void LuaBindings::GameEnd()
{
}

void LuaBindings::Update()
{
}

void LuaBindings::Draw()
{
}

void LuaBindings::BindEngine(GameEngine* pGameEngine)
{
	m_LuaState.set_function("set_window_title", [pGameEngine](const std::wstring& windowName)
		{
			pGameEngine->SetTitle(windowName);
		});
	m_LuaState.set_function("set_window_size", [pGameEngine](const int& width, const int& heigt)
		{
			pGameEngine->SetWidth(width);
			pGameEngine->SetHeight(heigt);
		});
}

void LuaBindings::BindDraw(GameEngine* pGameEngine)
{
}