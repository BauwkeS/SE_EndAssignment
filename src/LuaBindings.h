#include <string>
#include <sol/sol.hpp>
#include <vector>
#include "GameEngine.h"

class LuaBindings{
	public:
	    static void InitializeStuff(GameEngine* pGameEngine);
	    static void LoadLuaScript(const std::string& scriptName);

	    static void Initialize();
	    static void GameStart();
	    static void GameEnd();
	    static void Update();
	    static void Draw();
	private:
	    static void BindEngine(GameEngine* pGameEngine);
	    static void BindDraw(GameEngine* pGameEngine);

	    static sol::state m_LuaState;
	    static std::vector<std::unique_ptr<Bitmap>> m_Bitmaps;
	    static std::vector<std::unique_ptr<Font>> m_Fonts;
};
