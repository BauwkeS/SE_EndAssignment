#include "LuaBindings.h"

sol::state LuaBindings::m_LuaState;
std::vector <std::unique_ptr<Bitmap >> m_Bitmaps;

void LuaBindings::InitializeStuff(GameEngine* pGameEngine)
{
	//m_LuaState.open_libraries(sol::lib::base);
	luaL_openlibs(m_LuaState);

	BindEngine(pGameEngine);
	BindDraw(pGameEngine);
	BindClasses(pGameEngine);

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
	m_LuaState.set_function("is_key_down", [pGameEngine](const char& vKey)
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

	m_LuaState.set_function("set_color", [pGameEngine](const COLORREF& color)
		{
			pGameEngine->SetColor(color);
		});
	m_LuaState.set_function("set_font", [pGameEngine](Font& font)
		{
			pGameEngine->SetFont(&font);
		});
	m_LuaState.set_function("fill_window_rect", [pGameEngine](const COLORREF& color)
		{
			return pGameEngine->FillWindowRect(color);
		});
	m_LuaState.set_function("draw_line", [pGameEngine](const int& x1, const int& y1, const int& x2, const int& y2)
		{
			return pGameEngine->DrawLine(x1, y1, x2, y2);
		});
	m_LuaState.set_function("draw_rect", [pGameEngine](const int& left, const int& top, const int& right, const int& bottom)
		{
			return pGameEngine->DrawRect(left,top,right,bottom);
		});
	m_LuaState.set_function("fill_rect",
		sol::overload(
			[pGameEngine](const int& left, const int& top, const int& right, const int& bottom)
			{
				return pGameEngine->FillRect(left, top, right, bottom);
			},
			[pGameEngine](const int& left, const int& top, const int& right, const int& bottom, const int& opacity)
			{
				return pGameEngine->FillRect(left, top, right, bottom, opacity);
			}
		)
	);
	m_LuaState.set_function("draw_round_rect", [pGameEngine](const int& left, const int& top, const int& right, const int& bottom, const int& radius)
		{
			return pGameEngine->DrawRoundRect(left, top, right, bottom,radius);
		});
	m_LuaState.set_function("fill_round_rect", [pGameEngine](const int& left, const int& top, const int& right, const int& bottom, const int& radius)
		{
			return pGameEngine->FillRoundRect(left, top, right, bottom, radius);
		});
	m_LuaState.set_function("draw_oval", [pGameEngine](const int& left, const int& top, const int& right, const int& bottom)
		{
			return pGameEngine->DrawOval(left, top, right, bottom);
		});
	m_LuaState.set_function("fill_oval",
		sol::overload(
			[pGameEngine](const int& left, const int& top, const int& right, const int& bottom)
			{
				return pGameEngine->FillOval(left, top, right, bottom);
			},
			[pGameEngine](const int& left, const int& top, const int& right, const int& bottom, const int& opacity)
			{
				return pGameEngine->FillOval(left, top, right, bottom, opacity);
			}
		)
	);
	m_LuaState.set_function("draw_arc", [pGameEngine](const int& left, const int& top, const int& right, const int& bottom, const int& startDegree, const int& angle)
		{
			return pGameEngine->DrawArc(left, top, right, bottom, startDegree, angle);
		});
	m_LuaState.set_function("fill_arc", [pGameEngine](const int& left, const int& top, const int& right, const int& bottom, const int& startDegree, const int& angle)
		{
			return pGameEngine->FillArc(left, top, right, bottom, startDegree, angle);
		});
	m_LuaState.set_function("draw_string",
		sol::overload(
			[pGameEngine](const std::wstring& text, const int& left, const int& top)
			{
				return pGameEngine->DrawString(text, left, top);
			},
			[pGameEngine](const std::wstring& text, const int& left, const int& top, const int& right, const int& bottom)
			{
				return pGameEngine->DrawString(text, left, top,right,bottom);
			}
		)
	);
	m_LuaState.set_function("draw_bitmap",
		sol::overload(
			[pGameEngine](const Bitmap& bitmap, const int& left, const int& top)
			{
				return pGameEngine->DrawBitmap(&bitmap, left, top);
			},
			[pGameEngine](const Bitmap& bitmap, const int& left, const int& top, const int& right, RECT sourceRect)
			{
				return pGameEngine->DrawBitmap(&bitmap, left, top,sourceRect);
			} // TO DOOOOOOOOOOOOOOOOOOOOOOOO
		)
	);

}

void LuaBindings::BindClasses(GameEngine* pGameEngine)
{
	//BIND FONT CLASS
	m_LuaState.new_usertype<Font>
	(
		"Font",
		sol::constructors<Font(tstring&,bool,bool,bool,int)>()
	);

	//BIND BITMAP CLASS
	m_LuaState.new_usertype<Bitmap>
	(
		"Bitmap",
		sol::constructors<Bitmap(const tstring, bool = true)>(),
		"set_transparency_color", &Bitmap::SetTransparencyColor,
		"set_opacity", &Bitmap::SetOpacity,
		"exists", &Bitmap::Exists,
		"get_width", &Bitmap::GetWidth,
		"get_height", &Bitmap::GetHeight,
		"get_transparency_color", &Bitmap::GetTransparencyColor,
		"get_opacity", &Bitmap::GetOpacity,
		"has_alpha_channel", &Bitmap::HasAlphaChannel,
		"save_to_file", &Bitmap::SaveToFile
	);
}
