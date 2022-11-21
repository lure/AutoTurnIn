function AutoTurnIn:CinematickHooks()
	--[[ 
    	CINEMATICS OF ALL KINDS
    --]]
    CinematicFrame:HookScript("OnShow", function()
        if ((AutoTurnIn.db.profile.skip_cinematics == 2 and IsInInstance()) or AutoTurnIn.db.profile.skip_cinematics == 3)
        	and CinematicFrame:IsShown()
        	and CinematicFrame.closeDialog
        	and CinematicFrameCloseDialogConfirmButton
        then
            CinematicFrameCloseDialog:Hide()
            CinematicFrameCloseDialogConfirmButton:Click()
        end
    end)
    CinematicFrame:HookScript("OnKeyDown", function(_, key)
        if AutoTurnIn.db.profile.skip_cinematics > 1
        	and key == "ESCAPE"
        	and CinematicFrame:IsShown()
        	and CinematicFrame.closeDialog
        	and CinematicFrameCloseDialogConfirmButton
        then
            CinematicFrameCloseDialog:Hide()
        end
    end)

    CinematicFrame:HookScript("OnKeyUp", function(_, key)
        if AutoTurnIn.db.profile.skip_cinematics > 1
        	and (key == "SPACE" or key == "ESCAPE" or key == "ENTER")
        	and CinematicFrame:IsShown()
        	and CinematicFrame.closeDialog
        	and CinematicFrameCloseDialogConfirmButton
        then
            CinematicFrameCloseDialogConfirmButton:Click()
        end
    end)

    --[[ 
    	MOVIES OF ALL KINDS
    --]]
    MovieFrame:HookScript("OnShow", function()
        if ((AutoTurnIn.db.profile.skip_movies == 2 and IsInInstance()) or AutoTurnIn.db.profile.skip_movies == 3)
        	and MovieFrame:IsShown()
        	and MovieFrame.CloseDialog
        	and MovieFrame.CloseDialog.ConfirmButton
        then
            MovieFrame.CloseDialog.ConfirmButton:Click()
        end
    end)
    MovieFrame:HookScript("OnKeyUp", function(_, key)
        if AutoTurnIn.db.profile.skip_movies > 1
	        and (key == "SPACE" or key == "ESCAPE" or key == "ENTER")
	        and MovieFrame:IsShown()
	        and MovieFrame.CloseDialog
	        and MovieFrame.CloseDialog.ConfirmButton
     	then
            MovieFrame.CloseDialog.ConfirmButton:Click()
        end
    end)
end