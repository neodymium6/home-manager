function toggleApp(appID, keymod, key, maximize)
	hs.hotkey.bind({ keymod }, key, function()
		local app = hs.application.get(appID)

		if app == nil then
			hs.application.launchOrFocusByBundleID(appID)

			hs.timer.doAfter(0.2, function()
				local a = hs.application.get(appID)
				if not a then
					return
				end
				a:activate(true)
				if maximize then
					local w = a:mainWindow()
					if w then
						w:maximize(0)
					end
				end
			end)
			return
		end

		local win = app:mainWindow()
		if not win then
			app:activate(true)
			return
		end

		local mouseScreen = hs.mouse.getCurrentScreen()
		local appScreen = win:screen()

		if appScreen and mouseScreen and appScreen:id() == mouseScreen:id() then
			if app:isFrontmost() then
				app:hide()
			else
				app:activate(true)
				if maximize then
					win:maximize(0)
				end
			end
		else
			win:moveToScreen(mouseScreen, false, true, 0)
			app:activate(true)
			if maximize then
				win:maximize(0)
			end
		end
	end)
end

toggleApp("com.github.wez.wezterm", "option", "space", true)
toggleApp("com.apple.Preview", "option", "p", false)
