function AutoTurnIn:CinematickHooks()
    self:RegisterEvent("CINEMATIC_START")
    self:RegisterEvent("PLAY_MOVIE")
end

local function shouldSkipVideo(flag)
    return ((flag == 2 and IsInInstance()) or flag == 3)
end

function AutoTurnIn:CINEMATIC_START()
    if shouldSkipVideo(AutoTurnIn.db.profile.skip_cinematics) then
        if InCombatLockdown() then
            AutoTurnIn.defer.cinematic = true
            return
        end
        CinematicFrame_CancelCinematic()
        self:Print("cinematic skipped")
    end
end

function AutoTurnIn:PLAY_MOVIE(...)
    if shouldSkipVideo(AutoTurnIn.db.profile.skip_movies) then
        local _, movieId = ...
        if InCombatLockdown() then
            AutoTurnIn.defer.movieId = movieId
            return
        end
        AutoTurnIn.db.skippedMovieId = movieId
        GameMovieFinished()
        self:Print("movie skipped. Replay avaialbe with /au replay")
    end
end


-- https://legacy.curseforge.com/wow/addons/autoturnin?comment=855
-- Elvui authors guessed that AU may incorrectly cancel the videos. 
-- my guess is that reporter has DBM, which uses a bit different approach to stop movies
-- interestingly, folks had to resort to another approach https://github.com/fubaWoW/fuba_CinematicSkip/issues/1
function AutoTurnIn:DEPRECATED_CinematickHooks()
    self:Print("CinematickHooks HOOKED")
   
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
