function onInit()
	ActionsManager.registerResultHandler("buildAdvPC", onRoll);
end


function performRoll(draginfo, rActor, sDie, nHpbonus)

	local rRoll = getRoll(rActor, sDie, nHpbonus);

	if Session.IsHost and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end

	ActionsManager.performAction(draginfo, rActor, rRoll, sDie, nHpbonus);
end



function getRoll(rActor, sDie, nHpbonus)

	local rRoll = {};
	rRoll.sType = "buildAdvPC";
	rRoll.aDice = StringManager.convertStringToDice(sDie);
	rRoll.nMod = tonumber(nHpbonus);
	rRoll.sDesc = "[HP Roll]";

	return rRoll;


end

function onRoll(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

            local Node = ActorManager.getCreatureNode(rSource)
            local nodeMax = DB.getPath(Node, "maxhp_combat");
			local nodeHp =DB.getPath(Node, "hp_current");
            local nMaxcurrhp = DB.getValue(nodeMax, "maxhp_combat");
            local nHp_current = DB.getValue(nodeHp, "hp_current");

			local nodeCheck =DB.getPath(Node, "multiclasscheck");
            local nCheck = DB.getValue(nodeCheck, "multiclasscheck");

            if nCheck == 1 then
            nMult = 0.5
			local msg =
						{
							font = "reference-h",
							text ="HP roll cut in half due to multiclass";
						}
						Comm.deliverChatMessage(msg);

            else
            nMult=1
            end

                local nResult = 0;


                --  create Var
                for k,v in ipairs(rRoll.aDice) do
                --  loop through each dice
                    nResult = nResult + rRoll.aDice[k].result;
                --  add dice results
                end

              local nResult = math.floor((nResult +rRoll.nMod)*nMult);

              local nHPnew = nResult + nMaxcurrhp;

              if nHPnew <=0 and nMaxcurrhp==0 then
				nResult=1
				nHPnew =1
				local msg =
						{
							font = "reference-h",
							icon = "portrait_troll";
							text ="WOW you basically just died on Character Creation. Your Con score is lower than a one legged Pixie.  I set your HP to one but you should consider making a new character";
						}
						Comm.deliverChatMessage(msg);
				end


              if nHPnew <= nMaxcurrhp then
              local nResult=1
              local nHPnew= 1+nMaxcurrhp

              DB.setValue(Node, "maxhp_combat", "number",  nHPnew);

              DB.setValue(Node, "hp_current", "number", (nResult + nHp_current));

               else
               DB.setValue(Node, "maxhp_combat", "number",  nHPnew);

               DB.setValue(Node, "hp_current", "number", (nResult + nHp_current));
               end



	Comm.deliverChatMessage(rMessage);
end