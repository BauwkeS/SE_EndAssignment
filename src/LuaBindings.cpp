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
	m_LuaState["game_start"]();
}

void LuaBindings::GameEnd()
{
	m_LuaState["game_end"]();
}

void LuaBindings::Update()
{
	m_LuaState["update"]();
}

void LuaBindings::Draw()
{
	m_LuaState["draw"]();
}

void LuaBindings::BindEngine(GameEngine* pGameEngine)
{
	//game engine functions
	m_LuaState.set_function("set_window_title", [pGameEngine](const std::wstring& windowName)
		{
			pGameEngine->SetTitle(windowName);
		});
	m_LuaState.set_function("set_window_position", [pGameEngine](const int& left, const int& top)
		{
			pGameEngine->SetWindowPosition(left, top);
		});
	m_LuaState.set_function("set_window_size", [pGameEngine](const int& width, const int& heigt)
		{
			pGameEngine->SetWidth(width);
			pGameEngine->SetHeight(heigt);
		});
	m_LuaState.set_function("set_key_list", [pGameEngine](const std::wstring& keyList)
		{
			pGameEngine->SetKeyList(keyList);
		});
	m_LuaState.set_function("set_frame_rate", [pGameEngine](const int& frameRate)
		{
			pGameEngine->SetFrameRate(frameRate);
		});
	m_LuaState.set_function("go_fullscreen", [pGameEngine]()
		{
			return pGameEngine->GoFullscreen();
		});
	m_LuaState.set_function("go_windowed_mode", [pGameEngine]()
		{
			return pGameEngine->GoWindowedMode();
		});
	m_LuaState.set_function("show_mouse_pointer", [pGameEngine](const bool& value)
		{
			pGameEngine->ShowMousePointer(value);
		});
	m_LuaState.set_function("quit", [pGameEngine]()
		{
			pGameEngine->Quit();
		});
	m_LuaState.set_function("is_full_screen", [pGameEngine]()
		{
			return pGameEngine->IsFullscreen();
		});
	m_LuaState.set_function("is_key_down", [pGameEngine](const int& vKey)
		{
			return pGameEngine->IsKeyDown(vKey);
		});
	m_LuaState.set_function("message_box", [pGameEngine](const std::wstring& message)
		{
			pGameEngine->MessageBox(message);
		});
}

void LuaBindings::BindDraw(GameEngine* pGameEngine)
{
	m_LuaState.set_function("set_color", [pGameEngine](const int& r, const int& g, const int& b)
		{
			pGameEngine->SetColor(RGB(r, g, b));
		});
	m_LuaState.set_function("set_font", [pGameEngine](const std::wstring& fontName, bool bold, bool italic, bool underline, int size)
		{
			//make a new font and then save it and use it -> dont save it twice? => check
			auto newFont{ std::make_unique<Font>(fontName,bold,italic,underline,size) };
			pGameEngine->SetFont(newFont.get());
			m_Fonts.emplace_back(std::move(newFont));
		//do you NEED to save it??? check later!
		});
	m_LuaState.set_function("fill_window_rect", [pGameEngine](const int& r, const int& g, const int& b)
		{
			return pGameEngine->FillWindowRect(RGB(r, g, b));
		});
	m_LuaState.set_function("draw_line", [pGameEngine](const int& x1, const int& y1, const int& x2, const int& y2)
		{
			return pGameEngine->DrawLine(x1, y1, x2, y2);
		});
	m_LuaState.set_function("draw_rect", [pGameEngine](const int& left, const int& top, const int& right, const int& bottom)
		{
			return pGameEngine->DrawLine(left,top,right,bottom);
		});
	//m_LuaState.set_function("fill_rect", [pGameEngine](const int& left, const int& top, const int& right, const int& bottom)
	//	{
	//		return pGameEngine->DrawLine(left, top, right, bottom);
	//	});
}