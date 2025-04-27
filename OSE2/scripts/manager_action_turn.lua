function onInit()
ActionsManager.registerResultHandler("turn", TurnHandler);
end
	
function performRoll(draginfo, rActor,sType,aDice,nBonus,sName,sAction)

	local rRoll = getRoll(rActor,sType,aDice,nBonus,sName,sAction);

	if Session.IsHost and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end

	ActionsManager.performAction(draginfo, rActor, rRoll);
	

end

	
function getRoll(rActor,sType,aDice,nBonus,sName,sAction)

	local rRoll = {};
	rRoll.sType = sType;
	rRoll.aDice = aDice;
	rRoll.nBonus = nBonus;
	rRoll.nMod = 0;
	rRoll.sDesc = sName;
	rRoll.Action = sAction
manager_actions2.encodeDesktopMods(rRoll);
return rRoll;
end

	
function sortingFunction(undead1, undead2) 
  return undead1.UT < undead2.UT
end	
	
	
function TurnHandler(rSource,rTarget,rRoll)

if not rSource then return false end
local nodeAttacker = ActorManager.getCTNode(rSource)
local rTurnTable = DataCommon.turn
local nTotal = ActionsManager.total(rRoll)
local sTA = rRoll.Action
local sOutCome = ""
local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

if rTarget then
local nodeDefender = ActorManager.getCTNode(rTarget)
local sType = DB.getValue(nodeDefender,"tags",""):lower()
local nNumTurned = 0
sName = DB.getValue(nodeDefender,"name","")

	if string.find(sType,"undead") then
		nHD = DB.getValue(nodeDefender,"hd_current",0)
		local nSpecHD = DB.getValue(nodeDefender, "specHD",0)
		
		if nHD==2 and nSpecHD ~= 0 then
		nUT = DB.getValue(nodeDefender,"hd_current",0)+1
		elseif nHD > 2 then
		nUT = DB.getValue(nodeDefender,"hd_current",0)+1
		else
		nUT = DB.getValue(nodeDefender,"hd_current",0)
		end
		sResult,nNumTurned, bNumber = TurnResult(nUT,sTA,nTotal,rTurnTable)
		if bNumber and nNumTurned <=6 then
		nNumTurned = 7
		end

	end

						rUndeadDecision = {}

						local aTargets =TargetingManager.getFullTargets(nodeAttacker)

											for k,v in pairs (aTargets) do
											local nodeTarget = DB.findNode(v.sCreatureNode)

											local sTypetarget = DB.getValue(nodeTarget,"tags",""):lower()
									
														if string.find(sTypetarget,"undead") then
														local nUT = DB.getValue(nodeTarget,"hd_current",0)
														table.insert(rUndeadDecision,{UT =nUT,Node=nodeTarget})					
														
														end
														
												local nTurned = DB.getValue(ActorManager.getCreatureNode(rSource),"numturned",0)

												if nTurned <= 0 then
		
												DB.setValue(ActorManager.getCreatureNode(rSource),"numturned","number",nNumTurned)
												RulesetWizard.changeDBValueOOB(DB.getChild(ActorManager.getCreatureNode(nodeTarget),"numturned"), nNumTurned)


												end			
														

											end
						table.sort(rUndeadDecision, sortingFunction)


	
local nTurned = DB.getValue(ActorManager.getCreatureNode(rSource),"numturned",0)	

nCount = nTurned	
			for _,vDecide in ipairs (rUndeadDecision) do
			

				if vDecide.Node == ActorManager.getCTNode(rTarget) then
				
					sOutCome = sResult

					break
				end	
				
			nCount = nCount -nHD
			
				if nCount <= 0 and nCount < nTurned then
					sOutCome = "NOT TURNED"
					break
				end
			
			end

rMessage.text = rMessage.text.." "..sName.." ["..sOutCome.."]".."\n[#HD Turned:"..nTurned.."]"

end


Comm.deliverChatMessage(rMessage);

end


function ResetTurned()

	for _,v in pairs(CombatManager.getCombatantNodes()) do
		RulesetWizard.changeDBValueOOB(DB.getChild(v,"numturned"), 0)
	end


end




function TurnResult(nUT,sTA,nTotal,rTurnTable)

for kTa,vTurn in pairs(rTurnTable)do
local bNumber=false

			if kTa == sTA then
		
				for kUT,vResult in ipairs (vTurn) do

					if kUT == nUT then
					
							if manager_effectOSE.isNUmeric(vResult) then

								if nTotal >= tonumber(vResult) then
								sResult="TURNED"
								nNumTurned = math.random(2,12)
								bNumber=false

								else
								sResult="NOT TURNED"
								nNumTurned =0
								end

							elseif vResult =="T" then
							nNumTurned = math.random(2,12)
							bNumber=false
							sResult="TURNED"
							elseif vResult =="D" then
							nNumTurned = math.random(2,12)
							bNumber=false
							sResult="Destroyed"
							elseif vResult =="NT" then
							sResult="NOT TURNED"
							nNumTurned =0
							end
					break;
					end
				
				
				end

		end

end

return sResult,nNumTurned, bNumber

end